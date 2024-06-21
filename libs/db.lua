local _, DarkMode = ...
function DarkMode:GetCP()
	DMTAB = DMTAB or {}
	DMTAB["CURRENTPROFILE"] = DMTAB["CURRENTPROFILE"] or "DEFAULT"

	return DMTAB["CURRENTPROFILE"]
end

function DarkMode:AddProfile(name)
	DMTAB = DMTAB or {}
	DMTAB["PROFILES"] = DMTAB["PROFILES"] or {}
	-- Profile
	DMTAB["PROFILES"][name] = DMTAB["PROFILES"][name] or {}
	-- Frames
	DMTAB["PROFILES"][name]["FRAMES"] = DMTAB["PROFILES"][name]["FRAMES"] or {}
	DMTAB["PROFILES"][name]["FRAMES"]["POINTS"] = DMTAB["PROFILES"][name]["FRAMES"]["POINTS"] or {}
	DMTAB["PROFILES"][name]["FRAMES"]["SIZES"] = DMTAB["PROFILES"][name]["FRAMES"]["SIZES"] or {}
	-- Eles
	DMTAB["PROFILES"][name]["ELES"] = DMTAB["PROFILES"][name]["ELES"] or {}
	DMTAB["PROFILES"][name]["ELES"]["POINTS"] = DMTAB["PROFILES"][name]["ELES"]["POINTS"] or {}
	DMTAB["PROFILES"][name]["ELES"]["SIZES"] = DMTAB["PROFILES"][name]["ELES"]["SIZES"] or {}
	DMTAB["PROFILES"][name]["ELES"]["OPTIONS"] = DMTAB["PROFILES"][name]["ELES"]["OPTIONS"] or {}
	DMTAB["PROFILES"][name]["ELES"]["OPTIONS"]["ACTIONBARS"] = DMTAB["PROFILES"][name]["ELES"]["OPTIONS"]["ACTIONBARS"] or {}
end

function DarkMode:InitDB()
	-- DB
	DMTAB = DMTAB or {}
	-- PROFILES
	DMTAB["PROFILES"] = DMTAB["PROFILES"] or {}
	DMTAB["CURRENTPROFILE"] = DMTAB["CURRENTPROFILE"] or "DEFAULT"
	DarkMode:AddProfile("DEFAULT")
end

function DarkMode:GetTab()
	return DMTAB["PROFILES"][DarkMode:GetCP()]
end

function DarkMode:SetEnabled(element, value)
	DarkMode:GetTab()["ELES"]["OPTIONS"][element] = DarkMode:GetTab()["ELES"]["OPTIONS"][element] or {}
	DarkMode:GetTab()["ELES"]["OPTIONS"][element]["ENABLED"] = value
end

function DarkMode:IsEnabled(element, value)
	if element == nil then
		DarkMode:MSG("[IsEnabled] Missing Name")

		return false
	end

	if value == nil then
		DarkMode:MSG("[IsEnabled] Missing Value")

		return false
	end

	DarkMode:GetTab()["ELES"]["OPTIONS"][element] = DarkMode:GetTab()["ELES"]["OPTIONS"][element] or {}
	if DarkMode:GetTab()["ELES"]["OPTIONS"][element]["ENABLED"] == nil then
		DarkMode:GetTab()["ELES"]["OPTIONS"][element]["ENABLED"] = value
	end

	return DarkMode:GetTab()["ELES"]["OPTIONS"][element]["ENABLED"]
end

function DarkMode:GetElePoint(key)
	DarkMode:GetTab()["ELES"]["POINTS"][key] = DarkMode:GetTab()["ELES"]["POINTS"][key] or {}
	local an = DarkMode:GetTab()["ELES"]["POINTS"][key]["AN"]
	local pa = DarkMode:GetTab()["ELES"]["POINTS"][key]["PA"]
	local re = DarkMode:GetTab()["ELES"]["POINTS"][key]["RE"]
	local px = DarkMode:GetTab()["ELES"]["POINTS"][key]["PX"]
	local py = DarkMode:GetTab()["ELES"]["POINTS"][key]["PY"]

	return an, pa, re, px, py
end

function DarkMode:SetElePoint(key, p1, p2, p3, p4, p5)
	DarkMode:GetTab()["ELES"]["POINTS"][key]["AN"] = p1
	DarkMode:GetTab()["ELES"]["POINTS"][key]["PA"] = p2
	DarkMode:GetTab()["ELES"]["POINTS"][key]["RE"] = p3
	DarkMode:GetTab()["ELES"]["POINTS"][key]["PX"] = p4
	DarkMode:GetTab()["ELES"]["POINTS"][key]["PY"] = p5
	local frame = _G[key]
	if frame then
		frame:ClearAllPoints()
		frame:SetPoint(p1, UIParent, p3, p4, p5)
	end
end

function DarkMode:SV(name, value)
	DMTAB = DMTAB or {}
	DMTAB["VALUES"] = DMTAB["VALUES"] or {}
	DMTAB["VALUES"][name] = value
end

function DarkMode:GV(name, value)
	DMTAB = DMTAB or {}
	DMTAB["VALUES"] = DMTAB["VALUES"] or {}
	if DMTAB["VALUES"][name] == nil then
		DarkMode:SV(name, value)
	end

	return DMTAB["VALUES"][name] or value
end

function DarkMode:GetMinimapTable()
	DMTAB["PROFILES"] = DMTAB["PROFILES"] or {}
	DarkMode:GetTab()["MMICON"] = DarkMode:GetTab()["MMICON"] or {}

	return DarkMode:GetTab()["MMICON"]
end
