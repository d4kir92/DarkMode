local _, DarkMode = ...
DMHIDDEN = CreateFrame("FRAME", "DMHIDDEN")
DMHIDDEN:Hide()
local debug = 0
function DarkMode:Debug(num, msg, ...)
	if debug > 0 and debug == num or debug == 11 then
		print(msg, ...)
	end
end

local addonsDelay = 0
local addonsRetry = false
function DarkMode:RetryAddonsSearch()
	if addonsRetry and GetTime() > addonsDelay then
		DarkMode:AddonsSearch("RETRY")
	end

	C_Timer.After(
		0.1,
		function()
			DarkMode:RetryAddonsSearch()
		end
	)
end

DarkMode:RetryAddonsSearch()
function DarkMode:AddonsSearch(from)
	if GetTime() < addonsDelay then
		addonsRetry = true
		addonsDelay = GetTime() + 0.11

		return
	end

	addonsDelay = GetTime() + 0.11
	addonsRetry = false
	C_Timer.After(
		0.09,
		function()
			DarkMode:Debug(5, "#17")
			DarkMode:SearchAddons(from)
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

			if ClassTalentFrame and ClassTalentFrame.dm_setup_talent == nil then
				ClassTalentFrame.dm_setup_talent = true
				function ClassTalentFrame:UpdateColors()
					local tabs = {ClassTalentFrame.TabSystem:GetChildren()}
					for i, v in pairs(tabs) do
						for x, w in pairs({v:GetRegions()}) do
							DarkMode:UpdateColor(w, "frames")
						end
					end
				end

				ClassTalentFrame:HookScript(
					"OnShow",
					function(sel)
						ClassTalentFrame:UpdateColors()
					end
				)

				ClassTalentFrame:UpdateColors()
			end
		end
	)
end

local DMTexturesUi = {}
local DMTexturesUF = {}
local DMTexturesNP = {}
local DMTexturesTT = {}
local DMTexturesFrames = {}
local DMTexturesActionButtons = {}
local DMTexturesBuffsAndDebuffs = {}
function DarkMode:UpdateColor(texture, typ, bShow)
	if not DarkMode:IsValidTexture(texture) then return false end
	if texture == nil then
		print("[DarkMode] INVALID TEXTURE OBJECT")

		return false
	end

	if debug == 10 then
		if texture.GetName then
			DarkMode:Debug(10, "UpdateColor", "name:", texture:GetName(), "typ:", typ)
		else
			DarkMode:Debug(10, "UpdateColor", "texture:", texture, "typ:", typ)
		end
	end

	local textureId = nil
	if texture.GetTexture ~= nil then
		textureId = texture:GetTexture()
	end

	if textureId and DarkMode:GetTextureBlockTable()[textureId] then return false end
	if texture:GetAlpha() == 0 then return false end
	if textureId == nil and texture.SetColorTexture then
		if typ == "ui" then
			local r, g, b, a = DarkMode:GetUiColor(texture)
			if r ~= nil and g ~= nil and b ~= nil then
				if texture:GetAlpha() < 1 then
					a = texture:GetAlpha()
				end

				texture:SetColorTexture(r, g, b, a)
			end
		elseif typ == "uf" then
			local r, g, b, a = DarkMode:GetUFColor(texture)
			if r ~= nil and g ~= nil and b ~= nil then
				if texture:GetAlpha() < 1 then
					a = texture:GetAlpha()
				end

				texture:SetColorTexture(r, g, b, a)
			end
		elseif typ == "np" then
			local r, g, b, a = DarkMode:GetNPColort(texture)
			if r ~= nil and g ~= nil and b ~= nil then
				if texture:GetAlpha() < 1 then
					a = texture:GetAlpha()
				end

				texture:SetColorTexture(r, g, b, a)
			end
		elseif typ == "tt" then
			local r, g, b, a = DarkMode:GetTTColor(texture)
			if r ~= nil and g ~= nil and b ~= nil then
				if texture:GetAlpha() < 1 then
					a = texture:GetAlpha()
				end

				texture:SetColorTexture(r, g, b, a)
			end
		elseif typ == "actionbuttons" then
			local r, g, b, a = DarkMode:GetActionButtonsColor(texture)
			if r ~= nil and g ~= nil and b ~= nil then
				if texture:GetAlpha() < 1 then
					a = texture:GetAlpha()
				end

				texture:SetColorTexture(r, g, b, a)
			end
		elseif typ == "buffsanddebuffs" then
			local r, g, b, a = DarkMode:GetBuffsAndDebuffsColor(texture)
			if r ~= nil and g ~= nil and b ~= nil then
				if texture:GetAlpha() < 1 then
					a = texture:GetAlpha()
				end

				texture:SetColorTexture(r, g, b, a)
			end
		else
			local r, g, b, a = DarkMode:GetFrameColor(texture)
			if r ~= nil and g ~= nil and b ~= nil then
				if texture:GetAlpha() < 1 then
					a = texture:GetAlpha()
				end

				texture:SetColorTexture(r, g, b, a)
			end
		end

		return true
	elseif textureId ~= nil and texture.SetVertexColor then
		if texture.SetText then return false end
		if texture.dm_setup_texture == nil then
			texture.dm_setup_texture = true
			hooksecurefunc(
				texture,
				"SetVertexColor",
				function(sel, olr, olg, olb, ola)
					if sel.dm_setvertexcolor then return end
					sel.dm_setvertexcolor = true
					if typ == "ui" then
						local r, g, b, a = DarkMode:GetUiColor(sel)
						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					elseif typ == "uf" then
						local r, g, b, a = DarkMode:GetUFColor(sel)
						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					elseif typ == "np" then
						local r, g, b, a = DarkMode:GetNPColor(sel)
						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					elseif typ == "tt" then
						local r, g, b, a = DarkMode:GetTTColor(sel)
						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					elseif typ == "actionbuttons" then
						local r, g, b, a = DarkMode:GetActionButtonsColor(sel)
						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					elseif typ == "buffsanddebuffs" then
						local r, g, b, a = DarkMode:GetBuffsAndDebuffsColor(sel)
						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					else
						local r, g, b, a = DarkMode:GetFrameColor(sel)
						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					end

					sel.dm_setvertexcolor = false
				end
			)
		end

		if typ == "ui" then
			local r, g, b, a = DarkMode:GetUiColor(texture)
			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "uf" then
			local r, g, b, a = DarkMode:GetUFColor(texture)
			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "np" then
			local r, g, b, a = DarkMode:GetNPColor(texture)
			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "tt" then
			local r, g, b, a = DarkMode:GetTTColor(texture)
			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "actionbuttons" then
			local r, g, b, a = DarkMode:GetActionButtonsColor(texture)
			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "buffsanddebuffs" then
			local r, g, b, a = DarkMode:GetBuffsAndDebuffsColor(texture)
			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		else
			local r, g, b, a = DarkMode:GetFrameColor(texture)
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
		elseif typ == "np" then
			if not tContains(DMTexturesNP, texture) then
				tinsert(DMTexturesNP, texture)
			end
		elseif typ == "tt" then
			if not tContains(DMTexturesTT, texture) then
				tinsert(DMTexturesTT, texture)
			end
		elseif typ == "actionbuttons" then
			if not tContains(DMTexturesActionButtons, texture) then
				tinsert(DMTexturesActionButtons, texture)
			end
		elseif typ == "buffsanddebuffs" then
			if not tContains(DMTexturesBuffsAndDebuffs, texture) then
				tinsert(DMTexturesBuffsAndDebuffs, texture)
			end
		elseif typ == "frames" then
			if DMTexturesFrames[texture] == nil then
				DMTexturesFrames[texture] = texture
			end
		else
			print("[DarkMode] Missing Type:", typ)
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
	elseif name:find("%[[0-9]+%]") then
		local f = _G[name:gsub("%[[0-9]+%]", "")]
		if f then
			local regions = {f:GetRegions()}
			local num = tonumber(name:match("[0-9]+"))

			return regions[num]
		end
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
		if text.dm_setup_text == nil then
			text.dm_setup_text = true
			hooksecurefunc(
				text,
				"SetTextColor",
				function(sel, olr, olg, olb, ola)
					if sel.dm_settextcolor then return end
					sel.dm_settextcolor = true
					local r, g, b, a = DarkMode:GetFrameColor()
					if r ~= nil and g ~= nil and b ~= nil then
						if a == nil then
							a = 1
						end

						local cr, cg, cb, ca = DarkMode:GetTextColor(r, g, b, a)
						if cr ~= nil and cg ~= nil and cb ~= nil then
							sel:SetTextColor(cr, cg, cb, ca)
							if sel:GetText() then
								sel:SetText(RGBToHexC(cr, cg, cb) .. RemoveColorCodes(sel:GetText()))
							end
						end
					end

					sel.dm_settextcolor = false
				end
			)
		end

		local r, g, b, a = DarkMode:GetFrameColor()
		if r ~= nil and g ~= nil and b ~= nil then
			if a == nil then
				a = 1
			end

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
	if frame and DarkMode:DMGV("COLORMODEF", 1) ~= 7 then
		DarkMode:FindTexts(frame, name)
	end
end

function DarkMode:UpdateColors()
	for i, v in pairs(DMTexturesUi) do
		local r, g, b, a = DarkMode:GetUiColor(v)
		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end

	for i, v in pairs(DMTexturesUF) do
		local r, g, b, a = DarkMode:GetUFColor(v)
		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end

	for i, v in pairs(DMTexturesTT) do
		local r, g, b, a = DarkMode:GetTTColor(v)
		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end

	-- FONTSTRINGS
	for i, v in pairs(DMFS) do
		local r, g, b, a = DarkMode:GetFrameColor(v)
		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end

	for i, v in pairs(DMTexturesFrames) do
		local r, g, b, a = DarkMode:GetFrameColor(v)
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
	if frame == nil then return end
	local bShow = false
	local ignoreId1 = nil
	local ignoreId2 = nil
	local ignoreId3 = nil
	if frame and frame ~= StoreFrame and frame.GetName ~= nil and frame:GetName() ~= nil then
		if string.find(frame:GetName(), "SkillLineTab") then
			ignoreId1 = 2
			ignoreId2 = 3
			ignoreId3 = 4
		elseif string.find(frame:GetName(), "XX") then
			ignoreId1 = 2
		end
	end

	if frame and frame ~= StoreFrame and frame.GetName ~= nil and frame:GetName() and DarkMode:GetIgnoreFrames(frame:GetName()) then return end
	if frame.SetVertexColor then
		DarkMode:UpdateColor(frame, typ)
	end

	if frame.GetRegions and getn({frame:GetRegions()}) > 0 then
		for i, v in pairs({frame:GetRegions()}) do
			local hasName = v.GetName ~= nil
			if (ignoreId1 == nil or ignoreId1 ~= i) and (ignoreId2 == nil or ignoreId2 ~= i) and (ignoreId3 == nil or ignoreId3 ~= i) and ((hasName and not DarkMode:GetIgnoreFrames(v:GetName())) or (not hasName and v.SetVertexColor)) then
				if bShow and v.GetTexture then
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
				if bShow and v.GetTexture then
					print(">>>", frame:GetName(), v:GetName(), v:GetTextureFilePath(), v:GetTexture(), "Size:", v:GetSize())
				end

				if not hasName or (hasName and not DarkMode:GetIgnoreTextureName(v:GetName())) then
					DarkMode:UpdateColor(v, typ)
				end
			end
		end
	end
end

function DarkMode:FindTexturesByName(name, typ)
	DarkMode:Debug(10, "FindTexturesByName", name)
	local frame = DarkMode:GetFrame(name)
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
			hooksecurefunc(
				GossipFrame.GreetingPanel.ScrollBox,
				"FullUpdate",
				function()
					DarkMode:UpdateGossipFrame()
				end
			)
		end

		frame:HookScript(
			"OnShow",
			function(sel, ...)
				C_Timer.After(
					0.05,
					function()
						DarkMode:Debug(5, "#1")
						DarkMode:UpdateGossipFrame()
					end
				)
			end
		)

		if GossipFrame.OnEvent then
			hooksecurefunc(
				GossipFrame,
				"OnEvent",
				function()
					C_Timer.After(
						0.05,
						function()
							DarkMode:Debug(5, "#2")
							DarkMode:UpdateGossipFrame()
						end
					)
				end
			)
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
		frame:HookScript(
			"OnShow",
			function(sel, ...)
				C_Timer.After(
					0.05,
					function()
						DarkMode:Debug(5, "#3")
						DarkMode:UpdateQuestLogFrame()
					end
				)
			end
		)

		if frame.OnEvent then
			hooksecurefunc(
				frame,
				"OnEvent",
				function()
					C_Timer.After(
						0.05,
						function()
							DarkMode:Debug(5, "#4")
							DarkMode:UpdateQuestLogFrame()
						end
					)
				end
			)
		end
	end

	function DarkMode:UpdateQuestMapFrame()
		for index, name in pairs(DarkMode:GetFrameTextTable()) do
			if _G[name] and debug then
				DarkMode:FindTextsByName(name)
			end
		end
	end

	DarkMode:UpdateQuestMapFrame()
end

function DarkMode:SearchFrames()
	for index, frame in pairs(DarkMode:GetFrameTableSpecial()) do
		DarkMode:UpdateColor(frame, "frames")
	end

	for index, name in pairs(DarkMode:GetFrameTable()) do
		for i, v in pairs(DarkMode:GetDMRepeatingFrames()) do
			DarkMode:FindTexturesByName(name .. v, "frames")
		end
	end
end

local foundAuctionator = false
local foundExpansion = false
function DarkMode:SearchAddons(from)
	if AuctionatorAHTabsContainer ~= nil and AuctionatorAHTabsContainer.Tabs ~= nil and foundAuctionator == false then
		foundAuctionator = true
		for i, v in pairs(AuctionatorAHTabsContainer.Tabs) do
			DarkMode:FindTextures(v, "frames")
		end
	end

	for index, name in pairs(DarkMode:GetFrameAddonsTable()) do
		for i, v in pairs(DarkMode:GetDMRepeatingFrames()) do
			DarkMode:FindTexturesByName(name .. v, "frames")
		end
	end

	if not foundExpansion and ExpansionLandingPage and ExpansionLandingPage.Overlay then
		for i, v in pairs({ExpansionLandingPage.Overlay:GetChildren()}) do
			if v then
				foundExpansion = true
				DarkMode:FindTextures(v.NineSlice, "frames")
			end
		end
	end
end

function DarkMode:SearchUi(from)
	local raidOnly = from == "raid"
	for index, tab in pairs(DarkMode:GetUiTable()) do
		if raidOnly and index == "UnitFrames" then
			for i, v in pairs(tab) do
				DarkMode:FindTexturesByName(v, "uf")
			end
		else
			if index == "ActionButtons" then
				for i, name in pairs(tab) do
					local max = 12
					--[[ Bar Addons ]]
					if name == "BT4Button" or name == "DominosActionButton" then
						max = 200
					end

					for x = 1, max do
						local btn = _G[name .. x]
						local btnTextureNormalTexture = _G[name .. x .. "NormalTexture"]
						local btnTextureFloatingBG = _G[name .. x .. "FloatingBG"]
						if name == "BT4StanceButton" and btn and _G[name .. x .. "BorderFix"] == nil and (DarkMode:IsEnabled("MASKACTIONBUTTONS", true) or name == "PetActionButton" or name == "StanceButton") and DarkMode:DMGV("COLORMODEAB", 1) ~= "Off" and DarkMode:DMGV("COLORMODEAB", 1) ~= "Default" then
							local sw, sh = btn:GetSize()
							sw = DarkMode:MathR(sw)
							sh = DarkMode:MathR(sh)
							local scale = 1.1
							_G[name .. x .. "BorderFix"] = btn:CreateTexture(name .. x .. "BorderFix", "OVERLAY")
							local border = _G[name .. x .. "BorderFix"]
							border:SetDrawLayer("OVERLAY", 3)
							border:SetSize(sw * scale, sh * scale)
							border:SetTexture("Interface\\AddOns\\DarkMode\\media\\default")
							border:SetPoint("CENTER", btn, "CENTER", 0, 0)
							DarkMode:UpdateColor(border, "actionbuttons")
						elseif btnTextureNormalTexture then
							DarkMode:UpdateColor(btnTextureNormalTexture, "actionbuttons")
						end

						local MSQ = LibStub("Masque", true)
						if MSQ then
							if btn then
								if btn.__MSQ_Mask then
									DarkMode:UpdateColor(btn.__MSQ_Mask, "actionbuttons")
								end

								if btn.__MSQ_Normal then
									DarkMode:UpdateColor(btn.__MSQ_Normal, "actionbuttons")
								end

								if btn.__MSQ_NewNormal then
									DarkMode:UpdateColor(btn.__MSQ_NewNormal, "actionbuttons")
								end
							end
						else
							if btnTextureFloatingBG then
								DarkMode:UpdateColor(btnTextureFloatingBG, "actionbuttons")
							end

							if btn and btn["SlotBackground"] then
								DarkMode:UpdateColor(btn["SlotBackground"], "actionbuttons")
							end

							if btn and btn["RightDivider"] then
								DarkMode:UpdateColor(btn["RightDivider"]["TopEdge"], "actionbuttons")
								DarkMode:UpdateColor(btn["RightDivider"]["Center"], "actionbuttons")
								DarkMode:UpdateColor(btn["RightDivider"]["BottomEdge"], "actionbuttons")
							end
						end

						if not MSQ then
							if DarkMode:IsEnabled("THINBORDERS", false) then
								local icon = _G[name .. x .. "Icon"]
								if icon then
									local br = 0.075
									if name == "PetActionButton" then
										br = 0.038
									end

									icon:SetTexCoord(br, 1 - br, br, 1 - br)
								end

								if name == "PetActionButton" then
									local border = _G[name .. x .. "NormalTexture2"]
									if border then
										hooksecurefunc(
											border,
											"SetAlpha",
											function(sel, ...)
												if sel.dm_setalpha then return end
												sel.dm_setalpha = true
												sel:SetAlpha(0)
												sel.dm_setalpha = false
											end
										)

										border:SetAlpha(0)
									end
								end

								if btnTextureNormalTexture then
									hooksecurefunc(
										btnTextureNormalTexture,
										"SetVertexColor",
										function(sel, ...)
											if sel.dm_setalpha then return end
											sel.dm_setalpha = true
											sel:SetAlpha(0)
											sel.dm_setalpha = false
										end
									)

									btnTextureNormalTexture:SetAlpha(0)
								end

								if btnTextureFloatingBG then
									hooksecurefunc(
										btnTextureFloatingBG,
										"SetVertexColor",
										function(sel, ...)
											if sel.dm_setalpha then return end
											sel.dm_setalpha = true
											sel:SetAlpha(0.5)
											sel.dm_setalpha = false
										end
									)

									btnTextureFloatingBG:SetAlpha(0.5)
									hooksecurefunc(
										btnTextureFloatingBG,
										"SetScale",
										function(sel)
											if sel.dm_setscale then return end
											sel.dm_setscale = true
											sel:SetScale(0.9)
											sel.dm_setscale = false
										end
									)

									btnTextureFloatingBG:SetScale(0.9)
									btnTextureFloatingBG:ClearAllPoints()
									btnTextureFloatingBG:SetPoint("CENTER", btn, "CENTER", 0, 0)
								end

								if btn and _G[name .. x .. "BorderDM"] == nil then
									local sw, sh = btn:GetSize()
									sw = DarkMode:MathR(sw)
									sh = DarkMode:MathR(sh)
									local scale = 1
									if name == "PetActionButton" then
										scale = 1.2
									end

									_G[name .. x .. "BorderDM"] = btn:CreateTexture(name .. x .. "BorderDM", "OVERLAY")
									local border = _G[name .. x .. "BorderDM"]
									border:SetDrawLayer("OVERLAY", 3)
									border:SetSize(sw * scale, sh * scale)
									if name == "PetActionButton" then
										border:SetTexture("Interface\\AddOns\\DarkMode\\media\\defaultEER")
									else
										border:SetTexture("Interface\\AddOns\\DarkMode\\media\\border_thin")
									end

									border:SetPoint("CENTER", btn, "CENTER", 0, 0)
									DarkMode:UpdateColor(border, "actionbuttons")
								end
							elseif DarkMode:GetWoWBuild() ~= "RETAIL" and (DarkMode:IsEnabled("MASKACTIONBUTTONS", true) or name == "PetActionButton" or name == "StanceButton") and DarkMode:DMGV("COLORMODEAB", 1) ~= "Off" and DarkMode:DMGV("COLORMODEAB", 1) ~= "Default" then
								local icon = _G[name .. x .. "Icon"]
								if icon then
									local br = 0.012
									icon:SetTexCoord(br, 1 - br, br, 1 - br)
								end

								if btn and _G[name .. x .. "BorderDM"] == nil then
									local sw, sh = btn:GetSize()
									sw = DarkMode:MathR(sw)
									sh = DarkMode:MathR(sh)
									local scale = 1.1
									_G[name .. x .. "BorderDM"] = btn:CreateTexture(name .. x .. "BorderDM", "OVERLAY")
									local border = _G[name .. x .. "BorderDM"]
									border:SetDrawLayer("OVERLAY", 3)
									border:SetSize(sw * scale, sh * scale)
									border:SetTexture("Interface\\AddOns\\DarkMode\\media\\defaultEER")
									border:SetPoint("CENTER", btn, "CENTER", 0, 0)
									DarkMode:UpdateColor(border, "actionbuttons")
								end
							end
						end
					end
				end
			elseif index == "Minimap" or index == "Artworks" or index == "Chat" or index == "Castbar" then
				for ind, name in pairs(tab) do
					if index == "Artworks" and name == "BT4BarBlizzardArt.nineSliceParent" then
						local frame = DarkMode:GetFrame(name)
						if frame then
							for i, v in pairs({frame:GetChildren()}) do
								if i == 1 then
									DarkMode:FindTextures(v, "ui") -- Bartender Border in BlizzardArt
								end
							end
						end
					end

					if name ~= "MainMenuBarBackpackButtonNormalTexture" or DarkMode:GetWoWBuild() ~= "RETAIL" then
						DarkMode:FindTexturesByName(name, "ui")
					end
				end
			elseif index == "Gryphons" then
				if DarkMode:IsEnabled("GRYPHONS", true) then
					for i, name in pairs(tab) do
						DarkMode:FindTexturesByName(name, "ui")
					end
				end
			elseif index == "Tooltips" then
				for i, name in pairs(tab) do
					DarkMode:FindTexturesByName(name, "tt")
				end
			elseif type(tab) == "string" then
				DarkMode:FindTexturesByName(tab, "ui")
			elseif index == "UnitFrames" then
				for i, name in pairs(tab) do
					DarkMode:FindTexturesByName(name, "uf")
				end
			else
				print("[DarkMode] Missing Ui index:", index, tab)
			end
		end
	end

	--[[if QueueStatusButton and _G["QueueStatusButton" .. "DMBorder"] == nil then
		local border = QueueStatusButton:CreateTexture("QueueStatusButton" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\eyeborder")
		border:SetSize(QueueStatusButton:GetSize())
		border:SetPoint("CENTER", QueueStatusButton, "CENTER", 0, 1)
		border:SetDrawLayer("OVERLAY", 3)
		border:SetAlpha(0.1)
		if border.SetScale then
			border:SetScale(0.95)
		end

		DarkMode:UpdateColor(border, "ui")
	end]]
	if MICRO_BUTTONS and DarkMode:GetWoWBuild() ~= "RETAIL" then
		for i, name in pairs(MICRO_BUTTONS) do
			if name then
				local mbtn = _G[name]
				if mbtn and _G[name .. "DMBorder"] == nil then
					if mbtn.Background then
						local border = mbtn:CreateTexture(name .. "DMBorder", "OVERLAY")
						border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mbtn_border")
						border:SetSize(32, 64)
						border:SetPoint("CENTER", mbtn.Background, "CENTER", 0, 10)
						DarkMode:UpdateColor(border, "ui")
					else
						local border = mbtn:CreateTexture(name .. "DMBorder", "OVERLAY")
						border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mbtn_border")
						border:SetAllPoints(mbtn)
						DarkMode:UpdateColor(border, "ui")
					end
				end
			end
		end
	end

	if KeyRingButton and _G["KeyRingButton" .. "DMBorder"] == nil then
		local border = KeyRingButton:CreateTexture("KeyRingButton" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\krbtn_border")
		border:SetAllPoints(KeyRingButton)
		border:SetTexCoord(0, 0.5625, 0, 0.609375)
		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
	end

	if MinimapZoomIn and MinimapZoomOut and _G["MinimapZoomIn" .. "DMBorder"] == nil then
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

	if MiniMapTrackingFrame and _G["MiniMapTrackingFrame" .. "DMBorder"] == nil then
		-- Classic Era
		local border = MiniMapTrackingFrame:CreateTexture("MiniMapTrackingFrame" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT")
		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
	end

	if MiniMapTrackingButton and _G["MiniMapTrackingButton" .. "DMBorder"] == nil then
		-- Wrath
		local border = MiniMapTrackingButton:CreateTexture("MiniMapTrackingButton" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetDrawLayer("OVERLAY", 3)
		if border.SetScale then
			border:SetScale(0.86)
		end

		DarkMode:UpdateColor(border, "ui")
	end

	if MiniMapWorldMapButton and _G["MiniMapWorldMapButton" .. "DMBorder"] == nil then
		-- Wrath
		local border = MiniMapWorldMapButton:CreateTexture("MiniMapWorldMapButton" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetDrawLayer("OVERLAY", 3)
		if border.SetScale then
			border:SetScale(0.8)
		end

		DarkMode:UpdateColor(border, "ui")
	end

	if MiniMapMailFrame and _G["MiniMapMailFrame" .. "DMBorder"] == nil then
		local border = MiniMapMailFrame:CreateTexture("MiniMapMailFrame" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetDrawLayer("OVERLAY", 3)
		if border.SetScale then
			border:SetScale(0.8)
		end

		DarkMode:UpdateColor(border, "ui")
	end

	if GameTimeFrame and DarkMode:GetWoWBuild() ~= "RETAIL" and _G["GameTimeFrame" .. "DMBorder"] == nil then
		local border = GameTimeFrame:CreateTexture("GameTimeFrame" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\gt_border")
		if DarkMode:GetWoWBuild() == "WRATH" or DarkMode:GetWoWBuild() == "CATA" then
			border:SetPoint("TOPLEFT", -1, 1)
			if border.SetScale then
				border:SetScale(0.82)
			end
		else
			border:SetPoint("TOPLEFT")
		end

		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
	end

	C_Timer.After(
		1.1,
		function()
			DarkMode:Debug(5, "#6")
			local DMMMBTN = LibStub("LibDBIcon-1.0", true)
			if DMMMBTN then
				for i, name in pairs(DMMMBTN:GetButtonList()) do
					local btn = _G["LibDBIcon10_" .. name]
					if btn and _G[name .. "DMBorder"] == nil and DarkMode:IsEnabled("MASKMINIMAPBUTTONS", true) then
						local border = btn:CreateTexture(name .. "DMBorder", "OVERLAY")
						border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
						border:SetPoint("TOPLEFT", 0, 1)
						border:SetParent(btn)
						if border.SetScale then
							border:SetScale(0.84)
						end

						border:SetDrawLayer("OVERLAY", 3)
						DarkMode:UpdateColor(border, "ui")
					end
				end
			end

			if MiniMapLFGFrame then
				DarkMode:FindTextures(MiniMapLFGFrame, "ui")
			end

			if Lib_GPI_Minimap_LFGBulletinBoard then
				for i, v in pairs({Lib_GPI_Minimap_LFGBulletinBoard:GetRegions()}) do
					if i == 2 then
						DarkMode:UpdateColor(v, "ui")
					end
				end
			end

			if PeggledMinimapIcon and PeggledMinimapIcon.border then
				DarkMode:UpdateColor(PeggledMinimapIcon.border, "ui")
			end
		end
	)

	local btwQ = _G["BtWQuestsMinimapButton"]
	if btwQ and _G["BtWQuestsMinimapButton" .. "DMBorder"] == nil then
		local border = btwQ:CreateTexture("BtWQuestsMinimapButton" .. "DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetParent(btwQ)
		if border.SetScale then
			border:SetScale(0.9)
		end

		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
	end
end

local compactframes = {"CompactPartyFrameBorderFrame", "CompactRaidFrameContainerBorderFrame", "CompactRaidGroup1BorderFrame", "CompactRaidGroup2BorderFrame", "CompactRaidGroup3BorderFrame", "CompactRaidGroup4BorderFrame", "CompactRaidGroup5BorderFrame", "CompactRaidGroup6BorderFrame", "CompactRaidGroup7BorderFrame", "CompactRaidGroup8BorderFrame"}
for i = 1, 40 do
	table.insert(compactframes, "CompactRaidFrame" .. i .. "HorizDivider")
	table.insert(compactframes, "CompactRaidFrame" .. i .. "HorizTopBorder")
	table.insert(compactframes, "CompactRaidFrame" .. i .. "HorizBottomBorder")
	table.insert(compactframes, "CompactRaidFrame" .. i .. "VertLeftBorder")
	table.insert(compactframes, "CompactRaidFrame" .. i .. "VertRightBorder")
end

function DarkMode:CheckCompactFrames()
	local newTab = {}
	for i, v in pairs(compactframes) do
		if _G[v] then
			DarkMode:FindTexturesByName(v, "uf")
		else
			table.insert(newTab, v)
		end
	end

	compactframes = newTab
end

local rf = CreateFrame("FRAME")
rf:RegisterEvent("GROUP_ROSTER_UPDATE")
rf:SetScript(
	"OnEvent",
	function(self, event, name, ...)
		C_Timer.After(
			0.1,
			function()
				DarkMode:Debug(5, "#7")
				DarkMode:CheckCompactFrames()
			end
		)
	end
)

C_Timer.After(
	2,
	function()
		DarkMode:CheckCompactFrames()
	end
)

function DarkMode:ColorAuraButton(btn, index, btnName, from)
	if btn == nil then return end
	local name = btn:GetName()
	if name == nil then
		name = btnName
	end

	local icon = btn.Icon or btn
	if DarkMode:IsEnabled("THINBORDERS", false) then
		if btn and _G[name .. "Buff" .. index .. "BorderDM"] == nil and DarkMode:IsEnabled("MASKBUFFSANDDEBUFFS", true) then
			if btn.Icon then
				local br = 0.075
				btn.Icon:SetTexCoord(br, 1 - br, br, 1 - br)
			end

			_G[name .. "Buff" .. index .. "BorderDM"] = btn:CreateTexture(name .. "Buff" .. index .. "BorderDM", "OVERLAY")
			local border = _G[name .. "Buff" .. index .. "BorderDM"]
			border:SetDrawLayer("OVERLAY", 7)
			border:SetTexture("Interface\\AddOns\\DarkMode\\media\\border_thin")
			border:SetAllPoints(icon)
			DarkMode:UpdateColor(border, "buffsanddebuffs")
		end
	else
		if btn ~= nil and _G[name .. "Buff" .. index .. "BorderDM"] == nil and DarkMode:IsEnabled("MASKBUFFSANDDEBUFFS", true) then
			_G[name .. "Buff" .. index .. "BorderDM"] = btn:CreateTexture(name .. "Buff" .. index .. "BorderDM", "OVERLAY")
			local border = _G[name .. "Buff" .. index .. "BorderDM"]
			border:SetDrawLayer("OVERLAY", 7)
			border:SetTexture("Interface\\AddOns\\DarkMode\\media\\defaultbuff")
			border:SetAllPoints(icon)
			DarkMode:UpdateColor(border, "buffsanddebuffs")
		end
	end
end

if TargetFrame_UpdateBuffAnchor then
	hooksecurefunc(
		"TargetFrame_UpdateBuffAnchor",
		function(self, button, index)
			local name = "Target"
			if type(button) == "string" then
				local btn = _G[button .. index]
				if btn then
					if btn.unit == "focus" then
						name = "Focus"
					end

					DarkMode:ColorAuraButton(btn, index, name, "TargetFrame_UpdateBuffAnchor")
				end
			else
				local btn = button
				if btn then
					if btn.unit == "focus" then
						name = "Focus"
					end

					DarkMode:ColorAuraButton(btn, index, name, "TargetFrame_UpdateBuffAnchor")
				end
			end
		end
	)
end

local nameplateIds = {}
local failedNameplateIds = {}
local npf = CreateFrame("FRAME")
npf:RegisterEvent("NAME_PLATE_UNIT_ADDED")
function DarkMode:ColorNameplate(id)
	if nameplateIds[id] == nil and _G["NamePlate" .. id] then
		if _G["NamePlate" .. id]["UnitFrame"] and _G["NamePlate" .. id]["UnitFrame"]["healthBar"] then
			nameplateIds[id] = true
			DarkMode:FindTexturesByName("NamePlate" .. id .. ".UnitFrame.healthBar.border", "np")
			DarkMode:FindTexturesByName("NamePlate" .. id .. ".UnitFrame.CastBar.Border", "np")
			DarkMode:FindTexturesByName("NamePlate" .. id .. ".UnitFrame.CastBar.BorderShield", "np")
		elseif _G["NamePlate" .. id]["UnitFrame"] and _G["NamePlate" .. id]["UnitFrame"]["HealthBarsContainer"] then
			nameplateIds[id] = true
			DarkMode:FindTexturesByName("NamePlate" .. id .. ".UnitFrame.HealthBarsContainer", "np")
		end
	end

	return nameplateIds[id] ~= nil
end

npf:SetScript(
	"OnEvent",
	function(self, event, name, ...)
		if DarkMode:DMGV("COLORMODENP", 1) == 9 then return end
		local id = string.sub(name, 10)
		local worked = DarkMode:ColorNameplate(id)
		if not worked then
			C_Timer.After(
				0.16,
				function()
					worked = DarkMode:ColorNameplate(id)
					if not worked then
						C_Timer.After(
							0.31,
							function()
								worked = DarkMode:ColorNameplate(id)
								if not worked and failedNameplateIds[id] == nil then
									failedNameplateIds[id] = true
									--DarkMode:MSG("FAILED TO ADD DARKMODE ON NAMEPLATE", id, "If custom nameplates are installed, set Nameplates to 'Off' in DarkMode")
								end
							end
						)
					end
				end
			)
		end
	end
)

function DarkMode:InitQuestFrameGreetingPanel()
	local frame = DarkMode:GetFrame("QuestFrameGreetingPanel")
	function DarkMode:UpdateQuestFrameGreetingPanel()
		DarkMode:FindTextsByName("QuestFrameGreetingPanel")
	end

	if frame then
		frame:HookScript(
			"OnShow",
			function(sel, ...)
				C_Timer.After(
					0.05,
					function()
						DarkMode:Debug(5, "#12")
						DarkMode:UpdateQuestFrameGreetingPanel()
					end
				)
			end
		)

		if QuestFrame.OnEvent then
			hooksecurefunc(
				QuestFrame,
				"OnEvent",
				function()
					C_Timer.After(
						0.05,
						function()
							DarkMode:Debug(5, "#13")
							DarkMode:UpdateQuestFrameGreetingPanel()
						end
					)
				end
			)
		end
	end
end

function DarkMode:InitSlash()
	DarkMode:AddSlash("dm", DarkMode.ToggleSettings)
	DarkMode:AddSlash("dark", DarkMode.ToggleSettings)
	DarkMode:AddSlash("darkmode", DarkMode.ToggleSettings)
	if C_UI then
		DarkMode:AddSlash("rl", C_UI.Reload)
		DarkMode:AddSlash("rel", C_UI.Reload)
	else
		DarkMode:AddSlash("rl", ReloadUI)
		DarkMode:AddSlash("rel", ReloadUI)
	end
end

local AuraFrames = {}
local TargetBuffs = {}
local FocusBuffs = {}
local BuffFrameBuffs = {}
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
			DarkMode:InitQuestFrameGreetingPanel()
			C_Timer.After(
				1,
				function()
					DarkMode:Debug(5, "#14")
					DarkMode:GroupLootUpdate()
				end
			)

			local chatButtons = {
				["ChatFrame%sButtonFrameBottomButton"] = {0.77, -0.5, 0},
				["ChatFrame%sButtonFrameDownButton"] = {0.77, -0.5, 0},
				["ChatFrame%sButtonFrameUpButton"] = {0.77, -0.5, 0},
			}

			local chatSpecialButtons = {
				["ChatFrameMenuButton"] = {0.8, 0.77, 0, 0},
				["ChatFrameChannelButton"] = {0.94, 0.94, 0, 0},
				["FriendsMicroButton"] = {0.76, 0.98, -1, 0},
				["QuickJoinToastButton"] = {0.76, 0.98, -1, 0},
			}

			if ChatFrame1ButtonFrameBottomButton then
				for i = 1, 10 do
					for btnName, btnTab in pairs(chatButtons) do
						local btn = _G[format(btnName, i)]
						if btn then
							local scale = btnTab[1]
							local px = btnTab[2]
							local py = btnTab[3]
							local _, sh = btn:GetSize()
							sh = DarkMode:MathR(sh)
							btn.border = btn:CreateTexture(format(btnName, i) .. ".border", "OVERLAY")
							local border = btn.border
							border:SetDrawLayer("OVERLAY", 3)
							border:SetSize(sh * scale, sh * scale)
							border:SetTexture("Interface\\AddOns\\DarkMode\\media\\default")
							border:SetPoint("CENTER", btn, "CENTER", px, py)
							hooksecurefunc(
								btn,
								"SetNormalTexture",
								function(sel, texture)
									-- Leatrix Plus fix...
									if texture == "" then
										border:SetAlpha(0)
									end
								end
							)

							DarkMode:UpdateColor(border, "frames")
						end
					end
				end
			end

			for btnName, btnTab in pairs(chatSpecialButtons) do
				local btn = _G[btnName]
				if btn then
					local scalew = btnTab[1]
					local scaleh = btnTab[2]
					local px = btnTab[3]
					local py = btnTab[4]
					local sw, sh = btn:GetSize()
					sw = DarkMode:MathR(sw)
					sh = DarkMode:MathR(sh)
					btn.border = btn:CreateTexture(btnName .. ".border", "OVERLAY")
					local border = btn.border
					border:SetDrawLayer("OVERLAY", 3)
					border:SetSize(sw * scalew, sh * scaleh)
					border:SetTexture("Interface\\AddOns\\DarkMode\\media\\default")
					border:SetPoint("CENTER", btn, "CENTER", px, py)
					DarkMode:UpdateColor(border, "frames")
				end
			end

			if DarkMode:GetWoWBuild() ~= "RETAIL" then
				-- delay for other addons changing
				C_Timer.After(
					2,
					function()
						DarkMode:Debug(5, "#15")
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

							local MSQ = LibStub("Masque", true)
							if MSQ and bagF and v ~= "BagToggle" then
								if bagF.__MSQ_Mask then
									DarkMode:UpdateColor(bagF.__MSQ_Mask, "actionbuttons")
								end

								if bagF.__MSQ_Normal then
									DarkMode:UpdateColor(bagF.__MSQ_Normal, "actionbuttons")
								end

								if bagF.__MSQ_NewNormal then
									DarkMode:UpdateColor(bagF.__MSQ_NewNormal, "actionbuttons")
								end
							end
						end
					end
				)
			end

			if DarkMode:IsEnabled("MASKBUFFSANDDEBUFFS", true) then
				if AuraFrameMixin and AuraFrameMixin.Update then
					hooksecurefunc(
						AuraFrameMixin,
						"Update",
						function(sel)
							DarkMode:Debug(3, "AuraFrameMixin Update")
							for index, btn in pairs(sel.auraFrames) do
								if btn and AuraFrames[btn] == nil then
									AuraFrames[btn] = true
									DarkMode:Debug(3, "AuraFrameMixin Added btn", btn)
									local MSQ = LibStub("Masque", true)
									if MSQ and btn then
										if btn.__MSQ_Mask then
											DarkMode:UpdateColor(btn.__MSQ_Mask, "actionbuttons")
										end

										if btn.__MSQ_Normal then
											DarkMode:UpdateColor(btn.__MSQ_Normal, "actionbuttons")
										end

										if btn.__MSQ_NewNormal then
											DarkMode:UpdateColor(btn.__MSQ_NewNormal, "actionbuttons")
										end
									else
										DarkMode:ColorAuraButton(btn, index, "Aura", "AuraFrameMixin")
									end
								end
							end
						end
					)
				elseif BuffFrame_UpdateAllBuffAnchors then
					hooksecurefunc(
						"BuffFrame_UpdateAllBuffAnchors",
						function(sel, ...)
							DarkMode:Debug(3, "BuffFrame_UpdateAllBuffAnchors")
							local buttonName = "BuffButton"
							for index = 1, BUFF_ACTUAL_DISPLAY do
								local btn = _G[buttonName .. index]
								if btn and BuffFrameBuffs[index] == nil then
									BuffFrameBuffs[index] = true
									DarkMode:Debug(3, "BuffFrame_UpdateAllBuffAnchors Added index", index)
									local MSQ = LibStub("Masque", true)
									if MSQ then
										if btn.__MSQ_Mask then
											DarkMode:UpdateColor(btn.__MSQ_Mask, "actionbuttons")
										end

										if btn.__MSQ_Normal then
											DarkMode:UpdateColor(btn.__MSQ_Normal, "actionbuttons")
										end

										if btn.__MSQ_NewNormal then
											DarkMode:UpdateColor(btn.__MSQ_NewNormal, "actionbuttons")
										end
									else
										DarkMode:ColorAuraButton(btn, index, buttonName, "BuffFrame_UpdateAllBuffAnchors")
									end
								end
							end
						end
					)
				end

				if TargetFrame_UpdateAuras then
					hooksecurefunc(
						"TargetFrame_UpdateAuras",
						function(frame)
							DarkMode:Debug(3, "TargetFrame_UpdateAuras")
							local buttonName = frame:GetName() .. "Buff"
							for index = 1, 32 do
								local btn = _G[buttonName .. index]
								local MSQ = LibStub("Masque", true)
								if btn and ((frame == TargetFrame and TargetBuffs[index] == nil) or (frame == FocusFrame and FocusBuffs[index] == nil)) then
									if frame == TargetFrame then
										TargetBuffs[index] = true
									elseif frame == TargetFrame then
										FocusBuffs[index] = true
									end

									DarkMode:Debug(3, "TargetFrame_UpdateAuras Added index", index)
									if MSQ and btn then
										if btn.__MSQ_Mask then
											DarkMode:UpdateColor(btn.__MSQ_Mask, "actionbuttons")
										end

										if btn.__MSQ_Normal then
											DarkMode:UpdateColor(btn.__MSQ_Normal, "actionbuttons")
										end

										if btn.__MSQ_NewNormal then
											DarkMode:UpdateColor(btn.__MSQ_NewNormal, "actionbuttons")
										end
									else
										DarkMode:ColorAuraButton(btn, index, buttonName, "TargetFrame_UpdateAuras")
									end
								end
							end
						end
					)
				end
			end

			local castbars = {"TargetFrameSpellBar", "FocusFrameSpellBar"}
			for index, v in pairs(castbars) do
				local spellbar = _G[v]
				if spellbar then
					local icon = spellbar.Icon
					if icon then
						local scale = 1.1
						local sw, sh = icon:GetSize()
						sw = DarkMode:MathR(sw)
						sh = DarkMode:MathR(sh)
						local border = spellbar:CreateTexture(v .. ".BorderDM_T", "OVERLAY")
						border:SetSize(sw * scale, sh * scale)
						border:SetPoint("CENTER", icon, "CENTER", 0, 0)
						border:SetTexture("Interface\\AddOns\\DarkMode\\media\\default")
						border:SetDrawLayer("OVERLAY", 7)
						DarkMode:UpdateColor(border, "buffsanddebuffs")
					end
				end
			end

			C_Timer.After(
				0.1,
				function()
					DarkMode:Debug(5, "#16")
					DarkMode:SearchUi("setup")
					DarkMode:SearchFrames()
					for index, name in pairs(DarkMode:GetFrameTextTable()) do
						DarkMode:FindTextsByName(name)
					end

					if ItemTextPageText then
						hooksecurefunc(
							ItemTextPageText,
							"SetTextColor",
							function(sel, name, ...)
								if sel.dm_settextcolor then return end
								sel.dm_settextcolor = true
								local r, g, b, a = DarkMode:GetFrameColor(sel)
								local cr, cg, cb, ca = DarkMode:GetTextColor(r, g, b, a)
								sel:SetTextColor(name, cr, cg, cb, ca)
								sel.dm_settextcolor = false
							end
						)

						local r, g, b = 1, 1, 1
						ItemTextPageText:SetTextColor("P", r, g, b)
						ItemTextPageText:SetTextColor("H1", r, g, b)
						ItemTextPageText:SetTextColor("H2", r, g, b)
						ItemTextPageText:SetTextColor("H3", r, g, b)
					end
				end
			)

			--[[ SPECIALS ]]
			if DarkMode:GetWoWBuild() ~= "RETAIL" and FriendsFramePortrait then
				hooksecurefunc(
					FriendsFramePortrait,
					"Show",
					function()
						FriendsFramePortrait:Hide()
					end
				)

				FriendsFramePortrait:Hide()
			end

			if UIParent.SetFixedFrameStrata then
				C_Timer.After(
					1,
					function()
						DarkMode:CreateMinimapButton(
							{
								["name"] = "DarkMode",
								["icon"] = 136122,
								["dbtab"] = DMTAB,
								["vTT"] = {{"DarkMode |T136122:16:16:0:0|t", "v|cff3FC7EB0.5.108"}, {DarkMode:Trans("LEFTCLICK"), DarkMode:Trans("MMBTNLEFT")}, {DarkMode:Trans("RIGHTCLICK"), DarkMode:Trans("MMBTNRIGHT")}},
								["funcL"] = function()
									DarkMode:ToggleSettings()
								end,
								["funcR"] = function()
									DarkMode:SV(DMTAB, "MMBTN", false)
									DarkMode:HideMMBtn("DarkMode")
								end,
							}
						)

						if DarkMode:GV(DMTAB, "MMBTN", DarkMode:GetWoWBuild() ~= "RETAIL") then
							DarkMode:ShowMMBtn("DarkMode")
						else
							DarkMode:HideMMBtn("DarkMode")
						end
					end
				)
			end
		end
	elseif event == "ADDON_LOADED" then
		local from = ...
		DarkMode:AddonsSearch(from)
	elseif event == "START_LOOT_ROLL" then
		C_Timer.After(
			0.1,
			function()
				DarkMode:Debug(5, "#18")
				DarkMode:GroupLootUpdate()
			end
		)
	end
end

function DarkMode:GroupLootUpdate()
	for i, name in pairs(DarkMode:GetGroupLootTable()) do
		local gf = _G[name]
		if gf then
			DarkMode:UpdateColor(gf, "ui")
			for x, v in pairs(DarkMode:GetDMRepeatingFrames2()) do
				local texture = gf[v]
				if texture then
					DarkMode:UpdateColor(texture, "ui")
				end
			end
		end
	end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", DarkMode.Event)
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("START_LOOT_ROLL")
f.incombat = false
