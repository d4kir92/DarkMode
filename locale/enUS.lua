-- enUS English
local _, DarkMode = ...

function DarkMode:UpdateLanguageTab(tab)
	local lang = DarkMode:GetLangTab()

	for i, v in pairs(tab) do
		lang[i] = v
	end
end

function DarkMode:Lang_enUS()
	local tab = {
		["MMBTNLEFT"] = "Left Click => Options",
		["MMBTNRIGHT"] = "Right Click => Hide Minimap Button",
		["GENERAL"] = "General",
		["SHOWMINIMAPBUTTON"] = "Show Minimap Button",
		["COLORMODE"] = "Color Mode Ui",
		["COLORMODEUF"] = "Color Mode UnitFrames",
		["COLORMODETT"] = "Color Mode Tooltips",
		["COLORMODEF"] = "Color Mode Windows",
		["CUSTOMUIC"] = "Custom Ui Color",
		["CUSTOMUFC"] = "Custom UnitFrames Color",
		["CUSTOMTTC"] = "Custom Tooltip Color",
		["CUSTOMFRC"] = "Custom Windows Color",
		["MASKACTIONBUTTONS"] = "Mask Actionbuttons",
		["GRYPHONS"] = "Mask Gryphons",
	}

	DarkMode:UpdateLanguageTab(tab)
end