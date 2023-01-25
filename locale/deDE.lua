-- deDE German Deutsch

local AddOnName, DarkMode = ...

function DarkMode:Lang_deDE()
	local tab = {
		["MMBTNLEFT"] = "Linksklick => Optionen",
		["MMBTNRIGHT"] = "Rechtsklick => Minimapknopf verstecken",

		["GENERAL"] = "Allgemein",
		["SHOWMINIMAPBUTTON"] = "Minimapknopf anzeigen",
		
		["COLORMODE"] = "Farbmodus Ui",
		["COLORMODEF"] = "Farbmodus Fenster",
	}

	DarkMode:UpdateLanguageTab( tab )
end
