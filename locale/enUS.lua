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
		["COLORMODEAB"] = "Color Mode Actionbuttons",
		["COLORMODEBAD"] = "Color Mode Buffs and Debuffs",
		["COLORMODEF"] = "Color Mode Windows",
		["CUSTOMUIC"] = "Custom Ui Color",
		["CUSTOMUFC"] = "Custom UnitFrames Color",
		["CUSTOMTTC"] = "Custom Tooltip Color",
		["CUSTOMABC"] = "Custom Actionbuttons Color",
		["CUSTOMBADC"] = "Custom Buffs and Debuffs Color",
		["CUSTOMFRC"] = "Custom Windows Color",
		["MASKACTIONBUTTONS"] = "Add Border to Actionbuttons",
		["GRYPHONS"] = "Mask Gryphons",
		["MASKBUFFSANDDEBUFFS"] = "Add Border to Buffs and Debuffs",
		["MASKMINIMAPBUTTONS"] = "Add Border to Minimapbuttons",
	}

	DarkMode:UpdateLanguageTab(tab)
end