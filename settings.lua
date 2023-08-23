local _, DarkMode = ...

local config = {
	["title"] = format("DarkMode |T136122:16:16:0:0|t v|cff3FC7EB%s", "0.3.15")
}

local searchStr = ""
local posy = -4
local cas = {}
local cbs = {}
local sls = {}
local cps = {}

local DMColorModes = {"Dark", "Dark+", "Darker", "Darker+", "Black", "ClassColor", "Default", "Custom", "Off"}

function DarkMode:GetColorModes()
	return DMColorModes
end

local function DMSetPos(ele, key, x)
	if ele == nil then return false end
	ele:ClearAllPoints()

	if strfind(strlower(key), strlower(searchStr)) then
		ele:Show()

		if posy < -4 then
			posy = posy - 10
		end

		ele:SetPoint("TOPLEFT", DMSettings.SC, "TOPLEFT", x or 6, posy)
		posy = posy - 24
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
		ca.f:SetText(DarkMode:GT(key))
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

		cb:SetScript("OnClick", function(sel)
			DarkMode:SetEnabled(key, sel:GetChecked())

			if func then
				func(sel, sel:GetChecked())
			end

			if DMSettings.save then
				DMSettings.save:Enable()
			end
		end)

		cb.f = cb:CreateFontString(nil, nil, "GameFontNormal")
		cb.f:SetPoint("LEFT", cb, "RIGHT", 0, 0)
		cb.f:SetText(DarkMode:GT(key))
	end

	cbs[key]:ClearAllPoints()

	if strfind(strlower(key), strlower(searchStr)) or strfind(strlower(DarkMode:GT(key)), strlower(searchStr)) then
		cbs[key]:Show()
		cbs[key]:SetPoint("TOPLEFT", DMSettings.SC, "TOPLEFT", x, posy)
		posy = posy - 24
	else
		cbs[key]:Hide()
	end
end

local function AddSlider(x, key, val, func, vmin, vmax, steps)
	if sls[key] == nil then
		sls[key] = CreateFrame("Slider", "sls[" .. key .. "]", DMSettings.SC, "OptionsSliderTemplate")
		sls[key]:SetWidth(DMSettings.SC:GetWidth() - 30 - x)
		sls[key]:SetPoint("TOPLEFT", DMSettings.SC, "TOPLEFT", x + 5, posy)

		if type(vmin) == "number" then
			sls[key].Low:SetText(vmin)
			sls[key].High:SetText(vmax)
			sls[key]:SetMinMaxValues(vmin, vmax)
			sls[key].Text:SetText(DarkMode:GT(key) .. ": " .. DarkMode:GV(key, val))
		else
			sls[key].Low:SetText("")
			sls[key].High:SetText("")
			sls[key]:SetMinMaxValues(1, #vmin)
			sls[key].Text:SetText(DarkMode:GT(key) .. ": " .. vmin[DarkMode:GV(key, val)])
		end

		sls[key]:SetObeyStepOnDrag(true)

		if steps then
			sls[key]:SetValueStep(steps)
		end

		sls[key]:SetValue(DarkMode:GV(key, val))

		sls[key]:SetScript("OnValueChanged", function(sel, valu)
			--valu = valu - valu % steps
			if steps then
				valu = tonumber(string.format("%" .. steps .. "f", valu))
			end

			if valu and valu ~= DarkMode:GV(key) then
				if type(vmin) == "number" then
					DarkMode:SV(key, valu)
					sls[key].Text:SetText(DarkMode:GT(key) .. ": " .. valu)
				else
					DarkMode:SV(key, valu)
					sls[key].Text:SetText(DarkMode:GT(key) .. ": " .. vmin[valu])
				end

				if func then
					func(sel, valu)
				end

				if DMSettings.save then
					DMSettings.save:Enable()
				end
			end
		end)
	end

	posy = posy - 10
	DMSetPos(sls[key], key, x)
	posy = posy - 10

	return sls[key]
end

function DarkMode:ShowColorPicker(r, g, b, a, changedCallback)
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc = changedCallback, changedCallback
	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = a ~= nil, 1 - a

	ColorPickerFrame.previousValues = {r, g, b, a}

	ColorPickerFrame:SetColorRGB(r, g, b)
	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = a ~= nil, 1 - a
	ColorPickerFrame:Hide() -- Need to run the OnShow handler.
	ColorPickerFrame:Show()
end

function DarkMode:AddColorPicker(name, parent, x, y)
	if cps[name] == nil then
		cps[name] = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
		local btn = cps[name]
		btn:SetSize(300, 25)
		btn:SetPoint("TOPLEFT", parent, "TOPLEFT", x, posy)
		btn:SetText(DarkMode:GT(name))

		btn:SetScript("OnClick", function()
			local r, g, b, a = DarkMode:GetCustomColor(name)

			DarkMode:ShowColorPicker(r, g, b, a, function(restore)
				local newR, newG, newB, newA

				if restore then
					newR, newG, newB, newA = unpack(restore)
				else
					newA, newR, newG, newB = 1 - OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
				end

				DarkMode:SetCustomColor(name, newR, newG, newB, newA)
			end)
		end)
	end

	DMSetPos(cps[name], name, x)
	posy = posy - 10

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

function DarkMode:InitDMSettings()
	DMSettings = CreateFrame("Frame", "DMSettings", UIParent, "BasicFrameTemplate")
	DMSettings:SetSize(550, 500)
	DMSettings:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	DMSettings:SetFrameStrata("HIGH")
	DMSettings:SetFrameLevel(999)
	DMSettings:SetClampedToScreen(true)
	DMSettings:SetMovable(true)
	DMSettings:EnableMouse(true)
	DMSettings:RegisterForDrag("LeftButton")
	DMSettings:SetScript("OnDragStart", DMSettings.StartMoving)

	DMSettings:SetScript("OnDragStop", function()
		DMSettings:StopMovingOrSizing()
		local p1, _, p3, p4, p5 = DMSettings:GetPoint()
		DarkMode:SetElePoint("DMSettings", p1, _, p3, p4, p5)
	end)

	if DarkMode:IsEnabled("SETTINGS", false) then
		DMSettings:Show()
	else
		DMSettings:Hide()
	end

	DMSettings.TitleText:SetText(config.title)

	DMSettings.CloseButton:SetScript("OnClick", function()
		DarkMode:ToggleSettings()
	end)

	function DMUpdateElementList()
		posy = -8
		AddCategory("GENERAL")
		AddCheckBox(4, "SHOWMINIMAPBUTTON", true, DarkMode.UpdateMinimapButton)

		if DarkMode:GetWoWBuild() ~= "RETAIL" then
			AddCheckBox(4, "MASKACTIONBUTTONS", true)
		end

		AddCheckBox(4, "GRYPHONS", true)

		local sCM = AddSlider(4, "COLORMODE", DarkMode:GV("COLORMODE", 1), function(sel, val)
			sel.Text:SetText(DarkMode:GT("COLORMODE") .. ": " .. DarkMode:GetColorModes()[val])
			DarkMode:UpdateColors()
		end, 1, getn(DarkMode:GetColorModes()), 1)

		sCM.Text:SetText(DarkMode:GT("COLORMODE") .. ": " .. DarkMode:GetColorModes()[DarkMode:GV("COLORMODE", 1)])
		DarkMode:AddColorPicker("CUSTOMUIC", DMSettings.SC, 0, 0)

		local sCMUF = AddSlider(4, "COLORMODEUF", DarkMode:GV("COLORMODEUF", 7), function(sel, val)
			sel.Text:SetText(DarkMode:GT("COLORMODEUF") .. ": " .. DarkMode:GetColorModes()[val])
			DarkMode:UpdateColors()
		end, 1, getn(DarkMode:GetColorModes()), 1)

		sCMUF.Text:SetText(DarkMode:GT("COLORMODEUF") .. ": " .. DarkMode:GetColorModes()[DarkMode:GV("COLORMODEUF", 7)])
		DarkMode:AddColorPicker("CUSTOMUFC", DMSettings.SC, 0, 0)

		local sCMTT = AddSlider(4, "COLORMODETT", DarkMode:GV("COLORMODETT", 1), function(sel, val)
			sel.Text:SetText(DarkMode:GT("COLORMODETT") .. ": " .. DarkMode:GetColorModes()[val])
			DarkMode:UpdateColors()
		end, 1, getn(DarkMode:GetColorModes()), 1)

		sCMTT.Text:SetText(DarkMode:GT("COLORMODETT") .. ": " .. DarkMode:GetColorModes()[DarkMode:GV("COLORMODETT", 7)])
		DarkMode:AddColorPicker("CUSTOMTTC", DMSettings.SC, 0, 0)

		local sCMF = AddSlider(4, "COLORMODEF", DarkMode:GV("COLORMODEF", 1), function(sel, val)
			sel.Text:SetText(DarkMode:GT("COLORMODEF") .. ": " .. DarkMode:GetColorModes()[val])
			DarkMode:UpdateColors()
		end, 1, getn(DarkMode:GetColorModes()), 1)

		sCMF.Text:SetText(DarkMode:GT("COLORMODEF") .. ": " .. DarkMode:GetColorModes()[DarkMode:GV("COLORMODEF", 1)])
		DarkMode:AddColorPicker("CUSTOMFRC", DMSettings.SC, 0, 0)
	end

	DMSettings.Search = CreateFrame("EditBox", "DMSettings_Search", DMSettings, "InputBoxTemplate")
	DMSettings.Search:SetPoint("TOPLEFT", DMSettings, "TOPLEFT", 12, -26)
	DMSettings.Search:SetSize(DMSettings:GetWidth() - 22 - 100, 24)
	DMSettings.Search:SetAutoFocus(false)

	DMSettings.Search:SetScript("OnTextChanged", function(sel, ...)
		searchStr = DMSettings.Search:GetText()
		DMUpdateElementList()
	end)

	DMSettings.SF = CreateFrame("ScrollFrame", "DMSettings_SF", DMSettings, "UIPanelScrollFrameTemplate")
	DMSettings.SF:SetPoint("TOPLEFT", DMSettings, 8, -30 - 24)
	DMSettings.SF:SetPoint("BOTTOMRIGHT", DMSettings, -32, 24 + 8)
	DMSettings.SC = CreateFrame("Frame", "DMSettings_SC", DMSettings.SF)
	DMSettings.SC:SetSize(DMSettings.SF:GetSize())
	DMSettings.SC:SetPoint("TOPLEFT", DMSettings.SF, "TOPLEFT", 0, 0)
	DMSettings.SF:SetScrollChild(DMSettings.SC)
	DMSettings.SF.bg = DMSettings.SF:CreateTexture("DMSettings.SF.bg", "ARTWORK")
	DMSettings.SF.bg:SetAllPoints(DMSettings.SF)
	DMSettings.SF.bg:SetColorTexture(0.03, 0.03, 0.03, 0.5)
	DMSettings.save = CreateFrame("BUTTON", "DMSettings" .. ".save", DMSettings, "UIPanelButtonTemplate")
	DMSettings.save:SetSize(120, 24)
	DMSettings.save:SetPoint("TOPLEFT", DMSettings, "TOPLEFT", 4, -DMSettings:GetHeight() + 24 + 4)
	DMSettings.save:SetText(SAVE)

	DMSettings.save:SetScript("OnClick", function()
		C_UI.Reload()
	end)

	DMSettings.save:Disable()
	DMSettings.reload = CreateFrame("BUTTON", "DMSettings" .. ".reload", DMSettings, "UIPanelButtonTemplate")
	DMSettings.reload:SetSize(120, 24)
	DMSettings.reload:SetPoint("TOPLEFT", DMSettings, "TOPLEFT", 4 + 120 + 4, -DMSettings:GetHeight() + 24 + 4)
	DMSettings.reload:SetText(RELOADUI)

	DMSettings.reload:SetScript("OnClick", function()
		C_UI.Reload()
	end)

	DMSettings.showerrors = CreateFrame("BUTTON", "DMSettings" .. ".showerrors", DMSettings, "UIPanelButtonTemplate")
	DMSettings.showerrors:SetSize(120, 24)
	DMSettings.showerrors:SetPoint("TOPLEFT", DMSettings, "TOPLEFT", 4 + 120 + 4 + 120 + 4, -DMSettings:GetHeight() + 24 + 4)
	DMSettings.showerrors:SetText("Show Errors")

	DMSettings.showerrors:SetScript("OnClick", function()
		if GetCVar("ScriptErrors") == "0" then
			SetCVar("ScriptErrors", 1)
			C_UI.Reload()
		end

		DMSettings:UpdateShowErrors()
	end)

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