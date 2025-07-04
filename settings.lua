local _, DarkMode = ...
local sliders = {}
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
			posy = posy - 24
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
		sls[key] = CreateFrame("Slider", "sls[" .. key .. "]", DMSettings.SC, "UISliderTemplate")
		sls[key]:SetSize(DMSettings.SC:GetWidth() - 30 - 50 - x, 16)
		sls[key]:SetPoint("TOPLEFT", DMSettings.SC, "TOPLEFT", x + 5, posy)
		if sls[key].Low == nil then
			sls[key].Low = sls[key]:CreateFontString(nil, nil, "GameFontNormal")
			sls[key].Low:SetPoint("BOTTOMLEFT", sls[key], "BOTTOMLEFT", 0, -12)
			sls[key].Low:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
			sls[key].Low:SetTextColor(1, 1, 1)
		end

		if sls[key].High == nil then
			sls[key].High = sls[key]:CreateFontString(nil, nil, "GameFontNormal")
			sls[key].High:SetPoint("BOTTOMRIGHT", sls[key], "BOTTOMRIGHT", 0, -12)
			sls[key].High:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
			sls[key].High:SetTextColor(1, 1, 1)
		end

		if sls[key].Text == nil then
			sls[key].Text = sls[key]:CreateFontString(nil, nil, "GameFontNormal")
			sls[key].Text:SetPoint("TOP", sls[key], "TOP", 0, 16)
			sls[key].Text:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
			sls[key].Text:SetTextColor(1, 1, 1)
		end

		sls[key].key = key
		sls[key].SetText = function(self, text)
			if sls[key].Text then
				sls[key].Text:SetText(text)
			else
				_G["sls[" .. key .. "]" .. "Text"]:SetText(text)
			end
		end

		if type(vmin) == "number" then
			if sls[key].Low then
				sls[key].Low:SetText(vmin)
			else
				_G["sls[" .. key .. "]" .. "Low"]:SetText(vmin)
			end

			if sls[key].High then
				sls[key].High:SetText(vmax)
			else
				_G["sls[" .. key .. "]" .. "High"]:SetText(vmax)
			end

			sls[key]:SetMinMaxValues(vmin, vmax)
			if sls[key].Text then
				sls[key].Text:SetText(DarkMode:Trans("LID_" .. key) .. ": " .. DarkMode:DMGV(key, val))
			else
				_G["sls[" .. key .. "]" .. "Text"]:SetText(DarkMode:Trans("LID_" .. key) .. ": " .. DarkMode:DMGV(key, val))
			end
		else
			if sls[key].Low then
				sls[key].Low:SetText("")
			else
				_G["sls[" .. key .. "]" .. "Low"]:SetText("")
			end

			if sls[key].High then
				sls[key].High:SetText("")
			else
				_G["sls[" .. key .. "]" .. "High"]:SetText("")
			end

			sls[key]:SetMinMaxValues(1, #vmin)
			if sls[key].Text then
				sls[key].Text:SetText(DarkMode:Trans("LID_" .. key) .. ": " .. vmin[DarkMode:DMGV(key, val)])
			else
				_G["sls[" .. key .. "]" .. "Text"]:SetText(DarkMode:Trans("LID_" .. key) .. ": " .. vmin[DarkMode:DMGV(key, val)])
			end
		end

		if sls[key].SetObeyStepOnDrag then
			sls[key]:SetObeyStepOnDrag(true)
		end

		if steps then
			sls[key]:SetValueStep(steps)
		end

		sls[key]:SetValue(DarkMode:DMGV(key, val))
		sls[key]:SetScript(
			"OnValueChanged",
			function(sel, valu)
				--valu = valu - valu % steps
				if steps then
					valu = tonumber(string.format("%" .. steps .. "f", valu))
				end

				if valu and valu ~= DarkMode:DMGV(key) then
					if type(vmin) == "number" then
						DarkMode:DMSV(key, valu)
						if keys then
							for i, v in pairs(keys) do
								DarkMode:DMSV(v, valu)
							end
						end

						if sls[key].Text then
							sls[key].Text:SetText(DarkMode:Trans("LID_" .. key) .. ": " .. valu)
						else
							_G["sls[" .. key .. "]" .. "Text"]:SetText(DarkMode:Trans("LID_" .. key) .. ": " .. valu)
						end

						if keys then
							for i, v in pairs(sliders) do
								v:SetValue(DarkMode:DMGV(v.key, valu))
								v.Text:SetText(DarkMode:Trans("LID_" .. v.key) .. ": " .. DarkMode:GetColorModes()[valu])
							end
						end
					else
						DarkMode:DMSV(key, valu)
						if keys then
							for i, v in pairs(keys) do
								DarkMode:DMSV(v, valu)
							end
						end

						if sls[key].Text then
							sls[key].Text:SetText(DarkMode:Trans("LID_" .. key) .. ": " .. vmin[valu])
						else
							_G["sls[" .. key .. "]" .. "Text"]:SetText(DarkMode:Trans("LID_" .. key) .. ": " .. vmin[valu])
						end

						if keys then
							for i, v in pairs(sliders) do
								v:SetValue(DarkMode:DMGV(v.key, valu))
								v.Text:SetText(DarkMode:Trans("LID_" .. v.key) .. ": " .. vmin[valu])
							end
						end
					end

					if func then
						func(sel, valu)
					end

					if DMSettings.save then
						DMSettings.save:Enable()
					end
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

function DarkMode:InitDMSettings()
	DarkMode:SetVersion(136122, "0.7.28")
	if not DarkMode:IsOldWow() then
		DMSettings = CreateFrame("Frame", "DMSettings", UIParent, "BasicFrameTemplate")
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
		if not MSQ then
			AddCheckBox(4, "MASKACTIONBUTTONS", true)
			AddCheckBox(4, "MASKBUFFSANDDEBUFFS", true)
			AddCheckBox(4, "THINBORDERS", false)
		end

		AddCheckBox(4, "DESATURATE", true)
		AddCheckBox(4, "COLORBUTTONS", true)
		posy = posy - 10
		--AddCategory("OVERALL")
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
		--AddCategory("UI")
		local sCM = AddSlider(
			4,
			"COLORMODE",
			DarkMode:DMGV("COLORMODE", 1),
			function(sel, val)
				sel:SetText(DarkMode:Trans("LID_COLORMODE") .. ": " .. DarkMode:GetColorModes()[val])
				DarkMode:UpdateColors()
			end, 1, getn(DarkMode:GetColorModes()), 1
		)

		sCM:SetText(DarkMode:Trans("LID_COLORMODE") .. ": " .. DarkMode:GetColorModes()[DarkMode:DMGV("COLORMODE", 1)])
		tinsert(sliders, sCM)
		DarkMode:AddDMColorPicker("CUSTOMUIC", DMSettings.SC, 0, 0, "COLORMODE")
		--AddCategory("NAMEPLATES")
		local sCMNP = AddSlider(
			30,
			"COLORMODENP",
			DarkMode:DMGV("COLORMODENP", 1),
			function(sel, val)
				sel:SetText(DarkMode:Trans("LID_COLORMODENP") .. ": " .. DarkMode:GetColorModes()[val])
				DarkMode:UpdateColors()
			end, 1, getn(DarkMode:GetColorModes()), 1
		)

		sCMNP:SetText(DarkMode:Trans("LID_COLORMODENP") .. ": " .. DarkMode:GetColorModes()[DarkMode:DMGV("COLORMODENP", 1)])
		tinsert(sliders, sCMNP)
		DarkMode:AddDMColorPicker("CUSTOMNPC", DMSettings.SC, 0, 0, "COLORMODENP")
		--AddCategory("TOOLTIPS")
		local sCMTT = AddSlider(
			30,
			"COLORMODETT",
			DarkMode:DMGV("COLORMODETT", 1),
			function(sel, val)
				sel:SetText(DarkMode:Trans("LID_COLORMODETT") .. ": " .. DarkMode:GetColorModes()[val])
				DarkMode:UpdateColors()
			end, 1, getn(DarkMode:GetColorModes()), 1
		)

		sCMTT:SetText(DarkMode:Trans("LID_COLORMODETT") .. ": " .. DarkMode:GetColorModes()[DarkMode:DMGV("COLORMODETT", 1)])
		tinsert(sliders, sCMTT)
		DarkMode:AddDMColorPicker("CUSTOMTTC", DMSettings.SC, 0, 0, "COLORMODETT")
		--AddCategory("ACTIONBUTTONS")
		local sCMAB = AddSlider(
			30,
			"COLORMODEAB",
			DarkMode:DMGV("COLORMODEAB", 1),
			function(sel, val)
				sel:SetText(DarkMode:Trans("LID_COLORMODEAB") .. ": " .. DarkMode:GetColorModes()[val])
				DarkMode:UpdateColors()
			end, 1, getn(DarkMode:GetColorModes()), 1
		)

		sCMAB:SetText(DarkMode:Trans("LID_COLORMODEAB") .. ": " .. DarkMode:GetColorModes()[DarkMode:DMGV("COLORMODEAB", 1)])
		tinsert(sliders, sCMAB)
		DarkMode:AddDMColorPicker("CUSTOMABC", DMSettings.SC, 0, 0, "COLORMODEAB")
		--AddCategory("BAGS")
		local sCMBA = AddSlider(
			30,
			"COLORMODEBA",
			DarkMode:DMGV("COLORMODEBA", 1),
			function(sel, val)
				sel:SetText(DarkMode:Trans("LID_COLORMODEBA") .. ": " .. DarkMode:GetColorModes()[val])
				DarkMode:UpdateColors()
			end, 1, getn(DarkMode:GetColorModes()), 1
		)

		sCMBA:SetText(DarkMode:Trans("LID_COLORMODEBA") .. ": " .. DarkMode:GetColorModes()[DarkMode:DMGV("COLORMODEBA", 1)])
		tinsert(sliders, sCMBA)
		DarkMode:AddDMColorPicker("CUSTOMBAC", DMSettings.SC, 0, 0, "COLORMODEBA")
		--AddCategory("MICROMENU")
		local sCMMI = AddSlider(
			30,
			"COLORMODEMI",
			DarkMode:DMGV("COLORMODEMI", 1),
			function(sel, val)
				sel:SetText(DarkMode:Trans("LID_COLORMODEMI") .. ": " .. DarkMode:GetColorModes()[val])
				DarkMode:UpdateColors()
			end, 1, getn(DarkMode:GetColorModes()), 1
		)

		sCMMI:SetText(DarkMode:Trans("LID_COLORMODEMI") .. ": " .. DarkMode:GetColorModes()[DarkMode:DMGV("COLORMODEMI", 1)])
		tinsert(sliders, sCMMI)
		DarkMode:AddDMColorPicker("CUSTOMMIC", DMSettings.SC, 0, 0, "COLORMODEMI")
		--AddCategory("BUFFSANDDEBUFFS")
		local sCMBAD = AddSlider(
			30,
			"COLORMODEBAD",
			DarkMode:DMGV("COLORMODEBAD", 1),
			function(sel, val)
				sel:SetText(DarkMode:Trans("LID_COLORMODEBAD") .. ": " .. DarkMode:GetColorModes()[val])
				DarkMode:UpdateColors()
			end, 1, getn(DarkMode:GetColorModes()), 1
		)

		sCMBAD:SetText(DarkMode:Trans("LID_COLORMODEBAD") .. ": " .. DarkMode:GetColorModes()[DarkMode:DMGV("COLORMODEBAD", 1)])
		tinsert(sliders, sCMBAD)
		DarkMode:AddDMColorPicker("CUSTOMBADC", DMSettings.SC, 0, 0, "COLORMODEBAD")
		--AddCategory("UNITFRAMES")
		local sCMUF = AddSlider(
			30,
			"COLORMODEUNFR",
			DarkMode:DMGV("COLORMODEUNFR", 1),
			function(sel, val)
				sel:SetText(DarkMode:Trans("LID_COLORMODEUNFR") .. ": " .. DarkMode:GetColorModes()[val])
				DarkMode:UpdateColors()
			end, 1, getn(DarkMode:GetColorModes()), 1
		)

		sCMUF:SetText(DarkMode:Trans("LID_COLORMODEUNFR") .. ": " .. DarkMode:GetColorModes()[DarkMode:DMGV("COLORMODEUNFR", 1)])
		tinsert(sliders, sCMUF)
		DarkMode:AddDMColorPicker("CUSTOMUFC", DMSettings.SC, 0, 0, "COLORMODEUNFR")
		if PlayerFrameDragon or TargetFrameDragon then
			--AddCategory("UNITFRAMESDRAGON")
			local sCMUFDR = AddSlider(
				60,
				"COLORMODEUNFRDRA",
				DarkMode:DMGV("COLORMODEUNFRDRA", 7),
				function(sel, val)
					sel:SetText(DarkMode:Trans("LID_COLORMODEUNFRDRA") .. ": " .. DarkMode:GetColorModes()[val])
					DarkMode:UpdateColors()
				end, 1, getn(DarkMode:GetColorModes()), 1
			)

			sCMUFDR:SetText(DarkMode:Trans("LID_COLORMODEUNFRDRA") .. ": " .. DarkMode:GetColorModes()[DarkMode:DMGV("COLORMODEUNFRDRA", 7)])
			--tinsert(sliders, sCMUFDR)
			DarkMode:AddDMColorPicker("CUSTOMUFDRC", DMSettings.SC, 0, 0, "COLORMODEUNFRDRA")
		end

		--AddCategory("FRAMES")
		local sCMF = AddSlider(
			4,
			"COLORMODEF",
			DarkMode:DMGV("COLORMODEF", 1),
			function(sel, val)
				sel:SetText(DarkMode:Trans("LID_COLORMODEF") .. ": " .. DarkMode:GetColorModes()[val])
				DarkMode:UpdateColors()
			end, 1, getn(DarkMode:GetColorModes()), 1
		)

		sCMF:SetText(DarkMode:Trans("LID_COLORMODEF") .. ": " .. DarkMode:GetColorModes()[DarkMode:DMGV("COLORMODEF", 1)])
		tinsert(sliders, sCMF)
		DarkMode:AddDMColorPicker("CUSTOMFRC", DMSettings.SC, 0, 0, "COLORMODEF")
		--AddCategory("ADDONS")
		local sCMFA = AddSlider(
			4,
			"COLORMODEFA",
			DarkMode:DMGV("COLORMODEFA", 1),
			function(sel, val)
				sel:SetText(DarkMode:Trans("LID_COLORMODEFA") .. ": " .. DarkMode:GetColorModes()[val])
				DarkMode:UpdateColors()
			end, 1, getn(DarkMode:GetColorModes()), 1
		)

		sCMFA:SetText(DarkMode:Trans("LID_COLORMODEFA") .. ": " .. DarkMode:GetColorModes()[DarkMode:DMGV("COLORMODEFA", 1)])
		tinsert(sliders, sCMFA)
		DarkMode:AddDMColorPicker("CUSTOMFRAC", DMSettings.SC, 0, 0, "COLORMODEFA")
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
