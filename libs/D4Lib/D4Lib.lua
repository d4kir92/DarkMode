local _, D4 = ...
--[[ Basics ]]
local buildNr = select(4, GetBuildInfo())
local buildName = "CLASSIC"
if buildNr >= 100000 then
    buildName = "RETAIL"
elseif buildNr >= 40000 then
    buildName = "CATA"
elseif buildNr >= 30000 then
    buildName = "WRATH"
elseif buildNr >= 20000 then
    buildName = "TBC"
end

function D4:GetWoWBuildNr()
    return buildNr
end

function D4:GetWoWBuild()
    return buildName
end

D4.oldWow = D4.oldWow or false
if C_Timer == nil then
    D4:MSG("[D4] ADD C_Timer")
    C_Timer = {}
    local f = CreateFrame("Frame")
    f.tab = {}
    f:HookScript(
        "OnUpdate",
        function()
            for i, v in pairs(f.tab) do
                if v[1] < GetTime() then
                    local func = v[2]
                    func()
                    tremove(f.tab, i)
                end
            end
        end
    )

    C_Timer.After = function(duration, callback)
        tinsert(f.tab, {GetTime() + duration, callback})
    end

    D4.oldWow = true
end

if GetClassColor == nil then
    D4:MSG("[D4] ADD GetClassColor")
    GetClassColor = function(classFilename)
        local color = RAID_CLASS_COLORS[classFilename]
        if color then return color.r, color.g, color.b, color.colorStr end

        return 1, 1, 1, "ffffffff"
    end

    D4.oldWow = true
end

function D4:IsOldWow()
    return D4.oldWow
end

function D4:RegisterEvent(frame, event, unit)
    if C_EventUtils.IsEventValid(event) then
        if unit then
            frame:RegisterUnitEvent(event, "player")
        else
            frame:RegisterEvent(event)
        end
    end
end

--[[ QOL ]]
local ICON_TAG_LIST_EN = {
    ["star"] = 1,
    ["yellow"] = 1,
    ["cirlce"] = 2,
    ["orange"] = 2,
    ["diamond"] = 3,
    ["triangle"] = 4,
    ["moon"] = 5,
    ["square"] = 6,
    ["blue"] = 6,
    ["cross"] = 7,
    ["red"] = 7,
    ["skull"] = 8,
}

function D4:SafeExec(sel, func)
    if InCombatLockdown() and sel:IsProtected() then return end
    func()
end

function D4:GetCVar(name)
    if C_CVar and C_CVar.GetCVar then return C_CVar.GetCVar(name) end
    if GetCVar then return GetCVar(name) end
    D4:MSG("[D4][GetCVar] FAILED")

    return nil
end

function D4:GetItemInfo(itemID)
    if itemID == nil then return nil end
    if C_Item and C_Item.GetItemInfo then return C_Item.GetItemInfo(itemID) end
    if GetItemInfo then return GetItemInfo(itemID) end
    D4:MSG("[D4][GetItemInfo] FAILED")

    return nil
end

function D4:GetSpellInfo(spellID)
    if spellID == nil then return nil end
    if C_Spell and C_Spell.GetSpellInfo then
        local tab = C_Spell.GetSpellInfo(spellID)
        if tab then return tab.name, tab.rank, tab.iconID, tab.castTime, tab.minRange, tab.maxRange, tab.spellID end

        return tab
    end

    if GetSpellInfo then return GetSpellInfo(spellID) end
    D4:MSG("[D4][GetSpellInfo] FAILED")

    return nil
end

function D4:IsSpellInRange(spellID, spellType, unit)
    if spellID == nil then return nil end
    if C_Spell and C_Spell.IsSpellInRange then return C_Spell.IsSpellInRange(spellID, spellType, unit) end
    if IsSpellInRange then return IsSpellInRange(spellID, spellType, unit) end
    D4:MSG("[D4][IsSpellInRange] FAILED")

    return nil
end

function D4:GetSpellCharges(spellID)
    if spellID == nil then return nil end
    if C_Spell and C_Spell.GetSpellCharges then return C_Spell.GetSpellCharges(spellID) end
    if GetSpellCharges then return GetSpellCharges(spellID) end
    D4:MSG("[D4][GetSpellCharges] FAILED")

    return nil
end

function D4:GetSpellCastCount(...)
    if spellID == nil then return nil end
    if C_Spell and C_Spell.GetSpellCastCount then return C_Spell.GetSpellCastCount(...) end
    if GetSpellCastCount then return GetSpellCastCount(...) end
    D4:MSG("[D4][GetSpellCastCount] FAILED")

    return nil
end

function D4:GetMouseFocus()
    if GetMouseFoci then return GetMouseFoci()[1] end
    if GetMouseFocus then return GetMouseFocus() end
    D4:MSG("[D4][GetMouseFocus] FAILED")

    return nil
end

function D4:UnitAura(...)
    if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then return C_UnitAuras.GetAuraDataByIndex(...) end
    if UnitAura then return UnitAura(...) end
    D4:MSG("[D4][UnitAura] FAILED")

    return nil
end

function D4:LoadAddOn(name)
    if C_AddOns and C_AddOns.LoadAddOn then return C_AddOns.LoadAddOn(name) end
    if LoadAddOn then return LoadAddOn(name) end
    D4:MSG("[D4][LoadAddOn] FAILED")

    return nil
end

function D4:IsAddOnLoaded(name)
    if C_AddOns and C_AddOns.IsAddOnLoaded then return C_AddOns.IsAddOnLoaded(name) end
    if IsAddOnLoaded then return IsAddOnLoaded(name) end
    D4:MSG("[D4][IsAddOnLoaded] FAILED")

    return nil
end

function D4:GetName(frameOrTexture)
    if frameOrTexture and frameOrTexture.GetName then return frameOrTexture:GetName() end

    return nil
end

local function FixIconChat(sel, event, message, author, ...)
    if ICON_LIST then
        for tag in string.gmatch(message, "%b{}") do
            local term = strlower(string.gsub(tag, "[{}]", ""))
            if ICON_TAG_LIST_EN[term] and ICON_LIST[ICON_TAG_LIST_EN[term]] then
                message = string.gsub(message, tag, ICON_LIST[ICON_TAG_LIST_EN[term]] .. "0|t")
            end
        end
    end

    return false, message, author, ...
end

local chatChannels = {}
for i, v in pairs(_G) do
    if string.find(i, "CHAT_MSG_", 1, true) and not tContains(chatChannels, i) then
        tinsert(chatChannels, i)
    end
end

for i, v in pairs(chatChannels) do
    ChatFrame_AddMessageEventFilter(i, FixIconChat)
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", FixIconChat)
if D4:GetWoWBuild() == "CLASSIC" then
    C_Timer.After(
        2,
        function()
            -- FIX HEALTH
            D4.fixedHealth = D4.fixedHealth or false
            if D4.fixedHealth == false then
                D4.fixedHealth = true
                local foundText = false
                local HealthBarTexts = {TargetFrameHealthBar.RightText, TargetFrameHealthBar.LeftText, TargetFrameHealthBar.TextString, TargetFrameTextureFrameDeadText}
                for _, healthBar in pairs(HealthBarTexts) do
                    if TargetFrameHealthBar.TextString ~= nil then
                        foundText = true
                    end
                end

                if foundText == false then
                    TargetFrameTextureFrame:CreateFontString("TargetFrameHealthBarText", "BORDER", "TextStatusBarText")
                    TargetFrameTextureFrame:CreateFontString("TargetFrameHealthBarTextLeft", "BORDER", "TextStatusBarText")
                    TargetFrameTextureFrame:CreateFontString("TargetFrameHealthBarTextRight", "BORDER", "TextStatusBarText")
                    TargetFrameTextureFrame:CreateFontString("TargetFrameManaBarText", "BORDER", "TextStatusBarText")
                    TargetFrameTextureFrame:CreateFontString("TargetFrameManaBarTextLeft", "BORDER", "TextStatusBarText")
                    TargetFrameTextureFrame:CreateFontString("TargetFrameManaBarTextRight", "BORDER", "TextStatusBarText")
                    TargetFrameHealthBarText:ClearAllPoints()
                    TargetFrameHealthBarTextLeft:ClearAllPoints()
                    TargetFrameHealthBarTextRight:ClearAllPoints()
                    TargetFrameManaBarText:ClearAllPoints()
                    TargetFrameManaBarTextLeft:ClearAllPoints()
                    TargetFrameManaBarTextRight:ClearAllPoints()
                    TargetFrameHealthBarText:SetPoint("CENTER", TargetFrameHealthBar, "CENTER", 0, 0)
                    TargetFrameHealthBarTextLeft:SetPoint("LEFT", TargetFrameHealthBar, "LEFT", 0, 0)
                    TargetFrameHealthBarTextRight:SetPoint("RIGHT", TargetFrameHealthBar, "RIGHT", 0, 0)
                    TargetFrameManaBarText:SetPoint("CENTER", TargetFrameManaBar, "CENTER", 0, 0)
                    TargetFrameManaBarTextLeft:SetPoint("LEFT", TargetFrameManaBar, "LEFT", 2, 0)
                    TargetFrameManaBarTextRight:SetPoint("RIGHT", TargetFrameManaBar, "RIGHT", -2, 0)
                    TargetFrameHealthBar.LeftText = TargetFrameHealthBarTextLeft
                    TargetFrameHealthBar.RightText = TargetFrameHealthBarTextRight
                    TargetFrameManaBar.LeftText = TargetFrameManaBarTextLeft
                    TargetFrameManaBar.RightText = TargetFrameManaBarTextRight
                    UnitFrameHealthBar_Initialize("target", TargetFrameHealthBar, TargetFrameHealthBarText, true)
                    UnitFrameManaBar_Initialize("target", TargetFrameManaBar, TargetFrameManaBarText, true)
                    if FocusFrame then
                        UnitFrameHealthBar_Initialize("focus", FocusFrameHealthBar, FocusFrameHealthBarText, true)
                        UnitFrameManaBar_Initialize("focus", FocusFrameManaBar, FocusFrameManaBarText, true)
                    end

                    local function TextStatusBar_UpdateTextStringWithValues(statusFrame, textString, value, valueMin, valueMax)
                        if statusFrame.LeftText and statusFrame.RightText then
                            statusFrame.LeftText:SetText("")
                            statusFrame.RightText:SetText("")
                            statusFrame.LeftText:Hide()
                            statusFrame.RightText:Hide()
                        end

                        if (tonumber(valueMax) ~= valueMax or valueMax > 0) and not statusFrame.pauseUpdates then
                            statusFrame:Show()
                            if (statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable) or statusFrame.forceShow then
                                textString:Show()
                            elseif statusFrame.lockShow > 0 and (not statusFrame.forceHideText) then
                                textString:Show()
                            else
                                textString:SetText("")
                                textString:Hide()

                                return
                            end

                            if value == 0 and statusFrame.zeroText then
                                textString:SetText(statusFrame.zeroText)
                                statusFrame.isZero = 1
                                textString:Show()

                                return
                            end

                            statusFrame.isZero = nil
                            local valueDisplay = value
                            local valueMaxDisplay = valueMax
                            if statusFrame.numericDisplayTransformFunc then
                                valueDisplay, valueMaxDisplay = statusFrame.numericDisplayTransformFunc(value, valueMax)
                            else
                                valueDisplay = AbbreviateLargeNumbers(value)
                                valueMaxDisplay = AbbreviateLargeNumbers(valueMax)
                            end

                            local shouldUsePrefix = statusFrame.prefix and (statusFrame.alwaysPrefix or not (statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable))
                            local displayMode = GetCVar("statusTextDisplay")
                            if statusFrame.showNumeric then
                                displayMode = "NUMERIC"
                            end

                            if statusFrame.disablePercentages and displayMode == "PERCENT" then
                                displayMode = "NUMERIC"
                            end

                            if valueMax <= 0 or displayMode == "NUMERIC" or displayMode == "NONE" then
                                if shouldUsePrefix then
                                    textString:SetText(statusFrame.prefix .. " " .. valueDisplay .. " / " .. valueMaxDisplay)
                                else
                                    textString:SetText(valueDisplay .. " / " .. valueMaxDisplay)
                                end
                            elseif displayMode == "BOTH" then
                                if statusFrame.LeftText and statusFrame.RightText then
                                    if not statusFrame.disablePercentages and (not statusFrame.powerToken or statusFrame.powerToken == "MANA") then
                                        statusFrame.LeftText:SetText(math.ceil((value / valueMax) * 100) .. "%")
                                        statusFrame.LeftText:Show()
                                    end

                                    statusFrame.RightText:SetText(valueDisplay)
                                    statusFrame.RightText:Show()
                                    textString:Hide()
                                else
                                    valueDisplay = valueDisplay .. " / " .. valueMaxDisplay
                                    if not statusFrame.disablePercentages then
                                        valueDisplay = "(" .. math.ceil((value / valueMax) * 100) .. "%) " .. valueDisplay
                                    end
                                end

                                textString:SetText(valueDisplay)
                            elseif displayMode == "PERCENT" then
                                valueDisplay = math.ceil((value / valueMax) * 100) .. "%"
                                if shouldUsePrefix then
                                    textString:SetText(statusFrame.prefix .. " " .. valueDisplay)
                                else
                                    textString:SetText(valueDisplay)
                                end
                            end
                        else
                            textString:Hide()
                            textString:SetText("")
                            if not statusFrame.alwaysShow then
                                statusFrame:Hide()
                            else
                                statusFrame:SetValue(0)
                            end
                        end
                    end

                    hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", TextStatusBar_UpdateTextStringWithValues)
                end
            end
        end
    )
end

function D4:ReplaceStr(text, old, new)
    if text == nil then return "" end
    local b, e = text:find(old, 1, true)
    if b == nil then
        return text
    else
        return text:sub(1, b - 1) .. new .. text:sub(e + 1)
    end
end

local genderNames = {"", "Male", "Female"}
function D4:GetClassAtlas(class)
    return ("classicon-%s"):format(class)
end

function D4:GetClassIcon(class)
    return "|A:" .. D4:GetClassAtlas(class) .. ":16:16:0:0|a"
end

function D4:GetRaceAtlas(race, gender)
    return ("raceicon-%s-%s"):format(race, gender)
end

function D4:GetRaceIcon(race, gender)
    return "|A:" .. D4:GetRaceAtlas(race, genderNames[gender]) .. ":16:16:0:0|a"
end

local units = {"player"}
for i = 1, 4 do
    table.insert(units, "party" .. i)
end

for i = 1, 40 do
    table.insert(units, "raid" .. i)
end

local specIcons = {
    ["DEATHKNIGHT"] = {
        [1] = 135770,
        [2] = 135773,
        [3] = 135775,
    },
    ["DEMONHUNTER"] = {
        [1] = 1247264,
        [2] = 1247265,
    },
    ["DRUID"] = {
        [1] = 136096,
        [2] = 132115,
        [3] = 132276,
        [4] = 136041,
    },
    ["EVOKER"] = {
        [1] = 4511811,
        [2] = 4511812,
        [3] = 5198700,
    },
    ["HUNTER"] = {
        [1] = 132164,
        [2] = 132222,
        [3] = 132215,
    },
    ["MAGE"] = {
        [1] = 135932,
        [2] = 135812,
        [3] = 135846,
    },
    ["MONK"] = {
        [1] = 608951,
        [2] = 608952,
        [3] = 608953,
    },
    ["PALADIN"] = {
        [1] = 135920,
        [2] = 135893,
        [3] = 135873,
    },
    ["PRIEST"] = {
        [1] = 135940,
        [2] = 135920,
        [3] = 136207,
    },
    ["ROGUE"] = {
        [1] = 136189,
        [2] = 132282,
        [3] = 132320,
    },
    ["SHAMAN"] = {
        [1] = 136048,
        [2] = 132314,
        [3] = 136043,
    },
    ["WARLOCK"] = {
        [1] = 136145,
        [2] = 136172,
        [3] = 136186,
    },
    ["WARRIOR"] = {
        [1] = 132292,
        [2] = 132347,
        [3] = 134952,
    },
}

local classIds = {
    ["WARRIOR"] = 1,
    ["PALADIN"] = 2,
    ["HUNTER"] = 3,
    ["ROGUE"] = 4,
    ["PRIEST"] = 5,
    ["DEATHKNIGHT"] = 6,
    ["SHAMAN"] = 7,
    ["MAGE"] = 8,
    ["WARLOCK"] = 9,
    ["MONK"] = 10,
    ["DRUID"] = 11,
    ["DEMONHUNTER"] = 12,
    ["EVOKER"] = 13,
}

local specRoless = {
    ["DEATHKNIGHT"] = {
        [1] = "TANK",
        [2] = "DAMAGER",
        [3] = "DAMAGER",
    },
    ["DEMONHUNTER"] = {
        [1] = "DAMAGER",
        [2] = "TANK",
    },
    ["EVOKER"] = {
        [1] = "DAMAGER",
        [2] = "HEALER",
        [3] = "HEALER",
    },
    ["HUNTER"] = {
        [1] = "DAMAGER",
        [2] = "DAMAGER",
        [3] = "DAMAGER",
    },
    ["MAGE"] = {
        [1] = "DAMAGER",
        [2] = "DAMAGER",
        [3] = "DAMAGER",
    },
    ["MONK"] = {
        [1] = "TANK",
        [2] = "HEALER",
        [3] = "DAMAGER",
    },
    ["PALADIN"] = {
        [1] = "HEALER",
        [2] = "TANK",
        [3] = "DAMAGER",
    },
    ["PRIEST"] = {
        [1] = "HEALER",
        [2] = "HEALER",
        [3] = "DAMAGER",
    },
    ["ROGUE"] = {
        [1] = "DAMAGER",
        [2] = "DAMAGER",
        [3] = "DAMAGER",
    },
    ["SHAMAN"] = {
        [1] = "DAMAGER",
        [2] = "DAMAGER",
        [3] = "HEALER",
    },
    ["WARLOCK"] = {
        [1] = "DAMAGER",
        [2] = "DAMAGER",
        [3] = "DAMAGER",
    },
    ["WARRIOR"] = {
        [1] = "DAMAGER",
        [2] = "DAMAGER",
        [3] = "TANK",
    },
}

if D4:GetWoWBuild() == "RETAIL" then
    specRoless["DRUID"] = {
        [1] = "DAMAGER",
        [2] = "DAMAGER",
        [3] = "TANK",
        [4] = "HEALER",
    }
else
    specRoless["DRUID"] = {
        [1] = "DAMAGER",
        [2] = "TANK",
        [3] = "HEALER",
    }
end

function D4:GetRole(className, specId)
    return specRoless[className][specId]
end

function D4:GetSpecIcon(className, specId)
    if GetSpecializationInfoForClassID then
        local classId = classIds[className]
        if classId then
            local _, _, _, icon = GetSpecializationInfoForClassID(classId, specId)
            if icon then return icon end
        end
    end

    return specIcons[className][specId]
end

function D4:GetTalentInfo()
    local specid, icon
    if GetSpecialization then
        specid = GetSpecialization()
        if GetSpecializationInfo then
            _, _, _, icon = GetSpecializationInfo(specid)
        end

        return specid, icon
    else
        local ps = 0
        for i = 1, 4 do
            local _, _, _, iconTexture, pointsSpent = GetTalentTabInfo(i)
            if pointsSpent ~= nil and pointsSpent > ps then
                ps = pointsSpent
                specid = i
                icon = iconTexture
                local _, class = UnitClass("PLAYER")
                if GetActiveTalentGroup and class == "DRUID" and D4:GetWoWBuild() ~= "CATA" then
                    local group = GetActiveTalentGroup()
                    local role = GetTalentGroupRole(group)
                    if role == "DAMAGER" then
                        specid = 2
                        icon = 132115
                    elseif role == "TANK" then
                        specid = 3
                    end
                end
            end

            if icon == nil then
                local _, class = UnitClass("PLAYER")
                icon = D4:GetSpecIcon(class, specid)
                if icon == nil then
                    if class == "DRUID" then
                        icon = 625999
                    elseif class == "HUNTER" then
                        icon = 626000
                    elseif class == "MAGE" then
                        icon = 626001
                    elseif class == "PALADIN" then
                        if specid == 1 then
                            icon = 135920
                        elseif specid == 2 then
                            icon = 135893
                        elseif specid == 3 then
                            icon = 135873
                        end
                    elseif class == "PRIEST" then
                        icon = 626004
                    elseif class == "ROGUE" then
                        icon = 626005
                    elseif class == "SHAMAN" then
                        icon = 626006
                    elseif class == "WARLOCK" then
                        icon = 626007
                    elseif class == "WARRIOR" then
                        icon = 626008
                    end
                end
            end
        end

        return specid, icon
    end

    return nil, nil
end

function D4:GetRoleByGuid(guid)
    if UnitGroupRolesAssigned == nil then return "NONE" end
    for i, unit in pairs(units) do
        if UnitGUID(unit) == guid then return UnitGroupRolesAssigned(unit) end
    end

    return "NONE"
end

function D4:GetRoleIcon(role)
    if role == "" then return "" end
    if role == "NONE" then return "" end
    if role == "DAMAGER" then
        return "UI-LFG-RoleIcon-DPS"
    elseif role == "HEALER" then
        return "UI-LFG-RoleIcon-HEALER"
    elseif role == "TANK" then
        return "UI-LFG-RoleIcon-TANK"
    end

    return ""
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript(
    "OnEvent",
    function(self, event, ...)
        local trackingTexture = GetTrackingTexture()
        if trackingTexture and MiniMapTracking and MiniMapTrackingIcon and not MiniMapTrackingIcon:GetTexture() then
            MiniMapTrackingIcon:SetTexture(trackingTexture)
            MiniMapTracking:Show()
        end
    end
)
