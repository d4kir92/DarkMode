-- deDE German Deutsch

local AddOnName, DarkMode = ...

function DarkMode:Lang_deDE()
	local tab = {
		["MMBTNLEFT"] = "Linksklick => Optionen",
		["MMBTNRIGHT"] = "Rechtsklick => Minimapknopf verstecken",

		["GENERAL"] = "Allgemein",
		["SHOWMINIMAPBUTTON"] = "Minimapknopf anzeigen",
		
		["COLORMODE"] = "Farbmodus",
	}

	DarkMode:UpdateLanguageTab( tab )
end
