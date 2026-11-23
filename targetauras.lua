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
	["dispelKeys"] = {"None", "", "Magic", "Curse", "Disease", "Poison", "Enrage", "Bleed"},
	["glowAsset"] = "Interface\\AddOns\\DarkMode\\media\\auraglow",
	["glowScale"] = 1.6,
	["glowStrength"] = 0.85,
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

function TA:CreateAssetMap(asset)
	local assets = {}
	for _, dispelKey in ipairs(TA.dispelKeys) do
		assets[dispelKey] = {
			["asset"] = asset
		}
	end

	return assets
end

function TA:BuildGlowOptions(entry)
	local styles = Enum.CustomAuraButtonDispelTypeTextureStyle
	local opts = {
		["style"] = styles.CustomAsset,
		["showWhenHarmful"] = entry.baseOptions.showWhenHarmful,
		["showWhenHelpful"] = entry.baseOptions.showWhenHelpful,
		["showWithoutDispelType"] = entry.baseOptions.showWithoutDispelType,
		["stealableFilter"] = entry.baseOptions.stealableFilter,
		["customDispelAssetMap"] = entry.assets
	}

	local r, g, b, a = DarkMode:GetCustomColor(TA.glowColors[entry.key])
	local mult = (a or 1) * TA.glowStrength
	if CreateColor then
		local color = CreateColor(r * mult, g * mult, b * mult)
		local colors = {}
		for _, dispelKey in ipairs(TA.dispelKeys) do
			colors[dispelKey] = color
		end

		opts["customDispelColorMap"] = colors
	end

	return opts, r, g, b, mult
end

function TA:SchedulePendingGlows()
	TA.pendingGlows = true
	if TA.pendingFrame == nil then
		TA.pendingFrame = CreateFrame("Frame")
		TA.pendingFrame:SetScript("OnEvent", function(sel)
			sel:UnregisterEvent("PLAYER_REGEN_ENABLED")
			if TA.pendingGlows then
				TA.pendingGlows = nil
				DarkMode:UpdateTargetAuraGlows()
			end
		end)
	end

	TA.pendingFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function TA:ApplyGlow(entry)
	local button = entry.button
	local enabled = DarkMode:IsEnabled(entry.key, false) and true or false
	if enabled and entry.glow then
		if entry.fallback and entry.fallbackActive then
			local okRemove = pcall(button.RemoveDispelTypeTexture, button, entry.fallback)
			local okHide = pcall(entry.fallback.Hide, entry.fallback)
			if not okRemove then
				TA:SchedulePendingGlows()
				return
			end

			entry.fallbackActive = false
			if not okHide then TA:SchedulePendingGlows() end
		end

		if entry.glowActive then
			if not pcall(button.RemoveDispelTypeTexture, button, entry.glow) then
				TA:SchedulePendingGlows()
				return
			end

			entry.glowActive = false
		end

		local opts, r, g, b, mult = TA:BuildGlowOptions(entry)
		local ok = pcall(button.AddDispelTypeTexture, button, entry.glow, opts)
		if not ok and opts["customDispelColorMap"] then
			opts["customDispelColorMap"] = nil
			ok = pcall(button.AddDispelTypeTexture, button, entry.glow, opts)
			if ok then pcall(entry.glow.SetVertexColor, entry.glow, r, g, b, mult) end
		end

		if ok then
			entry.glowActive = true
		else
			pcall(entry.glow.Hide, entry.glow)
			TA:SchedulePendingGlows()
		end
	else
		if entry.glow and entry.glowActive then
			local okRemove = pcall(button.RemoveDispelTypeTexture, button, entry.glow)
			local okHide = pcall(entry.glow.Hide, entry.glow)
			if not okRemove then
				TA:SchedulePendingGlows()
				return
			end

			entry.glowActive = false
			if not okHide then TA:SchedulePendingGlows() end
		end

		if entry.fallback and not entry.fallbackActive then
			if pcall(button.AddDispelTypeTexture, button, entry.fallback, entry.fallbackOptions) then
				entry.fallbackActive = true
			else
				TA:SchedulePendingGlows()
			end
		end
	end
end

function TA:AddGlow(host, button, overlay, size, key, baseOptions, fallback, fallbackOptions)
	local styles = Enum.CustomAuraButtonDispelTypeTextureStyle
	local glow = nil
	local assets = nil
	if styles.CustomAsset then
		DarkMode:EnsureTargetAuraGlowColors()
		assets = TA:CreateAssetMap(TA.glowAsset)
		glow = overlay:CreateTexture(nil, "OVERLAY", nil, 2)
		glow:SetSize(size * TA.glowScale, size * TA.glowScale)
		glow:SetPoint("CENTER", button, "CENTER", 0, 0)
		glow:SetBlendMode("ADD")
		glow:Hide()
	end

	local entry = {
		["button"] = button,
		["glow"] = glow,
		["assets"] = assets,
		["baseOptions"] = baseOptions,
		["fallback"] = fallback,
		["fallbackOptions"] = fallbackOptions,
		["glowActive"] = false,
		["fallbackActive"] = false,
		["key"] = key
	}

	host.glows[#host.glows + 1] = entry
	TA:ApplyGlow(entry)
end

function DarkMode:UpdateTargetAuraGlows()
	DarkMode:EnsureTargetAuraGlowColors()
	for _, host in pairs(TA.frames) do
		for _, entry in ipairs(host.glows) do
			TA:ApplyGlow(entry)
		end
	end
end

function TA:UpdateBorder(host, entry)
	local border = entry.button.dmAuraBorder
	if border then pcall(border.SetShown, border, not host.harmful[entry.key]) end
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

	if key == "Second" then
		TA:AddGlow(host, button, overlay, size, "TARGETAURADISPELGLOW", {
			["showWhenHarmful"] = true,
			["showWhenHelpful"] = false,
			["showWithoutDispelType"] = false
		})

		if styles.CustomAsset and Enum.CustomAuraButtonDispelTypeStealableFilter then
			local stealable = overlay:CreateTexture(nil, "OVERLAY", nil, 1)
			stealable:SetSize(24, 24)
			stealable:SetPoint("CENTER", button, "CENTER", 0, 0)
			stealable:SetBlendMode("ADD")
			stealable:Hide()
			local stealableOptions = {
				["style"] = styles.CustomAsset,
				["showWhenHarmful"] = false,
				["showWhenHelpful"] = true,
				["showWithoutDispelType"] = true,
				["stealableFilter"] = Enum.CustomAuraButtonDispelTypeStealableFilter.Stealable,
				["customDispelAssetMap"] = TA:CreateAssetMap("Interface\\TargetingFrame\\UI-TargetingFrame-Stealable")
			}

			TA:AddGlow(host, button, overlay, size, "TARGETAURAPURGEGLOW", {
				["showWhenHarmful"] = false,
				["showWhenHelpful"] = true,
				["showWithoutDispelType"] = true,
				["stealableFilter"] = Enum.CustomAuraButtonDispelTypeStealableFilter.Stealable
			}, stealable, stealableOptions)
		end
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

	local showCount = frame.showAuraCount == true
	if host.showCount ~= showCount then
		host.showCount = showCount
		for _, count in ipairs(host.counts) do
			pcall(count.SetShown, count, showCount)
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
