local _, DarkMode = ...

function DarkMode:GetColor(id, name)
	local colorMode = DarkMode:GetColorModes()[id]

	if colorMode == "Dark" then
		return 0.180, 0.180, 0.180, 1
	elseif colorMode == "Dark+" then
		return 0.140, 0.140, 0.140, 1
	elseif colorMode == "Darker" then
		return 0.100, 0.100, 0.100, 1
	elseif colorMode == "Darker+" then
		return 0.060, 0.060, 0.060, 1
	elseif colorMode == "Black" then
		return 0.000, 0.000, 0.000, 1
	elseif colorMode == "ClassColor" then
		local _, PlayerClassEng, _ = UnitClass("PLAYER")
		local r, g, b, _ = GetClassColor(PlayerClassEng)

		return r, g, b, 1
	elseif colorMode == "Default" then
		return 1, 1, 1, 1
	elseif colorMode == "Off" then
		return nil, nil, nil, nil
	elseif colorMode == "Custom" then
		return DarkMode:GetCustomColor(name)
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

function DarkMode:GetUiColor()
	local r, g, b, a = DarkMode:GetColor(DarkMode:GV("COLORMODE", 1), "CUSTOMUIC")

	return r, g, b, a
end

function DarkMode:GetUFColor()
	local r, g, b, a = DarkMode:GetColor(DarkMode:GV("COLORMODEUF", 7), "CUSTOMUFC")

	return r, g, b, a
end

function DarkMode:GetTTColor()
	local r, g, b, a = DarkMode:GetColor(DarkMode:GV("COLORMODETT", 1), "CUSTOMTTC")

	return r, g, b, a
end

function DarkMode:GetFrameColor()
	local r, g, b, a = DarkMode:GetColor(DarkMode:GV("COLORMODEF", 1), "CUSTOMFRC")

	return r, g, b, a
end

function DarkMode:GetTextColor(r, g, b, a)
	if r ~= nil and g ~= nil and b ~= nil then
		local sum = r + g + b
		if sum > 1 then return 0, 0, 0, 1 end
	end

	return 1, 1, 1, 1
end

local DMRepeatingFrames = {"", ".Background", ".Bg", ".Bg.TopSection", ".Bg.BottomEdge", "Inset", "Inset.Bg", "Inset.NineSlice", "Inset.NineSlice.TopEdge", "Inset.NineSlice.RightEdge", "Inset.NineSlice.LeftEdge", "Inset.NineSlice.BottomEdge", "Inset.NineSlice.TopRightCorner", "Inset.NineSlice.TopLeftCorner", "Inset.NineSlice.BottomRightCorner", "Inset.NineSlice.BottomLeftCorner", ".NineSlice", ".NineSlice.TopEdge", ".NineSlice.RightEdge", ".NineSlice.LeftEdge", ".NineSlice.BottomEdge", ".NineSlice.TopRightCorner", ".NineSlice.TopLeftCorner", ".NineSlice.BottomRightCorner", ".NineSlice.BottomLeftCorner", "ScrollFrame", ".Begin", ".Middle", ".End", ".ScrollBar.Background",}

function DarkMode:GetDMRepeatingFrames()
	return DMRepeatingFrames
end

local DMUi = {
	["ActionButtons"] = {"ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarLeftButton", "MultiBarRightButton", "ActionBar7Button", "ActionBar8Button", "ActionBar9Button", "ActionBar10Button", "MultiBar5Button", "MultiBar6Button", "MultiBar7Button", "StanceButton", "PetActionButton", "BT4Button", "BT4StanceButton", "BT4PetButton", "DominosActionButton"},
	["Minimap"] = {"MinimapBorder", "MinimapBorderTop", "TimeManagerClockButton", "MinimapCompassTexture", "MinimapCluster.BorderTop",},
	["UnitFrames"] = {"PlayerFrameTexture", "TargetFrameTextureFrameTexture", "FocusFrameTextureFrameTexture", "TargetFrameToTTextureFrameTexture", "PetFrameTexture", "PlayerFrame.PlayerFrameContainer.AlternatePowerFrameTexture", "PlayerFrame.PlayerFrameContainer.FrameTexture", "TargetFrame.TargetFrameContainer.FrameTexture", "FocusFrame.TargetFrameContainer.FrameTexture", "PartyMemberFrame1Texture", "PartyMemberFrame2Texture", "PartyMemberFrame3Texture", "PartyMemberFrame4Texture", "PartyFrame.MemberFrame1.Texture", "PartyFrame.MemberFrame2.Texture", "PartyFrame.MemberFrame3.Texture", "PartyFrame.MemberFrame4.Texture", "CompactRaidFrameContainerBorderFrame"},
	["Tooltips"] = {"GameTooltip.NineSlice", "ItemRefTooltip.NineSlice", "ShoppingTooltip1.NineSlice", "ShoppingTooltip2.NineSlice", "WhatsTrainingTooltip.NineSlice"},
	["Artworks"] = {"MainMenuBarTexture0", "MainMenuBarTexture1", "MainMenuBarTexture2", "MainMenuBarTexture3", "MainMenuExpBar", "ReputationWatchBar.StatusBar", "MainStatusTrackingBarContainer.BarFrameTexture", "SecondaryStatusTrackingBarContainer.BarFrameTexture", "MainMenuBarMaxLevelBar", "BT4BarBlizzardArt", "BlizzardArtLeftCap", "BlizzardArtRightCap", "CompactRaidFrameManager", "CharacterReagentBag0SlotNormalTexture", "CharacterBag0SlotNormalTexture", "CharacterBag1SlotNormalTexture", "CharacterBag2SlotNormalTexture", "CharacterBag3SlotNormalTexture", "MainMenuBarBackpackButtonNormalTexture"},
	["Gryphons"] = {"MA_LeftEndCap", "MA_RightEndCap", "MainMenuBar.EndCaps", "MainMenuBarLeftEndCap", "MainMenuBarRightEndCap"},
	["Chat"] = {"ChatFrame1Tab", "ChatFrame2Tab", "ChatFrame3Tab", "ChatFrame4Tab", "ChatFrame5Tab", "ChatFrame6Tab", "ChatFrame7Tab", "ChatFrame8Tab", "ChatFrame9Tab", "ChatFrame10Tab",},
	["Castbar"] = {"CastingBarFrame.Border"}
}

for i = 1, 40 do
	table.insert(DMUi["UnitFrames"], "CompactRaidFrame" .. i .. "HorizDivider")
	table.insert(DMUi["UnitFrames"], "CompactRaidFrame" .. i .. "HorizTopBorder")
	table.insert(DMUi["UnitFrames"], "CompactRaidFrame" .. i .. "HorizBottomBorder")
	table.insert(DMUi["UnitFrames"], "CompactRaidFrame" .. i .. "VertLeftBorder")
	table.insert(DMUi["UnitFrames"], "CompactRaidFrame" .. i .. "VertRightBorder")
end

function DarkMode:GetUiTable()
	return DMUi
end

local DMUiAddons = {"FocusFrame.FocusFrameContainer.FrameTexture"}

function DarkMode:GetUiAddonsTable()
	return DMUiAddons
end

local DMFrames = {"SettingsPanel", "PaperDollFrame", "CharacterFrame", "CharacterStatsPane", "CharacterFrameTab1", "CharacterFrameTab2", "CharacterFrameTab3", "CharacterFrameTab4", "CharacterFrameTab5", "nwtab5", "nwtab6", "ReputationFrame", "ReputationListScrollFrame", "SkillFrame", "SkillListScrollFrame", "SkillDetailScrollFrame", "HonorFrame", "PetPaperDollFrame", "PetPaperDollFrameTab1", "PetPaperDollFrameTab2", "PetPaperDollFrameTab3", "PetPaperDollFrameExpBar", "TokenFrame", "SpellBookFrame", "SpellBookSkillLineTab1", "SpellBookSkillLineTab2", "SpellBookSkillLineTab3", "SpellBookSkillLineTab4", "SpellBookSkillLineTab5", "SpellBookSkillLineTab6", "SpellBookSkillLineTab7", "WhatsTrainingFrame", "SpellBookFrameTabButton1", "SpellBookFrameTabButton2", "QuestLogFrame", "QuestLogCollapseAllButton", "QuestScrollFrame.ScrollBar", "FriendsFrame", "FriendsFrameFriendsScrollFrame", "FriendsFrameTab1", "FriendsFrameTab2", "FriendsFrameTab3", "FriendsFrameTab4", "WhoFrameList", "WorldMapFrame", "WorldMapFrame.BorderFrame", "LFGParentFrame", "LFGParentFrameTab1", "LFGParentFrameTab2", "LFMFrame", "LFGBrowseFrame", "LFGListingFrame", "PVEFrame", "PVEFrameTab1", "PVEFrameTab2", "PVEFrameTab3", "PVEFrameTab4", "PVPFrame", "ChallengesFrame", "GameMenuFrame", "GameMenuFrame.Border", "GameMenuFrame.Header", "QuestFrame", "QuestFrameDetailPanel", "QuestDetailScrollFrame", "QuestDetailScrollChildFrame", "GossipFrameGreetingPanel", "GossipGreetingScrollFrame", "QuestFrameGreetingPanel", "QuestGreetingScrollFrame", "QuestFrameProgressPanel", "QuestProgressScrollFrame", "QuestRewardScrollFrame", "QuestFrameRewardPanel", "QuestInfoRewardsFrame", "GossipFrame", "GossipFrame.GreetingPanel", "GossipFrame.GreetingPanel.ScrollBox", "GossipFrame.GreetingPanel.ScrollBar.Background", "MerchantFrame", "MerchantBuyBackItem", "MerchantFrameTab1", "MerchantFrameTab2", "MerchantItem1", "MerchantItem2", "MerchantItem3", "MerchantItem4", "MerchantItem5", "MerchantItem6", "MerchantItem7", "MerchantItem8", "MerchantItem9", "MerchantItem10", "MerchantItem11", "MerchantItem12", "MerchantMoney", "MerchantMoneyBg", "PetStableFrame", "AddonList", "AddonListDisableAllButton_RightSeparator", "AddonListEnableAllButton_RightSeparator", "AddonListOkayButton_LeftSeparator", "AddonListOkayButton_RightSeparator", "AddonListCancelButton_LeftSeparator", "HelpFrame", "VideoOptionsFrame", "InterfaceOptionsFrame", "TimeManagerFrame", "MailFrame", "MailFrameTab1", "MailFrameTab2", "InboxFrame", "SendMailFrame", "SendMailMoney", "SendMailMoneyBg", "SendMailMoneyFrame", "SendMail", "MailEditBoxScrollBar", "BankFrame", "BankFrameTab1", "BankFrameTab2", "BankFrameMoneyFrame", "BankFrameMoneyFrameBorder", "BackpackTokenFrame", "ContainerFrame1", "ContainerFrame2", "ContainerFrame3", "ContainerFrame4", "ContainerFrame5", "ContainerFrame6", "ContainerFrame7", "ContainerFrame8", "ContainerFrame9", "ContainerFrame10", "ContainerFrame11", "ContainerFrame12", "ContainerFrameCombinedBags", "PVPFrame", "PVPParentFrame", "PVPParentFrameTab1", "PVPParentFrameTab2", "BattlefieldFrame", "BattlefieldFrameType", "TaxiFrame", "YourFrameName", "QuestMapFrame", "QuestMapFrame.DetailsFrame"}

function DarkMode:GetFrameTable()
	return DMFrames
end

local DMFramesAddons = {"ClassTrainerFrame", "ClassTrainerListScrollFrame", "ClassTrainerExpandButtonFrame", "KeyBindingFrame", "KeyBindingFrame.header", "MacroFrame", "MacroFrameTab1", "MacroFrameTab2", "MacroFrameTextBackground", "MacroButtonScrollFrame", "MacroFrame.MacroSelector.ScrollBar.Background", "TradeSkillFrame", "TradeSkillList", "AuctionFrame", "AuctionFrameTab1", "AuctionFrameTab2", "AuctionFrameTab3", "AuctionFrameTab4", "AuctionFrameTab5", "AuctionFrameTab6", "AuctionFrameTab7", "AuctionFrameTab8", "AuctionFrameTab9", "AuctionFrameTab10", "AuctionFrameTab11", "AuctionFrameTab12", "BrowseBidButton", "BrowseBuyoutButton", "BrowseCloseButton", "BidBidButton", "BidBuyoutButton", "BidCloseButton", "AuctionHouseFrame", "AuctionHouseFrameBuyTab", "AuctionHouseFrameSellTab", "AuctionHouseFrameAuctionsTab", "PlayerTalentFrame", "PlayerTalentFramePointsBar", "PlayerTalentFrameTab1", "PlayerTalentFrameTab2", "PlayerTalentFrameTab3", "PlayerTalentFrameTab4", "PlayerTalentFrameTab5", "ClassTalentFrame", "ClassTalentFrame.TabSystem", "ClassTalentFrame.TalentsTab.BottomBar", "AchievementFrame", "AchievementFrame.Header", "AchievementFrameTab1", "AchievementFrameTab2", "AchievementFrameTab3", "AchievementFrameTab4", "AchievementFrameHeader", "AchievementFrameCategories", "AchievementFrameSummary", "WeeklyRewardsFrame", "CommunitiesFrame", "CommunitiesFrameCommunitiesList", "CommunitiesFrame.MemberList", "CommunitiesFrame.Chat.MessageFrame.ScrollBar", "CollectionsJournal", "CollectionsJournalTab1", "CollectionsJournalTab2", "CollectionsJournalTab3", "CollectionsJournalTab4", "CollectionsJournalTab5", "CollectionsJournalTab6", "WardrobeCollectionFrame", "WardrobeCollectionFrame.ItemsCollectionFrame", "ToyBox", "ToyBox.iconsFrame", "HeirloomsJournal", "HeirloomsJournal.iconsFrame", "EncounterJournal", "EncounterJournalMonthlyActivitiesTab", "EncounterJournalSuggestTab", "EncounterJournalDungeonTab", "EncounterJournalRaidTab", "EncounterJournalLootJournalTab", "EncounterJournalInstanceSelect", "CalendarFrame",}

function DarkMode:GetFrameAddonsTable()
	return DMFramesAddons
end

local DMFrameTexts = {"GossipGreetingScrollChildFrame", "QuestGreetingScrollChildFrame", "QuestProgressScrollChildFrame", "QuestRewardScrollChildFrame", "QuestLogDetailScrollChildFrame", "QuestInfoTitleHeader", "QuestInfoQuestType", "QuestInfoObjective1", "QuestInfoObjective2", "QuestInfoObjective3", "QuestInfoObjective4", "QuestInfoObjective5", "QuestInfoObjective6", "QuestInfoDescriptionHeader", "QuestInfoDescriptionText", "QuestInfoObjectivesHeader", "QuestInfoObjectivesText", "QuestInfoRewardText", "QuestInfoRewardsFrame", "GossipGreetingText", "QuestTitleButton1", "QuestTitleButton2", "QuestTitleButton3", "QuestTitleButton4", "QuestTitleButton5", "QuestTitleButton6", "QuestTitleButton7", "QuestTitleButton8", "QuestTitleButton9", "QuestTitleButton10", "QuestTitleButton11", "QuestTitleButton12", "QuestTitleButton13", "QuestTitleButton14", "QuestTitleButton15", "GossipTitleButton1", "GossipTitleButton2", "GossipTitleButton3", "GossipTitleButton4", "GossipTitleButton5", "GossipTitleButton6", "GossipTitleButton7", "GossipTitleButton8", "GossipTitleButton9", "GossipTitleButton10", "GossipTitleButton11", "GossipTitleButton12", "GossipTitleButton13", "GossipTitleButton14", "GossipTitleButton15",}

function DarkMode:GetFrameTextTable()
	return DMFrameTexts
end

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

-- CHAT Tabs
-- ids: https://www.townlong-yak.com/framexml/live/Helix/ArtTextureID.lua
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
end

function DarkMode:GetIgnoreFrames(name)
	return DMTextureBlock[name] or false
end

local DMIgnoreTextureNames = {}
DMIgnoreTextureNames["ContainerFrame1Portrait"] = true

function DarkMode:GetIgnoreTextureName(name)
	return DMIgnoreTextureNames[name] or false
end