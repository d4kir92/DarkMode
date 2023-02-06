-- enUS English

local AddOnName, DarkMode = ...

function DarkMode:UpdateLanguageTab( tab )
	local lang = DarkMode:GetLangTab()
	for i, v in pairs( tab ) do
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
		["COLORMODEF"] = "Color Mode Windows",

		["CUSTOMUIC"] = "Custom Ui Color",
		["CUSTOMUFC"] = "Custom UnitFrames Color",
		["CUSTOMFRC"] = "Custom Windows Color",
	}

	DarkMode:UpdateLanguageTab( tab )
end
