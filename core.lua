
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

local DMUi = {
	-- Collections
	-- Classic ERA
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
	},
	["Minimap"] = {
		"MinimapBorder",
		"MinimapBorderTop",
		"TimeManagerClockButton",
	},

	-- Textures
	-- Classic ERA
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
}

local DMUiAddons = {
	"FocusFrame.FocusFrameContainer.FrameTexture",
}

local DMFrames = {
	-- Classic ERA
	-- 1
	"PaperDollFrame",
	"CharacterFrameTab1",
	"CharacterFrameTab2",
	"CharacterFrameTab3",
	"CharacterFrameTab4",
	"CharacterFrameTab5",
	"ReputationFrame",
	"SkillFrame",
	"SkillListScrollFrame",
	"SkillDetailScrollFrame",
	"HonorFrame",
	"PetPaperDollFrame",
	"PetPaperDollFrameExpBar",

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

	-- 3 requires addon loaded

	-- 4
	"QuestLogFrame",
	"QuestLogCollapseAllButton",
	--"QuestLogExpandButtonFrame", -- false

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

	-- 8
	"GameMenuFrame",

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

	--"GossipFrame.GreetingPanel",
	--"GossipFrame.GreetingPanel.ScrollBar.Background",

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
	"AddonListScrollFrame",
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
	"InboxFrame",
	"SendMailFrame",
	"SendMailMoney",
	"SendMailMoneyBg",
	"SendMailMoneyFrame",
	"MailEditBoxScrollBar",

	"BankFrame",

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
	"TradeSkillListScrollFrame",

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

	"GossipFrame.GreetingPanel.ScrollBox.ScrollTarget",

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
function DarkMode:UpdateColor( texture )
	if texture and texture.SetVertexColor and texture.GetTexture then
		if texture:GetTexture() == nil then 
			return false
		end
		if DMT[texture:GetTexture()] then
			return false
		end
		if texture:GetParent():GetName() == "XX" then --ClassTrainerFrame
			print("> TextureName:", texture:GetTexture())
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
		tinsert( DMTextures, texture )
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
	if frame ~= nil then
		return frame
	elseif strfind( name, ".", 1, true ) then
		for i, v in pairs( { strsplit( ".", name ) } ) do
			if i == 1 then
				frame = _G[v]
			elseif frame then
				frame = frame[v]
			else
				return nil
			end
		end
		return frame
	end
	return nil
end

function DarkMode:FindTextures( name )
	local frame = DarkMode:GetFrame( name )
	if frame ~= nil then
		if frame.SetVertexColor then
			DarkMode:UpdateColor( frame )
		else
			if frame.GetRegions then
				for i, v in pairs( { frame:GetRegions() } ) do
					if v.SetVertexColor and v.GetTexture then
						DarkMode:UpdateColor( v )
					end
				end
			end
		end
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
		tinsert( DMFS, text )
		return true
	end
	return false
end


function DarkMode:FindTexts( name )
	local frame = DarkMode:GetFrame( name )
	if frame ~= nil then
		if frame.SetTextColor then
			DarkMode:UpdateText( frame, name, 1 )
		else
			if frame.GetRegions and getn( { frame:GetRegions() } ) > 0 then
				for i, v in pairs( { frame:GetRegions() } ) do
					if v.SetTextColor then
						DarkMode:UpdateText( v, name, 2 )
					end
				end
			end
			if frame.GetChildren and getn( { frame:GetChildren() } ) > 0 then
				for i, v in pairs( { frame:GetChildren() } ) do
					if v.SetTextColor then
						DarkMode:UpdateText( v, name, 3 )
					end
				end
			end
		end
	end
end

function DarkMode:Event( event, ... )
	if event == "PLAYER_LOGIN" then
		if DarkMode.Setup == nil then
			DarkMode.Setup = true
					
			DarkMode:InitSlash()
			DarkMode:InitDB()

			DarkMode:InitDMSettings()
			
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
							DarkMode:FindTextures( name )
						end
					elseif type( tab ) == "string" then
						DarkMode:FindTextures( tab )
					else
						print( "Missing", index, tab )
					end
				end

				for index, name in pairs( DMFrames ) do
					DarkMode:FindTextures( name )
					DarkMode:FindTextures( name .. "Inset" )
					DarkMode:FindTextures( name .. ".NineSlice" )
				end
				for index, name in pairs( DMTexts ) do
					DarkMode:FindTexts( name )
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
			DarkMode:FindTextures( name )
			DarkMode:FindTextures( name .. "Inset" )
			DarkMode:FindTextures( name .. ".NineSlice" )
		end
	end
end

local f = CreateFrame("Frame")
f:SetScript( "OnEvent", DarkMode.Event )
f:RegisterEvent( "PLAYER_LOGIN" )
f:RegisterEvent( "ADDON_LOADED" )
f.incombat = false 
