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
	["dispelKeys"] = {"None", "Magic", "Curse", "Disease", "Poison", "Enrage", "Bleed"},
	["glowAsset"] = "Interface\\AddOns\\DarkMode\\media\\auraglow",
	["glowScale"] = 1.4,
	["glowStrength"] = 0.55,
	["glowDefault"] = {0.2, 0.6, 1, 1},
	["glowColors"] = {
		["TARGETAURAPURGEGLOW"] = "CUSTOMTARGETAURAPURGEC",
		["TARGETAURADISPELGLOW"] = "CUSTOMTARGETAURADISPELC"
	}
}

function DarkMode:EnsureTargetAuraGlowColors()
	if type(DMTAB) ~= "table" then return end
	for _, colorKey in pairs(TA.glowColors) do
		if DMTAB[colorKey .. "_r"] == nil then
			DMTAB[colorKey .. "_r"], DMTAB[colorKey .. "_g"], DMTAB[colorKey .. "_b"], DMTAB[colorKey .. "_a"] = unpack(TA.glowDefault)
		end
	end
end

function DarkMode:GetTargetAuraGlowColorKey(key)
	return TA.glowColors[key]
end

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

function TA:AddGlow(host, button, overlay, size, key, options)
	local styles = Enum.CustomAuraButtonDispelTypeTextureStyle
	if not styles.CustomAsset then return false end
	DarkMode:EnsureTargetAuraGlowColors()
	local assets = {}
	for _, dispelKey in ipairs(TA.dispelKeys) do
		assets[dispelKey] = {
			["asset"] = TA.glowAsset
		}
	end

	local holder = CreateFrame("Frame", nil, overlay)
	holder:SetAllPoints(button)
	holder:Hide()
	local glow = holder:CreateTexture(nil, "OVERLAY", nil, 2)
	glow:SetSize(size * TA.glowScale, size * TA.glowScale)
	glow:SetPoint("CENTER", button, "CENTER", 0, 0)
	glow:SetBlendMode("ADD")
	options["style"] = styles.CustomAsset
	options["customDispelAssetMap"] = assets
	if not pcall(button.AddDispelTypeTexture, button, glow, options) then
		glow:Hide()
		return false
	end

	local entry = {
		["texture"] = glow,
		["frame"] = holder,
		["host"] = host,
		["key"] = key
	}

	host.glows[#host.glows + 1] = entry
	TA:UpdateGlow(entry)
	return true
end

function TA:AddFallback(host, texture, key, hasGlow)
	local entry = {
		["texture"] = texture,
		["host"] = host,
		["key"] = key,
		["hasGlow"] = hasGlow,
		["fallback"] = true
	}

	host.glows[#host.glows + 1] = entry
	TA:UpdateGlow(entry)
end

function TA:UpdateGlow(entry)
	local enabled = DarkMode:IsEnabled(entry.key, false) == true
	if entry.key == "TARGETAURADISPELGLOW" and not entry.host.friendly then enabled = false end
	if entry.fallback then
		entry.texture:SetAlpha((enabled and entry.hasGlow) and 0 or 1)
		return
	end

	local r, g, b, a = DarkMode:GetCustomColor(TA.glowColors[entry.key])
	entry.texture:SetVertexColor(r, g, b)
	entry.frame:SetAlpha((a or 1) * TA.glowStrength)
	entry.frame:SetShown(enabled)
end

function DarkMode:UpdateTargetAuraGlows()
	DarkMode:EnsureTargetAuraGlowColors()
	for _, host in pairs(TA.frames) do
		for _, entry in ipairs(host.glows) do
			TA:UpdateGlow(entry)
		end
	end
end

function TA:UpdateBorder(host, entry)
	local border = entry.button.dmAuraBorder
	if border then border:SetShown(not host.harmful[entry.key]) end
end

function TA:InitButton(host, button, size, key)
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
	local entry = {
		["button"] = button,
		["key"] = key
	}

	host.buttons[#host.buttons + 1] = entry
	TA:UpdateBorder(host, entry)
	local overlay = CreateFrame("Frame", nil, button)
	overlay:SetAllPoints(button)
	overlay:SetFrameLevel(cooldown:GetFrameLevel() + 1)
	local styles = Enum.CustomAuraButtonDispelTypeTextureStyle
	local dispelGlow = TA:AddGlow(host, button, overlay, size, "TARGETAURADISPELGLOW", {
		["showWhenHarmful"] = true,
		["showWhenHelpful"] = false,
		["showWithoutDispelType"] = false
	})

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

	TA:AddFallback(host, dispel, "TARGETAURADISPELGLOW", dispelGlow)
	local purgeGlow = Enum.CustomAuraButtonDispelTypeStealableFilter and TA:AddGlow(host, button, overlay, size, "TARGETAURAPURGEGLOW", {
		["showWhenHarmful"] = false,
		["showWhenHelpful"] = true,
		["showWithoutDispelType"] = true,
		["stealableFilter"] = Enum.CustomAuraButtonDispelTypeStealableFilter.Stealable
	})

	if styles.CustomAsset and Enum.CustomAuraButtonDispelTypeStealableFilter then
		local stealable = overlay:CreateTexture(nil, "OVERLAY", nil, 1)
		stealable:SetSize(24, 24)
		stealable:SetPoint("CENTER", button, "CENTER", 0, 0)
		stealable:SetBlendMode("ADD")
		local assets = {}
		for _, dispelKey in ipairs(TA.dispelKeys) do
			assets[dispelKey] = {
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

		TA:AddFallback(host, stealable, "TARGETAURAPURGEGLOW", purgeGlow)
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
			pcall(TA.InitButton, TA, host, button, size, key)
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

	host.harmful.FirstMine = not friendly
	host.harmful.FirstOther = not friendly
	host.harmful.Second = friendly
	for _, entry in ipairs(host.buttons) do
		TA:UpdateBorder(host, entry)
	end

	if host.friendly ~= friendly then
		host.friendly = friendly
		for _, entry in ipairs(host.glows) do
			TA:UpdateGlow(entry)
		end
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
		["counts"] = {},
		["buttons"] = {},
		["glows"] = {},
		["harmful"] = {}
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
		pcall(TA.Configure, TA, host)
	end

	if type(frame.ConfigureAuraContainer) == "function" then hooksecurefunc(frame, "ConfigureAuraContainer", Refresh) end
	if type(frame.UpdateAuraContainerAnchors) == "function" then hooksecurefunc(frame, "UpdateAuraContainerAnchors", function() TA:Anchor(host) end) end
	hooksecurefunc(frame, "SetScale", Refresh)
	frame:HookScript("OnShow", Refresh)
	frame:HookScript("OnHide", function() container:Hide() end)
	Refresh()
end

function DarkMode:CanReplaceTargetAuras()
	return TA:IsRestricted() and TA:IsSupported() and true or false
end

function DarkMode:IsBBFHandlingTargetAuras()
	return type(BBF) == "table" and type(BetterBlizzFramesDB) == "table" and BetterBlizzFramesDB.playerAuraFiltering and true or false
end

function DarkMode:SetupRestrictedTargetAuras()
	if DarkMode:IsBBFHandlingTargetAuras() then return true end
	if not DarkMode:IsEnabled("REPLACETARGETAURAS", true) or not DarkMode:CanReplaceTargetAuras() then return false end
	pcall(TA.Setup, TA, TargetFrame, "target")
	pcall(TA.Setup, TA, FocusFrame, "focus")
	return TA.frames.target ~= nil or TA.frames.focus ~= nil
end
