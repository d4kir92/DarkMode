local _, DarkMode = ...
local isRetail = DarkMode:GetWoWBuild() == "RETAIL"
local function DMAppend(target, list)
	for i = 1, #list do
		tinsert(target, list[i])
	end
	return target
end

local function DMPrefixed(prefix, parts)
	local list = {}
	for i = 1, #parts do
		list[i] = prefix .. parts[i]
	end
	return list
end

local function DMToSet(groups, value)
	local set = {}
	for _, list in pairs(groups) do
		for i = 1, #list do
			set[list[i]] = value or list[i]
		end
	end
	return set
end

local DMNineSliceParts = {"TopEdge", "RightEdge", "LeftEdge", "BottomEdge", "TopRightCorner", "TopLeftCorner", "BottomRightCorner", "BottomLeftCorner"}
function DarkMode:GetDMRepeatingFrames2()
	return DMNineSliceParts
end

local DMRepeatingFrames = {"", ".Bg.TopSection", ".Bg.BottomEdge", "Inset", "Inset.Bg", "Inset.NineSlice"}
DMAppend(DMRepeatingFrames, DMPrefixed("Inset.NineSlice.", DMNineSliceParts))
tinsert(DMRepeatingFrames, ".NineSlice")
DMAppend(DMRepeatingFrames, DMPrefixed(".NineSlice.", DMNineSliceParts))
DMAppend(DMRepeatingFrames, {"ScrollFrame", ".Begin", ".Middle", ".End", ".ScrollBar.Background"})
if not isRetail then DMAppend(DMRepeatingFrames, {".Background", ".Bg"}) end
local DMRepeatingPaths = nil
function DarkMode:GetDMRepeatingPaths()
	if DMRepeatingPaths == nil then
		DMRepeatingPaths = {}
		for i = 1, #DMRepeatingFrames do
			local suffix = DMRepeatingFrames[i]
			local entry = {
				["suffix"] = suffix,
				["skipOnLoot"] = suffix == ".Bg" or suffix == ".Background"
			}

			if strsub(suffix, 1, 1) == "." then entry["path"] = {strsplit(".", strsub(suffix, 2))} end
			DMRepeatingPaths[i] = entry
		end
	end
	return DMRepeatingPaths
end

-- format: multiline
local DMUi = {
	["ActionButtons"] = {
		"PetActionButton",
		"ActionButton",
		"MultiBarBottomLeftButton",
		"MultiBarBottomRightButton",
		"MultiBarLeftButton",
		"MultiBarRightButton",
		"ActionBar7Button",
		"ActionBar8Button",
		"ActionBar9Button",
		"ActionBar10Button",
		"MultiBar5Button",
		"MultiBar6Button",
		"MultiBar7Button",
		"StanceButton",
		"BT4Button",
		"DragonflightUIMultiactionBar6Button",
		"DragonflightUIMultiactionBar7Button",
		"DragonflightUIMultiactionBar8Button",
		"BT4StanceButton",
		"BT4PetButton",
		"DominosActionButton",
		"MultiBarBottomLeftActionButton",
		"MultiBarBottomRightActionButton",
		"MultiBarLeftActionButton",
		"MultiBarRightActionButton",
		"MultiBar5ActionButton",
		"MultiBar6ActionButton",
		"MultiBar7ActionButton",
	},
	["Minimap"] = {
		"DragonflightUIMinimapBorderSquare",
		"QuestTimerFrame",
		"CalendarButtonFrame",
		"MiniMapBattlefieldFrameBorder",
		"MiniMapBattlefieldBorder",
		"MinimapBorder",
		"MinimapBorderTop",
		"TimeManagerClockButton",
		"MinimapCompassTexture",
		"MinimapCluster.BorderTop",
	},
	["UnitFrames"] = {
		"FocusFrameToT",
		"TargetFrameToT",
		"CompactArenaFrame.PreMatchFramesContainer.PreMatchFrame1.SpecPortraitBorderTexture",
		"CompactArenaFrame.PreMatchFramesContainer.PreMatchFrame2.SpecPortraitBorderTexture",
		"CompactArenaFrame.PreMatchFramesContainer.PreMatchFrame3.SpecPortraitBorderTexture",
		"CompactArenaFrame.PreMatchFramesContainer.PreMatchFrame4.SpecPortraitBorderTexture",
		"CompactArenaFrame.PreMatchFramesContainer.PreMatchFrame5.SpecPortraitBorderTexture",
		"ArenaPrepFrame1Texture",
		"ArenaPrepFrame2Texture",
		"ArenaPrepFrame3Texture",
		"ArenaPrepFrame4Texture",
		"ArenaPrepFrame5Texture",
		"ArenaEnemyFrame1Texture",
		"ArenaEnemyFrame2Texture",
		"ArenaEnemyFrame3Texture",
		"ArenaEnemyFrame4Texture",
		"ArenaEnemyFrame5Texture",
		"PlayerFrameAlternateManaBarBorder",
		"PlayerFrameAlternateManaBarRightBorder",
		"PlayerFrameAlternateManaBarLeftBorder",
		"Boss1TargetFrameTextureFrame",
		"Boss2TargetFrameTextureFrame",
		"Boss3TargetFrameTextureFrame",
		"Boss4TargetFrameTextureFrame",
		"Boss5TargetFrameTextureFrame",
		"PlayerFrame.ClassicFrame",
		"PlayerFrameTexture",
		"TargetFrame.ClassicFrame.Texture",
		"TargetFrameTextureFrameTexture",
		"FocusFrame.ClassicFrame",
		"FocusFrameTextureFrameTexture",
		"TargetFrameToTTextureFrameTexture",
		"FocusFrameToTTextureFrameTexture",
		"PetFrameTexture",
		"PlayerFrame.PlayerFrameContainer.AlternatePowerFrameTexture",
		"PlayerFrame.PlayerFrameContainer.FrameTexture",
		"TargetFrame.TargetFrameContainer.FrameTexture",
		"FocusFrame.TargetFrameContainer.FrameTexture",
		"PartyMemberFrame1PetFrameTexture",
		"PartyMemberFrame2PetFrameTexture",
		"PartyMemberFrame3PetFrameTexture",
		"PartyMemberFrame4PetFrameTexture",
		"PartyMemberFrame1Texture",
		"PartyMemberFrame2Texture",
		"PartyMemberFrame3Texture",
		"PartyMemberFrame4Texture",
		"PartyFrame.MemberFrame1.Texture",
		"PartyFrame.MemberFrame2.Texture",
		"PartyFrame.MemberFrame3.Texture",
		"PartyFrame.MemberFrame4.Texture",
	},
	["Tooltips"] = {
		"FriendsTooltip.NineSlice",
		"RaiderIO_ProfileTooltip.NineSlice",
		"EmbeddedItemTooltip.NineSlice",
		"PartyMemberBuffTooltip.NineSlice",
		"DropDownList1MenuBackdrop.NineSlice",
		"DropDownList2MenuBackdrop.NineSlice",
		"DropDownList3MenuBackdrop.NineSlice",
		"DropDownList4MenuBackdrop.NineSlice",
		"GameTooltip.NineSlice",
		"ItemRefTooltip.NineSlice",
		"ShoppingTooltip1.NineSlice",
		"ShoppingTooltip2.NineSlice",
		"WhatsTrainingTooltip.NineSlice",
	},
	["Artworks"] = {
		"MainStatusTrackingBarContainer.StandaloneFrameTextureRightCapTop",
		"MainStatusTrackingBarContainer.StandaloneFrameTextureLeftCapTop",
		"MainStatusTrackingBarContainer.StandaloneFrameTextureRightCapBottom",
		"MainStatusTrackingBarContainer.StandaloneFrameTextureLeftCapBottom",
		"MainStatusTrackingBarContainer.StandaloneFrameTexture1",
		"MainStatusTrackingBarContainer.StandaloneFrameTexture2",
		"MainStatusTrackingBarContainer.StandaloneFrameTexture3",
		"MainStatusTrackingBarContainer.StandaloneFrameTexture4",
		"MainStatusTrackingBarContainer.StandaloneFrameTexture5",
		"MainStatusTrackingBarContainer.MainMenuBarFrameTexture1",
		"MainStatusTrackingBarContainer.MainMenuBarFrameTexture2",
		"MainStatusTrackingBarContainer.MainMenuBarFrameTexture3",
		"MainStatusTrackingBarContainer.MainMenuBarFrameTexture4",
		"PVPTimerFrame",
		"PaladinPowerBarFrame",
		"PaladinPowerBarFrame.ActiveTexture",
		"PaladinPowerBarFrame.Background",
		"TimerTrackerTimer1StatusBarBorder",
		"TimerTrackerTimer2StatusBarBorder",
		"MirrorTimer1",
		"MirrorTimer2",
		"MirrorTimer3",
		"MainActionBar.BorderArt",
		"MainActionBarTextureExtender",
		"MainMenuBar.BorderArt",
		"MainMenuBarTextureExtender",
		"StanceBarLeft",
		"StanceBarMiddle",
		"StanceBarRight",
		"StanceButton1NormalTexture2",
		"StanceButton2NormalTexture2",
		"StanceButton3NormalTexture2",
		"StanceButton4NormalTexture2",
		"StanceButton5NormalTexture2",
		"StanceButton6NormalTexture2",
		"StanceButton7NormalTexture2",
		"StanceButton8NormalTexture2",
		"SlidingActionBarTexture0",
		"SlidingActionBarTexture1",
		"MainMenuBarTexture0",
		"MainMenuBarTexture1",
		"MainMenuBarTexture2",
		"MainMenuBarTexture3",
		"MainMenuExpBar",
		"ReputationWatchBar.StatusBar",
		"MainStatusTrackingBarContainer.BarFrameTexture",
		"SecondaryStatusTrackingBarContainer.BarFrameTexture",
		"MainMenuBarMaxLevelBar",
		"BT4BarBlizzardArt",
		"BT4BarBlizzardArt.nineSliceParent",
		"BlizzardArtLeftCap",
		"BlizzardArtRightCap",
		"CompactRaidFrameManager",
		"BagsBar.BorderArt",
		"MicroMenu.BorderArt",
	},
	["Gryphons"] = {
		"MA_LeftEndCap",
		"MA_RightEndCap",
		"MainMenuBar.EndCaps",
		"MainMenuBarLeftEndCap",
		"MainMenuBarRightEndCap",
		"MainActionBar.EndCaps",
		"MainActionBar.EndCaps.LeftEndCap.Texture",
		"MainActionBar.EndCaps.RightEndCap.Texture",
	},
	["Chat"] = {
		"ChatFrame1EditBox",
		"ChatFrame2EditBox",
		"ChatFrame3EditBox",
		"ChatFrame4EditBox",
		"ChatFrame5EditBox",
		"ChatFrame6EditBox",
		"ChatFrame7EditBox",
		"ChatFrame8EditBox",
		"ChatFrame9EditBox",
		"ChatFrame10EditBox",
		"ChatFrame1Tab",
		"ChatFrame2Tab",
		"ChatFrame3Tab",
		"ChatFrame4Tab",
		"ChatFrame5Tab",
		"ChatFrame6Tab",
		"ChatFrame7Tab",
		"ChatFrame8Tab",
		"ChatFrame9Tab",
		"ChatFrame10Tab",
	},
	["Castbar"] = {
		"CastingBarFrame.Border",
		"PlayerCastingBarFrame.Background",
		"PlayerCastingBarFrame.Border",
		"PlayerCastingBarFrame.TextBorder",
	},
}

-- format: multiline
local DMCastbarRetail = {
	"TargetFrameSpellBar.Background",
	"TargetFrameSpellBar.Border",
	"TargetFrameSpellBar.TextBorder",
	"FocusFrameSpellBar.Background",
	"FocusFrameSpellBar.Border",
	"FocusFrameSpellBar.TextBorder",
	"PetCastingBarFrame.Border",
}

-- format: multiline
local DMCastbarNonRetail = {
	"TargetFrameSpellBar.Border",
	"FocusFrameSpellBar.Border",
	"TargetFrameSpellBar.BorderShield",
	"FocusFrameSpellBar.BorderShield",
	"PetCastingBarFrame.Border",
	"PetCastingBarFrame.BorderShield",
}

DMAppend(DMUi["Castbar"], isRetail and DMCastbarRetail or DMCastbarNonRetail)
function DarkMode:GetUiTable()
	return DMUi
end

-- format: multiline
local DMUiAddons = {
	["OwnAddons"] = {
		"ExpansionUtilsSettings",
		"ExpansionUtilsCharacterOverview",
		"AchievementsUtilsSettings",
		"ArmoryUtilsSettings",
		"AutoQueueSettings",
		"CenteredSettings",
		"ChatUtilsSettings",
		"CVARsSettings",
		"DRaidFramesSettings",
		"DUnitFramesSettings",
		"HealerHelperSettings",
		"HealerProtectionSettings",
		"HighLevelAlertSettings",
		"IASettings",
		"InterruptTrackSettings",
		"LossOfControlMessagesSettings",
		"MALock",
		"MAProfiles",
		"MidnightNameplatesSettings",
		"MissingPowerSettings",
		"PersonalResourceSettings",
		"SpecBisTooltipSettings",
		"TankHelperSettings",
		"ThreatMeterSettings",
		"TooltipUtilsSettings",
		"UnitFrameUtilsSettings",
	},
	["Blizzard"] = {
		"LFGListInviteDialog.Border",
		"LFDRoleCheckPopup.Border",
		"UIWidgetPowerBarContainerFrame",
		"TimerTrackerTimer1StatusBarBorder",
		"TimerTrackerTimer2StatusBarBorder",
		"FocusFrame.FocusFrameContainer.FrameTexture",
		"ArenaPrepFrame1Texture",
		"ArenaPrepFrame2Texture",
		"ArenaPrepFrame3Texture",
		"ArenaPrepFrame4Texture",
		"ArenaPrepFrame5Texture",
		"ArenaEnemyFrame1Texture",
		"ArenaEnemyFrame2Texture",
		"ArenaEnemyFrame3Texture",
		"ArenaEnemyFrame4Texture",
		"ArenaEnemyFrame5Texture",
	},
}

local DMUiAddonsTab = DMToSet(DMUiAddons)
function DarkMode:GetUiAddonsTable()
	return DMUiAddonsTab
end

-- format: multiline
local DMEquipmentSlots = {
	"AmmoSlot[1]",
	"MainHandSlot[17]",
	"MainHandSlotFrame",
	"SecondaryHandSlot[17]",
	"SecondaryHandSlotFrame",
	"RangedSlotFrame",
	"HandsSlotFrame",
	"WaistSlotFrame",
	"LegsSlotFrame",
	"FeetSlotFrame",
	"Finger0SlotFrame",
	"Finger1SlotFrame",
	"Trinket0SlotFrame",
	"Trinket1SlotFrame",
	"HeadSlotFrame",
	"NeckSlotFrame",
	"ShoulderSlotFrame",
	"BackSlotFrame",
	"ChestSlotFrame",
	"ShirtSlotFrame",
	"TabardSlotFrame",
	"WristSlotFrame",
	"FrameInsetRight"
}

-- format: multiline
local DMFrames = {
	["Character"] = {
		"CharacterFrame",
		"CharacterFrameTab1",
		"CharacterFrameTab2",
		"CharacterFrameTab3",
		"CharacterFrameTab4",
		"CharacterFrameTab5",
		"nwtab5",
		"nwtab6",
		"PaperDollFrame",
		"CharacterStatsPane",
		"CharacterModelScene",
		"PetPaperDollFrame",
		"PetPaperDollFrameTab1",
		"PetPaperDollFrameTab2",
		"PetPaperDollFrameTab3",
		"PetPaperDollFrameExpBar",
		"SkillFrame",
		"SkillListScrollFrame",
		"SkillDetailScrollFrame",
		"HonorFrame",
	},
	["Reputation"] = {
		"ReputationFrame",
		"ReputationListScrollFrame",
		"ReputationDetailFrame",
		"ReputationDetailFrame.Border",
		"ReputationFrame.ReputationDetailFrame.Border",
	},
	["Currency"] = {
		"TokenFrame",
		"TokenFrameContainerScrollBar",
		"TokenFramePopup",
		"TokenFramePopup.Border",
		"CurrencyTransferMenu",
		"CurrencyTransferMenu.TitleContainer",
		"CurrencyTransferLog",
	},
	["DressUp"] = {
		"DressUpFrame",
		"SideDressUpFrame",
		"SideDressUpModelCloseButton",
		"ModelPreviewFrame",
		"ModelPreviewFrameCloseButton_LeftSeparator",
	},
	["Spellbook"] = {
		"SpellBookFrame",
		"SpellBookSkillLineTab1",
		"SpellBookSkillLineTab2",
		"SpellBookSkillLineTab3",
		"SpellBookSkillLineTab4",
		"SpellBookSkillLineTab5",
		"SpellBookSkillLineTab6",
		"SpellBookSkillLineTab7",
		"SpellBookFrameTabButton1",
		"SpellBookFrameTabButton2",
		"SpellBookFrameTabButton3",
		"SpellBookFrameTabButton4",
		"WhatsTrainingFrame",
	},
	["Quest"] = {
		"QuestFrame",
		"QuestFrameDetailPanel",
		"QuestDetailScrollFrame",
		"QuestDetailScrollChildFrame",
		"QuestFrameGreetingPanel",
		"QuestGreetingScrollFrame",
		"QuestFrameProgressPanel",
		"QuestProgressScrollFrame",
		"QuestFrameRewardPanel",
		"QuestRewardScrollFrame",
		"QuestInfoRewardsFrame",
		"QuestNPCModelTextFrame",
		"QuestModelScene",
	},
	["QuestLog"] = {
		"QuestLogFrame",
		"QuestLogDetailFrame",
		"QuestLogDetailScrollFrame",
		"QuestLogListScrollFrame",
		"QuestLogCollapseAllButton",
		"QuestScrollFrame.ScrollBar",
		"QuestMapFrame",
		"QuestMapFrame.DetailsFrame",
		"QuestMapFrame.QuestsTab.Background",
		"QuestMapFrame.EventsTab.Background",
		"QuestMapFrame.MapLegendTab.Background",
	},
	["WorldMap"] = {
		"WorldMapFrame",
		"WorldMapFrame.BorderFrame",
		"WorldMapFrame.MiniBorderFrame",
	},
	["Gossip"] = {
		"GossipFrame",
		"GossipFrameGreetingPanel",
		"GossipGreetingScrollFrame",
		"GossipFrame.GreetingPanel",
		"GossipFrame.GreetingPanel.ScrollBox",
		"GossipFrame.GreetingPanel.ScrollBar.Background",
	},
	["Npc"] = {
		"ItemTextFrame",
		"TabardFrame",
		"StableFrame",
		"PetStableFrame",
		"ArchaeologyFrame",
	},
	["Merchant"] = {
		"MerchantFrame",
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
		"MerchantBuyBackItem",
		"MerchantMoney",
		"MerchantMoneyBg",
	},
	["Mail"] = {
		"MailFrame",
		"MailFrameTab1",
		"MailFrameTab2",
		"InboxFrame",
		"MailItem1",
		"MailItem2",
		"MailItem3",
		"MailItem4",
		"MailItem5",
		"MailItem6",
		"MailItem7",
		"OpenMailFrame",
		"OpenMailScrollFrame",
		"SendMail",
		"SendMailFrame",
		"SendMailMoney",
		"SendMailMoneyBg",
		"SendMailMoneyFrame",
		"MailEditBoxScrollBar",
	},
	["Bank"] = {
		"BankFrame",
		"BankFrameTab1",
		"BankFrameTab2",
		"BankFrameTab3",
		"BankFrameTab4",
		"BankFrameMoneyFrame",
		"BankFrameMoneyFrameBorder",
	},
	["Bags"] = {
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
	},
	["Trade"] = {
		"TradeFrame",
		"TradeFrame.RecipientOverlay",
	},
	["Loot"] = {
		"LootFrame",
		"GroupLootHistoryFrame",
		"GroupLootHistoryFrame.ResizeButton",
	},
	["Social"] = {
		"FriendsFrame",
		"FriendsFrameFriendsScrollFrame",
		"FriendsFrameTab1",
		"FriendsFrameTab2",
		"FriendsFrameTab3",
		"FriendsFrameTab4",
		"FriendsFrameTab5",
		"WhoListScrollFrame",
		"WhoFrameList",
		"GuildMemberDetailFrame",
	},
	["Chat"] = {
		"ChatConfigFrame",
		"ChatConfigCategoryFrame",
		"ChatConfigBackgroundFrame",
	},
	["GroupFinder"] = {
		"PVEFrame",
		"PVEFrameTab1",
		"PVEFrameTab2",
		"PVEFrameTab3",
		"PVEFrameTab4",
		"ChallengesFrame",
		"LFGParentFrame",
		"LFGParentFrameTab1",
		"LFGParentFrameTab2",
		"LFMFrame",
		"LFGWhoListFrame",
		"LFGBrowseFrame",
		"LFGListingFrame",
		"LFDQueueFrameFindGroupButton_LeftSeparator",
		"LFDQueueFrameFindGroupButton_RightSeparator",
		"LFGDungeonReadyDialog.Border",
		"LFGDungeonReadyStatus.Border",
		"QueueStatusFrame",
		"ReadyCheckListenerFrame",
	},
	["PvP"] = {
		"PVPFrame",
		"PVPFrameTab1",
		"PVPFrameTab2",
		"PVPFrameTab3",
		"PVPFrameTab4",
		"PVPParentFrame",
		"PVPParentFrameTab1",
		"PVPParentFrameTab2",
		"PVPReadyDialog",
		"PVPReadyDialog.Border",
		"BattlefieldFrame",
		"BattlefieldListScrollFrame",
		"BattlefieldFrameType",
		"WorldStateScoreFrame",
		"WorldStateScoreFrameTab1",
		"WorldStateScoreFrameTab2",
		"WorldStateScoreFrameTab3",
	},
	["Dialogs"] = {
		"StaticPopup1",
		"StaticPopup1.Border",
		"StaticPopup1.BG",
		"StaticPopup2.Border",
		"StaticPopup2.BG",
		"StackSplitFrame",
		"AdventureMapQuestChoiceDialog",
		"MovieFrame.CloseDialog.Border",
		"CinematicFrameCloseDialog.Border",
	},
	["Timers"] = {
		"TimerTrackerTimer1StatusBarBorder",
		"TimerTrackerTimer2StatusBarBorder",
	},
	["System"] = {
		"GameMenuFrame",
		"GameMenuFrame.Border",
		"GameMenuFrame.Header",
		"SettingsPanel",
		"VideoOptionsFrame",
		"InterfaceOptionsFrame",
		"HelpFrame",
		"TimeManagerFrame",
		"AddonList",
		"AddonListDisableAllButton_RightSeparator",
		"AddonListEnableAllButton_RightSeparator",
		"AddonListOkayButton_LeftSeparator",
		"AddonListOkayButton_RightSeparator",
		"AddonListCancelButton_LeftSeparator",
		"DMSettings",
	},
	["DragonflightUI"] = {
		"DragonflightUIProfessionFrame",
		"DragonflightUISpellBookProfessionFrame",
		"DragonflightUIWhatsTrainingFrameCompatibilitySpellBookBG",
	},
}

DMFrames["CharacterSlots"] = DMPrefixed("Character", DMEquipmentSlots)
-- format: multiline
local DMTaxiBorders = {
	"TaxiFrame.TopBorder",
	"TaxiFrame.TitleBg",
	"TaxiFrame.RightBorder",
	"TaxiFrame.LeftBorder",
	"TaxiFrame.BottomBorder",
	"TaxiFrame.TopRightCorner",
	"TaxiFrame.TopLeftCorner",
	"TaxiFrame.BotRightCorner",
	"TaxiFrame.BotLeftCorner"
}

if TaxiFrame and TaxiFrame.TopBorder then
	DMFrames["Taxi"] = DMTaxiBorders
else
	DMFrames["Taxi"] = {"TaxiFrame"}
end

local DMFramesBrighter = {}
DMFrames["BagItems"] = {}
for x = 1, 12 do
	for i = 1, 32 do
		local name = string.format("ContainerFrame%sItem%sNormalTexture", x, i)
		tinsert(DMFrames["BagItems"], name)
		DMFramesBrighter[name] = true
	end
end

function DarkMode:IsBrighterFrame(name)
	return DMFramesBrighter[name] or false
end

local DMFramesTab = DMToSet(DMFrames)
function DarkMode:GetFrameTable()
	return DMFramesTab
end

-- format: multiline
local DMFramesAddons = {
	["Spellbook"] = {
		"PlayerSpellsFrame",
		"PlayerSpellsFrame.SpellBookFrame.BookBGHalved",
		"PlayerSpellsFrame.SpellBookFrame.BookBGLeft",
		"PlayerSpellsFrame.SpellBookFrame.BookBGRight",
		"PlayerSpellsFrame.SpellBookFrame.BookCornerFlipbook",
		"ProfessionsBookFrame",
		"EngravingFrame",
		"EngravingFrame.Border",
		"EngravingFrameSideInset",
	},
	["Talents"] = {
		"PlayerTalentFrame",
		"PlayerTalentFramePointsBar",
		"PlayerTalentFrameTab1",
		"PlayerTalentFrameTab2",
		"PlayerTalentFrameTab3",
		"PlayerTalentFrameTab4",
		"PlayerTalentFrameTab5",
		"PlayerTalentFrameSpecializationLearnButton_LeftSeparator",
		"PlayerTalentFrameSpecializationLearnButton_RightSeparator",
		"ClassTalentFrame",
		"ClassTalentFrame.TabSystem",
		"ClassTalentFrame.TalentsTab.BottomBar",
		"HeroTalentsSelectionDialog",
		"GenericTraitFrame",
		"GenericTraitFrame.NineSlice",
	},
	["Inspect"] = {
		"InspectFrame",
		"InspectFrameTab1",
		"InspectFrameTab2",
		"InspectFrameTab3",
		"InspectPaperDollFrame",
		"InspectTalentFrame",
		"InspectTalentFramePointsBar",
		"InspectPVPFrame",
		"InspectHonorFrame",
	},
	["Professions"] = {
		"ProfessionsFrame",
		"ProfessionsFrame.CraftingPage",
		"ProfessionsFrame.CraftingPage.CraftingOutputLog",
		"ProfessionsFrame.TabSystem",
		"ProfessionsCustomerOrdersFrame",
		"TradeSkillFrame",
		"TradeSkillList",
		"CraftFrame",
		"ClassTrainerFrame",
		"ClassTrainerListScrollFrame",
		"ClassTrainerExpandButtonFrame",
	},
	["Items"] = {
		"ItemSocketingFrame",
		"ItemUpgradeFrame",
		"ItemInteractionFrame",
		"ItemInteractionFrame.ItemConversionFrame",
		"ScrappingMachineFrame",
		"ReforgingFrame",
		"ReforgingFrameButtonFrame",
		"ReforgingFrameRestoreButton_LeftSeparator",
		"ReforgingFrameRestoreButton_RightSeparator",
		"VoidStorageBorderFrame",
		"VoidStorageFrame.Page1",
		"VoidStorageFrame.Page2",
		"VoidStorageFrame.Page3",
	},
	["Collections"] = {
		"CollectionsJournal",
		"CollectionsJournalTab1",
		"CollectionsJournalTab2",
		"CollectionsJournalTab3",
		"CollectionsJournalTab4",
		"CollectionsJournalTab5",
		"CollectionsJournalTab6",
		"MountJournalMountButton_RightSeparator",
		"PetJournalSummonButton_RightSeparator",
		"ToyBox",
		"ToyBox.iconsFrame",
		"HeirloomsJournal",
		"HeirloomsJournal.iconsFrame",
		"WardrobeFrame",
		"WardrobeCollectionFrame",
		"WardrobeCollectionFrame.ItemsCollectionFrame",
		"TransmogFrame",
		"DressUpFrame.CustomSetDetailsPanel",
	},
	["Achievements"] = {
		"AchievementFrame",
		"AchievementFrame.Header",
		"AchievementFrameTab1",
		"AchievementFrameTab2",
		"AchievementFrameTab3",
		"AchievementFrameTab4",
		"AchievementFrameTab5",
		"AchievementFrameTab6",
		"AchievementFrameTab7",
		"AchievementFrameTab8",
		"AchievementFrameCategories",
		"AchievementFrameSummary",
	},
	["EncounterJournal"] = {
		"EncounterJournal",
		"EncounterJournalInstanceSelect",
		"EncounterJournalMonthlyActivitiesTab",
		"EncounterJournalSuggestTab",
		"EncounterJournalDungeonTab",
		"EncounterJournalRaidTab",
		"EncounterJournalLootJournalTab",
		"EncounterJournalJourneysTab",
		"EncounterJournal.TutorialsTab",
	},
	["Auction"] = {
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
		"BrowseFilterScrollFrame",
		"BrowseScrollFrame",
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
	},
	["Communities"] = {
		"CommunitiesFrame",
		"CommunitiesFrameCommunitiesList",
		"CommunitiesFrame.MemberList",
		"CommunitiesFrame.Chat.MessageFrame.ScrollBar",
		"CommunitiesFrame.ChatTab",
		"CommunitiesFrame.RosterTab",
		"CommunitiesFrame.GuildBenefitsTab",
		"CommunitiesFrame.GuildInfoTab",
		"CommunitiesFrame.GuildMemberDetailFrame.Border",
		"ChannelFrame",
		"ChannelFrameBg",
		"ChannelFrame.ChannelRoster.ScrollFrame.scrollBar",
	},
	["Social"] = {
		"GuildInfoFrame",
		"GuildInfoFrame.Border",
		"GuildInfoFrame.Header",
		"GuildControlUI",
		"RaidInfoFrame",
		"RaidInfoFrame.Border",
		"RaidInfoFrame.Header",
	},
	["GroupFinder"] = {
		"ReadyStatus.Border",
		"RolePollPopup",
		"RolePollPopup.Border",
	},
	["MythicPlus"] = {
		"ChallengesKeystoneFrame",
		"KeystoneLootFrame",
		"KeystoneLootFrame.CatalystFrame.Border",
		"WeeklyRewardsFrame",
		"WeeklyRewardsFrame.BorderContainer",
		"WeeklyRewardsFrame.SelectRewardButton.Background",
	},
	["Delves"] = {
		"DelvesCompanionConfigurationFrame.Border",
		"DelvesCompanionConfigurationFrame.CompanionCombatRoleSlot.OptionsList",
		"DelvesCompanionConfigurationFrame.CompanionCombatTrinketSlot.OptionsList",
		"DelvesCompanionConfigurationFrame.CompanionUtilityTrinketSlot.OptionsList",
		"DelvesDifficultyPickerFrame.Border",
	},
	["PvP"] = {
		"PVPConquestFrame",
		"PVPFrameRightButton_LeftSeparator",
		"PVPHonorFrameBGTex",
		"PVPHonorFrameInfoScrollFrameScrollBar",
		"PVPHonorFrameInfoScrollFrame.ScrollBar.Background",
		"PVPHonorFrame.bgTypeScrollBar",
		"PVPTeamManagementFrame",
		"HonorQueueFrameSoloQueueButton_RightSeparator",
		"HonorQueueFrameGroupQueueButton_LeftSeparator",
		"WarGamesFrame",
		"WarGamesFrameBGTex",
		"WarGamesFrameInfoScrollFrameScrollBar",
		"WarGamesFrameInfoScrollFrame.ScrollBar.Background",
		"WarGamesFrame.scrollBar",
		"WarGameStartButton_RightSeparator",
		"PVPMatchResults",
		"PVPMatchResults.content",
		"PVPMatchScoreboard",
		"PVPMatchScoreboard.Content",
		"PVPMatchScoreboard.Content.TabContainer.InsetBorderTop",
		"PVPScoreFrameTab1",
		"PVPScoreFrameTab2",
		"PVPScoreFrameTab3",
		"PVPScoreboardTab1",
		"PVPScoreboardTab2",
		"PVPScoreboardTab3",
	},
	["Housing"] = {
		"HousingDashboardFrame",
		"HousingBulletinBoardFrame",
		"HousingHouseSettingsFrame",
		"HousingModelPreviewFrame",
		"HousingInviteResidentFrame.Border",
		"HousingCornerstoneHouseInfoFrame",
		"HousingCornerstonePurchaseFrame",
		"HousingCornerstoneVisitorFrame",
		"HouseFinderFrame",
		"HouseEditorFrame.StoragePanel",
	},
	["Macros"] = {
		"MacroFrame",
		"MacroFrameTab1",
		"MacroFrameTab2",
		"MacroFrameTextBackground",
		"MacroButtonScrollFrame",
		"MacroFrame.MacroSelector.ScrollBar.Background",
		"MacroPopupFrame.BorderBox",
	},
	["Settings"] = {
		"KeyBindingFrame",
		"KeyBindingFrame.header",
		"ClickBindingFrame",
		"EditModeManagerFrame.Border",
		"CooldownViewerSettings",
	},
	["Dialogs"] = {
		"StaticPopup2",
	},
	["LegacySystem"] = {
		"LegacySystemFrame",
	},
	["Misc"] = {
		"CalendarFrame",
		"PlayerChoiceFrame",
		"UIWidgetPowerBarContainerFrame",
		"FlightMapFrame.BorderFrame",
		"CovenantMissionFrame",
		"RemixArtifactFrame.BorderContainer",
		"GhostFrame",
		"DeathRecapFrame",
	},
	["LfgUtils"] = {
		"LfgUtilsForeverFilter",
	},
	["TrainerSpells"] = {
		"TrainerSpellsFrame",
		"TrainerSpellsFrameBackground",
		"TrainerSpellsProfessionBackground",
		"TrainerSpellsSpellbookTabBorder",
		"TrainerSpellsTradeSkillNativeTabBorder",
		"TrainerSpellsTradeSkillProfessionTabBorder",
		"TrainerSpellsTradeSkillRecipeTabBorder",
	},
	["Outfitter"] = {
		"OutfitterFrame",
		"OutfitterFrameTab1",
		"OutfitterFrameTab2",
		"OutfitterFrameTab3",
		"OutfitterMainFrameScrollbarTrench",
	},
	["ArenaAnalytics"] = {
		"ArenaAnalyticsMinimapButton.Border.texture",
		"ArenaAnalyticsImportFrame",
		"ArenaAnalyticsScrollFrame",
	},
	["DragonflightUI"] = {
		"DragonflightUIMinimapBorder",
		"DragonflightUIPlayerFrameBorder",
		"DragonflightUIPlayerFrameBackground",
	},
	["TrinketMenu"] = {
		"TrinketMenu_MainFrame",
		"TrinketMenu_MenuFrame",
		"TrinketMenu_Trinket0.NormalTexture",
		"TrinketMenu_Trinket1.NormalTexture",
	},
	["ItemRack"] = {
		"ItemRackMenuFrame",
		"ItemRackOptFrame",
	},
	["OtherAddons"] = {
		"ACP_AddonList",
		"ACP_AddonList_ScrollFrame",
		"AddonUsage",
		"BagnonInventory1.skin",
		"BagnonInventory2.skin",
		"BuyEmAllFrame",
		"ECS_StatsFrame",
		"FlightTimerClassic",
		"RankerMainFrame",
		"WeakAurasOptions",
		"WeaponSwingTimerHunterBackdropFrame",
		"WeaponSwingTimerPlayerBackdropFrame",
		"WeaponSwingTimerTargetBackdropFrame",
	},
}

DMFramesAddons["InspectSlots"] = DMPrefixed("Inspect", DMEquipmentSlots)
DMFramesAddons["MinimapButtonButton"] = DMPrefixed("MinimapButtonButtonButton.", DMNineSliceParts)
for i = 0, 19 do
	tinsert(DMFramesAddons["ItemRack"], "ItemRackOptInv" .. i .. "NormalTexture")
	tinsert(DMFramesAddons["ItemRack"], "ItemRackMenu" .. i .. "NormalTexture")
	tinsert(DMFramesAddons["ItemRack"], "ItemRackButton" .. i .. "NormalTexture")
end

local DMFramesAddonsTab = DMToSet(DMFramesAddons)
function DarkMode:GetFrameAddonsTable()
	return DMFramesAddonsTab
end

-- format: multiline
local DMFrameTexts = {
	["Quest"] = {
		"QuestGreetingScrollChildFrame",
		"QuestProgressScrollChildFrame",
		"QuestRewardScrollChildFrame",
		"QuestLogDetailScrollChildFrame",
		"QuestTitleButton1",
		"QuestTitleButton2",
		"QuestTitleButton3",
		"QuestTitleButton4",
		"QuestTitleButton5",
		"QuestTitleButton6",
		"QuestTitleButton7",
		"QuestTitleButton8",
		"QuestTitleButton9",
		"QuestTitleButton10",
		"QuestTitleButton11",
		"QuestTitleButton12",
		"QuestTitleButton13",
		"QuestTitleButton14",
		"QuestTitleButton15",
	},
	["Gossip"] = {
		"GossipGreetingScrollChildFrame",
		"GossipGreetingText",
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
	},
	["PvP"] = {
		"WarGamesFrameDescription",
		"PVPHonorFrameInfoScrollFrameChildFrameDescription",
		"BattlefieldFrameZoneDescription",
	},
	["Professions"] = {
		"CraftTradeSkillFrame",
	},
	["Spellbook"] = {
	},
}

for i = 1, 12 do
	tinsert(DMFrameTexts["Spellbook"], "SpellButton" .. i .. "SpellName")
	tinsert(DMFrameTexts["Spellbook"], "SpellButton" .. i .. "SubSpellName")
	tinsert(DMFrameTexts["Spellbook"], "SpellButton" .. i .. "RequiredLevelString")
end

local DMFrameTextsTab = DMToSet(DMFrameTexts)
function DarkMode:GetFrameTextTable()
	return DMFrameTextsTab
end

-- format: multiline
local DMMapFrameTexts = {
	["QuestInfo"] = {
		"QuestInfoTitleHeader",
		"QuestInfoQuestType",
		"QuestInfoDescriptionHeader",
		"QuestInfoDescriptionText",
		"QuestInfoObjectivesHeader",
		"QuestInfoObjectivesText",
		"QuestInfoObjective1",
		"QuestInfoObjective2",
		"QuestInfoObjective3",
		"QuestInfoObjective4",
		"QuestInfoObjective5",
		"QuestInfoObjective6",
		"QuestInfoObjective7",
		"QuestInfoObjective8",
		"QuestInfoObjective9",
		"QuestInfoObjective10",
		"QuestInfoObjective11",
		"QuestInfoObjective12",
		"QuestInfoObjective13",
		"QuestInfoObjective14",
		"QuestInfoRewardText",
		"QuestInfoRewardsFrame",
	},
}

local DMMapFrameTextsTab = DMToSet(DMMapFrameTexts)
function DarkMode:GetMapFrameTextTable()
	return DMMapFrameTextsTab
end

-- format: multiline
local DMGroupLootFrames = {
	"GroupLootContainer",
	"GroupLootFrame1",
	"GroupLootFrame2",
	"GroupLootFrame3",
	"GroupLootFrame4",
	"GroupLootFrame5",
	"GroupLootFrame1Corner",
	"GroupLootFrame2Corner",
	"GroupLootFrame3Corner",
	"GroupLootFrame4Corner",
	"GroupLootFrame5Corner",
}

function DarkMode:GetGroupLootTable()
	return DMGroupLootFrames
end

-- ids: https://www.townlong-yak.com/framexml/live/Helix/ArtTextureID.lua
-- format: multiline
local DMTextureBlockGroups = {
	["Paths"] = {
		"Interface\\QuestFrame\\UI-QuestLog-BookIcon",
		"Interface\\Spellbook\\Spellbook-Icon",
		"Interface\\SpellBook\\SpellBook-SkillLineTab-Glow",
		"Interface\\FriendsFrame\\FriendsFrameScrollIcon",
		"Interface\\MacroFrame\\MacroFrame-Icon",
		"Interface\\MailFrame\\Mail-Icon",
		"Interface\\TimeManager\\GlobeIcon",
		"Interface\\ContainerFrame\\UI-Bag-1Slot",
		"Interface\\TargetingFrame\\UI-StatusBar",
		"Interface\\Buttons\\UI-CheckBox-Check",
		"Interface\\Buttons\\UI-MinusButton-UP",
		"Interface\\Buttons\\UI-PlusButton-Hilight",
		"Interface\\Buttons\\UI-Panel-Button-Up",
		"Interface\\Buttons\\UI-Panel-Button-Highlight",
		"Interface\\Buttons\\ButtonHilight-Square",
		"Interface\\Buttons\\CheckButtonHilight",
	},
	["Portraits"] = {
		"RTPortrait1",
		"Portrait2", -- CollectionsJournal
	},
	["Icons"] = {
		130724, -- Spellbook Tab Highlight Icon
		136797, -- QuestLogFrame Icon
		131116, -- FriendsFrame Icon
		136382, -- MailFrame Icon
		130709, -- "Interface/BattlefieldFrame/UI-Battlefield-Icon",
		136830, -- Spellbook Icon
	},
	["StatusBar"] = {
		137012, -- "Interface/TargetingFrame/UI-StatusBar"
	},
	["Button"] = {
		130717, -- "Interface/Buttons/ButtonHilight-Round"
		130718, -- "Interface/Buttons/ButtonHilight-Square"
		130719, -- "Interface/Buttons/ButtonHilight-SquareQuickslot"
	},
	["ChatTabs"] = {
		374168,
		374170,
		374172,
		374174,
		374176,
		374178
	},
	["Other"] = {
		130832,
		413584,
		442272,
		526421,
		1500877,
		2056011
	},
}

if isRetail then
	DMTextureBlockGroups["RetailIcons"] = {
		136377, -- MacroFrame Portrai
	}
end

local DMTextureBlock = DMToSet(DMTextureBlockGroups, true)
function DarkMode:GetTextureBlockTable()
	return DMTextureBlock
end

local DMIgnoreFrameGroups = {
	["All"] = {"HonorFramePvPIcon"},
}

-- format: multiline
local DMIgnoreFramesNonRetail = {
	"FriendsFrameIcon",
	"FriendsFramePortrait",
	"FriendsFramePortraitFrame",
	"FriendsTabHeader",
	"FriendsListFrame",
	"CollectionsJournalPortrait",
	"CollectionsJournalPortraitFrame"
}

if not isRetail then DMIgnoreFrameGroups["NonRetail"] = DMIgnoreFramesNonRetail end
local DMIgnoreFrames = DMToSet(DMIgnoreFrameGroups, true)
function DarkMode:GetIgnoreFrames(name)
	return DMIgnoreFrames[name] or DMTextureBlock[name] or false
end

local DMIgnoreTextureNames = DMToSet({
	["All"] = {"ContainerFrame1Portrait", "HonorFramePvPIcon"},
}, true)

function DarkMode:GetIgnoreTextureName(name)
	return DMIgnoreTextureNames[name] or false
end
