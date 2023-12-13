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
		["COLORMODETT"] = "Farbmodus Tooltips",
		["COLORMODEAB"] = "Farbmodus Aktionsknöpfe",
		["COLORMODEBAD"] = "Farbmodus Buffs und Debuffs",
		["COLORMODEF"] = "Farbmodus Fenster",
		["CUSTOMUIC"] = "Benutzerdefinierte Ui Farbe",
		["CUSTOMUFC"] = "Benutzerdefinierte Einheitenfenster Farbe",
		["CUSTOMTTC"] = "Benutzerdefinierte Tooltip Farbe",
		["CUSTOMABC"] = "Benutzerdefinierte Aktionsknöpfe Farbe",
		["CUSTOMBADC"] = "Benutzerdefinierte Buffs und Debuffs Farbe",
		["CUSTOMFRC"] = "Benutzerdefinierte Fenster Farbe",
		["MASKACTIONBUTTONS"] = "Aktionsknöpfe maskieren",
		["GRYPHONS"] = "Greifen maskieren",
		["MASKBUFFSANDDEBUFFS"] = "Buffs und Debuffs maskieren",
	}

	DarkMode:UpdateLanguageTab(tab)
end