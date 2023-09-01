local _, DarkMode = ...
local ialang = {}

function DarkMode:GetLangTab()
	return ialang
end

function DarkMode:GT(str)
	local tab = DarkMode:GetLangTab()
	local result = tab[str]

	if result ~= nil then
		return result
	else
		DarkMode:MSG(format("Missing Translation: %s", str))

		return str
	end
end

function DarkMode:UpdateLanguage()
	DarkMode:Lang_enUS()

	if GetLocale() == "deDE" then
		DarkMode:Lang_deDE()
	elseif GetLocale() == "zhCN" then
		DarkMode:Lang_zhCN()
	elseif GetLocale() == "zhTW" then
		DarkMode:Lang_zhTW()
	elseif GetLocale() == "enUS" then
		DarkMode:Lang_enUS()
	end
end

DarkMode:UpdateLanguage()