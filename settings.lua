local _, DarkMode = ...
local DMColorModes = {"Dark", "More Dark", "Darker", "More Darker", "Black", "ClassColor", "Custom", "Off"}
local DMColorModeIDs = {}
for i, v in pairs(DMColorModes) do
	DMColorModeIDs[v] = i
end

local DMDROPDOWNWIDTH = 140
local DMSWATCHSIZE = 24
local DMDEFAULTWIDTH = 620
local dmChoices = {}
local dmSwatches = {}
local dmLinked = {}
local dmSettings = nil
for i, v in ipairs(DMColorModes) do
	tinsert(dmChoices, {
		["value"] = i,
		["label"] = "LID_" .. v
	})
end

DarkMode.LANGUAGES = {{"English", "enUS"}, {"Deutsch", "deDE"}, {"Español (España)", "esES"}, {"Español (México)", "esMX"}, {"Français", "frFR"}, {"Italiano", "itIT"}, {"한국어", "koKR"}, {"Português (Brasil)", "ptBR"}, {"Русский", "ruRU"}, {"简体中文", "zhCN"}, {"繁體中文", "zhTW"}}
DarkMode.LanguageNames = {}
for _, info in ipairs(DarkMode.LANGUAGES) do
	DarkMode.LanguageNames[info[2]] = info[1]
end

function DarkMode:GetLanguage()
	local lang = type(DMTAB) == "table" and DMTAB["LANGUAGE"] or nil
	if lang ~= nil and DarkMode.LanguageNames[lang] ~= nil then return lang end
	if DarkMode.LanguageNames[GetLocale()] ~= nil then return GetLocale() end
	return "enUS"
end

function DarkMode:GetLanguageName(lang)
	lang = lang or DarkMode:GetLanguage()
	return DarkMode.LanguageNames[lang] or lang
end

DarkMode.LibTrans = DarkMode.Trans
function DarkMode:Trans(key, lang, ...)
	return DarkMode.LibTrans(self, key, lang or DarkMode:GetLanguage(), ...)
end

function DarkMode:SetLanguage(lang)
	if DarkMode.LanguageNames[lang] == nil or lang == DarkMode:GetLanguage() then return end
	DMTAB = DMTAB or {}
	if lang == GetLocale() then
		DMTAB["LANGUAGE"] = nil
	else
		DMTAB["LANGUAGE"] = lang
	end

	DarkMode:RefreshLanguage()
end

function DarkMode:AddLanguageButton(win)
	local function SelectLanguage(lang)
		DarkMode:SetLanguage(lang)
	end

	local function LanguageMenu(_, root)
		root:CreateTitle(DarkMode:Trans("LID_LANGUAGE"))
		for _, info in ipairs(DarkMode.LANGUAGES) do
			local lang = info[2]
			root:CreateRadio(format("%s (%s)", info[1], lang), function() return DarkMode:GetLanguage() == lang end, function() SelectLanguage(lang) end)
		end
	end

	local parent = win.titleBar or win
	local button
	if DarkMode:GetWoWBuild() == "RETAIL" and DarkMode:CheckTemplates("WowStyle1DropdownTemplate") then
		button = CreateFrame("DropdownButton", nil, parent, "WowStyle1DropdownTemplate")
		button:SetScale(0.8)
		button:SetSize(162.5, 25)
		button:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -1.25)
		button:SetSelectionText(function() return DarkMode:GetLanguageName() end)
		button:SetTooltip(function(tooltip) tooltip:SetText(DarkMode:Trans("LID_LANGUAGE")) end)
		button:SetupMenu(LanguageMenu)
	else
		button = DarkMode:CreateButton(nil, parent)
		button:SetSize(130, 20)
		button:SetPoint("TOPLEFT", parent, "TOPLEFT", 7, -2)
		button.Arrow = button:CreateTexture(nil, "OVERLAY")
		button.Arrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
		button.Arrow:SetSize(16, 16)
		button.Arrow:SetPoint("RIGHT", button, "RIGHT", -2, 0)
		button:SetScript("OnClick", function(sel)
			if MenuUtil and MenuUtil.CreateContextMenu then
				MenuUtil.CreateContextMenu(sel, LanguageMenu)
			else
				local current = 1
				for index, info in ipairs(DarkMode.LANGUAGES) do
					if info[2] == DarkMode:GetLanguage() then current = index end
				end

				SelectLanguage(DarkMode.LANGUAGES[current % #DarkMode.LANGUAGES + 1][2])
			end
		end)

		button:SetScript("OnEnter", function(sel)
			GameTooltip:SetOwner(sel, "ANCHOR_RIGHT")
			GameTooltip:SetText(DarkMode:Trans("LID_LANGUAGE"))
			GameTooltip:Show()
		end)

		button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end

	local function RefreshButton()
		button:SetText(DarkMode:GetLanguageName())
	end

	RefreshButton()
	win.Language = button
	return RefreshButton
end

function DarkMode:GetColorModes()
	return DMColorModes
end

function DarkMode:GetColorModeID(name)
	return DMColorModeIDs[name] or 1
end

local function DMSetSolidColor(texture, r, g, b, a)
	if texture == nil then return end
	if texture.SetColorTexture then
		texture:SetColorTexture(r, g, b, a)
	else
		texture:SetTexture(r, g, b, a)
	end
end

local function DMEnableSave()
	if dmSettings == nil then return end
	if dmSettings.DMSave == nil then return end
	local save = dmSettings.DMSave
	if save:IsEnabled() then return end
	if InCombatLockdown() then
		save.dmEnableAfterCombat:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	save:Enable()
end

local function DMUpdateShowErrors()
	if dmSettings == nil then return end
	if dmSettings.DMShowErrors == nil then return end
	if GetCVar("ScriptErrors") == "0" then
		dmSettings.DMShowErrors:Show()
	else
		dmSettings.DMShowErrors:Hide()
	end
end

local function DMUpdateSwatches()
	local custom = DarkMode:GetColorModeID("Custom")
	for i = 1, #dmSwatches do
		local btn = dmSwatches[i]
		if btn.dmalways or DarkMode:DMGV(btn.dmkey, 1) == custom then
			local r, g, b, a = DarkMode:GetCustomColor(btn.dmcolorkey)
			DMSetSolidColor(btn.dmfill, r, g, b, a)
			btn:Show()
		else
			btn:Hide()
		end
	end
end

local function DMGetCollapsed(key)
	if key == nil then return nil end
	if type(DMTAB) ~= "table" then return nil end
	if type(DMTAB["COLLAPSED"]) ~= "table" then return nil end
	return DMTAB["COLLAPSED"][key]
end

local function DMSetCollapsed(key, collapsed)
	if key == nil then return end
	if type(DMTAB) ~= "table" then return end
	if type(DMTAB["COLLAPSED"]) ~= "table" then DMTAB["COLLAPSED"] = {} end
	DMTAB["COLLAPSED"][key] = collapsed == true
end

function DarkMode:ShowColorPicker(r, g, b, a, changedCallback)
	if ColorPickerFrame.SetupColorPickerAndShow then
		local info = {}
		info.r = r
		info.g = g
		info.b = b
		info.swatchFunc = changedCallback
		info.hasOpacity = a ~= nil
		info.opacityFunc = changedCallback
		info.opacity = a
		self.previousValues = {
			r = info.r,
			g = info.g,
			b = info.b,
			a = info.opacity
		}

		info.cancelFunc = nil
		info.extraInfo = "TEST"
		ColorPickerFrame:SetupColorPickerAndShow(info)
	else
		ColorPickerFrame.func = changedCallback
		ColorPickerFrame.opacityFunc = changedCallback
		ColorPickerFrame.swatchFunc = changedCallback
		ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = a ~= nil, 1 - a
		ColorPickerFrame.previousValues = {r, g, b, a}
		if ColorPickerFrame.SetColorRGB then
			ColorPickerFrame:SetColorRGB(r, g, b)
		elseif ColorPickerFrame.Content.ColorSwatchCurrent.SetColorTexture then
			ColorPickerFrame.Content.ColorSwatchCurrent:SetColorTexture(r, g, b)
		else
			DarkMode:MSG("Failed ColorPicker #1")
		end

		ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = a ~= nil, 1 - a
		ColorPickerFrame:Hide() -- Need to run the OnShow handler.
		ColorPickerFrame:Show()
	end
end

local function DMAddColorSwatch(holder, key, colorKey, always)
	local btn = DarkMode:CreateButton("DMSettingsSwatch" .. key, holder, true)
	btn.dmalways = always
	btn:SetSize(DMSWATCHSIZE, DMSWATCHSIZE)
	btn:SetPoint("RIGHT", holder, "RIGHT", 0, 0)
	btn.dmborder = btn:CreateTexture(nil, "BACKGROUND")
	btn.dmborder:SetAllPoints(btn)
	DMSetSolidColor(btn.dmborder, 0.6, 0.6, 0.6, 1)
	btn.dmfill = btn:CreateTexture(nil, "ARTWORK")
	btn.dmfill:SetPoint("TOPLEFT", btn, "TOPLEFT", 1, -1)
	btn.dmfill:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -1, 1)
	btn.dmhighlight = btn:CreateTexture(nil, "HIGHLIGHT")
	btn.dmhighlight:SetAllPoints(btn)
	DMSetSolidColor(btn.dmhighlight, 1, 1, 1, 0.25)
	btn.dmkey = key
	btn.dmcolorkey = colorKey
	btn:SetScript("OnEnter", function(sel)
		GameTooltip:SetOwner(sel, "ANCHOR_RIGHT")
		GameTooltip:SetText(DarkMode:Trans("LID_COLOR"))
		GameTooltip:Show()
	end)

	btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
	btn:SetScript("OnClick", function()
		local r, g, b, a = DarkMode:GetCustomColor(colorKey)
		DarkMode:ShowColorPicker(r, g, b, a, function(restore)
			local newR, newG, newB, newA
			if restore then
				newR, newG, newB, newA = unpack(restore)
			else
				local OpacitySliderFrame = getglobal("OpacitySliderFrame")
				if OpacitySliderFrame then
					newA, newR, newG, newB = 1 - OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
				elseif ColorPickerFrame.Content.ColorPicker.GetColorAlpha then
					newA, newR, newG, newB = ColorPickerFrame.Content.ColorPicker:GetColorAlpha(), ColorPickerFrame:GetColorRGB()
				else
					DarkMode:MSG("Failed ColorPicker #2")
				end
			end

			DarkMode:SetCustomColor(colorKey, newR, newG, newB, newA)
			DMUpdateSwatches()
			if btn.dmalways then DMEnableSave() end
		end)
	end)

	tinsert(dmSwatches, btn)
	return btn
end

local function DMAddCheckbox(key, default, func, added, tooltip)
	return dmSettings:AddCheckbox({
		["label"] = "LID_" .. key,
		["search"] = key,
		["added"] = added,
		["tooltip"] = tooltip,
		["whatsNew"] = tooltip,
		["value"] = DarkMode:IsEnabled(key, default),
		["func"] = function(value)
			DarkMode:SetEnabled(key, value)
			if func then
				func(value)
			else
				DMEnableSave()
			end
		end
	})
end

local function DMAddColorMode(key, default, colorKey, linked, choices)
	local holder = dmSettings:AddDropdown({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = DarkMode:DMGV(key, default),
		["width"] = DMDROPDOWNWIDTH,
		["choices"] = choices or dmChoices,
		["func"] = function(value)
			DarkMode:DMSV(key, value)
			DarkMode:UpdateColors()
			DMUpdateSwatches()
			if key ~= "COLORMODEABTNS" then DMEnableSave() end
		end
	})

	if holder == nil then return nil end
	DMAddColorSwatch(holder, key, colorKey)
	if linked then
		tinsert(dmLinked, {
			["key"] = key,
			["holder"] = holder
		})
	end
	return holder
end

local function DMAddGeneralColorMode()
	return dmSettings:AddDropdown({
		["label"] = "LID_COLORMODEG",
		["search"] = "COLORMODEG",
		["value"] = DarkMode:DMGV("COLORMODEG", 1),
		["width"] = DMDROPDOWNWIDTH,
		["choices"] = dmChoices,
		["func"] = function(value)
			DarkMode:DMSV("COLORMODEG", value)
			for i = 1, #dmLinked do
				DarkMode:DMSV(dmLinked[i]["key"], value)
				dmLinked[i]["holder"]:SetValue(value)
			end

			DarkMode:UpdateColors()
			DMUpdateSwatches()
			DMEnableSave()
		end
	})
end

local function DMBuildFooter()
	local footer = dmSettings:AddFooter({
		["height"] = 24
	})

	dmSettings.DMSave = DarkMode:CreateReloadButton("DMSettingsSave", footer)
	dmSettings.DMSave:SetSize(100, 24)
	dmSettings.DMSave:SetPoint("LEFT", footer, "LEFT", 0, 0)
	dmSettings.DMSave:SetText(SAVE)
	dmSettings.DMSave:Disable()
	local enableAfterCombat = CreateFrame("Frame")
	enableAfterCombat:SetScript("OnEvent", function(frame)
		frame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		DMEnableSave()
	end)
	dmSettings.DMSave.dmEnableAfterCombat = enableAfterCombat
	dmSettings.DMReload = DarkMode:CreateReloadButton("DMSettingsReload", footer)
	dmSettings.DMReload:SetSize(100, 24)
	dmSettings.DMReload:SetPoint("LEFT", dmSettings.DMSave, "RIGHT", 4, 0)
	dmSettings.DMReload:SetText(RELOADUI or "RELOADUI")
	dmSettings.DMShowErrors = DarkMode:CreateButton("DMSettingsShowErrors", footer)
	dmSettings.DMShowErrors:SetSize(110, 24)
	dmSettings.DMShowErrors:SetPoint("LEFT", dmSettings.DMReload, "RIGHT", 4, 0)
	dmSettings.DMShowErrors:SetText("Show Errors")
	dmSettings.DMShowErrors:SetScript("OnClick", function()
		if GetCVar("ScriptErrors") == "0" then
			SetCVar("ScriptErrors", 1)
		end

		DMUpdateShowErrors()
	end)

	dmSettings.DMDiscord = CreateFrame("EditBox", "DMSettingsDiscord", footer, "InputBoxTemplate")
	dmSettings.DMDiscord:SetText("discord.gg/AYB3qR5hQm")
	dmSettings.DMDiscord:SetSize(160, 24)
	dmSettings.DMDiscord:SetPoint("RIGHT", footer, "RIGHT", 0, 0)
	dmSettings.DMDiscord:SetAutoFocus(false)
end

local function DMAddCategory(key, label)
	return dmSettings:AddCategory({
		["label"] = label,
		["key"] = key,
		["search"] = key
	})
end

local function DMBuildElementList()
	dmSettings:SuspendLayout()
	local masque = getglobal("MSQ") ~= nil
	local off = DarkMode:GetColorModeID("Off")
	DMAddCategory("GENERAL", "LID_GENERAL")
	DMAddCheckbox("MMBTN", true, function()
		if DarkMode:IsEnabled("MMBTN", DarkMode:GetWoWBuild() ~= "RETAIL") then
			DarkMode:ShowMMBtn("DarkMode")
		else
			DarkMode:HideMMBtn("DarkMode")
		end
	end)

	if DarkMode.WhatsNew then DarkMode.WhatsNew:AddSettingsCheckbox(dmSettings, "2026-11-20") end
	DMAddGeneralColorMode()
	DMAddCheckbox("DESATURATE", true, function(value) DarkMode:UpdateGrayscale(value) end, nil, "LID_DESATURATE_TOOLTIP")
	if not masque then DMAddCheckbox("THINBORDERS", false, nil, nil, "LID_THINBORDERS_TOOLTIP") end
	DMAddCategory("INTERFACE", "LID_INTERFACE")
	DMAddColorMode("COLORMODE", 1, "CUSTOMUIC", true)
	DMAddColorMode("COLORMODEMI", 1, "CUSTOMMIC", true)
	DMAddColorMode("COLORMODEBA", 1, "CUSTOMBAC", true)
	DMAddColorMode("COLORMODEABTNS", off, "CUSTOMBTNS", false)
	DMAddCheckbox("MASKMINIMAPBUTTONS", true, nil, nil, "LID_MASKMINIMAPBUTTONS_TOOLTIP")
	DMAddCategory("WINDOWS", "LID_WINDOWS")
	DMAddColorMode("COLORMODEF", 1, "CUSTOMFRC", true)
	DMAddColorMode("COLORMODEFA", 1, "CUSTOMFRAC", true)
	local questChoices = {{["value"] = 0, ["label"] = "LID_QUESTBACKGROUNDWINDOWCOLOR"}}
	for _, choice in ipairs(dmChoices) do
		tinsert(questChoices, choice)
	end

	DMAddColorMode("COLORMODEQUESTBACKGROUND", 0, "CUSTOMQUESTBACKGROUNDC", false, questChoices)
	DMAddCategory("UNITFRAMES", "LID_UNITFRAMES")
	DMAddColorMode("COLORMODEUNFR", 1, "CUSTOMUFC", true)
	DMAddColorMode("COLORMODEAUNFRHPA", off, "CUSTOMUFHPC", false)
	DMAddColorMode("COLORMODEAUNFRPORA", off, "CUSTOMUFPORC", false)
	DMAddColorMode("COLORMODEAUNFRREPA", off, "CUSTOMUFREC", false)
	DMAddColorMode("COLORMODEAUNFRDRA", off, "CUSTOMUFDRC", false)
	DMAddColorMode("COLORMODEAUNFRDRAP", off, "CUSTOMUFDRPC", false)
	dmSettings:AddDropdown({
		["label"] = "LID_PLAYERDRAGON",
		["search"] = "PLAYERDRAGON",
		["value"] = DarkMode:DMGV("PLAYERDRAGON", 1),
		["width"] = DMDROPDOWNWIDTH,
		["choices"] = {
			{
				["value"] = 1,
				["label"] = "LID_Off"
			},
			{
				["value"] = 2,
				["label"] = "LID_PLAYERDRAGONELITE"
			},
			{
				["value"] = 3,
				["label"] = "LID_PLAYERDRAGONRARE"
			},
			{
				["value"] = 4,
				["label"] = "LID_PLAYERDRAGONRAREELITE"
			}
		},
		["func"] = function(value)
			DarkMode:DMSV("PLAYERDRAGON", value)
			DarkMode:UpdatePlayerDragon()
		end
	})

	DMAddCheckbox("HIDENAMEBACKGROUND", false, function() DarkMode:UpdateNameBackgrounds() end, "2026-11-19")
	DMAddCategory("ACTIONBARS", "LID_ACTIONBARS")
	DMAddColorMode("COLORMODEAB", 1, "CUSTOMABC", true)
	DMAddCheckbox("GRYPHONS", true)
	if not masque then
		DMAddCheckbox("MASKACTIONBUTTONS", true, nil, nil, "LID_MASKACTIONBUTTONS_TOOLTIP")
		DMAddCheckbox("SHADOWACTIONBARS", false, nil, nil, "LID_SHADOWACTIONBARS_TOOLTIP")
	end

	DMAddCategory("BUFFSANDDEBUFFS", "LID_BUFFSANDDEBUFFS")
	DMAddColorMode("COLORMODEBAD", 1, "CUSTOMBADC", true)
	if not masque then
		DMAddCheckbox("MASKBUFFSANDDEBUFFS", true, nil, nil, "LID_MASKBUFFSANDDEBUFFS_TOOLTIP")
		if DarkMode.CanReplaceTargetAuras and DarkMode:CanReplaceTargetAuras() then
			if DarkMode:IsBBFHandlingTargetAuras() then
				local cb = dmSettings:AddCheckbox({
					["label"] = "LID_REPLACETARGETAURAS",
					["search"] = "REPLACETARGETAURAS",
					["tooltip"] = "LID_REPLACETARGETAURAS_BBF_TOOLTIP",
					["value"] = false,
					["textFunc"] = function() return DarkMode:Trans("LID_REPLACETARGETAURAS") .. " (" .. DarkMode:Trans("LID_HANDLEDBYBBF") .. ")" end
				})

				cb:SetEnabled(false)
			else
				local replace = DMAddCheckbox(
					"REPLACETARGETAURAS",
					true,
					function()
						dmSettings:UpdateDependencies()
						DMEnableSave()
					end, "2026-11-20", "LID_REPLACETARGETAURAS_TOOLTIP"
				)

				local function IsReplaceEnabled()
					return DarkMode:IsEnabled("REPLACETARGETAURAS", true)
				end

				DarkMode:EnsureTargetAuraGlowColors()
				for _, key in ipairs({"TARGETAURAPURGEGLOW", "TARGETAURADISPELGLOW"}) do
					local cb = dmSettings:AddDependency(DMAddCheckbox(key, false, nil, "2026-11-22", "LID_" .. key .. "_TOOLTIP"), IsReplaceEnabled)
					dmSettings:AddRequirement(cb, replace)
					if cb and cb.holder then dmSettings:AddDependency(DMAddColorSwatch(cb.holder, key, DarkMode:GetTargetAuraGlowColorKey(key), true), IsReplaceEnabled, 0) end
				end

				dmSettings:UpdateDependencies()
			end
		end
	end

	DMAddCategory("NAMEPLATES", "LID_NAMEPLATES")
	DMAddColorMode("COLORMODENP", 1, "CUSTOMNPC", true)
	DMAddCategory("TOOLTIPS", "LID_Tooltips")
	DMAddColorMode("COLORMODETT", 1, "CUSTOMTTC", true)
	dmSettings:ResumeLayout()
	DMUpdateSwatches()
end

function DarkMode:ToggleSettings()
	if dmSettings == nil then return end
	if InCombatLockdown() and dmSettings:IsProtected() then
		if dmSettings.combatToggle == nil then
			dmSettings.combatToggle = CreateFrame("Frame")
			dmSettings.combatToggle:SetScript(
				"OnEvent",
				function(sel)
					sel:UnregisterEvent("PLAYER_REGEN_ENABLED")
					DarkMode:ToggleSettings()
				end
			)
		end

		dmSettings.combatToggle:RegisterEvent("PLAYER_REGEN_ENABLED")
		if dmSettings:IsShown() then
			DarkMode:INFO(DarkMode:Trans("LID_SETTINGSCLOSEAFTERCOMBAT"))
		else
			DarkMode:INFO(DarkMode:Trans("LID_SETTINGSOPENAFTERCOMBAT"))
		end

		return
	end

	local show = not dmSettings:IsShown()
	DarkMode:SetEnabled("SETTINGS", show)
	if show then
		dmSettings:Show()
	else
		dmSettings:Hide()
	end

	DMUpdateShowErrors()
end

function DarkMode:GetSettingsTitle()
	return format("|T%s:16:16:0:0|t DarkMode v%s", DarkMode:GetAddonIcon(), DarkMode:GetVersion())
end

function DarkMode:RefreshLanguage()
	if dmSettings ~= nil then
		dmSettings:RefreshLanguage()
		if dmSettings.dmRefreshLanguageButton then dmSettings.dmRefreshLanguageButton() end
	end

	if DarkMode.WhatsNew then DarkMode.WhatsNew:RefreshLanguage() end
end

function DarkMode:InitDMSettings()
	DarkMode:SetVersion()
	DMTAB = DMTAB or {}
	DMTAB["WHATSNEW"] = DMTAB["WHATSNEW"] or {}
	DarkMode.WhatsNew = DarkMode:CreateUIWhatsNew({
		["name"] = "DMWhatsNew",
		["title"] = DarkMode:GetSettingsTitle(),
		["db"] = DMTAB["WHATSNEW"],
		["since"] = "2026-11-19",
		["getSettings"] = function() return dmSettings end,
		["addLanguageButton"] = function(win) return DarkMode:AddLanguageButton(win) end
	})

	DarkMode:BuildDMSettings()
	if DarkMode:IsEnabled("SETTINGS", false) then
		dmSettings:Show()
	else
		dmSettings:Hide()
	end

	C_Timer.After(2, function() DarkMode.WhatsNew:ShowIfNew() end)
end

function DarkMode:BuildDMSettings()
	dmSettings = DarkMode:CreateUIWindow({
		["name"] = "DMSettings",
		["pTab"] = {"CENTER"},
		["width"] = DarkMode:DMGV("SETTINGSWIDTH", DMDEFAULTWIDTH),
		["height"] = DarkMode:DMGV("SETTINGSHEIGHT", DarkMode:MClamp(640, 200, GetScreenHeight())),
		["minWidth"] = 420,
		["minHeight"] = 300,
		["title"] = DarkMode:GetSettingsTitle(),
		["navigation"] = true,
		["onResize"] = function(width, height)
			DarkMode:DMSV("SETTINGSWIDTH", width)
			DarkMode:DMSV("SETTINGSHEIGHT", height)
		end,
		["onMove"] = function(p1, p3, p4, p5) DarkMode:SetElePoint("DMSettings", p1, nil, p3, p4, p5) end,
		["onClose"] = function() DarkMode:ToggleSettings() end,
		["getCollapsed"] = function(key) return DMGetCollapsed(key) end,
		["setCollapsed"] = function(key, collapsed) DMSetCollapsed(key, collapsed) end
	})

	dmSettings:SetFrameLevel(99)
	dmSettings.dmRefreshLanguageButton = DarkMode:AddLanguageButton(dmSettings)
	dmSettings:AddSearch()
	DMBuildFooter()
	DMBuildElementList()
	local dbp1, _, dbp3, dbp4, dbp5 = DarkMode:GetElePoint("DMSettings")
	if dbp1 and dbp3 then
		dmSettings:ClearAllPoints()
		dmSettings:SetPoint(dbp1, UIParent, dbp3, dbp4, dbp5)
	end

	DMUpdateShowErrors()
end
