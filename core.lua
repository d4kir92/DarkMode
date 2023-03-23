
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

local DMTexturesUi = {}
local DMTexturesUF = {}
local DMTexturesFrames = {}
function DarkMode:UpdateColor( texture, typ )
	if texture == nil then
		print("INVALID TEXTURE OBJECT")
		return false
	end
	local textureId = nil
	if texture.GetTexture ~= nil then
		textureId = texture:GetTexture()
	end

	if textureId and DarkMode:GetTextureBlockTable()[textureId] then
		return false
	end

	if textureId == nil and texture.SetColorTexture and strfind( name or "", "ContainerFrame", 1, true ) ~= nil then
		if typ == "ui" then
			texture:SetColorTexture( DarkMode:GetUiColor() )
		elseif typ == "uf" then
			texture:SetColorTexture( DarkMode:GetUFColor() )
		else
			texture:SetColorTexture( DarkMode:GetFrameColor() )
		end
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
				if typ == "ui" then
					self:SetVertexColor( DarkMode:GetUiColor() )
				elseif typ == "uf" then
					self:SetVertexColor( DarkMode:GetUFColor() )
				else
					self:SetVertexColor( DarkMode:GetFrameColor() )
				end
				self.dm_setvertexcolor = false
			end )
		end
		if typ == "ui" then
			texture:SetVertexColor( DarkMode:GetUiColor() )
		elseif typ == "uf" then
			texture:SetVertexColor( DarkMode:GetUFColor() )
		else
			texture:SetVertexColor( DarkMode:GetFrameColor() )
		end
		if typ == "ui" then
			if not tContains( DMTexturesUi, texture ) then
				tinsert( DMTexturesUi, texture )
			end
		elseif typ == "uf" then
			if not tContains( DMTexturesUF, texture ) then
				tinsert( DMTexturesUF, texture )
			end
		else
			if not tContains( DMTexturesFrames, texture ) then
				tinsert( DMTexturesFrames, texture )
			end
		end
		return true
	end
	return false
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

local function RGBToHexC( r, g, b )
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return "|cFF" .. string.format( "%02x%02x%02x", r * 255, g * 255, b * 255 )
end

local function RemoveColorCodes( text )
    return text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
end

local DMFS = {}
function DarkMode:UpdateText( text, name, layer )
	if text and text.SetTextColor then
		if text.dm_setup == nil then
			text.dm_setup = true
			hooksecurefunc( text, "SetTextColor", function( self, r, g, b, a )
				if self.dm_settextcolor then return end
				self.dm_settextcolor = true
				local r, g, b, a = DarkMode:GetTextColor( DarkMode:GetFrameColor() )
				self:SetTextColor( r, g, b, a )
				if self:GetText() then
					self:SetText( RGBToHexC( r, g, b ) .. RemoveColorCodes(self:GetText()) )
				end
				self.dm_settextcolor = false
			end )
		end
		text:SetTextColor( DarkMode:GetTextColor( DarkMode:GetFrameColor() ) )

		if not tContains( DMFS, text ) then
			tinsert( DMFS, text )
		end
		return true
	end
	return false
end

function DarkMode:FindTexts( frame, name )
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
						DarkMode:FindTexts( v, name )
					end
				end
			end
			if frame.GetChildren and getn( { frame:GetChildren() } ) > 0 then
				for i, v in pairs( { frame:GetChildren() } ) do
					if v.SetTextColor then
						DarkMode:UpdateText( v, name, 3 )
					end
					if type( v ) == "table" then
						DarkMode:FindTexts( v, name )
					end
				end
			end
		end
	end
end

function DarkMode:FindTextsByName( name )
	local frame = DarkMode:GetFrame( name )
	if frame then
		DarkMode:FindTexts( frame, name )
	end
end

function DarkMode:UpdateColors()
	for i, v in pairs( DMTexturesUi ) do
		v:SetVertexColor( DarkMode:GetUiColor() )
	end
	for i, v in pairs( DMTexturesUF ) do
		v:SetVertexColor( DarkMode:GetUFColor() )
	end
	for i, v in pairs( DMFS ) do
		v:SetTextColor( DarkMode:GetFrameColor() )
	end
	for i, v in pairs( DMTexturesFrames ) do
		v:SetVertexColor( DarkMode:GetFrameColor() )
	end
end

function DarkMode:FindTextures( frame, typ )
	if frame ~= nil then
		local show = false
		if frame.GetName and frame:GetName() and strfind( frame:GetName(), "XX", 1, true ) then
			show = true
		end
		if frame.SetVertexColor then
			if show and frame.GetTexture then
				print(">", frame:GetTextureFilePath(), frame:GetSize())
			end
			DarkMode:UpdateColor( frame, typ )
		end
		if frame.GetRegions and getn( { frame:GetRegions() } ) > 0 then
			for i, v in pairs( { frame:GetRegions() } ) do
				if v.SetVertexColor then
					if show and v.GetTexture then
						print(">>", v:GetTextureFilePath(), v:GetSize())
					end
					DarkMode:UpdateColor( v, typ )
				end
			end
		end
		if frame.GetChildren and getn( { frame:GetChildren() } ) > 0 then
			for i, v in pairs( { frame:GetChildren() } ) do
				if v.SetVertexColor then
					if show and v.GetTexture then
						print(">>>", v:GetTextureFilePath(), v:GetSize())
					end
					DarkMode:UpdateColor( v, typ )
				end
			end
		end
	end
end

function DarkMode:FindTexturesByName( name, typ )
	local frame = DarkMode:GetFrame( name )

	local show = false
	if name and strfind( name, "Container", 1, true ) and strfind( name, "TopSection", 1, true ) then
		show = true
	end

	if frame then
		DarkMode:FindTextures( frame, typ )
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

	function DarkMode:UpdateGossipFrame()
		if frame == GossipFrame then
			DarkMode:FindTextsByName( "GossipFrame" )
		else
			DarkMode:FindTextsByName( "GossipFrame.GreetingPanel.ScrollBox.ScrollTarget" )
		end
		
		for index, name in pairs( frameTab ) do
			for i, v in pairs( DarkMode:GetDMRepeatingFrames() ) do
				DarkMode:FindTexturesByName( name .. v, "frames" )
			end
		end
	end

	if frame == nil then
		frame = DarkMode:GetFrame( "GossipFrame" )
	end
	if frame then
		if GossipFrame.GreetingPanel then
			hooksecurefunc( GossipFrame.GreetingPanel.ScrollBox, "FullUpdate" ,function()
				DarkMode:UpdateGossipFrame()
			end )
		end

		frame:HookScript( "OnShow", function(self, ... )
			C_Timer.After( 0.05, function()
				DarkMode:UpdateGossipFrame()
			end )
		end )
		
		if GossipFrame.OnEvent then
			hooksecurefunc( GossipFrame, "OnEvent", function()
				C_Timer.After( 0.05, function()
					DarkMode:UpdateGossipFrame()
				end )
			end )
		end
	end
end

function DarkMode:InitQuestLogFrame()
	local frame = DarkMode:GetFrame( "QuestLogFrame" )

	function DarkMode:UpdateQuestLogFrame()
		for index, name in pairs( DarkMode:GetFrameTextTable() ) do
			DarkMode:FindTextsByName( name )
		end
	end

	if frame then
		frame:HookScript( "OnShow", function(self, ... )
			C_Timer.After( 0.05, function()
				DarkMode:UpdateQuestLogFrame()
			end )
		end )
		
		if frame.OnEvent then
			hooksecurefunc( frame, "OnEvent", function()
				C_Timer.After( 0.05, function()
					DarkMode:UpdateQuestLogFrame()
				end )
			end )
		end
	end
end

function DarkMode:InitQuestFrame()
	local frame = DarkMode:GetFrame( "QuestFrameGreetingPanel" )

	function DarkMode:UpdateQuestFrame()
		DarkMode:FindTextsByName( "QuestFrameGreetingPanel" )
	end

	if frame then
		frame:HookScript( "OnShow", function(self, ... )
			C_Timer.After( 0.05, function()
				DarkMode:UpdateQuestFrame()
			end )
		end )
		
		if QuestFrame.OnEvent then
			hooksecurefunc( QuestFrame, "OnEvent", function()
				C_Timer.After( 0.05, function()
					DarkMode:UpdateQuestFrame()
				end )
			end )
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

			DarkMode:InitGreetingPanel()
			DarkMode:InitQuestLogFrame()
			DarkMode:InitQuestFrame()

			C_Timer.After( 0.1, function()
				for index, tab in pairs( DarkMode:GetUiTable() ) do
					if index == "ActionButtons" then
						for i, name in pairs( tab ) do
							for x = 1, 12 do
								local btnTexture = _G[name .. x .. "NormalTexture"]
								if btnTexture then
									DarkMode:UpdateColor( btnTexture, "ui" )
								end
								local btnTexture2 = _G[name .. x .. "FloatingBG"]
								if btnTexture2 then
									DarkMode:UpdateColor( btnTexture2, "ui" )
								end
								if _G[name .. x] and _G[name .. x]["SlotBackground"] then
									DarkMode:UpdateColor( _G[name .. x]["SlotBackground"], "ui" )
								end
							end
						end
					elseif index == "Minimap" then
						for i, name in pairs( tab ) do
							DarkMode:FindTexturesByName( name, "ui" )
						end
					elseif index == "UnitFrames" then
						for i, v in pairs( tab ) do
							DarkMode:FindTexturesByName( v, "uf" )
						end
					elseif type( tab ) == "string" then
						DarkMode:FindTexturesByName( tab, "ui" )
					else
						print( "Missing", index, tab )
					end
				end

				for index, name in pairs( DarkMode:GetFrameTable() ) do
					for i, v in pairs( DarkMode:GetDMRepeatingFrames() ) do
						DarkMode:FindTexturesByName( name .. v, "frames" )
					end
				end
				for index, name in pairs( DarkMode:GetFrameTextTable() ) do
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
		for index, name in pairs( DarkMode:GetFrameAddonsTable() ) do
			for i, v in pairs( DarkMode:GetDMRepeatingFrames() ) do
				DarkMode:FindTexturesByName( name .. v, "frames" )
			end
		end

		if PlayerTalentFrame then
			for i, v in pairs( { "PlayerSpecTab1", "PlayerSpecTab2", "PlayerSpecTab3", "PlayerSpecTab4" } ) do
				local tab = _G[v]
				if tab then
					for x, w in pairs( { tab:GetRegions() } ) do 
						if x == 1 then
							DarkMode:UpdateColor( w, "frames" )
						end
					end
				end
			end
		end

		if ClassTalentFrame then
			if ClassTalentFrame.dm_setup == nil then
				ClassTalentFrame.dm_setup = true
				
				function ClassTalentFrame:UpdateColors()
					local tabs = { ClassTalentFrame.TabSystem:GetChildren() }
					for i, v in pairs( tabs ) do
						for x, w in pairs( { v:GetRegions() } ) do 
							DarkMode:UpdateColor( w, "frames" )
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
