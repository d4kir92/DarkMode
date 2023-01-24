
local AddOnName, DarkMode = ...



-- TAINTFREE SLASH COMMANDS --
local lastMessage = ""
local cmds = {}

hooksecurefunc( "ChatEdit_ParseText", function( editBox, send, parseIfNoSpace )
	if send == 0 then
		lastMessage = editBox:GetText()
	end
end )

hooksecurefunc( "ChatFrame_DisplayHelpTextSimple", function( frame )
	if lastMessage and lastMessage ~= "" then
		local cmd = string.upper(lastMessage)
		cmd = strsplit( " ", cmd )
		if cmds[cmd] ~= nil then
			local count = 1
			local numMessages = frame:GetNumMessages()
			local function predicateFunction( entry )
				if count == numMessages then
					if entry == HELP_TEXT_SIMPLE then
						return true
					end
				end
				count = count + 1
			end
			frame:RemoveMessagesByPredicate( predicateFunction )
			cmds[cmd]()
		end
	end
end )

function DarkMode:InitSlash()
	cmds["/DM"] = DarkMode.ToggleSettings
	cmds["/DARK"] = DarkMode.ToggleSettings
	cmds["/DARKMODE"] = DarkMode.ToggleSettings
	cmds["/RL"] = C_UI.Reload
	cmds["/REL"] = C_UI.Reload
end
-- TAINTFREE SLASH COMMANDS --

DMHIDDEN = CreateFrame( "FRAME", "DMHIDDEN" )
DMHIDDEN:Hide()

local checkFrames = {
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

local DMUiAddons = {
	"FocusFrame.FocusFrameContainer.FrameTexture",
}

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
	"GameMenuFrame.Header",

	-- NPC
	"QuestFrameDetailPanel",
	"QuestDetailScrollFrame",
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

local DMTexts = {
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

local DMT = {}
DMT["Interface\\QuestFrame\\UI-QuestLog-BookIcon"] = true
DMT["Interface\\Spellbook\\Spellbook-Icon"] = true
DMT["Interface\\FriendsFrame\\FriendsFrameScrollIcon"] = true
DMT["Interface\\MacroFrame\\MacroFrame-Icon"] = true
DMT["Interface\\Buttons\\UI-CheckBox-Check"] = true
DMT["Interface\\Buttons\\UI-MinusButton-UP"] = true
DMT["Interface\\Buttons\\UI-PlusButton-Hilight"] = true
DMT["Interface\\Buttons\\UI-Panel-Button-Up"] = true
DMT["Interface\\Buttons\\UI-Panel-Button-Highlight"] = true
DMT["Interface\\TimeManager\\GlobeIcon"] = true
DMT[137012] = true
DMT["RTPortrait1"] = true
DMT["Interface\\TargetingFrame\\UI-StatusBar"] = true
DMT["Interface\\MailFrame\\Mail-Icon"] = true
DMT["Interface\\ContainerFrame\\UI-Bag-1Slot"] = true
DMT[136830] = true
DMT[130724] = true
DMT[130718] = true
DMT[135770] = true
DMT[135775] = true
DMT[136797] = true
DMT[131116] = true
DMT[130709] = true
DMT[136382] = true
DMT[136382] = true
DMT[1723833] = true

function DarkMode:GetGlobalColor()
	local colorMode = DMColorModes[DarkMode:GV( "COLORMODE", 1 )]
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
	elseif colorMode == "Custom" then
		return 1, 1, 1, 0.1
	end
	return 1.000, 0.000, 0.000, 0.3
end

local DMTextures = {}
function DarkMode:UpdateColor( texture, show, name )
	if texture == nil then
		print("INVALID TEXTURE OBJECT")
		return false
	end
	local textureId = nil
	if texture.GetTexture ~= nil then
		textureId = texture:GetTexture()
	end

	if textureId and DMT[textureId] then
		return false
	end

	if textureId == nil and texture.SetColorTexture and strfind( name or "", "ContainerFrame", 1, true ) ~= nil then
		texture:SetColorTexture( DarkMode:GetGlobalColor() )
		return true
	elseif textureId and texture.SetVertexColor then
		if texture.SetText then
			return false
		end

		if texture.dm_setup == nil then
			texture.dm_setup = true
			hooksecurefunc( texture, "SetVertexColor", function( self, r, g, b, a )
				if self.dm_setvertexcolor then return end
				self.dm_setvertexcolor = true
				self:SetVertexColor( DarkMode:GetGlobalColor() )
				self.dm_setvertexcolor = false
			end )
		end
		texture:SetVertexColor( DarkMode:GetGlobalColor() )

		if not tContains( DMTextures, texture ) then
			tinsert( DMTextures, texture )
		end
		return true
	end
	return false
end

function DarkMode:UpdateColors()
	for i, v in pairs( DMTextures ) do
		v:SetVertexColor( DarkMode:GetGlobalColor() )
	end
end

function DarkMode:GetFrame( name )
	local frame = _G[name]
	if frame ~= nil and type( frame ) == "table" then
		return frame
	elseif strfind( name, ".", 1, true ) then
		for i, v in pairs( { strsplit( ".", name ) } ) do
			if i == 1 then
				if type( _G[v] ) == "table" then
					frame = _G[v]
				elseif i > 1 then
					return nil
				end
			elseif frame then
				if type( frame[v] ) == "table" then
					frame = frame[v]
				elseif i > 1 then
					return nil
				end
			else
				return nil
			end
		end
		if type( frame ) == "table" then
			return frame
		end
	end
	return nil
end

function DarkMode:FindTextures( frame, show, name )
	if frame ~= nil then
		if frame.SetVertexColor then
			DarkMode:UpdateColor( frame, show, name )
		else
			if frame.GetRegions and getn( { frame:GetRegions() } ) > 0 then
				for i, v in pairs( { frame:GetRegions() } ) do
					if v.SetVertexColor then
						DarkMode:UpdateColor( v, show, name )
					end
				end
			end
			if frame.GetChildren and getn( { frame:GetChildren() } ) > 0 then
				for i, v in pairs( { frame:GetChildren() } ) do
					if v.SetVertexColor then
						DarkMode:UpdateColor( v, show, name )
					end
				end
			end
		end
	end
end

function DarkMode:FindTexturesByName( name, show )
	local frame = DarkMode:GetFrame( name, show )

	local show = false
	if name and strfind( name, "Container", 1, true ) and strfind( name, "TopSection", 1, true ) then
		show = true
	end

	if frame then
		DarkMode:FindTextures( frame, show, name )
	end
end

local DMFS = {}
function DarkMode:UpdateText( text, name, layer )
	if text and text.SetTextColor then
		if text.dm_setup == nil then
			text.dm_setup = true
			hooksecurefunc( text, "SetTextColor", function( self, r, g, b, a )
				if self.dm_settextcolor then return end
				self.dm_settextcolor = true
				self:SetTextColor( 1, 1, 1, 1 )
				self.dm_settextcolor = false
			end )
		end
		text:SetTextColor( 1, 1, 1, 1 )

		if not tContains( DMFS, text ) then
			tinsert( DMFS, text )
		end
		return true
	end
	return false
end

function DarkMode:FindTexts( frame )
	if frame ~= nil then
		if frame.SetTextColor then
			DarkMode:UpdateText( frame, name, 1 )
		else
			if frame.GetRegions and getn( { frame:GetRegions() } ) > 0 then
				for i, v in pairs( { frame:GetRegions() } ) do
					if v.SetTextColor then
						DarkMode:UpdateText( v, name, 2 )
					end
					if type( v ) == "table" then
						DarkMode:FindTexts( v )
					end
				end
			end
			if frame.GetChildren and getn( { frame:GetChildren() } ) > 0 then
				for i, v in pairs( { frame:GetChildren() } ) do
					if v.SetTextColor then
						DarkMode:UpdateText( v, name, 3 )
					end
					if type( v ) == "table" then
						DarkMode:FindTexts( v )
					end
				end
			end
		end
	end
end

function DarkMode:FindTextsByName( name )
	local frame = DarkMode:GetFrame( name )
	if frame then
		DarkMode:FindTexts( frame )
	end
end

function DarkMode:InitGreetingPanel()
	local frame = DarkMode:GetFrame( "GossipFrame.GreetingPanel.ScrollBox.ScrollTarget" )
	local frameTab = {
		"GossipFrame",
		"GossipFrame.GreetingPanel",
		"GossipFrame.GreetingPanel.ScrollBox",
		"GossipFrame.GreetingPanel.ScrollBar.Background",
	}
	if frame then
		frame:HookScript( "OnShow", function(self, ... )
			C_Timer.After( 0.01, function()
				DarkMode:FindTextsByName( "GossipFrame.GreetingPanel.ScrollBox.ScrollTarget" )

				for index, name in pairs( frameTab ) do
					for i, v in pairs( checkFrames ) do
						DarkMode:FindTexturesByName( name .. v )
					end
				end
			end )
		end )
	end
end

function DarkMode:Event( event, ... )
	if event == "PLAYER_LOGIN" then
		if DarkMode.Setup == nil then
			DarkMode.Setup = true
					
			DarkMode:InitSlash()
			DarkMode:InitDB()

			DarkMode:InitDMSettings()

			DarkMode:InitGreetingPanel()

			C_Timer.After( 0.1, function()
				for index, tab in pairs( DMUi ) do
					if index == "ActionButtons" then
						for i, name in pairs( tab ) do
							for x = 1, 12 do
								local btnTexture = _G[name .. x .. "NormalTexture"]
								if btnTexture then
									DarkMode:UpdateColor( btnTexture )
								end
							end
						end
					elseif index == "Minimap" then
						for i, name in pairs( tab ) do
							DarkMode:FindTexturesByName( name )
						end
					elseif type( tab ) == "string" then
						DarkMode:FindTexturesByName( tab )
					else
						print( "Missing", index, tab )
					end
				end

				for index, name in pairs( DMFrames ) do
					for i, v in pairs( checkFrames ) do
						DarkMode:FindTexturesByName( name .. v )
					end
				end
				for index, name in pairs( DMTexts ) do
					DarkMode:FindTextsByName( name )
				end
			end )

			function DarkMode:UpdateMinimapButton()
				if DMMMBTN then
					if DarkMode:IsEnabled( "SHOWMINIMAPBUTTON", true ) then
						DMMMBTN:Show("DarkModeMinimapIcon")
					else
						DMMMBTN:Hide("DarkModeMinimapIcon")
					end
				end
			end

			function DarkMode:ToggleMinimapButton()
				DarkMode:SetEnabled( "SHOWMINIMAPBUTTON", not DarkMode:IsEnabled( "SHOWMINIMAPBUTTON", true ) )
				if DMMMBTN then
					if DarkMode:IsEnabled( "SHOWMINIMAPBUTTON", true ) then
						DMMMBTN:Show("DarkModeMinimapIcon")
					else
						DMMMBTN:Hide("DarkModeMinimapIcon")
					end
				end
			end
			
			function DarkMode:HideMinimapButton()
				DarkMode:SetEnabled( "SHOWMINIMAPBUTTON", false )
				if DMMMBTN then
					DMMMBTN:Hide("DarkModeMinimapIcon")
				end
			end
			
			function DarkMode:ShowMinimapButton()
				DarkMode:SetEnabled( "SHOWMINIMAPBUTTON", true )
				if DMMMBTN then
					DMMMBTN:Show("DarkModeMinimapIcon")
				end
			end

			local DarkModeMinimapIcon = LibStub("LibDataBroker-1.1"):NewDataObject("DarkModeMinimapIcon", {
				type = "data source",
				text = "DarkModeMinimapIcon",
				icon = 136122,
				OnClick = function(self, btn)
					if btn == "LeftButton" then
						DarkMode:ToggleSettings()
					elseif btn == "RightButton" then
						DarkMode:HideMinimapButton()
					end
				end,
				OnTooltipShow = function(tooltip)
					if not tooltip or not tooltip.AddLine then return end
					tooltip:AddLine( "DarkMode")
					tooltip:AddLine( DarkMode:GT( "MMBTNLEFT" ) )
					tooltip:AddLine( DarkMode:GT( "MMBTNRIGHT" ) )
				end,
			})
			if DarkModeMinimapIcon then
				DMMMBTN = LibStub("LibDBIcon-1.0", true)
				if DMMMBTN then
					DMMMBTN:Register( "DarkModeMinimapIcon", DarkModeMinimapIcon, DarkMode:GetMinimapTable() )
				end
			end

			if DMMMBTN then
				if DarkMode:IsEnabled( "SHOWMINIMAPBUTTON", true ) then
					DMMMBTN:Show("DarkModeMinimapIcon")
				else
					DMMMBTN:Hide("DarkModeMinimapIcon")
				end
			end
		end
	elseif event == "ADDON_LOADED" then
		for index, name in pairs( DMFramesAddons ) do
			for i, v in pairs( checkFrames ) do
				DarkMode:FindTexturesByName( name .. v )
			end
		end

		if ClassTalentFrame then
			if ClassTalentFrame.dm_setup == nil then
				ClassTalentFrame.dm_setup = true
				
				function ClassTalentFrame:UpdateColors()
					local tabs = { ClassTalentFrame.TabSystem:GetChildren() }
					for i, v in pairs( tabs ) do
						for x, w in pairs( { v:GetRegions() } ) do 
							DarkMode:UpdateColor( w )
						end
					end
				end
				

				ClassTalentFrame:HookScript( "OnShow", function( self )
					ClassTalentFrame:UpdateColors()
				end )
				ClassTalentFrame:UpdateColors()
			end
		end
	end
end

local f = CreateFrame("Frame")
f:SetScript( "OnEvent", DarkMode.Event )
f:RegisterEvent( "PLAYER_LOGIN" )
f:RegisterEvent( "ADDON_LOADED" )
f.incombat = false 
