local _, DarkMode = ...
local TA = {
	["frames"] = {},
	["small"] = 17,
	["large"] = 21,
	["spacing"] = 3,
	["lineSize"] = 122,
	["totLineSize"] = 101,
	["startX"] = 5,
	["startY"] = 9,
	["mirroredStartY"] = -6,
	["maxBuffs"] = 32,
	["maxDebuffs"] = 16,
	["dispelKeys"] = {"None", "Magic", "Curse", "Disease", "Poison", "Enrage", "Bleed"}
}

function TA:IsRestricted()
	if type(GetBuildOption) ~= "function" then return false end
	local ok, value = pcall(GetBuildOption, "RestrictedAuraAPI")
	return ok and value == true
end

function TA:IsSupported()
	return AuraUtil and AuraUtil.AuraFilters and AuraUtil.IsValidFilterString and AnchorUtil and AnchorUtil.FlowDirection and Enum and Enum.CustomAuraButtonDispelTypeTextureStyle ~= nil
end

function TA:Bool(func, ...)
	local ok, value = pcall(func, ...)
	if not ok or DarkMode:IsSecret(value) then return nil end
	return value
end

function TA:Filter(...)
	local parts = {}
	for index = 1, select("#", ...) do
		local part = select(index, ...)
		if part then parts[#parts + 1] = part end
	end

	local filter = table.concat(parts, "|")
	if AuraUtil.IsValidFilterString(filter) then return filter end
	return nil
end

function TA:InitButton(host, button, size)
	button:SetSize(size, size)
	if button.SetFlattensRenderLayers then button:SetFlattensRenderLayers(true) end
	local icon = button:CreateTexture(nil, "BACKGROUND")
	icon:SetAllPoints(button)
	button.Icon = icon
	button:SetIcon(icon)
	local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
	cooldown:SetAllPoints(button)
	cooldown:SetReverse(true)
	cooldown:SetDrawEdge(true)
	cooldown:SetHideCountdownNumbers(true)
	button:SetDurationCooldown(cooldown)
	DarkMode:ColorAuraButton(button, true)
	local overlay = CreateFrame("Frame", nil, button)
	overlay:SetAllPoints(button)
	overlay:SetFrameLevel(cooldown:GetFrameLevel() + 1)
	local styles = Enum.CustomAuraButtonDispelTypeTextureStyle
	local dispel = overlay:CreateTexture(nil, "OVERLAY")
	dispel:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
	dispel:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
	dispel:SetPoint("TOPLEFT", button, "TOPLEFT", -1, 1)
	dispel:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
	button:AddDispelTypeTexture(dispel, {
		["style"] = styles.PreserveAsset,
		["showWhenHarmful"] = true,
		["showWhenHelpful"] = false,
		["showWithoutDispelType"] = true
	})

	if styles.CustomAsset and Enum.CustomAuraButtonDispelTypeStealableFilter then
		local stealable = overlay:CreateTexture(nil, "OVERLAY", nil, 1)
		stealable:SetSize(24, 24)
		stealable:SetPoint("CENTER", button, "CENTER", 0, 0)
		stealable:SetBlendMode("ADD")
		local assets = {}
		for _, key in ipairs(TA.dispelKeys) do
			assets[key] = {
				["asset"] = "Interface\\TargetingFrame\\UI-TargetingFrame-Stealable"
			}
		end

		button:AddDispelTypeTexture(stealable, {
			["style"] = styles.CustomAsset,
			["showWhenHarmful"] = false,
			["showWhenHelpful"] = true,
			["showWithoutDispelType"] = true,
			["stealableFilter"] = Enum.CustomAuraButtonDispelTypeStealableFilter.Stealable,
			["customDispelAssetMap"] = assets
		})
	end

	local count = overlay:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
	count:SetJustifyH("RIGHT")
	count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, 0)
	count:SetShown(host.showCount ~= false)
	button:SetApplicationCount(count)
	host.counts[#host.counts + 1] = count
	if button.SetCancelAuraButtons then button:SetCancelAuraButtons(nil) end
end

function TA:AddGroup(host, key, size, layoutIndex, forceNewLine)
	local spacing = TA.spacing
	host.container:AddAuraGroup(key, AuraUtil.AuraFilters.Helpful, {
		["maxFrameCount"] = 0,
		["initializeFrame"] = function(button)
			host.initCalls = (host.initCalls or 0) + 1
			TA:Try("InitButton " .. host.unit, TA.InitButton, TA, host, button, size)
		end,
		["layout"] = {
			["elementSpacing"] = spacing,
			["lineSpacing"] = spacing,
			["groupSpacing"] = spacing,
			["groupLineSpacing"] = spacing,
			["forceNewLine"] = forceNewLine,
			["elementWidth"] = size,
			["elementHeight"] = size,
			["layoutIndex"] = layoutIndex
		}
	})
end

function TA:ShouldHideOtherDebuffs(unit, friendly)
	if friendly then return false end
	if GetCVarBool and TA:Bool(GetCVarBool, "noBuffDebuffFilterOnTarget") then return false end
	if TA:Bool(UnitIsUnit, "player", unit) then return false end
	if TA:Bool(UnitIsPlayer, unit) then return false end
	if UnitIsOtherPlayersPet and TA:Bool(UnitIsOtherPlayersPet, unit) then return false end
	return true
end

function TA:BuffsDisabled()
	if not C_GameRules or not C_GameRules.IsGameRuleActive or not Enum.GameRule or not Enum.GameRule.TargetFrameBuffsDisabled then return false end
	return TA:Bool(C_GameRules.IsGameRuleActive, Enum.GameRule.TargetFrameBuffsDisabled) == true
end

function TA:SetGroup(container, key, filter, maxCount, candidates)
	if filter == nil then maxCount = 0 end
	if filter then container:SetAuraGroupFilterString(key, filter) end
	container:SetAuraGroupCandidateFilters(key, candidates)
	container:SetAuraGroupMaxFrameCount(key, maxCount)
end

function TA:Configure(host)
	local frame = host.frame
	local container = host.container
	local unit = host.unit
	local AF = AuraUtil.AuraFilters
	local friendly = TA:Bool(UnitIsFriend, "player", unit) == true
	local maxBuffs = frame.maxBuffs or TA.maxBuffs
	local maxDebuffs = frame.maxDebuffs or TA.maxDebuffs
	if TA:BuffsDisabled() then maxBuffs = 0 end
	local helpful = AF.Helpful
	local harmful = AF.Harmful
	local nameplate = AF.IncludeNameplateOnly
	local player = AF.Player
	local notPlayer = "!" .. player
	local otherCandidates = nil
	if TA:ShouldHideOtherDebuffs(unit, friendly) then
		otherCandidates = {
			["isFromPlayerOrPlayerPet"] = false
		}
	end

	local split = TA:Filter(helpful, notPlayer) ~= nil
	if not split then
		notPlayer = nil
		otherCandidates = nil
	end
	if friendly then
		TA:SetGroup(container, "FirstMine", split and TA:Filter(helpful, player) or nil, maxBuffs)
		TA:SetGroup(container, "FirstOther", TA:Filter(helpful, notPlayer), maxBuffs)
		TA:SetGroup(container, "Second", TA:Filter(harmful, nameplate), maxDebuffs)
	else
		TA:SetGroup(container, "FirstMine", split and TA:Filter(harmful, player, nameplate) or nil, maxDebuffs)
		TA:SetGroup(container, "FirstOther", TA:Filter(harmful, notPlayer, nameplate), maxDebuffs, otherCandidates)
		TA:SetGroup(container, "Second", TA:Filter(helpful), maxBuffs)
	end

	local showCount = frame.showAuraCount == true
	if host.showCount ~= showCount then
		host.showCount = showCount
		for _, count in ipairs(host.counts) do
			count:SetShown(showCount)
		end
	end

	local tot = frame.totFrame and frame.totFrame:IsShown()
	container:SetFlowLayoutMaximumLineSize(tot and (frame.TOT_AURA_ROW_WIDTH or TA.totLineSize) or TA.lineSize)
	TA:Anchor(host)
	if frame.GetEffectiveScale and UIParent:GetEffectiveScale() > 0 then container:SetScale(frame:GetEffectiveScale() / UIParent:GetEffectiveScale()) end
	container:SetFrameStrata(frame:GetFrameStrata())
	container:SetFrameLevel(frame:GetFrameLevel() + 30)
	container:SetShown(frame:IsShown())
	container:UpdateAllAuras()
end

function TA:Anchor(host)
	local frame = host.frame
	local container = host.container
	local anchor = frame.TargetFrameContainer and frame.TargetFrameContainer.FrameTexture or frame
	local mirrored = frame.buffsOnTop == true
	container:ClearAllPoints()
	if mirrored then
		local offsetY = TA.mirroredStartY
		local threat = frame.threatNumericIndicator
		if threat and threat:IsShown() then offsetY = offsetY + threat:GetHeight() end
		container:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", TA.startX, offsetY)
		container:SetFlowLayoutAnchorPoint("BOTTOMLEFT")
		container:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, AnchorUtil.FlowDirection.Up)
	else
		container:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", TA.startX, TA.startY)
		container:SetFlowLayoutAnchorPoint("TOPLEFT")
		container:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, AnchorUtil.FlowDirection.Down)
	end
end

function TA:Setup(frame, unit)
	if not frame or TA.frames[unit] or not frame.GetAuraContainer then return end
	local blizzard = frame:GetAuraContainer()
	if not blizzard or DarkMode:IsForbidden(blizzard) then return end
	local ok, container = pcall(CreateFrame, "AuraContainer", nil, UIParent, "CustomAuraContainerTemplate")
	if not ok or not container then return end
	local host = {
		["frame"] = frame,
		["unit"] = unit,
		["container"] = container,
		["counts"] = {}
	}

	TA.frames[unit] = host
	if container.SetFlattensRenderLayers then container:SetFlattensRenderLayers(true) end
	TA:AddGroup(host, "FirstMine", TA.large, 1, false)
	TA:AddGroup(host, "FirstOther", TA.small, 2, false)
	TA:AddGroup(host, "Second", TA.small, 3, true)
	container:SetUnit(unit)
	container:SetEnabled(true)
	blizzard:SetAlpha(0)
	hooksecurefunc(blizzard, "SetAlpha", function(sel, alpha)
		if not DarkMode:IsSecret(alpha) and alpha ~= 0 then sel:SetAlpha(0) end
	end)

	local function Refresh()
		host.configureCalls = (host.configureCalls or 0) + 1
		TA:Try("Configure " .. unit, TA.Configure, TA, host)
	end

	if type(frame.ConfigureAuraContainer) == "function" then hooksecurefunc(frame, "ConfigureAuraContainer", Refresh) end
	if type(frame.UpdateAuraContainerAnchors) == "function" then hooksecurefunc(frame, "UpdateAuraContainerAnchors", function() TA:Anchor(host) end) end
	hooksecurefunc(frame, "SetScale", Refresh)
	frame:HookScript("OnShow", Refresh)
	frame:HookScript("OnHide", function() container:Hide() end)
	Refresh()
end

function TA:Try(label, func, ...)
	local ok, err = pcall(func, ...)
	if not ok then
		TA.errors = TA.errors or {}
		if #TA.errors < 20 then TA.errors[#TA.errors + 1] = label .. ": " .. tostring(err) end
	end
	return ok
end

function DarkMode:SetupRestrictedTargetAuras()
	TA.setupCalled = true
	if not TA:IsRestricted() or not TA:IsSupported() then return false end
	TA:Try("Setup target", TA.Setup, TA, TargetFrame, "target")
	TA:Try("Setup focus", TA.Setup, TA, FocusFrame, "focus")
	return TA.frames.target ~= nil or TA.frames.focus ~= nil
end

function TA:Value(func, obj, ...)
	if not obj or type(obj[func]) ~= "function" then return "n/a" end
	local results = {pcall(obj[func], obj, ...)}
	if not results[1] then return "ERR " .. tostring(results[2]) end
	local out = {}
	for index = 2, #results do
		local value = results[index]
		if DarkMode:IsSecret(value) then
			out[#out + 1] = "secret"
		elseif type(value) == "table" then
			out[#out + 1] = (type(value.GetName) == "function" and value:GetName()) or "table"
		else
			out[#out + 1] = tostring(value)
		end
	end
	return table.concat(out, ",")
end

function TA:Debug()
	local lines = {}
	local function Add(...)
		lines[#lines + 1] = table.concat({...}, " ")
	end

	Add("setupCalled", tostring(TA.setupCalled), "restricted", tostring(TA:IsRestricted()), "supported", tostring(TA:IsSupported() and true or false))
	Add("option", tostring(DarkMode:IsEnabled("MASKBUFFSANDDEBUFFS", true)), "styleEnum", tostring(Enum and Enum.CustomAuraButtonDispelTypeTextureStyle ~= nil), "stealEnum", tostring(Enum and Enum.CustomAuraButtonDispelTypeStealableFilter ~= nil))
	for _, unit in ipairs({"target", "focus"}) do
		local host = TA.frames[unit]
		if host then
			local c = host.container
			local f = host.frame
			Add("[" .. unit .. "]", "configure", tostring(host.configureCalls), "init", tostring(host.initCalls), "buttons", tostring(#host.counts), "frameShown", TA:Value("IsShown", f))
			Add(" shown", TA:Value("IsShown", c), "visible", TA:Value("IsVisible", c), "alpha", TA:Value("GetEffectiveAlpha", c), "scale", TA:Value("GetEffectiveScale", c), "strata", TA:Value("GetFrameStrata", c), "level", TA:Value("GetFrameLevel", c))
			Add(" size", TA:Value("GetSize", c), "points", TA:Value("GetNumPoints", c), "point1", TA:Value("GetPoint", c, 1), "unit", TA:Value("GetUnit", c), "enabled", TA:Value("IsEnabled", c))
			Add(" frame strata", TA:Value("GetFrameStrata", f), "level", TA:Value("GetFrameLevel", f), "blizzAlpha", TA:Value("GetAlpha", f:GetAuraContainer()))
			for _, key in ipairs({"FirstMine", "FirstOther", "Second"}) do
				local first = c.GetAuraGroupFrame and select(2, pcall(c.GetAuraGroupFrame, c, key, 1)) or nil
				local firstInfo = "none"
				if type(first) == "table" then firstInfo = "shown " .. TA:Value("IsShown", first) .. " visible " .. TA:Value("IsVisible", first) .. " size " .. TA:Value("GetSize", first) .. " pt " .. TA:Value("GetPoint", first, 1) end
				Add(" group", key, "enabled", TA:Value("IsAuraGroupEnabled", c, key), "frames", TA:Value("GetAuraGroupFrameCount", c, key), "first:", firstInfo)
			end
		else
			Add("[" .. unit .. "] no host")
		end
	end

	for _, err in ipairs(TA.errors or {}) do
		Add("ERROR", err)
	end

	return table.concat(lines, "\n")
end

SLASH_DARKMODETA1 = "/dmta"
SlashCmdList["DARKMODETA"] = function()
	for line in string.gmatch(TA:Debug(), "[^\n]+") do
		print("|cff9999ffDMTA|r " .. line)
	end
end
