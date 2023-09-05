local _, DarkMode = ...
-- TAINTFREE SLASH COMMANDS --
local lastMessage = ""
local cmds = {}

hooksecurefunc("ChatEdit_ParseText", function(editBox, send, parseIfNoSpace)
	if send == 0 then
		lastMessage = editBox:GetText()
	end
end)

hooksecurefunc("ChatFrame_DisplayHelpTextSimple", function(frame)
	if lastMessage and lastMessage ~= "" then
		local cmd = string.upper(lastMessage)
		cmd = strsplit(" ", cmd)

		if cmds[cmd] ~= nil then
			local count = 1
			local numMessages = frame:GetNumMessages()

			local function predicateFunction(entry)
				if count == numMessages and entry == HELP_TEXT_SIMPLE then return true end
				count = count + 1
			end

			frame:RemoveMessagesByPredicate(predicateFunction)
			cmds[cmd]()
		end
	end
end)

function DarkMode:InitSlash()
	cmds["/DM"] = DarkMode.ToggleSettings
	cmds["/DARK"] = DarkMode.ToggleSettings
	cmds["/DARKMODE"] = DarkMode.ToggleSettings
	cmds["/RL"] = C_UI.Reload
	cmds["/REL"] = C_UI.Reload
end

-- TAINTFREE SLASH COMMANDS --
DMHIDDEN = CreateFrame("FRAME", "DMHIDDEN")
DMHIDDEN:Hide()
local DMTexturesUi = {}
local DMTexturesUF = {}
local DMTexturesTT = {}
local DMTexturesFrames = {}

function DarkMode:UpdateColor(texture, typ)
	if not DarkMode:IsValidTexture(texture) then return false end

	if texture == nil then
		print("INVALID TEXTURE OBJECT")

		return false
	end

	local textureId = nil

	if texture.GetTexture ~= nil then
		textureId = texture:GetTexture()
	end

	if textureId and DarkMode:GetTextureBlockTable()[textureId] then return false end
	if texture:GetAlpha() == 0 then return false end

	if textureId == nil and texture.SetColorTexture then
		if typ == "ui" then
			local r, g, b, a = DarkMode:GetUiColor()

			if r ~= nil and g ~= nil and b ~= nil then
				if texture:GetAlpha() < 1 then
					a = texture:GetAlpha()
				end

				texture:SetColorTexture(r, g, b, a)
			end
		elseif typ == "uf" then
			local r, g, b, a = DarkMode:GetUFColor()

			if r ~= nil and g ~= nil and b ~= nil then
				if texture:GetAlpha() < 1 then
					a = texture:GetAlpha()
				end

				texture:SetColorTexture(r, g, b, a)
			end
		elseif typ == "tt" then
			local r, g, b, a = DarkMode:GetTTColor()

			if r ~= nil and g ~= nil and b ~= nil then
				if texture:GetAlpha() < 1 then
					a = texture:GetAlpha()
				end

				texture:SetColorTexture(r, g, b, a)
			end
		else
			local r, g, b, a = DarkMode:GetFrameColor()

			if r ~= nil and g ~= nil and b ~= nil then
				if texture:GetAlpha() < 1 then
					a = texture:GetAlpha()
				end

				texture:SetColorTexture(r, g, b, a)
			end
		end

		return true
	elseif textureId and texture.SetVertexColor then
		if texture.SetText then return false end

		if texture.dm_setup == nil then
			texture.dm_setup = true

			hooksecurefunc(texture, "SetVertexColor", function(sel, olr, olg, olb, ola)
				if sel.dm_setvertexcolor then return end
				sel.dm_setvertexcolor = true

				if typ == "ui" then
					local r, g, b, a = DarkMode:GetUiColor()

					if r ~= nil and g ~= nil and b ~= nil then
						sel:SetVertexColor(r, g, b, a)
					end
				elseif typ == "uf" then
					local r, g, b, a = DarkMode:GetUFColor()

					if r ~= nil and g ~= nil and b ~= nil then
						sel:SetVertexColor(r, g, b, a)
					end
				elseif typ == "tt" then
					local r, g, b, a = DarkMode:GetTTColor()

					if r ~= nil and g ~= nil and b ~= nil then
						sel:SetVertexColor(r, g, b, a)
					end
				else
					local r, g, b, a = DarkMode:GetFrameColor()

					if r ~= nil and g ~= nil and b ~= nil then
						sel:SetVertexColor(r, g, b, a)
					end
				end

				sel.dm_setvertexcolor = false
			end)
		end

		if typ == "ui" then
			local r, g, b, a = DarkMode:GetUiColor()

			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "uf" then
			local r, g, b, a = DarkMode:GetUFColor()

			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "tt" then
			local r, g, b, a = DarkMode:GetTTColor()

			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		else
			local r, g, b, a = DarkMode:GetFrameColor()

			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		end

		if typ == "ui" then
			if not tContains(DMTexturesUi, texture) then
				tinsert(DMTexturesUi, texture)
			end
		elseif typ == "uf" then
			if not tContains(DMTexturesUF, texture) then
				tinsert(DMTexturesUF, texture)
			end
		elseif typ == "tt" then
			if not tContains(DMTexturesTT, texture) then
				tinsert(DMTexturesTT, texture)
			end
		else
			if not tContains(DMTexturesFrames, texture) then
				tinsert(DMTexturesFrames, texture)
			end
		end

		return true
	end

	return false
end

function DarkMode:GetFrame(name)
	local frame = _G[name]

	if frame ~= nil and type(frame) == "table" then
		return frame
	elseif strfind(name, ".", 1, true) then
		for i, v in pairs({strsplit(".", name)}) do
			if i == 1 then
				if type(_G[v]) == "table" then
					frame = _G[v]
				elseif i > 1 then
					return nil
				end
			elseif frame then
				if type(frame[v]) == "table" then
					frame = frame[v]
				elseif i > 1 then
					return nil
				end
			else
				return nil
			end
		end

		if type(frame) == "table" then return frame end
	end

	return nil
end

local function RGBToHexC(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0

	return "|cFF" .. string.format("%02x%02x%02x", r * 255, g * 255, b * 255)
end

local function RemoveColorCodes(text)
	return text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
end

local DMFS = {}

function DarkMode:UpdateText(text, name, layer)
	if text and text.SetTextColor then
		if text.dm_setup == nil then
			text.dm_setup = true

			hooksecurefunc(text, "SetTextColor", function(sel, olr, olg, olb, ola)
				if sel.dm_settextcolor then return end
				sel.dm_settextcolor = true
				local r, g, b, a = DarkMode:GetFrameColor()

				if r ~= nil and g ~= nil and b ~= nil then
					local cr, cg, cb, ca = DarkMode:GetTextColor(r, g, b, a)
					sel:SetTextColor(cr, cg, cb, ca)

					if sel:GetText() then
						sel:SetText(RGBToHexC(cr, cg, cb) .. RemoveColorCodes(sel:GetText()))
					end
				end

				sel.dm_settextcolor = false
			end)
		end

		local r, g, b, a = DarkMode:GetFrameColor()

		if r ~= nil and g ~= nil and b ~= nil then
			text:SetTextColor(DarkMode:GetTextColor(r, g, b, a))
		end

		if not tContains(DMFS, text) then
			tinsert(DMFS, text)
		end

		return true
	end

	return false
end

function DarkMode:FindTexts(frame, name)
	if frame ~= nil then
		if frame.SetTextColor then
			DarkMode:UpdateText(frame, name, 1)
		else
			if frame.GetRegions and getn({frame:GetRegions()}) > 0 then
				for i, v in pairs({frame:GetRegions()}) do
					if v.SetTextColor then
						DarkMode:UpdateText(v, name, 2)
					end

					if type(v) == "table" then
						DarkMode:FindTexts(v, name)
					end
				end
			end

			if frame.GetChildren and getn({frame:GetChildren()}) > 0 then
				for i, v in pairs({frame:GetChildren()}) do
					if v.SetTextColor then
						DarkMode:UpdateText(v, name, 3)
					end

					if type(v) == "table" then
						DarkMode:FindTexts(v, name)
					end
				end
			end
		end
	end
end

function DarkMode:FindTextsByName(name)
	local frame = DarkMode:GetFrame(name)

	if frame and DarkMode:GV("COLORMODEF", 1) ~= 7 then
		DarkMode:FindTexts(frame, name)
	end
end

function DarkMode:UpdateColors()
	for i, v in pairs(DMTexturesUi) do
		local r, g, b, a = DarkMode:GetUiColor()

		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end

	for i, v in pairs(DMTexturesUF) do
		local r, g, b, a = DarkMode:GetUFColor()

		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end

	for i, v in pairs(DMTexturesTT) do
		local r, g, b, a = DarkMode:GetTTColor()

		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end

	-- FONTSTRINGS
	for i, v in pairs(DMFS) do
		local r, g, b, a = DarkMode:GetFrameColor()

		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end

	for i, v in pairs(DMTexturesFrames) do
		local r, g, b, a = DarkMode:GetFrameColor()

		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end
end

function DarkMode:IsValidTexture(obj)
	if obj.GetTexture and obj:GetTexture() ~= nil then return true end
	if obj.GetTextureFilePath and obj:GetTextureFilePath() ~= nil then return true end

	return false
end

function DarkMode:FindTextures(frame, typ)
	if frame ~= nil then
		local show = false
		local ignoreId1 = nil
		local ignoreId2 = nil
		local ignoreId3 = nil

		if frame and frame.GetName and frame:GetName() ~= nil then
			if string.find(frame:GetName(), "SkillLineTab") then
				ignoreId1 = 2
				ignoreId2 = 3
				ignoreId3 = 4
			elseif string.find(frame:GetName(), "XX") then
				ignoreId1 = 2
			end
		end

		local findName = "XX"

		if frame.GetName and frame:GetName() then
			if DarkMode:GetIgnoreFrames(frame:GetName()) then
				return
			elseif strfind(frame:GetName(), findName) then
				show = true
			end
		end

		if frame.SetVertexColor then
			if show and frame.GetTexture then
				print(">", frame:GetName(), frame:GetTextureFilePath(), frame:GetTexture(), "Size:", frame:GetSize())
			end

			DarkMode:UpdateColor(frame, typ)
		end

		if frame.GetRegions and getn({frame:GetRegions()}) > 0 then
			for i, v in pairs({frame:GetRegions()}) do
				local hasName = v.GetName ~= nil

				if (ignoreId1 == nil or ignoreId1 ~= i) and (ignoreId2 == nil or ignoreId2 ~= i) and (ignoreId3 == nil or ignoreId3 ~= i) and ((hasName and not DarkMode:GetIgnoreFrames(v:GetName())) or (not hasName and v.SetVertexColor)) then
					if show and v.GetTexture then
						print(">>", frame:GetName(), v:GetName(), v:GetTextureFilePath(), v:GetTexture(), "Size:", v:GetSize())
					end

					if not hasName or (hasName and not DarkMode:GetIgnoreTextureName(v:GetName())) then
						DarkMode:UpdateColor(v, typ)
					end
				end
			end
		end

		if frame.GetChildren and getn({frame:GetChildren()}) > 0 then
			for i, v in pairs({frame:GetChildren()}) do
				local hasName = v.GetName ~= nil

				if (ignoreId1 == nil or ignoreId1 ~= i) and (ignoreId2 == nil or ignoreId2 ~= i) and (ignoreId3 == nil or ignoreId3 ~= i) and ((hasName and not DarkMode:GetIgnoreFrames(v:GetName())) or (not hasName and v.SetVertexColor)) then
					if show and v.GetTexture then
						print(">>>", frame:GetName(), v:GetName(), v:GetTextureFilePath(), v:GetTexture(), "Size:", v:GetSize())
					end

					if not hasName or (hasName and not DarkMode:GetIgnoreTextureName(v:GetName())) then
						DarkMode:UpdateColor(v, typ)
					end
				end
			end
		end
	end
end

function DarkMode:FindTexturesByName(name, typ)
	local frame = DarkMode:GetFrame(name)

	if name and strfind(name, "Container", 1, true) and strfind(name, "TopSection", 1, true) then
		show = true
	end

	if frame then
		DarkMode:FindTextures(frame, typ)
	end
end

function DarkMode:InitGreetingPanel()
	local frame = DarkMode:GetFrame("GossipFrame.GreetingPanel.ScrollBox.ScrollTarget")

	local frameTab = {"GossipFrame", "GossipFrame.GreetingPanel", "GossipFrame.GreetingPanel.ScrollBox", "GossipFrame.GreetingPanel.ScrollBar.Background",}

	function DarkMode:UpdateGossipFrame()
		if frame == GossipFrame then
			DarkMode:FindTextsByName("GossipFrame")
		else
			DarkMode:FindTextsByName("GossipFrame.GreetingPanel.ScrollBox.ScrollTarget")
		end

		for index, name in pairs(frameTab) do
			for i, v in pairs(DarkMode:GetDMRepeatingFrames()) do
				DarkMode:FindTexturesByName(name .. v, "frames")
			end
		end
	end

	if frame == nil then
		frame = DarkMode:GetFrame("GossipFrame")
	end

	if frame then
		if GossipFrame.GreetingPanel then
			hooksecurefunc(GossipFrame.GreetingPanel.ScrollBox, "FullUpdate", function()
				DarkMode:UpdateGossipFrame()
			end)
		end

		frame:HookScript("OnShow", function(sel, ...)
			C_Timer.After(0.05, function()
				DarkMode:UpdateGossipFrame()
			end)
		end)

		if GossipFrame.OnEvent then
			hooksecurefunc(GossipFrame, "OnEvent", function()
				C_Timer.After(0.05, function()
					DarkMode:UpdateGossipFrame()
				end)
			end)
		end
	end
end

function DarkMode:InitQuestLogFrame()
	local frame = DarkMode:GetFrame("QuestLogFrame")

	function DarkMode:UpdateQuestLogFrame()
		for index, name in pairs(DarkMode:GetFrameTextTable()) do
			DarkMode:FindTextsByName(name)
		end
	end

	if frame then
		frame:HookScript("OnShow", function(sel, ...)
			C_Timer.After(0.05, function()
				DarkMode:UpdateQuestLogFrame()
			end)
		end)

		if frame.OnEvent then
			hooksecurefunc(frame, "OnEvent", function()
				C_Timer.After(0.05, function()
					DarkMode:UpdateQuestLogFrame()
				end)
			end)
		end
	end

	local frame2 = DarkMode:GetFrame("QuestMapFrame")

	function DarkMode:UpdateQuestMapFrame()
		for index, name in pairs(DarkMode:GetFrameTextTable()) do
			DarkMode:FindTextsByName(name)
		end
	end

	if frame2 then
		hooksecurefunc(QuestMapFrame.DetailsFrame.SealMaterialBG, "SetVertexColor", function(sel, olr, olg, olb, ola)
			if sel.dm_setvertexcolor then return end
			sel.dm_setvertexcolor = true
			local r, g, b, a = DarkMode:GetFrameColor()

			if r ~= nil and g ~= nil and b ~= nil then
				sel:SetVertexColor(r, g, b, a)
			end

			sel.dm_setvertexcolor = false
		end)

		local r, g, b, a = DarkMode:GetFrameColor()

		if r ~= nil and g ~= nil and b ~= nil then
			QuestMapFrame.DetailsFrame.SealMaterialBG:SetVertexColor(r, g, b, a)
		end

		function DarkMode:UpdateTextInQuestMapFrame()
			DarkMode:UpdateQuestMapFrame()
			C_Timer.After(0.1, DarkMode.UpdateTextInQuestMapFrame)
		end

		DarkMode:UpdateTextInQuestMapFrame()
	end
end

function DarkMode:SearchFrames()
	for index, name in pairs(DarkMode:GetFrameTable()) do
		for i, v in pairs(DarkMode:GetDMRepeatingFrames()) do
			DarkMode:FindTexturesByName(name .. v, "frames")
		end
	end
end

function DarkMode:SearchAddons()
	for index, name in pairs(DarkMode:GetFrameAddonsTable()) do
		for i, v in pairs(DarkMode:GetDMRepeatingFrames()) do
			DarkMode:FindTexturesByName(name .. v, "frames")
		end
	end
end

function DarkMode:SearchUi()
	for index, tab in pairs(DarkMode:GetUiTable()) do
		if index == "ActionButtons" then
			for i, name in pairs(tab) do
				local max = 12

				--[[ Bar Addons ]]
				if name == "BT4Button" or name == "DominosActionButton" then
					max = 120
				end

				for x = 1, max do
					local btnTexture = _G[name .. x .. "NormalTexture"]

					if name == "BT4StanceButton" and _G[name .. x] and _G[name .. x .. "BorderFix"] == nil then
						local sw, sh = _G[name .. x]:GetSize()
						sw = DarkMode:MathR(sw)
						sh = DarkMode:MathR(sh)
						local scale = 1.1
						_G[name .. x .. "BorderFix"] = _G[name .. x]:CreateTexture(name .. x .. "BorderFix", "OVERLAY")
						local border = _G[name .. x .. "BorderFix"]
						border:SetDrawLayer("OVERLAY", 3)
						border:SetSize(sw * scale, sh * scale)
						border:SetTexture("Interface\\AddOns\\DarkMode\\media\\default")
						border:SetPoint("CENTER", _G[name .. x], "CENTER", 0, 0)
						DarkMode:UpdateColor(border, "ui")
					elseif btnTexture then
						DarkMode:UpdateColor(btnTexture, "ui")
					end

					local btnTexture2 = _G[name .. x .. "FloatingBG"]

					if btnTexture2 then
						DarkMode:UpdateColor(btnTexture2, "ui")
					end

					if _G[name .. x] and _G[name .. x]["SlotBackground"] then
						DarkMode:UpdateColor(_G[name .. x]["SlotBackground"], "ui")
					end

					if DarkMode:GetWoWBuild() ~= "RETAIL" and DarkMode:IsEnabled("MASKACTIONBUTTONS", true) then
						local icon = _G[name .. x .. "Icon"]

						if icon then
							local br = 0.01
							icon:SetTexCoord(br, 1 - br, br, 1 - br)
						end

						if _G[name .. x] and _G[name .. x .. "BorderDM"] == nil then
							local sw, sh = _G[name .. x]:GetSize()
							sw = DarkMode:MathR(sw)
							sh = DarkMode:MathR(sh)
							local scale = 1.1
							_G[name .. x .. "BorderDM"] = _G[name .. x]:CreateTexture(name .. x .. "BorderDM", "OVERLAY")
							local border = _G[name .. x .. "BorderDM"]
							border:SetDrawLayer("OVERLAY", 3)
							border:SetSize(sw * scale, sh * scale)
							border:SetTexture("Interface\\AddOns\\DarkMode\\media\\defaultEER")
							border:SetPoint("CENTER", _G[name .. x], "CENTER", 0, 0)
							DarkMode:UpdateColor(border, "ui")
						end
					end
				end
			end
		elseif index == "Minimap" or index == "Artworks" or index == "Chat" or index == "Castbar" then
			for i, v in pairs(tab) do
				if v ~= "MainMenuBarBackpackButtonNormalTexture" or DarkMode:GetWoWBuild() ~= "RETAIL" then
					DarkMode:FindTexturesByName(v, "ui")
				end
			end
		elseif index == "Gryphons" then
			if DarkMode:IsEnabled("GRYPHONS", true) then
				for i, v in pairs(tab) do
					DarkMode:FindTexturesByName(v, "ui")
				end
			end
		elseif index == "Tooltips" then
			for i, v in pairs(tab) do
				DarkMode:FindTexturesByName(v, "tt")
			end
		elseif type(tab) == "string" then
			DarkMode:FindTexturesByName(tab, "ui")
		elseif index == "UnitFrames" then
			for i, v in pairs(tab) do
				DarkMode:FindTexturesByName(v, "uf")
			end
		else
			print("Missing Ui index:", index, tab)
		end
	end

	if MICRO_BUTTONS and DarkMode:GetWoWBuild() ~= "RETAIL" then
		for i, name in pairs(MICRO_BUTTONS) do
			if name then
				local mbtn = _G[name]

				if mbtn then
					local border = mbtn:CreateTexture(name .. "DMBorder", "OVERLAY")
					border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mbtn_border")
					border:SetAllPoints(mbtn)
					DarkMode:UpdateColor(border, "ui")
				end
			end
		end
	end

	if KeyRingButton then
		local border = KeyRingButton:CreateTexture("KeyRingButton" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\krbtn_border")
		border:SetAllPoints(KeyRingButton)
		border:SetTexCoord(0, 0.5625, 0, 0.609375)
		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
	end

	if MinimapZoomIn and MinimapZoomOut then
		local border = MinimapZoomIn:CreateTexture("MinimapZoomIn" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\zoom_border")
		border:SetAllPoints(MinimapZoomIn)
		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
		local border2 = MinimapZoomOut:CreateTexture("MinimapZoomOut" .. "DMBorder", "OVERLAY")
		border2:SetTexture("Interface\\AddOns\\DarkMode\\media\\zoom_border")
		border2:SetAllPoints(MinimapZoomOut)
		border2:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border2, "ui")
	end

	if MiniMapTrackingFrame then
		-- Classic Era
		local border = MiniMapTrackingFrame:CreateTexture("MiniMapTrackingFrame" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT")
		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
	end

	if MiniMapTrackingButton then
		-- Wrath
		local border = MiniMapTrackingButton:CreateTexture("MiniMapTrackingButton" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetDrawLayer("OVERLAY", 3)
		border:SetScale(0.86)
		DarkMode:UpdateColor(border, "ui")
	end

	if MiniMapWorldMapButton then
		-- Wrath
		local border = MiniMapWorldMapButton:CreateTexture("MiniMapWorldMapButton" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetDrawLayer("OVERLAY", 3)
		border:SetScale(0.8)
		DarkMode:UpdateColor(border, "ui")
	end

	if MiniMapMailFrame then
		local border = MiniMapMailFrame:CreateTexture("MiniMapMailFrame" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetDrawLayer("OVERLAY", 3)
		border:SetScale(0.8)
		DarkMode:UpdateColor(border, "ui")
	end

	if GameTimeFrame and DarkMode:GetWoWBuild() ~= "RETAIL" then
		local border = GameTimeFrame:CreateTexture("GameTimeFrame" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\gt_border")

		if DarkMode:GetWoWBuild() == "WRATH" then
			border:SetPoint("TOPLEFT", -1, 1)
			border:SetScale(0.82)
		else
			border:SetPoint("TOPLEFT")
		end

		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
	end

	C_Timer.After(1.1, function()
		if DMMMBTN then
			for i, name in pairs(DMMMBTN:GetButtonList()) do
				local btn = _G["LibDBIcon10_" .. name]

				if btn then
					local border = btn:CreateTexture(name .. "DMBorder", "OVERLAY")
					border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
					border:SetPoint("TOPLEFT", 0, 1)
					border:SetParent(btn)
					border:SetScale(0.84)
					border:SetDrawLayer("OVERLAY", 3)
					DarkMode:UpdateColor(border, "ui")
				end
			end
		end
	end)

	local btwQ = _G["BtWQuestsMinimapButton"]

	if btwQ then
		local border = btwQ:CreateTexture("BtWQuestsMinimapButton" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetParent(btwQ)
		border:SetScale(0.9)
		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
	end
end

local npf = CreateFrame("FRAME")
npf:RegisterEvent("NAME_PLATE_UNIT_ADDED")

npf:SetScript("OnEvent", function(self, event, name, ...)
	local id = string.sub(name, 10)

	C_Timer.After(0.1, function()
		DarkMode:FindTexturesByName("NamePlate" .. id .. ".UnitFrame.healthBar.border", "uf")
	end)
end)

function DarkMode:InitQuestFrame()
	local frame = DarkMode:GetFrame("QuestFrameGreetingPanel")

	function DarkMode:UpdateQuestFrameGreetingPanel()
		DarkMode:FindTextsByName("QuestFrameGreetingPanel")
	end

	if QuestFrame then
		QuestFrame:HookScript("OnShow", function(sel, ...)
			DarkMode:SearchFrames()
		end)
	end

	if QuestFrameRewardPanel then
		QuestFrameRewardPanel:HookScript("OnShow", function(sel, ...)
			DarkMode:SearchFrames()
		end)
	end

	if QuestFrameDetailPanel then
		QuestFrameDetailPanel:HookScript("OnShow", function(sel, ...)
			DarkMode:SearchFrames()
		end)
	end

	if frame then
		frame:HookScript("OnShow", function(sel, ...)
			C_Timer.After(0.05, function()
				DarkMode:UpdateQuestFrameGreetingPanel()
			end)
		end)

		if QuestFrame.OnEvent then
			hooksecurefunc(QuestFrame, "OnEvent", function()
				C_Timer.After(0.05, function()
					DarkMode:UpdateQuestFrameGreetingPanel()
				end)
			end)
		end
	end
end

local BAGS = {"MainMenuBarBackpackButton", "CharacterBag0Slot", "CharacterBag1Slot", "CharacterBag2Slot", "CharacterBag3Slot"}

function DarkMode:Event(event, ...)
	if event == "PLAYER_LOGIN" then
		if DarkMode.Setup == nil then
			DarkMode.Setup = true
			DarkMode:InitSlash()
			DarkMode:InitDB()
			DarkMode:InitDMSettings()
			DarkMode:InitGreetingPanel()
			DarkMode:InitQuestLogFrame()
			DarkMode:InitQuestFrame()

			if DarkMode:GetWoWBuild() ~= "RETAIL" then
				-- delay for other addons changing
				C_Timer.After(2, function()
					for i, v in pairs(BAGS) do
						local bagF = _G[v]
						local NT = _G[v .. "NormalTexture"]

						if NT and bagF and NT.scalesetup == nil then
							NT.scalesetup = true

							if NT:GetTexture() == 130841 then
								local sw, sh = bagF:GetSize()
								local scale = 1.66
								NT:SetSize(sw * scale, sh * scale)
							end
						end
					end
				end)
			end

			if AuraFrameMixin and AuraFrameMixin.Update then
				hooksecurefunc(AuraFrameMixin, "Update", function(sel)
					for index, bf in pairs(sel.auraFrames) do
						if bf and _G["Buff" .. index .. "BorderDM"] == nil then
							local _, sh = bf.Icon:GetSize()
							sh = DarkMode:MathR(sh)
							local scale = 1
							_G["Buff" .. index .. "BorderDM"] = bf:CreateTexture("Buff" .. index .. "BorderDM", "OVERLAY")
							local border = _G["Buff" .. index .. "BorderDM"]
							border:SetDrawLayer("OVERLAY", 3)
							border:SetSize(sh * scale, sh * scale)
							border:SetTexture("Interface\\AddOns\\DarkMode\\media\\default")
							border:SetPoint("CENTER", bf.Icon, "CENTER", 0, 0)
							DarkMode:UpdateColor(border, "ui")
						end
					end
				end)
			elseif BuffFrame_UpdateAllBuffAnchors then
				hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", function()
					local buttonName = "BuffButton"

					for index = 1, BUFF_ACTUAL_DISPLAY do
						if _G[buttonName .. index] and _G[buttonName .. index .. "BorderDM"] == nil then
							local sw, sh = _G[buttonName .. index]:GetSize()
							sw = DarkMode:MathR(sw)
							sh = DarkMode:MathR(sh)
							local scale = 1.1
							_G[buttonName .. index .. "BorderDM"] = _G[buttonName .. index]:CreateTexture(buttonName .. index .. "BorderDM", "OVERLAY")
							local border = _G[buttonName .. index .. "BorderDM"]
							border:SetDrawLayer("OVERLAY", 3)
							border:SetSize(sw * scale, sh * scale)
							border:SetTexture("Interface\\AddOns\\DarkMode\\media\\default")
							border:SetPoint("CENTER", _G[buttonName .. index], "CENTER", 0, 0)
							DarkMode:UpdateColor(border, "ui")
						end
					end
				end)
			end

			if TargetFrame_UpdateAuras then
				hooksecurefunc("TargetFrame_UpdateAuras", function(frame)
					local buttonName = frame:GetName() .. "Buff"

					for index = 1, BUFF_ACTUAL_DISPLAY do
						if _G[buttonName .. index] and _G[buttonName .. index .. "BorderDM"] == nil then
							local sw, sh = _G[buttonName .. index]:GetSize()
							sw = DarkMode:MathR(sw)
							sh = DarkMode:MathR(sh)
							local scale = 1.1
							_G[buttonName .. index .. "BorderDM"] = _G[buttonName .. index]:CreateTexture(buttonName .. index .. "BorderDM", "OVERLAY")
							local border = _G[buttonName .. index .. "BorderDM"]
							border:SetDrawLayer("OVERLAY", 3)
							border:SetSize(sw * scale, sh * scale)
							border:SetTexture("Interface\\AddOns\\DarkMode\\media\\default")
							border:SetPoint("CENTER", _G[buttonName .. index], "CENTER", 0, 0)
							DarkMode:UpdateColor(border, "ui")
						end
					end
				end)
			end

			C_Timer.After(0.1, function()
				DarkMode:SearchUi()
				DarkMode:SearchFrames()

				for index, name in pairs(DarkMode:GetFrameTextTable()) do
					DarkMode:FindTextsByName(name)
				end
			end)

			--[[ SPECIALS ]]
			if DarkMode:GetWoWBuild() ~= "RETAIL" and FriendsFramePortrait then
				hooksecurefunc(FriendsFramePortrait, "Show", function()
					FriendsFramePortrait:Hide()
				end)

				FriendsFramePortrait:Hide()
			end

			function DarkMode:UpdateMinimapButton()
				if DMMMBTN then
					if DarkMode:IsEnabled("SHOWMINIMAPBUTTON", true) then
						DMMMBTN:Show("DarkModeMinimapIcon")
					else
						DMMMBTN:Hide("DarkModeMinimapIcon")
					end
				end
			end

			function DarkMode:ToggleMinimapButton()
				DarkMode:SetEnabled("SHOWMINIMAPBUTTON", not DarkMode:IsEnabled("SHOWMINIMAPBUTTON", true))

				if DMMMBTN then
					if DarkMode:IsEnabled("SHOWMINIMAPBUTTON", true) then
						DMMMBTN:Show("DarkModeMinimapIcon")
					else
						DMMMBTN:Hide("DarkModeMinimapIcon")
					end
				end
			end

			function DarkMode:HideMinimapButton()
				DarkMode:SetEnabled("SHOWMINIMAPBUTTON", false)

				if DMMMBTN then
					DMMMBTN:Hide("DarkModeMinimapIcon")
				end
			end

			function DarkMode:ShowMinimapButton()
				DarkMode:SetEnabled("SHOWMINIMAPBUTTON", true)

				if DMMMBTN then
					DMMMBTN:Show("DarkModeMinimapIcon")
				end
			end

			local DarkModeMinimapIcon = LibStub("LibDataBroker-1.1"):NewDataObject("DarkModeMinimapIcon", {
				type = "data source",
				text = "DarkModeMinimapIcon",
				icon = 136122,
				OnClick = function(sel, btn)
					if btn == "LeftButton" then
						DarkMode:ToggleSettings()
					elseif btn == "RightButton" then
						DarkMode:HideMinimapButton()
					end
				end,
				OnTooltipShow = function(tooltip)
					if not tooltip or not tooltip.AddLine then return end
					tooltip:AddLine("DarkMode")
					tooltip:AddLine(DarkMode:GT("MMBTNLEFT"))
					tooltip:AddLine(DarkMode:GT("MMBTNRIGHT"))
				end,
			})

			if DarkModeMinimapIcon then
				DMMMBTN = LibStub("LibDBIcon-1.0", true)

				if DMMMBTN then
					DMMMBTN:Register("DarkModeMinimapIcon", DarkModeMinimapIcon, DarkMode:GetMinimapTable())
				end
			end

			if DMMMBTN then
				if DarkMode:IsEnabled("SHOWMINIMAPBUTTON", true) then
					DMMMBTN:Show("DarkModeMinimapIcon")
				else
					DMMMBTN:Hide("DarkModeMinimapIcon")
				end
			end
		end
	elseif event == "ADDON_LOADED" then
		C_Timer.After(0.1, function()
			DarkMode:SearchAddons()

			if PlayerTalentFrame then
				for i, v in pairs({"PlayerSpecTab1", "PlayerSpecTab2", "PlayerSpecTab3", "PlayerSpecTab4"}) do
					local tab = _G[v]

					if tab then
						for x, w in pairs({tab:GetRegions()}) do
							if x == 1 then
								DarkMode:UpdateColor(w, "frames")
							end
						end
					end
				end
			end

			if ClassTalentFrame and ClassTalentFrame.dm_setup == nil then
				ClassTalentFrame.dm_setup = true

				function ClassTalentFrame:UpdateColors()
					local tabs = {ClassTalentFrame.TabSystem:GetChildren()}

					for i, v in pairs(tabs) do
						for x, w in pairs({v:GetRegions()}) do
							DarkMode:UpdateColor(w, "frames")
						end
					end
				end

				ClassTalentFrame:HookScript("OnShow", function(sel)
					ClassTalentFrame:UpdateColors()
				end)

				ClassTalentFrame:UpdateColors()
			end
		end)
	end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", DarkMode.Event)
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED")
f.incombat = false