local _, DarkMode = ...
function DarkMode:GetColor(id, name)
	local colorMode = DarkMode:GetColorModes()[id]
	if colorMode == "Dimmed" then
		return 0.5, 0.5, 0.5, 1
	elseif colorMode == "Dark" then
		return 0.360, 0.360, 0.360, 1
	elseif colorMode == "Dark+" then
		return 0.200, 0.200, 0.200, 1
	elseif colorMode == "Darker" then
		return 0.140, 0.140, 0.140, 1
	elseif colorMode == "Darker+" then
		return 0.080, 0.080, 0.080, 1
	elseif colorMode == "Black" then
		return 0.000, 0.000, 0.000, 1
	elseif colorMode == "ClassColor" then
		local _, PlayerClassEng, _ = UnitClass("PLAYER")
		local r, g, b, _ = DarkMode:GetClassColor(PlayerClassEng)

		return r, g, b, 1
	elseif colorMode == "Uncolored" or colorMode == "Default" then
		return 1, 1, 1, 1
	elseif colorMode == "Off" then
		return nil, nil, nil, nil
	elseif colorMode == "Custom" then
		return DarkMode:GetCustomColor(name)
	else
		DarkMode:INFO("[GetColor] Missing colorMode", colorMode)
	end

	return 1.000, 0.000, 0.000, 0.3
end

function DarkMode:GetCustomColor(name)
	if name == nil then return 1, 1, 1, 0.5 end
	local r = DMTAB[name .. "_r"]
	local g = DMTAB[name .. "_g"]
	local b = DMTAB[name .. "_b"]
	local a = DMTAB[name .. "_a"]
	if r and g and b and a then
		return r, g, b, a
	else
		return 1, 1, 1, 0.5
	end
end

function DarkMode:SetCustomColor(name, r, g, b, a)
	DMTAB[name .. "_r"] = r
	DMTAB[name .. "_g"] = g
	DMTAB[name .. "_b"] = b
	DMTAB[name .. "_a"] = a
	DarkMode:UpdateColors()
end

function DarkMode:GetBrighterColor(r, g, b, a, texture)
	local name = DarkMode:GetName(texture)
	if r and g and b and name and DarkMode:IsBrighterFrame(name) then return DarkMode:MClamp(r + 0.4, 0, 1), DarkMode:MClamp(g + 0.4, 0, 1), DarkMode:MClamp(b + 0.4, 0, 1), a end

	return r, g, b, a
end

function DarkMode:GetUiColor(texture, from)
	local mode = DarkMode:DMGV("COLORMODE", 1)
	local r, g, b, a = DarkMode:GetColor(mode, "CUSTOMUIC")
	r, g, b, a = DarkMode:GetBrighterColor(r, g, b, a, texture)
	if mode ~= 7 and mode ~= 9 and texture and texture.SetDesaturated and DarkMode:IsEnabled("DESATURATE", true) then
		texture:SetDesaturated(true)
	end

	return r, g, b, a
end

function DarkMode:GetUFColor(texture)
	local mode = DarkMode:DMGV("COLORMODEUNFR", 1)
	local r, g, b, a = DarkMode:GetColor(mode, "CUSTOMUFC")
	r, g, b, a = DarkMode:GetBrighterColor(r, g, b, a, texture)
	if mode ~= 7 and mode ~= 9 and texture and texture.SetDesaturated and DarkMode:IsEnabled("DESATURATE", true) then
		texture:SetDesaturated(true)
	end

	return r, g, b, a
end

function DarkMode:GetBtnsColor(texture)
	local mode = DarkMode:DMGV("COLORMODEABTNS", 9)
	local r, g, b, a = DarkMode:GetColor(mode, "CUSTOMBTNS")
	r, g, b, a = DarkMode:GetBrighterColor(r, g, b, a, texture)
	if mode ~= 7 and mode ~= 9 and texture and texture.SetDesaturated and DarkMode:IsEnabled("DESATURATE", true) then
		texture:SetDesaturated(true)
	end

	return r, g, b, a
end

function DarkMode:GetUFDRColor(texture)
	local mode = DarkMode:DMGV("COLORMODEAUNFRDRA", 9)
	local r, g, b, a = DarkMode:GetColor(mode, "CUSTOMUFDRC")
	r, g, b, a = DarkMode:GetBrighterColor(r, g, b, a, texture)
	if mode ~= 7 and mode ~= 9 and texture and texture.SetDesaturated and DarkMode:IsEnabled("DESATURATE", true) then
		texture:SetDesaturated(true)
	end

	return r, g, b, a
end

function DarkMode:GetUFHPColor(texture)
	local mode = DarkMode:DMGV("COLORMODEAUNFRHPA", 9)
	local r, g, b, a = DarkMode:GetColor(mode, "CUSTOMUFHPC")
	r, g, b, a = DarkMode:GetBrighterColor(r, g, b, a, texture)
	if mode ~= 7 and mode ~= 9 and texture and texture.SetDesaturated and DarkMode:IsEnabled("DESATURATE", true) then
		texture:SetDesaturated(true)
	end

	return r, g, b, a
end

function DarkMode:GetUFPORColor(texture)
	local mode = DarkMode:DMGV("COLORMODEAUNFRPORA", 9)
	local r, g, b, a = DarkMode:GetColor(mode, "CUSTOMUFPORC")
	r, g, b, a = DarkMode:GetBrighterColor(r, g, b, a, texture)
	if mode ~= 7 and mode ~= 9 and texture and texture.SetDesaturated and DarkMode:IsEnabled("DESATURATE", true) then
		texture:SetDesaturated(true)
	end

	return r, g, b, a
end

function DarkMode:GetNPColor(texture)
	local mode = DarkMode:DMGV("COLORMODENP", 1)
	local r, g, b, a = DarkMode:GetColor(mode, "CUSTOMNPC")
	r, g, b, a = DarkMode:GetBrighterColor(r, g, b, a, texture)
	if mode ~= 7 and mode ~= 9 and texture and texture.SetDesaturated and DarkMode:IsEnabled("DESATURATE", true) then
		texture:SetDesaturated(true)
	end

	return r, g, b, a
end

function DarkMode:GetTTColor(texture)
	local mode = DarkMode:DMGV("COLORMODETT", 1)
	local r, g, b, a = DarkMode:GetColor(mode, "CUSTOMTTC")
	r, g, b, a = DarkMode:GetBrighterColor(r, g, b, a, texture)
	if mode ~= 7 and mode ~= 9 and texture and texture.SetDesaturated and DarkMode:IsEnabled("DESATURATE", true) then
		texture:SetDesaturated(true)
	end

	return r, g, b, a
end

function DarkMode:GetActionButtonsColor(texture)
	local mode = DarkMode:DMGV("COLORMODEAB", 1)
	local r, g, b, a = DarkMode:GetColor(mode, "CUSTOMABC")
	r, g, b, a = DarkMode:GetBrighterColor(r, g, b, a, texture)
	if mode ~= 7 and mode ~= 9 and texture and texture.SetDesaturated and DarkMode:IsEnabled("DESATURATE", true) then
		texture:SetDesaturated(true)
	end

	return r, g, b, a
end

function DarkMode:GetBagsColor(texture)
	local mode = DarkMode:DMGV("COLORMODEBA", 1)
	local r, g, b, a = DarkMode:GetColor(mode, "CUSTOMBAC")
	r, g, b, a = DarkMode:GetBrighterColor(r, g, b, a, texture)
	if mode ~= 7 and mode ~= 9 and texture and texture.SetDesaturated and DarkMode:IsEnabled("DESATURATE", true) then
		texture:SetDesaturated(true)
	end

	return r, g, b, a
end

function DarkMode:GetMicroMenuColor(texture)
	local mode = DarkMode:DMGV("COLORMODEMI", 1)
	local r, g, b, a = DarkMode:GetColor(mode, "CUSTOMMIC")
	r, g, b, a = DarkMode:GetBrighterColor(r, g, b, a, texture)
	if mode ~= 7 and mode ~= 9 and texture and texture.SetDesaturated and DarkMode:IsEnabled("DESATURATE", true) then
		texture:SetDesaturated(true)
	end

	return r, g, b, a
end

function DarkMode:GetBuffsAndDebuffsColor(texture)
	local mode = DarkMode:DMGV("COLORMODEBAD", 1)
	local r, g, b, a = DarkMode:GetColor(mode, "CUSTOMBADC")
	r, g, b, a = DarkMode:GetBrighterColor(r, g, b, a, texture)
	if mode ~= 7 and mode ~= 9 and texture and texture.SetDesaturated and DarkMode:IsEnabled("DESATURATE", true) then
		texture:SetDesaturated(true)
	end

	return r, g, b, a
end

function DarkMode:GetAddonsColor(texture)
	local mode = DarkMode:DMGV("COLORMODEFA", 1)
	local r, g, b, a = DarkMode:GetColor(mode, "CUSTOMFRAC")
	r, g, b, a = DarkMode:GetBrighterColor(r, g, b, a, texture)
	if mode ~= 7 and mode ~= 9 and texture and texture.SetDesaturated and DarkMode:IsEnabled("DESATURATE", true) then
		texture:SetDesaturated(true)
	end

	return r, g, b, a
end

function DarkMode:GetFrameColor(texture)
	local mode = DarkMode:DMGV("COLORMODEF", 1)
	local r, g, b, a = DarkMode:GetColor(mode, "CUSTOMFRC")
	r, g, b, a = DarkMode:GetBrighterColor(r, g, b, a, texture)
	if mode ~= 7 and mode ~= 9 and texture and texture.SetDesaturated and DarkMode:IsEnabled("DESATURATE", true) then
		texture:SetDesaturated(true)
	end

	return r, g, b, a
end

function DarkMode:GetTextColor(r, g, b, a)
	if r ~= nil and g ~= nil and b ~= nil then
		local sum = r + g + b
		if sum >= 2 then return 0, 0, 0, 1 end
	end

	return 1, 1, 1, 1
end

local DMRepeatingFrames = {"", ".Bg.TopSection", ".Bg.BottomEdge", "Inset", "Inset.Bg", "Inset.NineSlice", "Inset.NineSlice.TopEdge", "Inset.NineSlice.RightEdge", "Inset.NineSlice.LeftEdge", "Inset.NineSlice.BottomEdge", "Inset.NineSlice.TopRightCorner", "Inset.NineSlice.TopLeftCorner", "Inset.NineSlice.BottomRightCorner", "Inset.NineSlice.BottomLeftCorner", ".NineSlice", ".NineSlice.TopEdge", ".NineSlice.RightEdge", ".NineSlice.LeftEdge", ".NineSlice.BottomEdge", ".NineSlice.TopRightCorner", ".NineSlice.TopLeftCorner", ".NineSlice.BottomRightCorner", ".NineSlice.BottomLeftCorner", "ScrollFrame", ".Begin", ".Middle", ".End", ".ScrollBar.Background",}
if DarkMode:GetWoWBuild() ~= "RETAIL" then
	table.insert(DMRepeatingFrames, ".Background")
	table.insert(DMRepeatingFrames, ".Bg")
end

function DarkMode:GetDMRepeatingFrames()
	return DMRepeatingFrames
end

local DMRepeatingFrames2 = {"TopEdge", "RightEdge", "LeftEdge", "BottomEdge", "TopRightCorner", "TopLeftCorner", "BottomRightCorner", "BottomLeftCorner"}
function DarkMode:GetDMRepeatingFrames2()
	return DMRepeatingFrames2
end

local DMUi = {
	["ActionButtons"] = {"PetActionButton", "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarLeftButton", "MultiBarRightButton", "ActionBar7Button", "ActionBar8Button", "ActionBar9Button", "ActionBar10Button", "MultiBar5Button", "MultiBar6Button", "MultiBar7Button", "StanceButton", "PetActionButton", "BT4Button", "DragonflightUIMultiactionBar6Button", "DragonflightUIMultiactionBar7Button", "DragonflightUIMultiactionBar8Button", "BT4StanceButton", "BT4PetButton", "DominosActionButton", "MultiBarBottomLeftActionButton", "MultiBarBottomRightActionButton", "MultiBarLeftActionButton", "MultiBarRightActionButton", "MultiBarBottomRightActionButton", "MultiBar5ActionButton", "MultiBar6ActionButton", "MultiBar7ActionButton"},
	["Minimap"] = {"DragonflightUIMinimapBorderSquare", "QuestTimerFrame", "CalendarButtonFrame", "MiniMapBattlefieldFrameBorder", "MiniMapBattlefieldBorder", "MinimapBorder", "MinimapBorderTop", "TimeManagerClockButton", "MinimapCompassTexture", "MinimapCluster.BorderTop",},
	["UnitFrames"] = {"TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor", "FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor", "FocusFrameToT", "TargetFrameToT", "CompactArenaFrame.PreMatchFramesContainer.PreMatchFrame1.SpecPortraitBorderTexture", "CompactArenaFrame.PreMatchFramesContainer.PreMatchFrame2.SpecPortraitBorderTexture", "CompactArenaFrame.PreMatchFramesContainer.PreMatchFrame3.SpecPortraitBorderTexture", "CompactArenaFrame.PreMatchFramesContainer.PreMatchFrame4.SpecPortraitBorderTexture", "CompactArenaFrame.PreMatchFramesContainer.PreMatchFrame5.SpecPortraitBorderTexture", "ArenaPrepFrame1Texture", "ArenaPrepFrame2Texture", "ArenaPrepFrame3Texture", "ArenaPrepFrame4Texture", "ArenaPrepFrame5Texture", "ArenaEnemyFrame1Texture", "ArenaEnemyFrame2Texture", "ArenaEnemyFrame3Texture", "ArenaEnemyFrame4Texture", "ArenaEnemyFrame5Texture", "PlayerFrameAlternateManaBarBorder", "Boss1TargetFrameTextureFrame", "Boss2TargetFrameTextureFrame", "Boss3TargetFrameTextureFrame", "Boss4TargetFrameTextureFrame", "Boss5TargetFrameTextureFrame", "PlayerFrameTexture", "TargetFrameTextureFrameTexture", "FocusFrameTextureFrameTexture", "TargetFrameToTTextureFrameTexture", "FocusFrameToTTextureFrameTexture", "PetFrameTexture", "PlayerFrame.PlayerFrameContainer.AlternatePowerFrameTexture", "PlayerFrame.PlayerFrameContainer.FrameTexture", "TargetFrame.TargetFrameContainer.FrameTexture", "FocusFrame.TargetFrameContainer.FrameTexture", "PartyMemberFrame1Texture", "PartyMemberFrame2Texture", "PartyMemberFrame3Texture", "PartyMemberFrame4Texture", "PartyFrame.MemberFrame1.Texture", "PartyFrame.MemberFrame2.Texture", "PartyFrame.MemberFrame3.Texture", "PartyFrame.MemberFrame4.Texture"},
	["Tooltips"] = {"FriendsTooltip.NineSlice", "RaiderIO_ProfileTooltip.NineSlice", "EmbeddedItemTooltip.NineSlice", "PartyMemberBuffTooltip.NineSlice", "DropDownList1MenuBackdrop.NineSlice", "DropDownList2MenuBackdrop.NineSlice", "DropDownList3MenuBackdrop.NineSlice", "DropDownList4MenuBackdrop.NineSlice", "GameTooltip.NineSlice", "ItemRefTooltip.NineSlice", "ShoppingTooltip1.NineSlice", "ShoppingTooltip2.NineSlice", "WhatsTrainingTooltip.NineSlice"},
	["Artworks"] = {"PVPTimerFrame", "PaladinPowerBarFrame", "PaladinPowerBarFrame.ActiveTexture", "PaladinPowerBarFrame.Background", "TimerTrackerTimer1StatusBarBorder", "TimerTrackerTimer2StatusBarBorder", "MirrorTimer1", "MirrorTimer2", "MirrorTimer3", "MainMenuBar.BorderArt", "MainMenuBarTextureExtender", "StanceBarLeft", "StanceBarMiddle", "StanceBarRight", "StanceButton1NormalTexture2", "StanceButton2NormalTexture2", "StanceButton3NormalTexture2", "StanceButton4NormalTexture2", "StanceButton5NormalTexture2", "StanceButton6NormalTexture2", "StanceButton7NormalTexture2", "StanceButton8NormalTexture2", "SlidingActionBarTexture0", "SlidingActionBarTexture1", "MainMenuBarTexture0", "MainMenuBarTexture1", "MainMenuBarTexture2", "MainMenuBarTexture3", "MainMenuExpBar", "ReputationWatchBar.StatusBar", "MainStatusTrackingBarContainer.BarFrameTexture", "SecondaryStatusTrackingBarContainer.BarFrameTexture", "MainMenuBarMaxLevelBar", "BT4BarBlizzardArt", "BT4BarBlizzardArt.nineSliceParent", "BlizzardArtLeftCap", "BlizzardArtRightCap", "CompactRaidFrameManager"},
	["Gryphons"] = {"MA_LeftEndCap", "MA_RightEndCap", "MainMenuBar.EndCaps", "MainMenuBarLeftEndCap", "MainMenuBarRightEndCap"},
	["Chat"] = {"ChatFrame1EditBox", "ChatFrame2EditBox", "ChatFrame3EditBox", "ChatFrame4EditBox", "ChatFrame5EditBox", "ChatFrame6EditBox", "ChatFrame7EditBox", "ChatFrame8EditBox", "ChatFrame9EditBox", "ChatFrame10EditBox", "ChatFrame1Tab", "ChatFrame2Tab", "ChatFrame3Tab", "ChatFrame4Tab", "ChatFrame5Tab", "ChatFrame6Tab", "ChatFrame7Tab", "ChatFrame8Tab", "ChatFrame9Tab", "ChatFrame10Tab",},
	["Castbar"] = {"CastingBarFrame.Border", "PlayerCastingBarFrame.Background", "PlayerCastingBarFrame.Border", "PlayerCastingBarFrame.TextBorder"}
}

if DarkMode:GetWoWBuild() == "RETAIL" then
	local retail = {"TargetFrameSpellBar.Background", "TargetFrameSpellBar.Border", "TargetFrameSpellBar.TextBorder", "FocusFrameSpellBar.Background", "FocusFrameSpellBar.Border", "FocusFrameSpellBar.TextBorder", "PetCastingBarFrame.Border"}
	for i, v in pairs(retail) do
		table.insert(DMUi["Castbar"], v)
	end
else
	local noneretail = {"TargetFrameSpellBar.Border", "FocusFrameSpellBar.Border", "TargetFrameSpellBar.BorderShield", "FocusFrameSpellBar.BorderShield", "PetCastingBarFrame.Border", "PetCastingBarFrame.BorderShield"}
	for i, v in pairs(noneretail) do
		table.insert(DMUi["Castbar"], v)
	end
end

function DarkMode:GetUiTable()
	return DMUi
end

local DMUiAddons = {"LFGListInviteDialog.Border", "LFDRoleCheckPopup.Border", "UIWidgetPowerBarContainerFrame", "TimerTrackerTimer1StatusBarBorder", "TimerTrackerTimer2StatusBarBorder", "FocusFrame.FocusFrameContainer.FrameTexture", "ArenaPrepFrame1Texture", "ArenaPrepFrame2Texture", "ArenaPrepFrame3Texture", "ArenaPrepFrame4Texture", "ArenaPrepFrame5Texture", "ArenaEnemyFrame1Texture", "ArenaEnemyFrame2Texture", "ArenaEnemyFrame3Texture", "ArenaEnemyFrame4Texture", "ArenaEnemyFrame5Texture",}
local DMFramesUiAddonsTab = nil
function DarkMode:GetUiAddonsTable()
	if DMFramesUiAddonsTab == nil then
		DMFramesUiAddonsTab = {}
		for x, name in ipairs(DMUiAddons) do
			DMFramesUiAddonsTab[name] = name
		end
	end

	return DMFramesUiAddonsTab
end

local DMFrames = {"StableFrame", "MovieFrame.CloseDialog.Border", "LFDQueueFrameFindGroupButton_LeftSeparator", "LFDQueueFrameFindGroupButton_RightSeparator", "QuestLogDetailScrollFrame", "QuestLogListScrollFrame", "ChatConfigFrame", "ChatConfigCategoryFrame", "ChatConfigBackgroundFrame", "TimerTrackerTimer1StatusBarBorder", "TimerTrackerTimer2StatusBarBorder", "ReadyStatus.Border", "DMSettings", "AdventureMapQuestChoiceDialog", "CovenantMissionFrame", "PVPReadyDialog.Border", "LFGDungeonReadyDialog.Border", "QueueStatusFrame", "StackSplitFrame", "PVPReadyDialog", "ReputationDetailFrame", "ReputationDetailFrame.Border", "ReputationFrame.ReputationDetailFrame.Border", "CurrencyTransferMenu", "CurrencyTransferMenu.TitleContainer", "CurrencyTransferLog", "TokenFrameContainerScrollBar", "TokenFramePopup", "TokenFramePopup.Border", "QuestLogDetailFrame", "QuestNPCModelTextFrame", "QuestModelScene", "QuestLogFrame", "QuestLogCollapseAllButton", "QuestScrollFrame.ScrollBar", "QuestFrame", "QuestFrameDetailPanel", "QuestDetailScrollFrame", "QuestDetailScrollChildFrame", "QuestFrameGreetingPanel", "QuestGreetingScrollFrame", "QuestFrameProgressPanel", "QuestProgressScrollFrame", "QuestRewardScrollFrame", "QuestFrameRewardPanel", "QuestInfoRewardsFrame", "QuestMapFrame", "QuestMapFrame.DetailsFrame", "QuestMapFrame.QuestsTab.Background", "QuestMapFrame.EventsTab.Background", "QuestMapFrame.MapLegendTab.Background", "CharacterModelScene", "GroupLootHistoryFrame", "GroupLootHistoryFrame.ResizeButton", "ModelPreviewFrameCloseButton_LeftSeparator", "ModelPreviewFrame", "SideDressUpModelCloseButton", "SideDressUpFrame", "ArchaeologyFrame", "MailItem1", "MailItem2", "MailItem3", "MailItem4", "MailItem5", "MailItem6", "MailItem7", "MailFrame", "InboxFrame", "GuildMemberDetailFrame", "TabardFrame", "TradeFrame", "TradeFrame.RecipientOverlay", "DressUpFrame", "LootFrame", "ReadyCheckListenerFrame", "LFGDungeonReadyStatus.Border", "CinematicFrameCloseDialog.Border", "StaticPopup1", "StaticPopup1.Border", "StaticPopup1.BG", "StaticPopup2.Border", "StaticPopup2.BG", "ItemTextFrame", "WorldStateScoreFrame", "WorldStateScoreFrameTab1", "WorldStateScoreFrameTab2", "WorldStateScoreFrameTab3", "SettingsPanel", "InspectPaperDollFrame", "PaperDollFrame", "CharacterFrame", "CharacterStatsPane", "CharacterFrameTab1", "CharacterFrameTab2", "CharacterFrameTab3", "CharacterFrameTab4", "CharacterFrameTab5", "nwtab5", "nwtab6", "ReputationFrame", "ReputationListScrollFrame", "SkillFrame", "SkillListScrollFrame", "SkillDetailScrollFrame", "HonorFrame", "PetPaperDollFrame", "PetPaperDollFrameTab1", "PetPaperDollFrameTab2", "PetPaperDollFrameTab3", "PetPaperDollFrameExpBar", "TokenFrame", "SpellBookFrame", "SpellBookSkillLineTab1", "SpellBookSkillLineTab2", "SpellBookSkillLineTab3", "SpellBookSkillLineTab4", "SpellBookSkillLineTab5", "SpellBookSkillLineTab6", "SpellBookSkillLineTab7", "WhatsTrainingFrame", "SpellBookFrameTabButton1", "SpellBookFrameTabButton2", "SpellBookFrameTabButton3", "SpellBookFrameTabButton4", "FriendsFrame", "FriendsFrameFriendsScrollFrame", "FriendsFrameTab1", "FriendsFrameTab2", "FriendsFrameTab3", "FriendsFrameTab4", "FriendsFrameTab5", "WhoListScrollFrame", "WhoFrameList", "WorldMapFrame", "WorldMapFrame.BorderFrame", "WorldMapFrame.MiniBorderFrame", "LFGParentFrame", "LFGParentFrameTab1", "LFGParentFrameTab2", "LFMFrame", "LFGBrowseFrame", "LFGListingFrame", "PVEFrame", "PVEFrameTab1", "PVEFrameTab2", "PVEFrameTab3", "PVEFrameTab4", "PVPFrame", "PVPFrameTab1", "PVPFrameTab2", "PVPFrameTab3", "PVPFrameTab4", "ChallengesFrame", "GameMenuFrame", "GameMenuFrame.Border", "GameMenuFrame.Header", "GossipFrameGreetingPanel", "GossipGreetingScrollFrame", "GossipFrame", "GossipFrame.GreetingPanel", "GossipFrame.GreetingPanel.ScrollBox", "GossipFrame.GreetingPanel.ScrollBar.Background", "MerchantFrame", "MerchantBuyBackItem", "MerchantFrameTab1", "MerchantFrameTab2", "MerchantItem1", "MerchantItem2", "MerchantItem3", "MerchantItem4", "MerchantItem5", "MerchantItem6", "MerchantItem7", "MerchantItem8", "MerchantItem9", "MerchantItem10", "MerchantItem11", "MerchantItem12", "MerchantMoney", "MerchantMoneyBg", "PetStableFrame", "AddonList", "AddonListDisableAllButton_RightSeparator", "AddonListEnableAllButton_RightSeparator", "AddonListOkayButton_LeftSeparator", "AddonListOkayButton_RightSeparator", "AddonListCancelButton_LeftSeparator", "HelpFrame", "VideoOptionsFrame", "InterfaceOptionsFrame", "TimeManagerFrame", "OpenMailFrame", "OpenMailScrollFrame", "MailFrameTab1", "MailFrameTab2", "SendMailFrame", "SendMailMoney", "SendMailMoneyBg", "SendMailMoneyFrame", "SendMail", "MailEditBoxScrollBar", "BankFrame", "BankFrameTab1", "BankFrameTab2", "BankFrameTab3", "BankFrameTab4", "BankFrameMoneyFrame", "BankFrameMoneyFrameBorder", "BackpackTokenFrame", "ContainerFrame1", "ContainerFrame2", "ContainerFrame3", "ContainerFrame4", "ContainerFrame5", "ContainerFrame6", "ContainerFrame7", "ContainerFrame8", "ContainerFrame9", "ContainerFrame10", "ContainerFrame11", "ContainerFrame12", "ContainerFrameCombinedBags", "PVPFrame", "PVPParentFrame", "PVPParentFrameTab1", "PVPParentFrameTab2", "BattlefieldFrame", "BattlefieldListScrollFrame", "BattlefieldFrameType", "YourFrameName", "QuestMapFrame", "QuestMapFrame.DetailsFrame"}
tinsert(DMFrames, "DragonflightUIProfessionFrame")
tinsert(DMFrames, "DragonflightUISpellBookProfessionFrame")
tinsert(DMFrames, "DragonflightUIWhatsTrainingFrameCompatibilitySpellBookBG")
if TaxiFrame and TaxiFrame.TopBorder then
	tinsert(DMFrames, "TaxiFrame.TopBorder")
	tinsert(DMFrames, "TaxiFrame.TitleBg")
	tinsert(DMFrames, "TaxiFrame.RightBorder")
	tinsert(DMFrames, "TaxiFrame.LeftBorder")
	tinsert(DMFrames, "TaxiFrame.BottomBorder")
	tinsert(DMFrames, "TaxiFrame.TopRightCorner")
	tinsert(DMFrames, "TaxiFrame.TopLeftCorner")
	tinsert(DMFrames, "TaxiFrame.BotRightCorner")
	tinsert(DMFrames, "TaxiFrame.BotLeftCorner")
else
	tinsert(DMFrames, "TaxiFrame")
end

local DMFranesBrighter = {}
for x = 1, 12 do
	for i = 1, 32 do
		local name = string.format("ContainerFrame%sItem%sNormalTexture", x, i)
		tinsert(DMFrames, name)
		DMFranesBrighter[name] = true
	end
end

function DarkMode:IsBrighterFrame(name)
	return DMFranesBrighter[name] or false
end

local DMFramesTab = nil
function DarkMode:GetFrameTable()
	if DMFramesTab == nil then
		DMFramesTab = {}
		for x, name in ipairs(DMFrames) do
			DMFramesTab[name] = name
		end
	end

	return DMFramesTab
end

local DMFramesSpecial = {}
if CharacterMainHandSlot then
	DarkMode:ForeachRegions(
		CharacterMainHandSlot,
		function(region, x)
			if x == 14 then
				tinsert(DMFramesSpecial, region) -- CATA
			end
		end, "CharacterMainHandSlot"
	)
end

local CharacterRangedSlot = getglobal("CharacterRangedSlot")
if CharacterRangedSlot then
	DarkMode:ForeachRegions(
		CharacterRangedSlot,
		function(region, x)
			if x == 14 then
				tinsert(DMFramesSpecial, region) -- CATA
			end
		end, "CharacterRangedSlot"
	)
end

function DarkMode:GetFrameTableSpecial()
	return DMFramesSpecial
end

local DMFramesAddons = {"HousingDashboardFrame", "CooldownViewerSettings", "RemixArtifactFrame.BorderContainer", "ChallengesKeystoneFrame", "HeroTalentsSelectionDialog", "PlayerSpellsFrame.SpellBookFrame.BookBGHalved", "PlayerSpellsFrame.SpellBookFrame.BookBGLeft", "PlayerSpellsFrame.SpellBookFrame.BookBGRight", "PlayerSpellsFrame.SpellBookFrame.BookCornerFlipbook", "GenericTraitFrame", "ArenaAnalyticsMinimapButton.Border.texture", "ArenaAnalyticsImportFrame", "ArenaAnalyticsScrollFrame", "DragonflightUIMinimapBorder", "DragonflightUIPlayerFrameBorder", "DragonflightUIPlayerFrameBackground", "ProfessionsFrame.CraftingPage.CraftingOutputLog", "RolePollPopup", "HonorQueueFrameSoloQueueButton_RightSeparator", "HonorQueueFrameGroupQueueButton_LeftSeparator", "ItemRackMenuFrame", "ItemRackOptFrame", "PetJournalSummonButton_RightSeparator", "MountJournalMountButton_RightSeparator", "PlayerTalentFrameSpecializationLearnButton_LeftSeparator", "PlayerTalentFrameSpecializationLearnButton_RightSeparator", "AddonUsage", "BagnonInventory1.skin", "BagnonInventory2.skin", "RXPFrame.Footer", "RXPFrame_bottomFrame", "RXPFrame_bottomFrame_steps", "RXPFrame_frame1", "RXPFrame_frame2", "RXPFrame_frame3", "RXPFrame_frame4", "RXPFrame_frame5", "RXPFrame_frame6", "PlayerChoiceFrame", "WeaponSwingTimerHunterBackdropFrame", "WeaponSwingTimerPlayerBackdropFrame", "WeaponSwingTimerTargetBackdropFrame", "FlightTimerClassic", "ACP_AddonList", "ACP_AddonList_ScrollFrame", "RankerMainFrame", "UIWidgetPowerBarContainerFrame", "ReadyStatus.Border", "FlightMapFrame.BorderFrame", "CovenantMissionFrame", "GhostFrame", "DeathRecapFrame", "PVPScoreFrameTab1", "PVPScoreFrameTab2", "PVPScoreFrameTab3", "PVPMatchResults.content", "PVPMatchResults", "PVPScoreboardTab1", "PVPScoreboardTab2", "PVPScoreboardTab3", "PVPMatchScoreboard", "PVPMatchScoreboard.Content", "PVPMatchScoreboard.Content.TabContainer.InsetBorderTop", "InspectFrame", "DelvesCompanionConfigurationFrame.CompanionCombatRoleSlot.OptionsList", "DelvesCompanionConfigurationFrame.CompanionCombatTrinketSlot.OptionsList", "DelvesCompanionConfigurationFrame.CompanionUtilityTrinketSlot.OptionsList", "DelvesCompanionConfigurationFrame.Border", "DelvesDifficultyPickerFrame.Border", "MacroPopupFrame.BorderBox", "ReforgingFrameRestoreButton_RightSeparator", "ReforgingFrameRestoreButton_LeftSeparator", "ReforgingFrameButtonFrame", "ReforgingFrame", "WeeklyRewardsFrame.BorderContainer", "WeeklyRewardsFrame", "WeeklyRewardsFrame.SelectRewardButton.Background", "ItemSocketingFrame", "ChannelFrameBg", "ChannelFrame.ChannelRoster.ScrollFrame.scrollBar", "ChannelFrame", "CommunitiesFrame.ChatTab", "CommunitiesFrame.RosterTab", "CommunitiesFrame.GuildBenefitsTab", "CommunitiesFrame.GuildInfoTab", "CommunitiesFrame.GuildMemberDetailFrame.Border", "WarGameStartButton_RightSeparator", "WarGamesFrame", "WarGamesFrameBGTex", "WarGamesFrameInfoScrollFrameScrollBar", "WarGamesFrameInfoScrollFrame.ScrollBar.Background", "WarGamesFrame.scrollBar", "PVPConquestFrame", "PVPFrameRightButton_LeftSeparator", "PVPHonorFrameBGTex", "PVPHonorFrameInfoScrollFrameScrollBar", "PVPHonorFrameInfoScrollFrame.ScrollBar.Background", "PVPHonorFrame.bgTypeScrollBar", "PVPTeamManagementFrame", "ProfessionsBookFrame", "PlayerSpellsFrame", "ScrappingMachineFrame", "ECS_StatsFrame", "TrinketMenu_MenuFrame", "TrinketMenu_MainFrame", "TrinketMenu_Trinket0.NormalTexture", "TrinketMenu_Trinket1.NormalTexture", "ProfessionsCustomerOrdersFrame", "VoidStorageBorderFrame", "VoidStorageFrame.Page1", "VoidStorageFrame.Page2", "VoidStorageFrame.Page3", "WardrobeFrame", "WardrobeCollectionFrame", "ProfessionsFrame", "ProfessionsFrame.CraftingPage", "ProfessionsFrame.TabSystem", "ItemInteractionFrame", "ItemInteractionFrame.ItemConversionFrame", "InspectTalentFrame", "InspectTalentFramePointsBar", "InspectPVPFrame", "InspectHonorFrame", "StaticPopup1", "StaticPopup2", "ItemUpgradeFrame", "InspectPaperDollFrame", "InspectFrameTab1", "InspectFrameTab2", "InspectFrameTab3", "EngravingFrame", "EngravingFrame.Border", "EngravingFrameSideInset", "WeakAurasOptions", "GenericTraitFrame.NineSlice", "EditModeManagerFrame.Border", "ClassTrainerFrame", "ClassTrainerListScrollFrame", "ClassTrainerExpandButtonFrame", "KeyBindingFrame", "KeyBindingFrame.header", "MacroFrame", "MacroFrameTab1", "MacroFrameTab2", "MacroFrameTextBackground", "MacroButtonScrollFrame", "MacroFrame.MacroSelector.ScrollBar.Background", "TradeSkillFrame", "CraftFrame", "TradeSkillList", "AuctionFrame", "BrowseFilterScrollFrame", "BrowseScrollFrame", "AuctionFrameTab1", "AuctionFrameTab2", "AuctionFrameTab3", "AuctionFrameTab4", "AuctionFrameTab5", "AuctionFrameTab6", "AuctionFrameTab7", "AuctionFrameTab8", "AuctionFrameTab9", "AuctionFrameTab10", "AuctionFrameTab11", "AuctionFrameTab12", "BrowseBidButton", "BrowseBuyoutButton", "BrowseCloseButton", "BidBidButton", "BidBuyoutButton", "BidCloseButton", "AuctionHouseFrame", "AuctionHouseFrameBuyTab", "AuctionHouseFrameSellTab", "AuctionHouseFrameAuctionsTab", "PlayerTalentFrame", "PlayerTalentFramePointsBar", "PlayerTalentFrameTab1", "PlayerTalentFrameTab2", "PlayerTalentFrameTab3", "PlayerTalentFrameTab4", "PlayerTalentFrameTab5", "ClassTalentFrame", "ClassTalentFrame.TabSystem", "ClassTalentFrame.TalentsTab.BottomBar", "AchievementFrame", "AchievementFrame.Header", "AchievementFrameTab1", "AchievementFrameTab2", "AchievementFrameTab3", "AchievementFrameTab4", "AchievementFrameTab5", "AchievementFrameTab6", "AchievementFrameTab7", "AchievementFrameTab8", "AchievementFrameCategories", "AchievementFrameSummary", "CommunitiesFrame", "CommunitiesFrameCommunitiesList", "CommunitiesFrame.MemberList", "CommunitiesFrame.Chat.MessageFrame.ScrollBar", "CollectionsJournal", "CollectionsJournalTab1", "CollectionsJournalTab2", "CollectionsJournalTab3", "CollectionsJournalTab4", "CollectionsJournalTab5", "CollectionsJournalTab6", "WardrobeCollectionFrame", "WardrobeCollectionFrame.ItemsCollectionFrame", "ToyBox", "ToyBox.iconsFrame", "HeirloomsJournal", "HeirloomsJournal.iconsFrame", "EncounterJournal", "EncounterJournalMonthlyActivitiesTab", "EncounterJournalSuggestTab", "EncounterJournalDungeonTab", "EncounterJournalRaidTab", "EncounterJournalLootJournalTab", "EncounterJournalInstanceSelect", "EncounterJournalJourneysTab", "EncounterJournal.TutorialsTab", "CalendarFrame",}
for i = 0, 19 do
	tinsert(DMFramesAddons, "ItemRackOptInv" .. i .. "NormalTexture")
	tinsert(DMFramesAddons, "ItemRackMenu" .. i .. "NormalTexture")
	tinsert(DMFramesAddons, "ItemRackButton" .. i .. "NormalTexture")
end

for x, w in pairs({"AmmoSlot[1]", "MainHandSlot[17]", "MainHandSlotFrame", "SecondaryHandSlot[17]", "SecondaryHandSlotFrame", "RangedSlotFrame", "HandsSlotFrame", "WaistSlotFrame", "LegsSlotFrame", "FeetSlotFrame", "Finger0SlotFrame", "Finger1SlotFrame", "Trinket0SlotFrame", "Trinket1SlotFrame", "HeadSlotFrame", "NeckSlotFrame", "ShoulderSlotFrame", "BackSlotFrame", "ChestSlotFrame", "ShirtSlotFrame", "TabardSlotFrame", "WristSlotFrame", "FrameInsetRight",}) do
	tinsert(DMFrames, "Character" .. w)
	tinsert(DMFramesAddons, "Inspect" .. w)
end

local BorderNames = {"RightEdge", "BottomRightCorner", "BottomEdge", "BottomLeftCorner", "LeftEdge", "TopLeftCorner", "TopEdge", "TopRightCorner"}
for i, frameName in pairs({"MinimapButtonButtonButton"}) do
	for x, borderName in pairs(BorderNames) do
		tinsert(DMFramesAddons, frameName .. "." .. borderName)
	end
end

for x, borderName in pairs(BorderNames) do
	tinsert(DMFramesAddons, "RXPFrameGuideName." .. borderName)
end

local DMFramesAddonsTab = nil
function DarkMode:GetFrameAddonsTable()
	if DMFramesAddonsTab == nil then
		DMFramesAddonsTab = {}
		for x, name in ipairs(DMFramesAddons) do
			DMFramesAddonsTab[name] = name
		end
	end

	return DMFramesAddonsTab
end

local DMFrameTexts = {"WarGamesFrameDescription", "PVPHonorFrameInfoScrollFrameChildFrameDescription", "BattlefieldFrameZoneDescription", "GossipGreetingScrollChildFrame", "QuestGreetingScrollChildFrame", "QuestProgressScrollChildFrame", "QuestRewardScrollChildFrame", "QuestLogDetailScrollChildFrame", "QuestInfoTitleHeader", "QuestInfoQuestType", "QuestInfoObjective1", "QuestInfoObjective2", "QuestInfoObjective3", "QuestInfoObjective4", "QuestInfoObjective5", "QuestInfoObjective6", "QuestInfoObjective7", "QuestInfoObjective8", "QuestInfoObjective9", "QuestInfoObjective10", "QuestInfoObjective11", "QuestInfoObjective12", "QuestInfoObjective13", "QuestInfoObjective14", "QuestInfoDescriptionHeader", "QuestInfoDescriptionText", "QuestInfoObjectivesHeader", "QuestInfoObjectivesText", "QuestInfoRewardText", "QuestInfoRewardsFrame", "GossipGreetingText", "QuestTitleButton1", "QuestTitleButton2", "QuestTitleButton3", "QuestTitleButton4", "QuestTitleButton5", "QuestTitleButton6", "QuestTitleButton7", "QuestTitleButton8", "QuestTitleButton9", "QuestTitleButton10", "QuestTitleButton11", "QuestTitleButton12", "QuestTitleButton13", "QuestTitleButton14", "QuestTitleButton15", "GossipTitleButton1", "GossipTitleButton2", "GossipTitleButton3", "GossipTitleButton4", "GossipTitleButton5", "GossipTitleButton6", "GossipTitleButton7", "GossipTitleButton8", "GossipTitleButton9", "GossipTitleButton10", "GossipTitleButton11", "GossipTitleButton12", "GossipTitleButton13", "GossipTitleButton14", "GossipTitleButton15",}
for i = 1, 12 do
	tinsert(DMFrameTexts, "SpellButton" .. i .. "SpellName")
	tinsert(DMFrameTexts, "SpellButton" .. i .. "SubSpellName")
	tinsert(DMFrameTexts, "SpellButton" .. i .. "RequiredLevelString")
end

local DMFrameTextsTab = nil
function DarkMode:GetFrameTextTable()
	if DMFrameTextsTab == nil then
		DMFrameTextsTab = {}
		for x, name in ipairs(DMFrameTexts) do
			if not string.find(name, "QuestInfo", 1, true) then
				DMFrameTextsTab[name] = name
			end
		end
	end

	return DMFrameTextsTab
end

local DMMapFrameTextsTab = nil
function DarkMode:GetMapFrameTextTable()
	if DMMapFrameTextsTab == nil then
		DMMapFrameTextsTab = {}
		for x, name in ipairs(DMFrameTexts) do
			if string.find(name, "QuestInfo", 1, true) then
				DMMapFrameTextsTab[name] = name
			end
		end
	end

	return DMMapFrameTextsTab
end

local DMGroupLootFrames = {"GroupLootContainer", "GroupLootFrame1", "GroupLootFrame2", "GroupLootFrame3", "GroupLootFrame4", "GroupLootFrame5", "GroupLootFrame1Corner", "GroupLootFrame2Corner", "GroupLootFrame3Corner", "GroupLootFrame4Corner", "GroupLootFrame5Corner"}
function DarkMode:GetGroupLootTable()
	return DMGroupLootFrames
end

-- ids: https://www.townlong-yak.com/framexml/live/Helix/ArtTextureID.lua
local DMTextureBlock = {}
DMTextureBlock["Interface\\QuestFrame\\UI-QuestLog-BookIcon"] = true
DMTextureBlock["Interface\\Spellbook\\Spellbook-Icon"] = true
DMTextureBlock["Interface\\FriendsFrame\\FriendsFrameScrollIcon"] = true
DMTextureBlock["Interface\\MacroFrame\\MacroFrame-Icon"] = true
DMTextureBlock["Interface\\Buttons\\UI-CheckBox-Check"] = true
DMTextureBlock["Interface\\Buttons\\UI-MinusButton-UP"] = true
DMTextureBlock["Interface\\Buttons\\UI-PlusButton-Hilight"] = true
DMTextureBlock["Interface\\Buttons\\UI-Panel-Button-Up"] = true
DMTextureBlock["Interface\\Buttons\\UI-Panel-Button-Highlight"] = true
DMTextureBlock["Interface\\Buttons\\ButtonHilight-Square"] = true
DMTextureBlock["Interface\\Buttons\\CheckButtonHilight"] = true
DMTextureBlock["Interface\\TimeManager\\GlobeIcon"] = true
DMTextureBlock["RTPortrait1"] = true
DMTextureBlock["Interface\\TargetingFrame\\UI-StatusBar"] = true
DMTextureBlock["Interface\\MailFrame\\Mail-Icon"] = true
DMTextureBlock["Interface\\ContainerFrame\\UI-Bag-1Slot"] = true
DMTextureBlock["Interface\\SpellBook\\SpellBook-SkillLineTab-Glow"] = true
if DarkMode:GetWoWBuild() == "RETAIL" then
	DMTextureBlock[130724] = true -- Spellbook Tab Highlight Icon
	DMTextureBlock[136377] = true -- MacroFrame Portrai
end

DMTextureBlock[130724] = true -- Spellbook Tab Highlight Icon
DMTextureBlock[136797] = true -- QuestLogFrame Icon
DMTextureBlock[131116] = true -- FriendsFrame Icon
DMTextureBlock[136382] = true -- MailFrame Icon
DMTextureBlock[130709] = true -- "Interface/BattlefieldFrame/UI-Battlefield-Icon",
DMTextureBlock[136830] = true -- Spellbook Icon
-- StatusBar
DMTextureBlock[137012] = true -- "Interface/TargetingFrame/UI-StatusBar"
-- Button
DMTextureBlock[130717] = true -- "Interface/Buttons/ButtonHilight-Round"
DMTextureBlock[130718] = true -- "Interface/Buttons/ButtonHilight-Square"
DMTextureBlock[130719] = true -- "Interface/Buttons/ButtonHilight-SquareQuickslot"
-- CHAT Tabs
DMTextureBlock[374174] = true
DMTextureBlock[374176] = true
DMTextureBlock[374178] = true
DMTextureBlock[374168] = true
DMTextureBlock[374170] = true
DMTextureBlock[374172] = true
DMTextureBlock["Portrait2"] = true -- CollectionsJournal
DMTextureBlock[130832] = true
DMTextureBlock[2056011] = true
DMTextureBlock[442272] = true
DMTextureBlock[413584] = true
DMTextureBlock[1500877] = true
DMTextureBlock[526421] = true
function DarkMode:GetTextureBlockTable()
	return DMTextureBlock
end

local DMIgnoreFrames = {}
if DarkMode:GetWoWBuild() ~= "RETAIL" then
	DMIgnoreFrames["FriendsFrameIcon"] = true
	DMIgnoreFrames["FriendsFramePortrait"] = true
	DMIgnoreFrames["FriendsFramePortraitFrame"] = true
	DMIgnoreFrames["FriendsTabHeader"] = true
	DMIgnoreFrames["FriendsListFrame"] = true
	DMIgnoreFrames["CollectionsJournalPortrait"] = true
	DMIgnoreFrames["CollectionsJournalPortraitFrame"] = true
end

DMIgnoreFrames["HonorFramePvPIcon"] = true
function DarkMode:GetIgnoreFrames(name)
	return DMTextureBlock[name] or false
end

local DMIgnoreTextureNames = {}
DMIgnoreTextureNames["ContainerFrame1Portrait"] = true
DMIgnoreTextureNames["HonorFramePvPIcon"] = true
function DarkMode:GetIgnoreTextureName(name)
	return DMIgnoreTextureNames[name] or false
end

DarkMode:After(
	1,
	function()
		if DarkMode:IsAddOnLoaded("DragonflightUI") then
			if TargetFrame then
				local texture = DarkMode:FindTextures(TargetFrame, "uf", "DragonflightUITargetFrameBorder")
				if texture then
					DarkMode:UpdateColor(texture, "uf")
				end

				local texture2 = DarkMode:FindTextures(TargetFrame, "uf", "DragonflightUITargetFrameBackground")
				if texture2 then
					DarkMode:UpdateColor(texture2, "uf")
				end
			end

			if TargetFrameToT then
				local texture = DarkMode:FindTextures(TargetFrameToT, "uf", "DragonflightUITargetFrameToTBorder")
				if texture then
					DarkMode:UpdateColor(texture, "uf")
				end

				local texture2 = DarkMode:FindTextures(TargetFrameToT, "uf", "DragonflightUITargetFrameToTBackground")
				if texture2 then
					DarkMode:UpdateColor(texture2, "uf")
				end
			end

			if FocusFrame then
				local texture = DarkMode:FindTextures(FocusFrame, "uf", "DragonflightUIFocusFrameBorder")
				if texture then
					DarkMode:UpdateColor(texture, "uf")
				end

				local texture2 = DarkMode:FindTextures(FocusFrame, "uf", "DragonflightUIFocusFrameBackground")
				if texture2 then
					DarkMode:UpdateColor(texture2, "uf")
				end
			end

			if FocusFrameToT then
				local texture = DarkMode:FindTextures(FocusFrameToT, "uf", "DragonflightUIFocusFrameToTBorder")
				if texture then
					DarkMode:UpdateColor(texture, "uf")
				end

				local texture2 = DarkMode:FindTextures(FocusFrameToT, "uf", "DragonflightUIFocusFrameToTBackground")
				if texture2 then
					DarkMode:UpdateColor(texture2, "uf")
				end
			end
		end
	end, "DragonflightUIFix"
)
