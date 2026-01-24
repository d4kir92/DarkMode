local _, DarkMode = ...
local sliders = {}
local searchStr = ""
local posy = -4
local cas = {}
local cbs = {}
local sls = {}
local cps = {}
local DMColorModes = {"Dark", "Dark+", "Darker", "Darker+", "Black", "ClassColor", "Uncolored", "Custom", "Off"}
function DarkMode:GetColorModes()
	return DMColorModes
end

local function DMSetPos(ele, key, x, y, ignoreY)
	ignoreY = ignoreY or false
	y = y or 0
	if ele == nil then return false end
	ele:ClearAllPoints()
	if strfind(strlower(key), strlower(searchStr)) then
		ele:Show()
		if posy < -4 then
			posy = posy - 10
		end

		ele:SetPoint("TOPLEFT", DMSettings.SC, "TOPLEFT", x or 6, posy + y)
		if not ignoreY then
			posy = posy - 30
		end
	else
		ele:Hide()
	end

	return true
end

local function AddCategory(key)
	if cas[key] == nil then
		cas[key] = CreateFrame("Frame", key .. "_Category", DMSettings.SC)
		local ca = cas[key]
		ca:SetSize(24, 24)
		ca.f = ca:CreateFontString(nil, nil, "GameFontNormal")
		ca.f:SetPoint("LEFT", ca, "LEFT", 0, 0)
		ca.f:SetText(DarkMode:Trans("LID_" .. key))
	end

	DMSetPos(cas[key], key)
end

local function AddCheckBox(x, key, val, func)
	if val == nil then
		val = true
	end

	if cbs[key] == nil then
		cbs[key] = CreateFrame("CheckButton", key .. "_CB", DMSettings.SC, "UICheckButtonTemplate") --CreateFrame( "CheckButton", "moversettingsmove", mover, "UICheckButtonTemplate" )
		local cb = cbs[key]
		cb:SetSize(24, 24)
		cb:SetChecked(DarkMode:IsEnabled(key, val))
		cb:SetScript(
			"OnClick",
			function(sel, btn, value)
				DarkMode:SetEnabled(key, sel:GetChecked() or false)
				if func then
					func(sel, sel:GetChecked() or false)
				end

				if DMSettings.save then
					DMSettings.save:Enable()
				end
			end
		)

		cb.f = cb:CreateFontString(nil, nil, "GameFontNormal")
		cb.f:SetPoint("LEFT", cb, "RIGHT", 0, 0)
		cb.f:SetText(DarkMode:Trans("LID_" .. key))
	end

	cbs[key]:ClearAllPoints()
	if strfind(strlower(key), strlower(searchStr)) or strfind(strlower(DarkMode:Trans("LID_" .. key)), strlower(searchStr)) then
		cbs[key]:Show()
		cbs[key]:SetPoint("TOPLEFT", DMSettings.SC, "TOPLEFT", x, posy)
		posy = posy - 24
	else
		cbs[key]:Hide()
	end
end

local function AddSlider(x, key, val, func, vmin, vmax, steps, keys)
	if sls[key] == nil then
		sls[key] = DarkMode:CreateSlider(
			{
				["key"] = key,
				["name"] = key,
				["parent"] = DMSettings.SC,
				["value"] = val,
				["vmin"] = vmin,
				["vmax"] = vmax,
				["steps"] = steps,
				["ptab"] = {"TOPLEFT", DMSettings.SC, "TOPLEFT", x + 5, posy},
				["sw"] = DMSettings.SC:GetWidth() - 30 - 100 - x,
				["sh"] = 16,
				["decimals"] = 0,
			}
		)

		sls[key].key = key
		sls[key]:SetScript(
			"OnValueChanged",
			function(sel, valu)
				valu = tonumber(string.format("%0.0f", valu))
				DarkMode:DMSV(key, valu)
				if keys then
					for i, v in pairs(sliders) do
						DarkMode:DMSV(v.key, valu)
						v:SetValue(DarkMode:DMGV(v.key, valu))
					end
				end

				if func then
					func(sel, valu)
				end

				if DMSettings.save then
					DMSettings.save:Enable()
				end
			end
		)
	end

	DMSetPos(sls[key], key, x)

	return sls[key]
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

function DarkMode:AddDMColorPicker(name, parent, x, y, keyMode)
	if cps[name] == nil then
		cps[name] = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
		local btn = cps[name]
		btn:SetSize(100, 25)
		btn:SetPoint("TOPLEFT", parent, "TOPLEFT", DMSettings.SC:GetWidth() - 15 - 100, posy + 40)
		btn:SetText(DarkMode:Trans("LID_COLOR"))
		btn:SetScript(
			"OnClick",
			function()
				local r, g, b, a = DarkMode:GetCustomColor(name)
				DarkMode:ShowColorPicker(
					r,
					g,
					b,
					a,
					function(restore)
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

						DarkMode:SetCustomColor(name, newR, newG, newB, newA)
					end
				)
			end
		)

		btn:SetScript(
			"OnUpdate",
			function()
				if DarkMode:DMGV(keyMode) == 8 then
					btn:SetAlpha(1)
					btn:EnableMouse(true)
				else
					btn:SetAlpha(0)
					btn:EnableMouse(false)
				end
			end
		)
	end

	DMSetPos(cps[name], name, DMSettings.SC:GetWidth() - 15 - 100, 40, true)

	return cps[name]
end

function DarkMode:ToggleSettings()
	DarkMode:SetEnabled("SETTINGS", not DarkMode:IsEnabled("SETTINGS", false))
	if DarkMode:IsEnabled("SETTINGS", false) then
		DMSettings:Show()
		DMSettings:UpdateShowErrors()
	else
		DMSettings:Hide()
		DMSettings:UpdateShowErrors()
	end
end

local vals = {}
function DarkMode:AddColor(px, key, value, cKey, add)
	local slider = AddSlider(
		px,
		key,
		DarkMode:DMGV(key, value),
		function(sel, val)
			if vals[key] ~= val then
				vals[key] = val
				sel:SetText(DarkMode:Trans("LID_" .. key) .. ": " .. DarkMode:GetColorModes()[val])
				DarkMode:UpdateColors()
			end
		end, 1, getn(DarkMode:GetColorModes()), 1
	)

	slider:SetText(DarkMode:Trans("LID_" .. key) .. ": " .. DarkMode:GetColorModes()[DarkMode:DMGV(key, value)])
	if add then
		tinsert(sliders, slider)
	end

	DarkMode:AddDMColorPicker(cKey, DMSettings.SC, 0, 0, key)
end

function DarkMode:InitDMSettings()
	DarkMode:SetVersion(136122, "0.7.104")
	if not DarkMode:IsOldWow() then
		DMSettings = DarkMode:CreateFrame("DMSettings", UIParent, "BasicFrameTemplate")
	else
		DMSettings = CreateFrame("Frame", "DMSettings", UIParent)
		DMSettings.TitleText = DMSettings:CreateFontString(nil, nil, "GameFontNormal")
		DMSettings.TitleText:SetPoint("TOP", DMSettings, "TOP", 0, 0)
		DMSettings.CloseButton = CreateFrame("Button", "DMSettings.CloseButton", DMSettings, "UIPanelButtonTemplate")
		DMSettings.CloseButton:SetPoint("TOPRIGHT", DMSettings, "TOPRIGHT", 0, 0)
		DMSettings.CloseButton:SetSize(25, 25)
		DMSettings.CloseButton:SetText("X")
		DMSettings.bg = DMSettings:CreateTexture("DMSettings.bg", "ARTWORK")
		DMSettings.bg:SetAllPoints(DMSettings)
		if DMSettings.bg.SetColorTexture then
			DMSettings.bg:SetColorTexture(0.03, 0.03, 0.03, 0.5)
		else
			DMSettings.bg:SetTexture(0.03, 0.03, 0.03, 0.5)
		end
	end

	DMSettings:SetSize(550, DarkMode:MClamp(640, 200, GetScreenHeight()))
	DMSettings:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	DMSettings:SetFrameStrata("HIGH")
	DMSettings:SetFrameLevel(99)
	DarkMode:SetClampedToScreen(DMSettings, true)
	DMSettings:SetMovable(true)
	DMSettings:EnableMouse(true)
	DMSettings:RegisterForDrag("LeftButton")
	DMSettings:SetScript("OnDragStart", DMSettings.StartMoving)
	DMSettings:SetScript(
		"OnDragStop",
		function()
			DMSettings:StopMovingOrSizing()
			local p1, _, p3, p4, p5 = DMSettings:GetPoint()
			DarkMode:SetElePoint("DMSettings", p1, _, p3, p4, p5)
		end
	)

	if DarkMode:IsEnabled("SETTINGS", false) then
		DMSettings:Show()
	else
		DMSettings:Hide()
	end

	DMSettings.TitleText:SetText(format("|T136122:16:16:0:0|t D|cff3FC7EBark|rM|cff3FC7EBode|r v|cff3FC7EB%s", DarkMode:GetVersion()))
	DMSettings.CloseButton:SetScript(
		"OnClick",
		function()
			DarkMode:ToggleSettings()
		end
	)

	function DarkMode:UpdateElementList()
		posy = -8
		AddCategory("GENERAL")
		AddCheckBox(
			4,
			"MMBTN",
			true,
			function(sel, val)
				DarkMode:SetEnabled("MMBTN", val)
				if DarkMode:IsEnabled("MMBTN", DarkMode:GetWoWBuild() ~= "RETAIL") then
					DarkMode:ShowMMBtn("DarkMode")
				else
					DarkMode:HideMMBtn("DarkMode")
				end
			end
		)

		AddCheckBox(4, "GRYPHONS", true)
		AddCheckBox(4, "MASKMINIMAPBUTTONS", true)
		if not getglobal("MSQ") then
			AddCheckBox(4, "MASKACTIONBUTTONS", true)
			AddCheckBox(4, "MASKBUFFSANDDEBUFFS", true)
			AddCheckBox(4, "THINBORDERS", false)
		end

		posy = posy - 10
		local gCM = AddSlider(
			4,
			"COLORMODEG",
			DarkMode:DMGV("COLORMODEG", 1),
			function(sel, val)
				sel:SetText(DarkMode:Trans("LID_COLORMODEG") .. ": " .. DarkMode:GetColorModes()[val])
				DarkMode:UpdateColors()
			end, 1, getn(DarkMode:GetColorModes()), 1, {"COLORMODE", "COLORMODEUNFR", "COLORMODENP", "COLORMODETT", "COLORMODEAB", "COLORMODEBA", "COLORMODEMI", "COLORMODEBAD", "COLORMODEF", "COLORMODEFA"}
		)

		gCM:SetText(DarkMode:Trans("LID_COLORMODEG") .. ": " .. DarkMode:GetColorModes()[DarkMode:DMGV("COLORMODEG", 1)])
		posy = posy - 20
		DarkMode:AddColor(4, "COLORMODE", 1, "CUSTOMUIC", true)
		DarkMode:AddColor(30, "COLORMODENP", 1, "CUSTOMNPC", true)
		DarkMode:AddColor(30, "COLORMODETT", 1, "CUSTOMTTC", true)
		DarkMode:AddColor(30, "COLORMODEAB", 1, "CUSTOMABC", true)
		DarkMode:AddColor(30, "COLORMODEBA", 1, "CUSTOMBAC", true)
		DarkMode:AddColor(30, "COLORMODEMI", 1, "CUSTOMMIC", true)
		DarkMode:AddColor(30, "COLORMODEBAD", 1, "CUSTOMBADC", true)
		DarkMode:AddColor(30, "COLORMODEUNFR", 1, "CUSTOMUFC", true)
		DarkMode:AddColor(4, "COLORMODEF", 1, "CUSTOMFRC", true)
		DarkMode:AddColor(4, "COLORMODEFA", 1, "CUSTOMFRAC", true)
		AddCategory("ADVANCED")
		AddCheckBox(4, "DESATURATE", true)
		posy = posy - 10
		DarkMode:AddColor(4, "COLORMODEABTNS", 9, "CUSTOMBTNS", false)
		DarkMode:AddColor(4, "COLORMODEAUNFRDRA", 9, "CUSTOMUFDRC", false)
		DarkMode:AddColor(4, "COLORMODEAUNFRHPA", 9, "CUSTOMUFHPC", false)
		DarkMode:AddColor(4, "COLORMODEAUNFRPORA", 9, "CUSTOMUFPORC", false)
	end

	DMSettings.Search = CreateFrame("EditBox", "DMSettings_Search", DMSettings, "InputBoxTemplate")
	DMSettings.Search:SetPoint("TOPLEFT", DMSettings, "TOPLEFT", 12, -26)
	DMSettings.Search:SetSize(DMSettings:GetWidth() - 22 - 100, 24)
	DMSettings.Search:SetAutoFocus(false)
	DMSettings.Search:SetScript(
		"OnTextChanged",
		function(sel, ...)
			searchStr = DMSettings.Search:GetText()
			if DarkMode.UpdateElementList then
				DarkMode:UpdateElementList()
			end
		end
	)

	DMSettings.SF = CreateFrame("ScrollFrame", "DMSettings_SF", DMSettings, "UIPanelScrollFrameTemplate")
	DMSettings.SF:SetPoint("TOPLEFT", DMSettings, 8, -30 - 24)
	DMSettings.SF:SetPoint("BOTTOMRIGHT", DMSettings, -32, 24 + 8)
	DMSettings.SC = CreateFrame("Frame", "DMSettings_SC", DMSettings.SF)
	DMSettings.SC:SetSize(DMSettings.SF:GetSize())
	DMSettings.SC:SetPoint("TOPLEFT", DMSettings.SF, "TOPLEFT", 0, 0)
	DMSettings.SF:SetScrollChild(DMSettings.SC)
	DMSettings.SF.bg = DMSettings.SF:CreateTexture("DMSettings.SF.bg", "ARTWORK")
	DMSettings.SF.bg:SetAllPoints(DMSettings.SF)
	if DMSettings.SF.bg.SetColorTexture then
		DMSettings.SF.bg:SetColorTexture(0.03, 0.03, 0.03, 0.5)
	else
		DMSettings.SF.bg:SetTexture(0.03, 0.03, 0.03, 0.5)
	end

	DMSettings.save = CreateFrame("BUTTON", "DMSettings" .. ".save", DMSettings, "UIPanelButtonTemplate")
	DMSettings.save:SetSize(120, 24)
	DMSettings.save:SetPoint("TOPLEFT", DMSettings, "TOPLEFT", 4, -DMSettings:GetHeight() + 24 + 4)
	DMSettings.save:SetText(SAVE)
	DMSettings.save:SetScript(
		"OnClick",
		function()
			if C_UI then
				C_UI.Reload()
			else
				ReloadUI()
			end
		end
	)

	DMSettings.save:Disable()
	DMSettings.reload = CreateFrame("BUTTON", "DMSettings" .. ".reload", DMSettings, "UIPanelButtonTemplate")
	DMSettings.reload:SetSize(120, 24)
	DMSettings.reload:SetPoint("TOPLEFT", DMSettings, "TOPLEFT", 4 + 120 + 4, -DMSettings:GetHeight() + 24 + 4)
	DMSettings.reload:SetText(RELOADUI or "RELOADUI")
	DMSettings.reload:SetScript(
		"OnClick",
		function()
			if C_UI then
				C_UI.Reload()
			else
				ReloadUI()
			end
		end
	)

	DMSettings.showerrors = CreateFrame("BUTTON", "DMSettings" .. ".showerrors", DMSettings, "UIPanelButtonTemplate")
	DMSettings.showerrors:SetSize(120, 24)
	DMSettings.showerrors:SetPoint("TOPLEFT", DMSettings, "TOPLEFT", 4 + 120 + 4 + 120 + 4, -DMSettings:GetHeight() + 24 + 4)
	DMSettings.showerrors:SetText("Show Errors")
	DMSettings.showerrors:SetScript(
		"OnClick",
		function()
			if GetCVar("ScriptErrors") == "0" then
				SetCVar("ScriptErrors", 1)
				if C_UI then
					C_UI.Reload()
				else
					ReloadUI()
				end
			end

			DMSettings:UpdateShowErrors()
		end
	)

	function DMSettings:UpdateShowErrors()
		if GetCVar("ScriptErrors") == "0" then
			DMSettings.showerrors:Show()
		else
			DMSettings.showerrors:Hide()
		end
	end

	DMSettings:UpdateShowErrors()
	DMSettings.DISCORD = CreateFrame("EditBox", "DMSettings" .. ".DISCORD", DMSettings, "InputBoxTemplate")
	DMSettings.DISCORD:SetText("discord.gg/AYB3qR5hQm")
	DMSettings.DISCORD:SetSize(160, 24)
	DMSettings.DISCORD:SetPoint("TOPLEFT", DMSettings, "TOPLEFT", DMSettings:GetWidth() - 160 - 8, -DMSettings:GetHeight() + 24 + 4)
	DMSettings.DISCORD:SetAutoFocus(false)
	local dbp1, _, dbp3, dbp4, dbp5 = DarkMode:GetElePoint("DMSettings")
	if dbp1 and dbp3 then
		DMSettings:ClearAllPoints()
		DMSettings:SetPoint(dbp1, UIParent, dbp3, dbp4, dbp5)
	end
end
