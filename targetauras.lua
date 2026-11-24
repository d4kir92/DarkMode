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
	["glowFlipbookAtlas"] = "UI-HUD-ActionBar-Proc-Loop-Flipbook",
	["glowFlipbookScale"] = 1.72,
	["glowFlipbookRows"] = 6,
	["glowFlipbookCols"] = 5,
	["glowFlipbookFrames"] = 30,
	["glowFlipbookDuration"] = 1,
	["glowAtlas"] = "UI-HUD-RotationHelper-ProcAltGlow",
	["glowAtlasScale"] = 1.32,
	["glowFallbackAsset"] = "Interface\\SpellActivationOverlay\\IconAlert",
	["glowFallbackScale"] = 2,
	["glowFallbackCoords"] = {
		["left"] = 0.00781250,
		["right"] = 0.50781250,
		["top"] = 0.53515625,
		["bottom"] = 0.78515625
	},
	["glowStrength"] = 1,
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

function DarkMode:IsTargetAuraGlowAnimated()
	return DarkMode:IsEnabled("TARGETAURAGLOWANIMATED", true) and true or false
end

function DarkMode:GetTargetAuraGlowStyle(animated)
	if animated == nil then animated = DarkMode:IsTargetAuraGlowAnimated() end
	if C_Texture and C_Texture.GetAtlasInfo then
		if animated and C_Texture.GetAtlasInfo(TA.glowFlipbookAtlas) then
			return {
				["asset"] = TA.glowFlipbookAtlas,
				["isAtlas"] = true,
				["isFlipbook"] = true,
				["rows"] = TA.glowFlipbookRows,
				["cols"] = TA.glowFlipbookCols,
				["frames"] = TA.glowFlipbookFrames,
				["duration"] = TA.glowFlipbookDuration,
				["scale"] = TA.glowFlipbookScale,
				["desaturate"] = true,
				["strength"] = TA.glowStrength
			}
		end

		if C_Texture.GetAtlasInfo(TA.glowAtlas) then
			return {
				["asset"] = TA.glowAtlas,
				["isAtlas"] = true,
				["scale"] = TA.glowAtlasScale,
				["desaturate"] = true,
				["strength"] = TA.glowStrength
			}
		end
	end

	return {
		["asset"] = TA.glowFallbackAsset,
		["isAtlas"] = false,
		["scale"] = TA.glowFallbackScale,
		["texCoords"] = TA.glowFallbackCoords,
		["desaturate"] = false,
		["strength"] = TA.glowStrength
	}
end

function DarkMode:AttachTargetAuraGlowAnimation(owner, texture, style)
	if not owner or not texture or not style or not style.isFlipbook or type(owner.CreateAnimationGroup) ~= "function" then return nil end
	local anim = owner:CreateAnimationGroup()
	anim:SetLooping("REPEAT")
	local flip = anim:CreateAnimation("FlipBook")
	if not flip then return nil end
	flip:SetTarget(texture)
	flip:SetDuration(style.duration or 1)
	flip:SetFlipBookRows(style.rows or 6)
	flip:SetFlipBookColumns(style.cols or 5)
	flip:SetFlipBookFrames(style.frames or 30)
	if flip.SetFlipBookFrameWidth then flip:SetFlipBookFrameWidth(0) end
	if flip.SetFlipBookFrameHeight then flip:SetFlipBookFrameHeight(0) end
	return anim
end

function TA:CreateAssetMap(asset, texCoords)
	local assets = {}
	for _, dispelKey in ipairs(TA.dispelKeys) do
		assets[dispelKey] = {
			["asset"] = asset,
			["useAtlasSize"] = false,
			["texCoords"] = texCoords
		}
	end

	return assets
end

function TA:CreateColorMap(r, g, b)
	if not CreateColor or r == nil or g == nil or b == nil then return nil end
	local color = CreateColor(r, g, b)
	local colors = {}
	for _, dispelKey in ipairs(TA.dispelKeys) do
		colors[dispelKey] = color
	end

	return colors
end

function TA:BuildGlowOptions(entry, useAnim)
	local styles = Enum.CustomAuraButtonDispelTypeTextureStyle
	local usePreserve = useAnim and entry.animStyle and entry.animStyle.isFlipbook and styles.PreserveAsset ~= nil
	local opts = {
		["style"] = usePreserve and styles.PreserveAsset or styles.CustomAsset,
		["showWhenHarmful"] = entry.baseOptions.showWhenHarmful,
		["showWhenHelpful"] = entry.baseOptions.showWhenHelpful,
		["showWithoutDispelType"] = entry.baseOptions.showWithoutDispelType,
		["stealableFilter"] = entry.baseOptions.stealableFilter
	}

	if not usePreserve then opts["customDispelAssetMap"] = entry.staticAssets end
	local r, g, b, a = DarkMode:GetCustomColor(TA.glowColors[entry.key])
	local mult = (a or 1) * TA.glowStrength
	local colors = TA:CreateColorMap(r * mult, g * mult, b * mult)
	if colors then opts["customDispelColorMap"] = colors end
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
				DarkMode:UpdateTargetAuraBorders()
				DarkMode:UpdateTargetAuraGlows()
			end
		end)
	end

	TA.pendingFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function TA:ApplyBorder(entry)
	local button = entry.button
	local border = entry.texture
	local enabled = DarkMode:IsEnabled("MASKBUFFSANDDEBUFFS", true) and true or false
	local styles = Enum.CustomAuraButtonDispelTypeTextureStyle
	if not styles or not styles.CustomAsset then return end
	if entry.active then
		local okRemove = pcall(button.RemoveDispelTypeTexture, button, border)
		if not okRemove then
			TA:SchedulePendingGlows()
			return
		end

		entry.active = false
	end

	if not enabled then
		if not pcall(border.Hide, border) then TA:SchedulePendingGlows() end
		return
	end

	local thin = DarkMode:IsEnabled("THINBORDERS", false)
	local path = "Interface\\AddOns\\DarkMode\\media\\" .. (thin and "border_thin" or "defaultbuff2")
	local opts = {
		["style"] = styles.CustomAsset,
		["showWhenHarmful"] = false,
		["showWhenHelpful"] = true,
		["showWithoutDispelType"] = true,
		["customDispelAssetMap"] = TA:CreateAssetMap(path)
	}

	local r, g, b = DarkMode:GetTypeColor("buffsanddebuffs")
	local colors = TA:CreateColorMap(r, g, b)
	if colors then opts["customDispelColorMap"] = colors end
	local ok = pcall(button.AddDispelTypeTexture, button, border, opts)
	if not ok and opts["customDispelColorMap"] then
		opts["customDispelColorMap"] = nil
		ok = pcall(button.AddDispelTypeTexture, button, border, opts)
		if ok and r and g and b then pcall(border.SetVertexColor, border, r, g, b, 1) end
	end

	if ok then
		entry.active = true
	else
		pcall(border.Hide, border)
		TA:SchedulePendingGlows()
	end
end

function DarkMode:UpdateTargetAuraBorders()
	for _, host in pairs(TA.frames) do
		for _, entry in ipairs(host.borders) do
			TA:ApplyBorder(entry)
		end
	end
end

function TA:CreateGlowTexture(button, size, style)
	local glow = button:CreateTexture(nil, "BACKGROUND", nil, -2)
	glow:SetSize(size * style.scale, size * style.scale)
	glow:SetPoint("CENTER", button, "CENTER", 0, 0)
	if style.isAtlas then
		glow:SetAtlas(style.asset, false)
	else
		glow:SetTexture(style.asset)
		if style.texCoords then glow:SetTexCoord(style.texCoords.left, style.texCoords.right, style.texCoords.top, style.texCoords.bottom) end
	end

	if style.desaturate then glow:SetDesaturated(true) end
	glow:SetBlendMode("ADD")
	glow:Hide()
	return glow
end

function TA:ApplyGlow(entry)
	local button = entry.button
	local enabled = DarkMode:IsEnabled(entry.key, false) and true or false
	local styles = Enum.CustomAuraButtonDispelTypeTextureStyle
	local useAnim = DarkMode:IsTargetAuraGlowAnimated() and entry.animGlow ~= nil and styles and styles.PreserveAsset ~= nil
	local targetGlow = useAnim and entry.animGlow or entry.staticGlow
	if enabled and targetGlow then
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

		if entry.activeGlow then
			local oldGlow = entry.activeGlow
			local okRemove = pcall(button.RemoveDispelTypeTexture, button, oldGlow)
			if not okRemove then
				TA:SchedulePendingGlows()
				return
			end

			entry.activeGlow = nil
			if oldGlow ~= targetGlow and not pcall(oldGlow.Hide, oldGlow) then TA:SchedulePendingGlows() end
		end

		local opts, r, g, b, mult = TA:BuildGlowOptions(entry, useAnim)
		local ok = pcall(button.AddDispelTypeTexture, button, targetGlow, opts)
		if not ok and opts["customDispelColorMap"] then
			opts["customDispelColorMap"] = nil
			ok = pcall(button.AddDispelTypeTexture, button, targetGlow, opts)
			if ok then pcall(targetGlow.SetVertexColor, targetGlow, r, g, b, mult) end
		end

		if ok then
			entry.activeGlow = targetGlow
		else
			pcall(targetGlow.Hide, targetGlow)
			TA:SchedulePendingGlows()
		end
	else
		if entry.activeGlow then
			local oldGlow = entry.activeGlow
			local okRemove = pcall(button.RemoveDispelTypeTexture, button, oldGlow)
			local okHide = pcall(oldGlow.Hide, oldGlow)
			if not okRemove then
				TA:SchedulePendingGlows()
				return
			end

			entry.activeGlow = nil
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

function TA:AddGlow(host, button, size, key, baseOptions, fallback, fallbackOptions)
	local styles = Enum.CustomAuraButtonDispelTypeTextureStyle
	local staticGlow = nil
	local staticStyle = nil
	local staticAssets = nil
	local animGlow = nil
	local animStyle = nil
	if styles.CustomAsset then
		DarkMode:EnsureTargetAuraGlowColors()
		staticStyle = DarkMode:GetTargetAuraGlowStyle(false)
		staticAssets = TA:CreateAssetMap(staticStyle.asset, staticStyle.texCoords)
		staticGlow = TA:CreateGlowTexture(button, size, staticStyle)
		local flipStyle = DarkMode:GetTargetAuraGlowStyle(true)
		if flipStyle.isFlipbook then
			animStyle = flipStyle
			animGlow = TA:CreateGlowTexture(button, size, animStyle)
			local anim = DarkMode:AttachTargetAuraGlowAnimation(button, animGlow, animStyle)
			if anim then
				local ok = type(button.AddAuraShownAnimation) == "function" and pcall(button.AddAuraShownAnimation, button, anim)
				if not ok then anim:Play() end
			end
		end
	end

	local entry = {
		["button"] = button,
		["staticGlow"] = staticGlow,
		["staticStyle"] = staticStyle,
		["staticAssets"] = staticAssets,
		["animGlow"] = animGlow,
		["animStyle"] = animStyle,
		["activeGlow"] = nil,
		["baseOptions"] = baseOptions,
		["fallback"] = fallback,
		["fallbackOptions"] = fallbackOptions,
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

function TA:InitButton(host, button, size, key)
	button:SetSize(size, size)
	if button.SetFlattensRenderLayers then button:SetFlattensRenderLayers(true) end
	local icon = button:CreateTexture(nil, "BACKGROUND", nil, 0)
	icon:SetAllPoints(button)
	button.Icon = icon
	button:SetIcon(icon)
	local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
	cooldown:SetAllPoints(button)
	cooldown:SetReverse(true)
	cooldown:SetDrawEdge(true)
	cooldown:SetHideCountdownNumbers(true)
	button:SetDurationCooldown(cooldown)
	local overlay = CreateFrame("Frame", nil, button)
	overlay:SetAllPoints(button)
	overlay:SetFrameLevel(cooldown:GetFrameLevel() + 1)
	local styles = Enum.CustomAuraButtonDispelTypeTextureStyle
	local border = overlay:CreateTexture(nil, "OVERLAY", nil, 1)
	border:SetAllPoints(button)
	border:Hide()
	button.dmAuraBorder = border
	local borderEntry = {
		["button"] = button,
		["texture"] = border,
		["active"] = false
	}

	host.borders[#host.borders + 1] = borderEntry
	TA:ApplyBorder(borderEntry)
	local dispel = overlay:CreateTexture(nil, "OVERLAY", nil, 0)
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
		TA:AddGlow(host, button, size, "TARGETAURADISPELGLOW", {
			["showWhenHarmful"] = true,
			["showWhenHelpful"] = false,
			["showWithoutDispelType"] = false
		})

		local stealable = nil
		local stealableOptions = nil
		if styles.CustomAsset and Enum.CustomAuraButtonDispelTypeStealableFilter then
			stealable = overlay:CreateTexture(nil, "OVERLAY", nil, 2)
			stealable:SetSize(24, 24)
			stealable:SetPoint("CENTER", button, "CENTER", 0, 0)
			stealable:SetBlendMode("ADD")
			stealable:Hide()
			stealableOptions = {
				["style"] = styles.CustomAsset,
				["showWhenHarmful"] = false,
				["showWhenHelpful"] = true,
				["showWithoutDispelType"] = true,
				["stealableFilter"] = Enum.CustomAuraButtonDispelTypeStealableFilter.Stealable,
				["customDispelAssetMap"] = TA:CreateAssetMap("Interface\\TargetingFrame\\UI-TargetingFrame-Stealable")
			}
		end

		TA:AddGlow(host, button, size, "TARGETAURAPURGEGLOW", {
			["showWhenHarmful"] = false,
			["showWhenHelpful"] = true,
			["showWithoutDispelType"] = false
		}, stealable, stealableOptions)
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
		["borders"] = {},
		["glows"] = {}
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
