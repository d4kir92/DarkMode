-- deDE German Deutsch
local _, DarkMode = ...

function DarkMode:Lang_deDE()
	local tab = {
		["MMBTNLEFT"] = "Linksklick => Optionen",
		["MMBTNRIGHT"] = "Rechtsklick => Minimapknopf verstecken",
		["GENERAL"] = "Allgemein",
		["SHOWMINIMAPBUTTON"] = "Minimapknopf anzeigen",
		["COLORMODE"] = "Farbmodus Ui",
		["COLORMODEUF"] = "Farbmodus Einheitenfenster",
		["COLORMODEF"] = "Farbmodus Fenster",
		["CUSTOMUIC"] = "Benutzerdefiniert Ui Farbe",
		["CUSTOMUFC"] = "Benutzerdefiniert Einheitenfenster Farbe",
		["CUSTOMFRC"] = "Benutzerdefiniert Fenster Farbe",
	}

	DarkMode:UpdateLanguageTab(tab)
end