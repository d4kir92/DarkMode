
local AddOnName, DarkMode = ...



function DarkMode:GetColor( id )
	local colorMode = DMColorModes[id]
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
		local PlayerClass, PlayerClassEng, PlayerClassIndex = UnitClass( "PLAYER" )
		local r, g, b, hex = GetClassColor( PlayerClassEng )
		return r, g, b, 1
	elseif colorMode == "Default" then
		return 1, 1, 1, 1
	elseif colorMode == "Custom" then
		return 1, 1, 1, 0.1
	end
	return 1.000, 0.000, 0.000, 0.3
end

function DarkMode:GetUiColor()
	local r, g, b, a = DarkMode:GetColor( DarkMode:GV( "COLORMODE", 1 ) )
	return r, g, b, a
end

function DarkMode:GetFrameColor()
	local r, g, b, a = DarkMode:GetColor( DarkMode:GV( "COLORMODEF", 1 ) )
	return r, g, b, a
end

function DarkMode:GetTextColor( r, g, b, a )
	if r and g and b then
		local sum = r + g + b
		if sum > 1 then
			return 0, 0, 0, 1
		end
	end
	return 1, 1, 1, 1
end


local DMRepeatingFrames = {
	"", -- self

	".Background",
	".Bg",
	".Bg.TopSection",
	".Bg.BottomEdge",

	"Inset", -- INSET
	"Inset.Bg",
	"Inset.NineSlice", -- INSET, NINESLICE
	"Inset.NineSlice.TopEdge",
	"Inset.NineSlice.RightEdge",
	"Inset.NineSlice.LeftEdge",
	"Inset.NineSlice.BottomEdge",
	"Inset.NineSlice.TopRightCorner",
	"Inset.NineSlice.TopLeftCorner",
	"Inset.NineSlice.BottomRightCorner",
	"Inset.NineSlice.BottomLeftCorner",
	
	".NineSlice", -- NINESLICE
	".NineSlice.TopEdge",
	".NineSlice.RightEdge",
	".NineSlice.LeftEdge",
	".NineSlice.BottomEdge",
	".NineSlice.TopRightCorner",
	".NineSlice.TopLeftCorner",
	".NineSlice.BottomRightCorner",
	".NineSlice.BottomLeftCorner",

	"ScrollFrame", -- SCROLLFRAME
	".Begin",
	".Middle",
	".End",
	".ScrollBar.Background",
}

function DarkMode:GetDMRepeatingFrames()
	return DMRepeatingFrames
end

local DMUi = {
	-- Collections
	["ActionButtons"] = {
		"ActionButton",
		"MultiBarBottomLeftButton",
		"MultiBarBottomRightButton",
		"MultiBarLeftButton",
		"MultiBarRightButton",

		-- MoveAny
		"ActionBar7Button",
		"ActionBar8Button",
		"ActionBar9Button",
		"ActionBar10Button",

		-- RETAIL
		"MultiBar5Button",
		"MultiBar6Button",
		"MultiBar7Button",

		"StanceButton",

		"PetActionButton",
	},
	["Minimap"] = {
		"MinimapBorder",
		"MinimapBorderTop",
		"TimeManagerClockButton",
		"MinimapCompassTexture",
		"MinimapCluster.BorderTop",
	},

	-- Textures
	"PlayerFrameTexture",
	"TargetFrameTextureFrameTexture",
	"FocusFrameTextureFrameTexture",
	"TargetFrameToTTextureFrameTexture",
	"PetFrameTexture",

	-- Classic ERA Frames
	"MainMenuBarArtFrame",
	"MainMenuExpBar",
	"ReputationWatchBar.StatusBar",

	-- RETAIL
	"PlayerFrame.PlayerFrameContainer.FrameTexture",
	"TargetFrame.TargetFrameContainer.FrameTexture",
	"FocusFrame.TargetFrameContainer.FrameTexture",
}

function DarkMode:GetUiTable()
	return DMUi
end

local DMUiAddons = {
	"FocusFrame.FocusFrameContainer.FrameTexture",
}

function DarkMode:GetUiAddonsTable()
	return DMUi
end

local DMFrames = {
	-- 1
	"PaperDollFrame",
	"CharacterFrame",
	"CharacterStatsPane",
	"CharacterFrameTab1",
	"CharacterFrameTab2",
	"CharacterFrameTab3",
	"CharacterFrameTab4",
	"CharacterFrameTab5",
	"ReputationFrame",
	"ReputationListScrollFrame",
	"SkillFrame",
	"SkillListScrollFrame",
	"SkillDetailScrollFrame",
	"HonorFrame",
	"PetPaperDollFrame",
	"PetPaperDollFrameTab1",
	"PetPaperDollFrameTab2",
	"PetPaperDollFrameTab3",
	"PetPaperDollFrameExpBar",
	"TokenFrame",

	-- 2
	"SpellBookFrame",
	"SpellBookSkillLineTab1",
	"SpellBookSkillLineTab2",
	"SpellBookSkillLineTab3",
	"SpellBookSkillLineTab4",
	"SpellBookSkillLineTab5",
	"SpellBookSkillLineTab6",
	"SpellBookSkillLineTab7", -- WhatsTraining
	"WhatsTrainingFrame",
	"SpellBookFrameTabButton1",
	"SpellBookFrameTabButton2",

	-- 3 requires addon loaded

	-- 4
	"QuestLogFrame",
	"QuestLogCollapseAllButton",
	--"QuestLogExpandButtonFrame", -- false
	"QuestMapFrame",
	"QuestScrollFrame.ScrollBar",

	-- 5
	"FriendsFrame",
	"FriendsFrameFriendsScrollFrame",
	"FriendsFrameTab1",
	"FriendsFrameTab2",
	"FriendsFrameTab3",
	"FriendsFrameTab4",
	"WhoFrameList",

	-- 6
	"WorldMapFrame",
	"WorldMapFrame.BorderFrame",

	-- 7
	"LFGParentFrame",
	"LFGParentFrameTab1",
	"LFGParentFrameTab2",
	"LFMFrame",
	"LFGBrowseFrame",
	"LFGListingFrame",
	"PVEFrame",
	"PVEFrameTab1",
	"PVEFrameTab2",
	"PVEFrameTab3",
	"PVEFrameTab4",
	"PVPFrame",
	"ChallengesFrame",


	-- 8
	"GameMenuFrame",
	"GameMenuFrame.Border",
	"GameMenuFrame.Header",

	-- NPC
	"QuestFrame",
	"QuestFrameDetailPanel",
	"QuestDetailScrollFrame",
	"QuestDetailScrollChildFrame",
	"GossipFrameGreetingPanel",
	"GossipGreetingScrollFrame",
	"QuestFrameGreetingPanel",
	"QuestGreetingScrollFrame",
	"QuestFrameProgressPanel",
	"QuestProgressScrollFrame",
	"QuestRewardScrollFrame",
	"QuestFrameRewardPanel",

	"GossipFrame",
	"GossipFrame.GreetingPanel",
	"GossipFrame.GreetingPanel.ScrollBox",
	"GossipFrame.GreetingPanel.ScrollBar.Background",

	"MerchantFrame",
	"MerchantBuyBackItem",
	"MerchantFrameTab1",
	"MerchantFrameTab2",
	"MerchantItem1",
	"MerchantItem2",
	"MerchantItem3",
	"MerchantItem4",
	"MerchantItem5",
	"MerchantItem6",
	"MerchantItem7",
	"MerchantItem8",
	"MerchantItem9",
	"MerchantItem10",
	"MerchantItem11",
	"MerchantItem12",
	"MerchantMoney",
	"MerchantMoneyBg",
	"PetStableFrame",

	-- 
	"AddonList",
	"AddonListDisableAllButton_RightSeparator",
	"AddonListEnableAllButton_RightSeparator",
	"AddonListOkayButton_LeftSeparator",
	"AddonListOkayButton_RightSeparator",
	"AddonListCancelButton_LeftSeparator",

	"HelpFrame",
	"VideoOptionsFrame",
	"InterfaceOptionsFrame",

	"TimeManagerFrame",

	"MailFrame",
	"MailFrameTab1",
	"MailFrameTab2",
	"InboxFrame",
	"SendMailFrame",
	"SendMailMoney",
	"SendMailMoneyBg",
	"SendMailMoneyFrame",
	"SendMail",
	"MailEditBoxScrollBar",

	"BankFrame",
	"BankFrameTab1",
	"BankFrameTab2",
	"BankFrameMoneyFrame",
	"BankFrameMoneyFrameBorder",

	"BackpackTokenFrame",
	"ContainerFrame1",
	"ContainerFrame2",
	"ContainerFrame3",
	"ContainerFrame4",
	"ContainerFrame5",
	"ContainerFrame6",
	"ContainerFrame7",
	"ContainerFrame8",
	"ContainerFrame9",
	"ContainerFrame10",
	"ContainerFrame11",
	"ContainerFrame12",
	"ContainerFrameCombinedBags",

	"PVPFrame",
	"PVPParentFrame",
	"PVPParentFrameTab1",
	"PVPParentFrameTab2",
	"BattlefieldFrame",
	"BattlefieldFrameType",

	"TaxiFrame",
}

function DarkMode:GetFrameTable()
	return DMFrames
end

local DMFramesAddons = {
	"ClassTrainerFrame",
	"ClassTrainerListScrollFrame",
	"ClassTrainerExpandButtonFrame",

	"KeyBindingFrame",
	"KeyBindingFrame.header",

	"MacroFrame",
	"MacroFrameTab1",
	"MacroFrameTab2",
	"MacroFrameTextBackground",
	"MacroButtonScrollFrame",

	"TradeSkillFrame",
	"TradeSkillList",

	"AuctionFrame",
	"AuctionFrameTab1",
	"AuctionFrameTab2",
	"AuctionFrameTab3",
	"AuctionFrameTab4",
	"AuctionFrameTab5",
	"AuctionFrameTab6",
	"AuctionFrameTab7",
	"AuctionFrameTab8",
	"AuctionFrameTab9",
	"AuctionFrameTab10",
	"AuctionFrameTab11",
	"AuctionFrameTab12",
	"BrowseBidButton",
	"BrowseBuyoutButton",
	"BrowseCloseButton",
	"BidBidButton",
	"BidBuyoutButton",
	"BidCloseButton",

	"AuctionHouseFrame",
	"AuctionHouseFrameBuyTab",
	"AuctionHouseFrameSellTab",
	"AuctionHouseFrameAuctionsTab",

	"PlayerTalentFrame",
	"PlayerTalentFramePointsBar",
	"PlayerSpecTab1",
	"PlayerSpecTab2",
	"PlayerSpecTab3",
	"PlayerSpecTab4",
	"PlayerTalentFrameTab1",
	"PlayerTalentFrameTab2",
	"PlayerTalentFrameTab3",
	"PlayerTalentFrameTab4",
	"PlayerTalentFrameTab5",

	"ClassTalentFrame",
	"ClassTalentFrame.TabSystem",
	"ClassTalentFrame.TalentsTab.BottomBar",

	"AchievementFrame",
	"AchievementFrame.Header",
	"AchievementFrameTab1",
	"AchievementFrameTab2",
	"AchievementFrameTab3",
	"AchievementFrameTab4",
	"AchievementFrameHeader",
	"AchievementFrameCategories",
	"AchievementFrameSummary",

	"WeeklyRewardsFrame",

	"CommunitiesFrame",
	"CommunitiesFrameCommunitiesList",
	"CommunitiesFrame.MemberList",
	"CommunitiesFrame.Chat.MessageFrame.ScrollBar",
	--"CommunitiesFrame.ChatTab",
	--"CommunitiesFrame.RosterTab",
	--"CommunitiesFrame.GuildBenefitsTab",
	--"CommunitiesFrame.GuildInfoTab",

	"CollectionsJournal",
	"CollectionsJournalTab1",
	"CollectionsJournalTab2",
	"CollectionsJournalTab3",
	"CollectionsJournalTab4",
	"CollectionsJournalTab5",
	"CollectionsJournalTab6",
	"WardrobeCollectionFrame",
	"WardrobeCollectionFrame.ItemsCollectionFrame",
	"ToyBox",
	"ToyBox.iconsFrame",
	"HeirloomsJournal",
	"HeirloomsJournal.iconsFrame",

	"EncounterJournal",
	"EncounterJournalSuggestTab",
	"EncounterJournalDungeonTab",
	"EncounterJournalRaidTab",
	"EncounterJournalInstanceSelect",
}

function DarkMode:GetFrameAddonsTable()
	return DMFramesAddons
end

local DMFrameTexts = {
	"GossipGreetingScrollChildFrame",
	"QuestGreetingScrollChildFrame",
	"QuestProgressScrollChildFrame",
	"QuestRewardScrollChildFrame",

	"QuestLogDetailScrollChildFrame",

	--"QuestDetailScrollChildFrame",
	"QuestInfoTitleHeader",
	"QuestInfoDescriptionText",
	"QuestInfoObjectivesHeader",
	"QuestInfoObjectivesText",
	"QuestInfoRewardText",

	"QuestInfoRewardsFrame",

	"GossipGreetingText",

	"QuestTitleButton1",
	"QuestTitleButton2",
	"QuestTitleButton3",
	"QuestTitleButton4",
	"QuestTitleButton5",
	"GossipTitleButton1",
	"GossipTitleButton2",
	"GossipTitleButton3",
	"GossipTitleButton4",
	"GossipTitleButton5",
	"GossipTitleButton6",
	"GossipTitleButton7",
	"GossipTitleButton8",
	"GossipTitleButton9",
	"GossipTitleButton10",
	"GossipTitleButton11",
	"GossipTitleButton12",
	"GossipTitleButton13",
	"GossipTitleButton14",
	"GossipTitleButton15",
}

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
DMTextureBlock[137012] = true
DMTextureBlock["RTPortrait1"] = true
DMTextureBlock["Interface\\TargetingFrame\\UI-StatusBar"] = true
DMTextureBlock["Interface\\MailFrame\\Mail-Icon"] = true
DMTextureBlock["Interface\\ContainerFrame\\UI-Bag-1Slot"] = true
DMTextureBlock[136830] = true
DMTextureBlock[130724] = true
DMTextureBlock[130718] = true
DMTextureBlock[135770] = true
DMTextureBlock[135775] = true
DMTextureBlock[136797] = true
DMTextureBlock[131116] = true
DMTextureBlock[130709] = true
DMTextureBlock[136382] = true
DMTextureBlock[136382] = true
DMTextureBlock[1723833] = true

function DarkMode:GetTextureBlockTable()
	return DMTextureBlock
end
