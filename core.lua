local _, DarkMode = ...
local bShow = false
local MSQ = nil
DMHIDDEN = CreateFrame("FRAME", "DMHIDDEN")
DMHIDDEN:Hide()
local debugDisabled = true
local debug = 0
function DarkMode:Debug(num, msg, ...)
	if debugDisabled then return end
	if debug > 0 and debug == num or debug == 11 then
		DarkMode:DEB("[" .. debug .. "]", msg, ...)
	end
end

function DarkMode:IsValidTexture(obj)
	if obj.GetTexture and obj:GetTexture() ~= nil then return true end
	if obj.GetTextureFilePath and obj:GetTextureFilePath() ~= nil then return true end

	return false
end

local DMTexturesUi = {}
local DMTexturesUF = {}
local DMTexturesUFDR = {}
local DMTexturesNP = {}
local DMTexturesTT = {}
local DMTexturesFrames = {}
local DMTexturesFramesAddons = {}
local DMTexturesActionButtons = {}
local DMTexturesBags = {}
local DMTexturesMicroMenu = {}
local DMTexturesBuffsAndDebuffs = {}
local MMBTNSETUP = {}
function DarkMode:UpdateColor(texture, typ, from)
	if not DarkMode:IsValidTexture(texture) then return false end
	if texture == nil then
		DarkMode:MSG("[UpdateColor] INVALID TEXTURE OBJECT")

		return false
	end

	if debug == 10 then
		local name = DarkMode:GetName(texture)
		if name then
			DarkMode:Debug(10, "UpdateColor", "name:", name, "typ:", typ)
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
			local r, g, b, a = DarkMode:GetUiColor(texture, "UpdateColor 1")
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
		elseif typ == "ufdr" then
			local r, g, b, a = DarkMode:GetUFDRColor(texture)
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
		elseif typ == "bags" then
			local r, g, b, a = DarkMode:GetBagsColor(texture)
			if r ~= nil and g ~= nil and b ~= nil then
				if texture:GetAlpha() < 1 then
					a = texture:GetAlpha()
				end

				texture:SetColorTexture(r, g, b, a)
			end
		elseif typ == "micromenu" then
			local r, g, b, a = DarkMode:GetMicroMenuColor(texture)
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
		elseif typ == "addons" then
			local r, g, b, a = DarkMode:GetAddonsColor(texture)
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
						local r, g, b, a = DarkMode:GetUiColor(sel, "UpdateColor 2")
						if ola and ola < 1 then
							a = ola
						end

						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					elseif typ == "uf" then
						local r, g, b, a = DarkMode:GetUFColor(sel)
						if ola and ola < 1 then
							a = ola
						end

						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					elseif typ == "ufdr" then
						local r, g, b, a = DarkMode:GetUFDRColor(sel)
						if ola and ola < 1 then
							a = ola
						end

						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					elseif typ == "np" then
						local r, g, b, a = DarkMode:GetNPColor(sel)
						if ola and ola < 1 then
							a = ola
						end

						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					elseif typ == "tt" then
						local r, g, b, a = DarkMode:GetTTColor(sel)
						if ola and ola < 1 then
							a = ola
						end

						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					elseif typ == "actionbuttons" then
						local r, g, b, a = DarkMode:GetActionButtonsColor(sel)
						if ola and ola < 1 then
							a = ola
						end

						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					elseif typ == "bags" then
						local r, g, b, a = DarkMode:GetBagsColor(sel)
						if ola and ola < 1 then
							a = ola
						end

						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					elseif typ == "micromenu" then
						local r, g, b, a = DarkMode:GetMicroMenuColor(sel)
						if ola and ola < 1 then
							a = ola
						end

						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					elseif typ == "buffsanddebuffs" then
						local r, g, b, a = DarkMode:GetBuffsAndDebuffsColor(sel)
						if ola and ola < 1 then
							a = ola
						end

						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					elseif typ == "addons" then
						local r, g, b, a = DarkMode:GetAddonsColor(sel)
						if ola and ola < 1 then
							a = ola
						end

						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					else
						local r, g, b, a = DarkMode:GetFrameColor(sel)
						if ola and ola < 1 then
							a = ola
						end

						if r ~= nil and g ~= nil and b ~= nil then
							sel:SetVertexColor(r, g, b, a)
						end
					end

					sel.dm_setvertexcolor = false
				end
			)
		end

		local ola = 1
		if texture:GetAlpha() < 1 then
			ola = texture:GetAlpha()
		end

		if typ == "ui" then
			local r, g, b, a = DarkMode:GetUiColor(texture, "UpdateColor 3")
			if ola and ola < 1 then
				a = ola
			end

			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "uf" then
			local r, g, b, a = DarkMode:GetUFColor(texture)
			if ola and ola < 1 then
				a = ola
			end

			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "ufdr" then
			local r, g, b, a = DarkMode:GetUFDRColor(texture)
			if ola and ola < 1 then
				a = ola
			end

			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "np" then
			local r, g, b, a = DarkMode:GetNPColor(texture)
			if ola and ola < 1 then
				a = ola
			end

			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "tt" then
			local r, g, b, a = DarkMode:GetTTColor(texture)
			if ola and ola < 1 then
				a = ola
			end

			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "actionbuttons" then
			local r, g, b, a = DarkMode:GetActionButtonsColor(texture)
			if ola and ola < 1 then
				a = ola
			end

			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "bags" then
			local r, g, b, a = DarkMode:GetBagsColor(texture)
			if ola and ola < 1 then
				a = ola
			end

			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "micromenu" then
			local r, g, b, a = DarkMode:GetMicroMenuColor(texture)
			if ola and ola < 1 then
				a = ola
			end

			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "buffsanddebuffs" then
			local r, g, b, a = DarkMode:GetBuffsAndDebuffsColor(texture)
			if ola and ola < 1 then
				a = ola
			end

			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		elseif typ == "addons" then
			local r, g, b, a = DarkMode:GetAddonsColor(texture)
			if ola and ola < 1 then
				a = ola
			end

			if r ~= nil and g ~= nil and b ~= nil then
				texture:SetVertexColor(r, g, b, a)
			end
		else
			local r, g, b, a = DarkMode:GetFrameColor(texture)
			if ola and ola < 1 then
				a = ola
			end

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
		elseif typ == "ufdr" then
			if not tContains(DMTexturesUFDR, texture) then
				tinsert(DMTexturesUFDR, texture)
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
		elseif typ == "bags" then
			if not tContains(DMTexturesBags, texture) then
				tinsert(DMTexturesBags, texture)
			end
		elseif typ == "micromenu" then
			if not tContains(DMTexturesMicroMenu, texture) then
				tinsert(DMTexturesMicroMenu, texture)
			end
		elseif typ == "buffsanddebuffs" then
			if not tContains(DMTexturesBuffsAndDebuffs, texture) then
				tinsert(DMTexturesBuffsAndDebuffs, texture)
			end
		elseif typ == "frames" then
			if DMTexturesFrames[texture] == nil then
				DMTexturesFrames[texture] = texture
			end
		elseif typ == "addons" then
			if DMTexturesFramesAddons[texture] == nil then
				DMTexturesFramesAddons[texture] = texture
			end
		else
			DarkMode:MSG("[UpdateColor] Missing Type:", typ)
		end

		return true
	end

	return false
end

function DarkMode:AddActionButtonBorder(parent, btn, name, sizew, sizeh, px, py, typ, texture, actionbuttons)
	if name ~= "StanceButton" and name ~= "PetActionButton" and DarkMode:IsAddOnLoaded("DragonflightUi") then return end
	local icon = _G[name .. "Icon"]
	if icon then
		local br = 0.075
		if string.find(name, "PetActionButton", 1, true) then
			br = 0.052
		elseif string.find(name, "StanceButton", 1, true) then
			br = 0.075
		end

		icon:SetTexCoord(br, 1 - br, br, 1 - br)
	end

	if parent.border ~= nil then return end
	px = px or 0
	py = py or 0
	texture = texture or "Interface\\AddOns\\DarkMode\\media\\default"
	parent.border = parent:CreateTexture(name .. ".DMBorder", "OVERLAY")
	local border = parent.border
	border:SetDrawLayer("OVERLAY", 3)
	border:SetSize(sizew, sizeh)
	if string.find(name, "PetActionButton", 1, true) and DarkMode:IsEnabled("THINBORDERS", false) then
		border:SetScale(0.88)
	end

	if actionbuttons then
		if DarkMode:IsEnabled("THINBORDERS", false) then
			border:SetTexture("Interface\\AddOns\\DarkMode\\media\\border_thin")
		else
			border:SetTexture(texture)
		end
	else
		border:SetTexture(texture)
	end

	border:SetPoint("CENTER", btn, "CENTER", px, py)
	DarkMode:UpdateColor(border, typ)

	return border
end

local addonsDelay = 0
local addonsRetry = false
local foundMinimapTracking = false
local talentFrameFound = false
function DarkMode:UpdateSpellBook()
	DarkMode:FindTexts(PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.View1, "sb")
	DarkMode:FindTexts(PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.View2, "sb")
	DarkMode:FindTexts(PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.PagingControls, "sb")
end

function DarkMode:RetryAddonsSearch()
	if addonsRetry and GetTime() > addonsDelay then
		DarkMode:AddonsSearch("RETRY")
	end

	if not foundMinimapTracking and MiniMapTrackingBorder then
		foundMinimapTracking = true
		DarkMode:UpdateColor(MiniMapTrackingBorder, "addons")
	end

	if not talentFrameFound and PlayerSpellsFrame then
		talentFrameFound = true
		if PlayerSpellsFrame.TabSystem then
			DarkMode:ForeachChildren(
				PlayerSpellsFrame.TabSystem,
				function(child, x)
					DarkMode:FindTextures(child, "frames")
				end
			)
		end

		if PlayerSpellsFrame.SpellBookFrame then
			if PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem then
				DarkMode:ForeachChildren(
					PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem,
					function(child, x)
						DarkMode:FindTextures(child, "frames")
					end
				)
			end

			if PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame and PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.View1 and PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.PagingControls then
				hooksecurefunc(
					PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame,
					"ApplyLayout",
					function()
						DarkMode:After(
							0.15,
							function()
								DarkMode:UpdateSpellBook()
							end, "ApplyLoadout"
						)
					end
				)

				DarkMode:UpdateSpellBook()
			end
		end
	end

	if addonsRetry then
		DarkMode:After(
			0.12,
			function()
				DarkMode:Debug(7, "RetryAddonsSearch")
				DarkMode:RetryAddonsSearch()
			end, "RetryAddonsSearch addonsRetry"
		)
	else
		DarkMode:After(
			0.19,
			function()
				DarkMode:Debug(7, "RetryAddonsSearch")
				DarkMode:RetryAddonsSearch()
			end, "RetryAddonsSearch"
		)
	end
end

local foundTrinket = false
function DarkMode:TriggerTrinketMenu()
	DarkMode:ForeachChildren(
		TrinketMenu_MenuFrame,
		function(child, c)
			DarkMode:ForeachRegions(
				child,
				function(region, r)
					local name = DarkMode:GetName(region)
					if name and string.find(name, "NormalTexture", 1, true) then
						DarkMode:UpdateColor(region, "addons")
					end
				end
			)
		end
	)
end

function DarkMode:AddonsSearch(from)
	if GetTime() < addonsDelay then
		addonsRetry = true
		addonsDelay = GetTime() + 0.11

		return
	end

	if not debugDisabled then
		DarkMode:DEB("AddonsSearch", from)
	end

	addonsDelay = GetTime() + 0.11
	addonsRetry = false
	if foundTrinket == false and TrinketMenu_MenuFrame then
		foundTrinket = true
		TrinketMenu_MenuFrame:HookScript(
			"OnShow",
			function()
				DarkMode:TriggerTrinketMenu()
			end
		)

		TrinketMenu_MenuFrame:HookScript(
			"OnEnter",
			function()
				DarkMode:TriggerTrinketMenu()
			end
		)
	end

	DarkMode:After(
		0.13,
		function()
			DarkMode:Debug(5, "AddonsSearch")
			DarkMode:SearchAddons(from)
			if PlayerTalentFrame then
				for i, v in pairs({"PlayerSpecTab1", "PlayerSpecTab2", "PlayerSpecTab3", "PlayerSpecTab4"}) do
					local tab = _G[v]
					if tab then
						DarkMode:ForeachRegions(
							tab,
							function(region, x)
								if x == 1 then
									DarkMode:UpdateColor(region, "frames")
								end
							end, "AddonsSearch"
						)
					end
				end
			end

			if ClassTalentFrame and ClassTalentFrame.dm_setup_talent == nil then
				ClassTalentFrame.dm_setup_talent = true
				function ClassTalentFrame:UpdateColors()
					if ClassTalentFrame.TabSystem then
						DarkMode:ForeachChildren(
							ClassTalentFrame.TabSystem,
							function(child)
								DarkMode:ForeachRegions(
									child,
									function(region)
										DarkMode:UpdateColor(region, "frames")
									end, "ClassTalentFrame.TabSystem regions"
								)
							end, "ClassTalentFrame.TabSystem childs"
						)
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
		end, "AddonsSearch1"
	)
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

function DarkMode:FindTexts(frame, name, iter)
	iter = iter or 0
	if frame ~= nil then
		if frame.SetTextColor then
			DarkMode:UpdateText(frame, name, 1)
		else
			if frame.GetRegions then
				DarkMode:ForeachRegions(
					frame,
					function(region, x)
						if region.SetTextColor then
							DarkMode:UpdateText(region, name, 2)
						end

						if type(region) == "table" then
							DarkMode:FindTexts(region, name)
						end
					end, "FindTexts"
				)
			end

			if frame.GetChildren then
				DarkMode:ForeachChildren(
					frame,
					function(child)
						if child.SetTextColor then
							DarkMode:UpdateText(child, name, 3)
						end

						if type(child) == "table" then
							DarkMode:FindTexts(child, name, iter + 1)
						end
					end, "FindTexts"
				)
			end
		end
	end
end

function DarkMode:FindTextsByName(name)
	local frame = DarkMode:GetFrameByName(name)
	if frame and DarkMode:DMGV("COLORMODEF", 1) ~= 7 then
		DarkMode:FindTexts(frame, name)
	end
end

function DarkMode:UpdateColors()
	for i, v in pairs(DMTexturesUi) do
		local r, g, b, a = DarkMode:GetUiColor(v, "UpdateColors")
		if v:GetAlpha() and v:GetAlpha() < 1 then
			a = v:GetAlpha()
		end

		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end

	for i, v in pairs(DMTexturesUF) do
		local r, g, b, a = DarkMode:GetUFColor(v)
		if v:GetAlpha() and v:GetAlpha() < 1 then
			a = v:GetAlpha()
		end

		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end

	for i, v in pairs(DMTexturesUFDR) do
		local r, g, b, a = DarkMode:GetUFDRColor(v)
		if v:GetAlpha() and v:GetAlpha() < 1 then
			a = v:GetAlpha()
		end

		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end

	for i, v in pairs(DMTexturesTT) do
		local r, g, b, a = DarkMode:GetTTColor(v)
		if v:GetAlpha() and v:GetAlpha() < 1 then
			a = v:GetAlpha()
		end

		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end

	for i, v in pairs(DMFS) do
		local r, g, b, a = DarkMode:GetFrameColor(v)
		if v:GetAlpha() and v:GetAlpha() < 1 then
			a = v:GetAlpha()
		end

		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end

	for i, v in pairs(DMTexturesFramesAddons) do
		local r, g, b, a = DarkMode:GetAddonsColor(v)
		if v:GetAlpha() and v:GetAlpha() < 1 then
			a = v:GetAlpha()
		end

		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end

	for i, v in pairs(DMTexturesFrames) do
		local r, g, b, a = DarkMode:GetFrameColor(v)
		if v:GetAlpha() and v:GetAlpha() < 1 then
			a = v:GetAlpha()
		end

		if r ~= nil and g ~= nil and b ~= nil then
			v:SetVertexColor(r, g, b, a)
		end
	end
end

function DarkMode:FindTextures(frame, typ, findName, show)
	if frame == nil then return end
	local ignoreId1 = nil
	local ignoreId2 = nil
	local ignoreId3 = nil
	local name = DarkMode:GetName(frame)
	if frame and frame ~= StoreFrame and name then
		if string.find(name, "SkillLineTab") then
			ignoreId1 = 2
			ignoreId2 = 3
			ignoreId3 = 4
		elseif string.find(name, "XX") then
			ignoreId1 = 2
		end
	end

	if frame and frame ~= StoreFrame and name and DarkMode:GetIgnoreFrames(name) then return end
	if frame.SetVertexColor then
		if findName == nil then
			DarkMode:UpdateColor(frame, typ)
		else
			if findName == DarkMode:GetName(frame) then return frame end
		end

		if show then
			DarkMode:INFO("#1", "[" .. DarkMode:GetName(frame, true) .. "]")
		end
	end

	if frame.GetRegions then
		local ret = DarkMode:ForeachRegions(
			frame,
			function(region, x)
				local regionName = DarkMode:GetName(frame)
				if (ignoreId1 == nil or ignoreId1 ~= x) and (ignoreId2 == nil or ignoreId2 ~= x) and (ignoreId3 == nil or ignoreId3 ~= x) and ((regionName or not DarkMode:GetIgnoreFrames(regionName)) or (not regionName and region.SetVertexColor)) then
					if bShow and region.GetTexture then
						DarkMode:MSG(">>", fname, regionName, region:GetTextureFilePath(), region:GetTexture(), "Size:", region:GetSize())
					end

					if not hasName or (hasName and not DarkMode:GetIgnoreTextureName(regionName)) then
						if findName == nil then
							DarkMode:UpdateColor(region, typ)
						else
							if findName == DarkMode:GetName(region) then return region end
						end

						if show then
							DarkMode:INFO("#2", "[" .. DarkMode:GetName(region, true) .. "]")
						end
					end
				end
			end, "FindTextures"
		)

		if ret then return ret end
	end

	if frame.GetChildren then
		local ret = DarkMode:ForeachChildren(
			frame,
			function(child, i)
				local childName = DarkMode:GetName(child)
				if (ignoreId1 == nil or ignoreId1 ~= i) and (ignoreId2 == nil or ignoreId2 ~= i) and (ignoreId3 == nil or ignoreId3 ~= i) and ((C_Widget.IsWidget(child) and not DarkMode:GetIgnoreFrames(childName)) or (not C_Widget.IsWidget(child) and child.SetVertexColor)) then
					if bShow and child.GetTexture then
						DarkMode:MSG(">>>", name, childName, child:GetTextureFilePath(), child:GetTexture(), "Size:", child:GetSize())
					end

					if not hasName or (hasName and not DarkMode:GetIgnoreTextureName(childName)) then
						if findName == nil then
							DarkMode:UpdateColor(child, typ)
						else
							if findName == DarkMode:GetName(child) then return child end
						end

						if show then
							DarkMode:INFO("#3", "[" .. DarkMode:GetName(child, true) .. "]")
						end
					end
				end
			end, "FindTextures"
		)

		if ret then return ret end
	end
end

function DarkMode:FindTexturesByName(name, typ)
	DarkMode:Debug(10, "FindTexturesByName", name)
	local frame = DarkMode:GetFrameByName(name)
	if frame then
		DarkMode:FindTextures(frame, typ)
	end
end

local questDelay = 0.2
function DarkMode:InitGreetingPanel()
	local frame = DarkMode:GetFrameByName("GossipFrame.GreetingPanel.ScrollBox.ScrollTarget")
	local frameTab = {"GossipFrame", "GossipFrame.GreetingPanel", "GossipFrame.GreetingPanel.ScrollBox", "GossipFrame.GreetingPanel.ScrollBar.Background",}
	function DarkMode:UpdateGossipFrame()
		if frame == GossipFrame then
			DarkMode:FindTextsByName("GossipFrame")
		else
			DarkMode:FindTextsByName("GossipFrame.GreetingPanel.ScrollBox.ScrollTarget")
		end

		for index, name in pairs(frameTab) do
			for x, v in pairs(DarkMode:GetDMRepeatingFrames()) do
				DarkMode:FindTexturesByName(name .. v, "frames")
			end
		end
	end

	if frame == nil then
		frame = DarkMode:GetFrameByName("GossipFrame")
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
				DarkMode:After(
					questDelay,
					function()
						DarkMode:Debug(5, "InitGreetingPanel 1")
						DarkMode:UpdateGossipFrame()
					end, "InitGreetingPanel1"
				)
			end
		)

		if GossipFrame.OnEvent then
			hooksecurefunc(
				GossipFrame,
				"OnEvent",
				function()
					DarkMode:After(
						questDelay,
						function()
							DarkMode:Debug(5, "InitGreetingPanel 2")
							DarkMode:UpdateGossipFrame()
						end, "InitGreetingPanel2"
					)
				end
			)
		end
	end
end

function DarkMode:InitQuestLogFrame()
	local frame = DarkMode:GetFrameByName("QuestLogFrame")
	function DarkMode:UpdateQuestLogFrame()
		for index, name in pairs(DarkMode:GetFrameTextTable()) do
			DarkMode:FindTextsByName(name)
		end
	end

	if frame then
		frame:HookScript(
			"OnShow",
			function(sel)
				DarkMode:After(
					questDelay,
					function()
						DarkMode:Debug(5, "InitQuestLogFrame 1")
						DarkMode:UpdateQuestLogFrame()
					end, "InitQuestLogFrame1"
				)
			end
		)

		if frame.OnEvent then
			hooksecurefunc(
				frame,
				"OnEvent",
				function()
					DarkMode:After(
						questDelay,
						function()
							DarkMode:Debug(5, "InitQuestLogFrame 2")
							DarkMode:UpdateQuestLogFrame()
						end, "InitQuestLogFrame2"
					)
				end
			)
		end
	end

	if WorldMapFrame then
		local findNames = false
		local foundNames = {}
		function DarkMode:UpdateQuestMapFrame()
			if findNames then
				for index, name in pairs(DarkMode:GetFrameTextTable()) do
					if _G[name] and foundNames[name] == nil then
						foundNames[name] = true
						DarkMode:FindTextsByName(name)
					end
				end

				DarkMode:After(
					0.2,
					function()
						DarkMode:UpdateQuestMapFrame()
					end, "UpdateQuestMapFrame 1"
				)
			else
				DarkMode:After(
					0.7,
					function()
						DarkMode:UpdateQuestMapFrame()
					end, "UpdateQuestMapFrame 2"
				)
			end
		end

		WorldMapFrame:HookScript(
			"OnShow",
			function(sel)
				findNames = true
			end
		)

		WorldMapFrame:HookScript(
			"OnHide",
			function(sel)
				findNames = false
			end
		)

		DarkMode:UpdateQuestMapFrame()
	end
end

function DarkMode:SearchFrames()
	for index, frame in pairs(DarkMode:GetFrameTableSpecial()) do
		DarkMode:UpdateColor(frame, "frames")
	end

	for index, name in pairs(DarkMode:GetFrameTable()) do
		if name ~= "LootFrame" then
			for x, v in pairs(DarkMode:GetDMRepeatingFrames()) do
				DarkMode:FindTexturesByName(name .. v, "frames")
			end
		else
			for x, v in pairs(DarkMode:GetDMRepeatingFrames()) do
				-- BottomLeft and BottomRight Corner 
				if v ~= ".Bg" and v ~= ".Background" then
					DarkMode:FindTexturesByName(name .. v, "frames")
				end
			end
		end
	end
end

local foundAuctionator = false
local foundExpansion = false
function DarkMode:SearchAddons(from)
	if AuctionatorAHTabsContainer ~= nil and AuctionatorAHTabsContainer.Tabs ~= nil and foundAuctionator == false then
		foundAuctionator = true
		for x, v in pairs(AuctionatorAHTabsContainer.Tabs) do
			DarkMode:FindTextures(v, "addons")
		end
	end

	if AuctionatorShoppingFrame then
		if AuctionatorShoppingFrame.ListsContainer and AuctionatorShoppingFrame.ListsContainer.ScrollBar and AuctionatorShoppingFrame.ListsContainer.ScrollBar.Background then
			DarkMode:FindTextures(AuctionatorShoppingFrame.ListsContainer.ScrollBar.Background, "addons")
		end

		if AuctionatorShoppingFrame.ResultsListing and AuctionatorShoppingFrame.ResultsListing.ScrollArea and AuctionatorShoppingFrame.ResultsListing.ScrollArea.ScrollBar and AuctionatorShoppingFrame.ResultsListing.ScrollArea.ScrollBar.Background then
			DarkMode:FindTextures(AuctionatorShoppingFrame.ResultsListing.ScrollArea.ScrollBar.Background, "addons")
		end
	end

	if AuctionatorBuyFrame and AuctionatorBuyFrame.CurrentPrices and AuctionatorBuyFrame.CurrentPrices.SearchResultsListing and AuctionatorBuyFrame.CurrentPrices.SearchResultsListing.ScrollArea and AuctionatorBuyFrame.CurrentPrices.SearchResultsListing.ScrollArea.ScrollBar and AuctionatorBuyFrame.CurrentPrices.SearchResultsListing.ScrollArea.ScrollBar.Background then
		DarkMode:FindTextures(AuctionatorBuyFrame.CurrentPrices.SearchResultsListing.ScrollArea.ScrollBar.Background, "addons")
	end

	if AuctionatorSellingFrame then
		if AuctionatorSellingFrame.BagListing and AuctionatorSellingFrame.BagListing.View and AuctionatorSellingFrame.BagListing.View.ScrollBar and AuctionatorSellingFrame.BagListing.View.ScrollBar.Background then
			DarkMode:FindTextures(AuctionatorSellingFrame.BagListing.View.ScrollBar.Background, "addons")
		end

		if AuctionatorSellingFrame.BuyFrame and AuctionatorSellingFrame.BuyFrame.CurrentPrices and AuctionatorSellingFrame.BuyFrame.CurrentPrices.SearchResultsListing and AuctionatorSellingFrame.BuyFrame.CurrentPrices.SearchResultsListing.ScrollArea and AuctionatorSellingFrame.BuyFrame.CurrentPrices.SearchResultsListing.ScrollArea.ScrollBar and AuctionatorSellingFrame.BuyFrame.CurrentPrices.SearchResultsListing.ScrollArea.ScrollBar.Background then
			DarkMode:FindTextures(AuctionatorSellingFrame.BuyFrame.CurrentPrices.SearchResultsListing.ScrollArea.ScrollBar.Background, "addons")
		end
	end

	if AuctionatorCancellingFrame and AuctionatorCancellingFrame.ResultsListing and AuctionatorCancellingFrame.ResultsListing.ScrollArea and AuctionatorCancellingFrame.ResultsListing.ScrollArea.ScrollBar and AuctionatorCancellingFrame.ResultsListing.ScrollArea.ScrollBar.Background then
		DarkMode:FindTextures(AuctionatorCancellingFrame.ResultsListing.ScrollArea.ScrollBar.Background, "addons")
	end

	for index, name in pairs(DarkMode:GetFrameAddonsTable()) do
		for x, v in pairs(DarkMode:GetDMRepeatingFrames()) do
			DarkMode:FindTexturesByName(name .. v, "addons")
		end
	end

	if DarkMode:IsEnabled("COLORBUTTONS", true) then
		for index, name in pairs({"RankerToggleButton", "RankerWhatIfButton"}) do
			for x, v in pairs(DarkMode:GetDMRepeatingFrames()) do
				DarkMode:FindTexturesByName(name .. v, "addons")
			end
		end
	end

	if not foundExpansion and ExpansionLandingPage and ExpansionLandingPage.Overlay then
		DarkMode:ForeachChildren(
			ExpansionLandingPage.Overlay,
			function(child)
				foundExpansion = true
				DarkMode:FindTextures(child.NineSlice, "ui")
			end, "SearchAddons"
		)
	end

	for index, name in pairs(DarkMode:GetUiAddonsTable()) do
		DarkMode:FindTexturesByName(name, "ui")
	end
end

function DarkMode:SearchUi(from)
	if not debugDisabled then
		DarkMode:DEB("SearchUi", from)
	end

	local raidOnly = from == "raid"
	if TotemFrame then
		for i = 1, 4 do
			local totem = _G["TotemFrameTotem" .. i]
			if totem then
				DarkMode:ForeachChildren(
					totem,
					function(child, c)
						if child and DarkMode:GetName(child) == nil then
							DarkMode:ForeachRegions(
								child,
								function(region, r)
									if region and r == 1 then
										DarkMode:UpdateColor(region, "ui")
									end
								end
							)
						end
					end
				)
			end
		end
	end

	for index, tab in pairs(DarkMode:GetUiTable()) do
		if raidOnly and index == "UnitFrames" then
			for x, v in pairs(tab) do
				DarkMode:FindTexturesByName(v, "uf")
			end
		else
			if index == "ActionButtons" then
				for i, name in pairs(tab) do
					local max = 12
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
							DarkMode:AddActionButtonBorder(btn, btn, name .. x, sw * scale, sh * scale, 0, 0, "actionbuttons", nil, true)
						elseif btnTextureNormalTexture then
							DarkMode:UpdateColor(btnTextureNormalTexture, "actionbuttons")
						end

						if LibStub and MSQ == nil then
							MSQ = LibStub("Masque", true)
						end

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
								elseif name == "StanceButton" then
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

								if btn and btn.border == nil then
									local sw, sh = btn:GetSize()
									sw = DarkMode:MathR(sw)
									sh = DarkMode:MathR(sh)
									local scale = 1
									if name == "PetActionButton" then
										scale = 1.2
									end

									DarkMode:AddActionButtonBorder(btn, btn, name .. x, sw * scale, sh * scale, 0, 0, "actionbuttons", "Interface\\AddOns\\DarkMode\\media\\defaultEER", true)
								end
							elseif DarkMode:GetWoWBuild() ~= "RETAIL" and (DarkMode:IsEnabled("MASKACTIONBUTTONS", true) or name == "PetActionButton" or name == "StanceButton") and DarkMode:DMGV("COLORMODEAB", 1) ~= "Off" and DarkMode:DMGV("COLORMODEAB", 1) ~= "Default" then
								local icon = _G[name .. x .. "Icon"]
								if icon then
									local br = 0.012
									icon:SetTexCoord(br, 1 - br, br, 1 - br)
								end

								if btn and _G[name .. x .. ".DMBorder"] == nil then
									local sw, sh = btn:GetSize()
									sw = DarkMode:MathR(sw)
									sh = DarkMode:MathR(sh)
									local scale = 1.1
									DarkMode:AddActionButtonBorder(btn, btn, name, sw * scale, sh * scale, 0, 0, "actionbuttons", "Interface\\AddOns\\DarkMode\\media\\defaultEER", true)
								end
							end
						end
					end
				end
			elseif index == "Minimap" or index == "Artworks" or index == "Chat" or index == "Castbar" then
				for ind, name in pairs(tab) do
					if index == "Artworks" and name == "BT4BarBlizzardArt.nineSliceParent" then
						local frame = DarkMode:GetFrameByName(name)
						if frame then
							DarkMode:ForeachChildren(
								ExpansionLandingPage.Overlay,
								function(child, x)
									if x == 1 then
										DarkMode:FindTextures(child, "ui") -- Bartender Border in BlizzardArt
									end
								end, "Artworks"
							)
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
				DarkMode:MSG("[SearchUi] Missing Ui index:", index, tab)
			end
		end
	end

	if MICRO_BUTTONS then
		local mode = DarkMode:DMGV("COLORMODEMI", 1)
		if mode ~= 7 and mode ~= 9 then
			for i, name in pairs(MICRO_BUTTONS) do
				if name then
					local mbtn = _G[name]
					if mbtn and _G[name .. ".DMBorder"] == nil then
						if mbtn.Background and MMBTNSETUP[mbtn.Background] == nil then
							MMBTNSETUP[mbtn.Background] = true
							local border = mbtn:CreateTexture(name .. ".DMBorder", "OVERLAY")
							border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mbtn_border")
							border:SetSize(32, 64)
							border:SetPoint("CENTER", mbtn.Background, "CENTER", 0, 10)
							DarkMode:UpdateColor(border, "micromenu")
						else
							local border = mbtn:CreateTexture(name .. ".DMBorder", "OVERLAY")
							border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mbtn_border")
							border:SetAllPoints(mbtn)
							DarkMode:UpdateColor(border, "micromenu")
						end
					end
				end
			end
		end
	end

	if MinimapZoomIn and MinimapZoomOut and _G["MinimapZoomIn" .. ".DMBorder"] == nil and not DarkMode:IsAddOnLoaded("DragonflightUI") then
		local border = MinimapZoomIn:CreateTexture("MinimapZoomIn" .. ".DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\zoom_border")
		border:SetAllPoints(MinimapZoomIn)
		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
		local border2 = MinimapZoomOut:CreateTexture("MinimapZoomOut" .. ".DMBorder", "OVERLAY")
		border2:SetTexture("Interface\\AddOns\\DarkMode\\media\\zoom_border")
		border2:SetAllPoints(MinimapZoomOut)
		border2:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border2, "ui")
	end

	if MiniMapTrackingFrame and _G["MiniMapTrackingFrame" .. ".DMBorder"] == nil then
		-- Classic Era
		local border = MiniMapTrackingFrame:CreateTexture("MiniMapTrackingFrame" .. ".DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT")
		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
	end

	if MiniMapTrackingButton and _G["MiniMapTrackingButton" .. ".DMBorder"] == nil and not DarkMode:IsAddOnLoaded("DragonflightUI") then
		-- Wrath
		local border = MiniMapTrackingButton:CreateTexture("MiniMapTrackingButton" .. ".DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetDrawLayer("OVERLAY", 3)
		if border.SetScale then
			border:SetScale(0.86)
		end

		DarkMode:UpdateColor(border, "ui")
	end

	if MiniMapWorldMapButton and _G["MiniMapWorldMapButton" .. ".DMBorder"] == nil and DarkMode:GetWoWBuild() == "WRATH" then
		local border = MiniMapWorldMapButton:CreateTexture("MiniMapWorldMapButton" .. ".DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetDrawLayer("OVERLAY", 3)
		if border.SetScale then
			border:SetScale(0.8)
		end

		DarkMode:UpdateColor(border, "ui")
	end

	if MiniMapMailFrame and _G["MiniMapMailFrame" .. ".DMBorder"] == nil then
		local border = MiniMapMailFrame:CreateTexture("MiniMapMailFrame" .. ".DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetDrawLayer("OVERLAY", 3)
		if border.SetScale then
			border:SetScale(0.8)
		end

		DarkMode:UpdateColor(border, "ui")
	end

	if GameTimeFrame and DarkMode:GetWoWBuild() ~= "RETAIL" and _G["GameTimeFrame" .. ".DMBorder"] == nil then
		local border = GameTimeFrame:CreateTexture("GameTimeFrame" .. ".DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\gt_border")
		if DarkMode:GetWoWBuild() ~= "CLASSIC" then
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

	DarkMode:After(
		1.1,
		function()
			DarkMode:Debug(5, "SearchUi")
			for i, btn in pairs(_G) do
				if (strfind(i, "LibDBIcon10_", 1, true) or strfind(i, "MinimapButton_D4Lib_", 1, true) or strfind(i, "LFGMinimapFrame", 1, true)) and not strfind(i, ".DMBorder", 1, true) then
					local name = DarkMode:GetName(btn)
					if btn and _G[name .. ".DMBorder"] == nil and btn.CreateTexture ~= nil and DarkMode:IsEnabled("MASKMINIMAPBUTTONS", true) and (btn.border == nil or btn.border == true) then
						btn.border = btn:CreateTexture(name .. ".DMBorder", "OVERLAY")
						local border = btn.border
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
				DarkMode:ForeachRegions(
					Lib_GPI_Minimap_LFGBulletinBoard,
					function(region, x)
						if x == 2 then
							DarkMode:UpdateColor(region, "ui")
						end
					end, "Lib_GPI_Minimap_LFGBulletinBoard"
				)
			end

			if PeggledMinimapIcon and PeggledMinimapIcon.border then
				DarkMode:UpdateColor(PeggledMinimapIcon.border, "ui")
			end
		end, "SearchUi"
	)

	local btwQ = _G["BtWQuestsMinimapButton"]
	if btwQ and _G["BtWQuestsMinimapButton" .. ".DMBorder"] == nil then
		local border = btwQ:CreateTexture("BtWQuestsMinimapButton" .. ".DMBorder", "OVERLAY")
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
		DarkMode:After(
			0.15,
			function()
				DarkMode:Debug(5, "GROUP_ROSTER_UPDATE")
				DarkMode:CheckCompactFrames()
			end, "GROUP_ROSTER_UPDATE"
		)
	end
)

DarkMode:After(
	2,
	function()
		DarkMode:Debug(5, "CheckCompactFrames")
		DarkMode:CheckCompactFrames()
	end, "CheckCompactFrames"
)

function DarkMode:ColorAuraButton(btn, index, btnName, from)
	if btn == nil then return end
	local name = DarkMode:GetName(btn)
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
			border:SetTexture("Interface\\AddOns\\DarkMode\\media\\defaultbuff2")
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
			DarkMode:After(
				0.16,
				function()
					DarkMode:Debug(5, "NAME_PLATE_UNIT_ADDED 1")
					worked = DarkMode:ColorNameplate(id)
					if not worked then
						DarkMode:After(
							0.31,
							function()
								DarkMode:Debug(5, "NAME_PLATE_UNIT_ADDED 2")
								worked = DarkMode:ColorNameplate(id)
								if not worked and failedNameplateIds[id] == nil then
									failedNameplateIds[id] = true
									--DarkMode:MSG("FAILED TO ADD DARKMODE ON NAMEPLATE", id, "If custom nameplates are installed, set Nameplates to 'Off' in DarkMode")
								end
							end, "NAME_PLATE_UNIT_ADDED 2"
						)
					end
				end, "NAME_PLATE_UNIT_ADDED 1"
			)
		end
	end
)

function DarkMode:InitQuestFrameGreetingPanel()
	local frame = DarkMode:GetFrameByName("QuestFrameGreetingPanel")
	function DarkMode:UpdateQuestFrameGreetingPanel()
		DarkMode:FindTextsByName("QuestFrameGreetingPanel")
	end

	if frame then
		frame:HookScript(
			"OnShow",
			function(sel, ...)
				DarkMode:After(
					questDelay,
					function()
						DarkMode:Debug(5, "InitQuestFrameGreetingPanel 1")
						DarkMode:UpdateQuestFrameGreetingPanel()
					end, "InitQuestFrameGreetingPanel 1"
				)
			end
		)

		if QuestFrame.OnEvent then
			hooksecurefunc(
				QuestFrame,
				"OnEvent",
				function()
					DarkMode:After(
						questDelay,
						function()
							DarkMode:Debug(5, "InitQuestFrameGreetingPanel 2")
							DarkMode:UpdateQuestFrameGreetingPanel()
						end, "InitQuestFrameGreetingPanel 2"
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
local BAGS = {"MainMenuBarBackpackButton", "CharacterBag0Slot", "CharacterBag1Slot", "CharacterBag2Slot", "CharacterBag3Slot", "DominosKeyRingButton", "KeyRingButton", "CharacterReagentBag0Slot"}
DarkMode:After(
	4,
	function()
		DarkMode:Debug(3, "startSearch 1")
		DarkMode:AddonsSearch("startSearch 1")
	end, "startSearch 1"
)

DarkMode:After(
	8,
	function()
		DarkMode:Debug(3, "startSearch 2")
		DarkMode:AddonsSearch("startSearch 2")
	end, "startSearch 2"
)

function DarkMode:Event(event, ...)
	if event == "PLAYER_LOGIN" then
		if DarkMode.Setup == nil then
			DarkMode.Setup = true
			local foundBugSack = false
			hooksecurefunc(
				"CreateFrame",
				function(typ, name, parent, template)
					if BugSackFrame and foundBugSack == false and strlower(typ) == "frame" then
						foundBugSack = true
						DarkMode:After(
							0.02,
							function()
								DarkMode:Debug(5, "foundBugSack")
								DarkMode:FindTextures(BugSackFrame, "addons")
							end, "foundBugSack"
						)
					end
				end
			)

			DarkMode:InitSlash()
			DarkMode:InitDB()
			DarkMode:InitDMSettings()
			DarkMode:InitGreetingPanel()
			DarkMode:InitQuestLogFrame()
			DarkMode:InitQuestFrameGreetingPanel()
			DarkMode:After(
				1,
				function()
					DarkMode:Debug(5, "GroupLootUpdate")
					DarkMode:GroupLootUpdate()
				end, "GroupLootUpdate"
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
							DarkMode:AddActionButtonBorder(btn, btn, format(btnName, i), sh * scale, sh * scale, px, py, "ui", nil, false)
							hooksecurefunc(
								btn,
								"SetNormalTexture",
								function(sel, texture)
									-- Leatrix Plus fix...
									if texture == "" then
										btn.border:SetAlpha(0)
									end
								end
							)
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
					DarkMode:AddActionButtonBorder(btn, btn, btnName, sh * scalew, sh * scaleh, px, py, "ui", nil, false)
				end
			end

			if DarkMode:GetWoWBuild() ~= "RETAIL" then
				-- delay for other addons changing
				DarkMode:After(
					2,
					function()
						DarkMode:Debug(5, "BAGS ~= RETAIL")
						local mode = DarkMode:DMGV("COLORMODEBA", 1)
						if mode ~= 7 and mode ~= 9 then
							for i, v in pairs(BAGS) do
								local bagF = _G[v]
								local NT = _G[v .. "NormalTexture"]
								if bagF then
									local sw, sh = bagF:GetSize()
									if NT and NT.scalesetup == nil then
										NT.scalesetup = true
										if NT:GetTexture() == 130841 then
											local scale = 1.66
											NT:SetSize(sw * scale, sh * scale)
										end
									end

									local scale = 1.1
									if v == "KeyRingButton" then
										scale = 1
									end

									if false then
										scale = 1.18
									end

									DarkMode:AddActionButtonBorder(bagF, bagF, v, sw * scale, sh * scale, 0, 0, "bags", nil, false)
									if LibStub and MSQ == nil then
										MSQ = LibStub("Masque", true)
									end

									if MSQ and bagF and v ~= "BagToggle" then
										if bagF.__MSQ_Mask then
											DarkMode:UpdateColor(bagF.__MSQ_Mask, "bags")
										end

										if bagF.__MSQ_Normal then
											DarkMode:UpdateColor(bagF.__MSQ_Normal, "bags")
										end

										if bagF.__MSQ_NewNormal then
											DarkMode:UpdateColor(bagF.__MSQ_NewNormal, "bags")
										end
									end
								end
							end
						end
					end, "BAGS"
				)

				function string:dm_endswith(suffix)
					return self:sub(-#suffix) == suffix
				end

				if TargetFrameTextureFrame and TargetFrameTextureFrameTexture then
					TargetFrameDragon = TargetFrameTextureFrame:CreateTexture("TargetFrameDragon", "BACKGROUND")
					TargetFrameDragon:SetSize(256, 128)
					TargetFrameDragon:SetPoint("TOPRIGHT", TargetFrameTextureFrame, "TOPRIGHT", 0, 0)
					hooksecurefunc(
						TargetFrameTextureFrameTexture,
						"SetTexture",
						function(sel, texture)
							TargetFrameDragon:SetDrawLayer("BACKGROUND", 1)
							if texture:dm_endswith("UI-TargetingFrame-Rare") then
								TargetFrameDragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Rare_Dragon")
							elseif texture:dm_endswith("UI-TargetingFrame-Elite") then
								TargetFrameDragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Elite_Dragon")
							elseif texture:dm_endswith("UI-TargetingFrame-Rare-Elite") then
								TargetFrameDragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Rare-Elite_Dragon")
							else
								TargetFrameDragon:SetTexture("")
							end
						end
					)

					TargetFrameDragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Rare-Elite_Dragon")
					DarkMode:UpdateColor(TargetFrameDragon, "ufdr")
					TargetFrameDragon:SetTexture("")
				end

				if PlayerFrame and PlayerFrameTexture then
					local parent = DarkMode:GetParent(PlayerFrameTexture)
					if parent then
						PlayerFrameDragon = parent:CreateTexture("PlayerFrameDragon", "BORDER")
						PlayerFrameDragon:SetTexCoord(1, 0, 0, 1)
						PlayerFrameDragon:SetSize(256, 128)
						PlayerFrameDragon:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
						hooksecurefunc(
							PlayerFrameTexture,
							"SetTexture",
							function(sel, texture)
								PlayerFrameDragon:SetDrawLayer("BORDER", 1)
								if texture:dm_endswith("UI-TargetingFrame-Rare") or texture:dm_endswith("UI-TargetingFrame-Rare.blp") then
									PlayerFrameDragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Rare_Dragon")
								elseif texture:dm_endswith("UI-TargetingFrame-Elite") or texture:dm_endswith("UI-TargetingFrame-Elite.blp") then
									PlayerFrameDragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Elite_Dragon")
								elseif texture:dm_endswith("UI-TargetingFrame-Rare-Elite") or texture:dm_endswith("UI-TargetingFrame-Rare-Elite.blp") then
									PlayerFrameDragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Rare-Elite_Dragon")
								elseif texture:dm_endswith("Leatrix_Plus-Rare.blp") then
									PlayerFrameDragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Rare_Dragon")
								elseif texture:dm_endswith("Leatrix_Plus-Elite.blp") then
									PlayerFrameDragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Elite_Dragon")
								elseif texture:dm_endswith("Leatrix_Plus.blp") then
									PlayerFrameDragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Rare-Elite_Dragon")
								else
									PlayerFrameDragon:SetTexture("")
								end
							end
						)

						PlayerFrameDragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Rare-Elite_Dragon")
						DarkMode:UpdateColor(PlayerFrameDragon, "ufdr")
						PlayerFrameDragon:SetTexture("")
					end
				end
			else
				-- delay for other addons changing
				DarkMode:After(
					1,
					function()
						DarkMode:Debug(5, "BAGS == RETAIL")
						local mode = DarkMode:DMGV("COLORMODEBA", 1)
						if mode ~= 7 and mode ~= 9 then
							for i, v in pairs(BAGS) do
								local bagF = _G[v]
								local NT = _G[v .. "NormalTexture"]
								if bagF and NT then
									if MainMenuBarBackpackButton ~= bagF then
										if DarkMode:IsEnabled("DESATURATE", true) then
											NT:SetDesaturated(true)
										end

										DarkMode:UpdateColor(NT, "bags")
									elseif not DarkMode:IsAddOnLoaded("DragonflightUi") then
										bagF.border = bagF:CreateTexture(v .. ".BagBorder", "ARTWORK")
										bagF.border:SetTexture("Interface\\AddOns\\DarkMode\\media\\bag-main-border")
										bagF.border:SetSize(bagF:GetSize())
										bagF.border:SetPoint("CENTER", bagF, "CENTER", -1, 1)
										if DarkMode:IsEnabled("DESATURATE", true) then
											bagF.border:SetDesaturated(true)
										end

										DarkMode:UpdateColor(bagF.border, "bags")
									end
								end
							end
						end
					end, "OtherAddons"
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
									if LibStub and MSQ == nil then
										MSQ = LibStub("Masque", true)
									end

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
									if LibStub and MSQ == nil then
										MSQ = LibStub("Masque", true)
									end

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
							local name = DarkMode:GetName(frame)
							if name == nil then return end
							local buttonName = name .. "Buff"
							for index = 1, 32 do
								local btn = _G[buttonName .. index]
								if LibStub and MSQ == nil then
									MSQ = LibStub("Masque", true)
								end

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
			for index, name in pairs(castbars) do
				local spellbar = _G[name]
				if spellbar then
					local icon = spellbar.Icon
					if icon then
						local scale = 1
						local sw, sh = icon:GetSize()
						sw = DarkMode:MathR(sw)
						sh = DarkMode:MathR(sh)
						DarkMode:AddActionButtonBorder(spellbar, icon, name, sw * scale, sh * scale, 0, 0, "buffsanddebuffs", nil, false)
					end
				end
			end

			DarkMode:After(
				0.1,
				function()
					DarkMode:Debug(5, "setup")
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
				end, "PLAYER_LOGIN"
			)

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
				DarkMode:CreateMinimapButton(
					{
						["name"] = "DarkMode",
						["icon"] = 136122,
						["dbtab"] = DMTAB,
						["vTT"] = {{"|T136122:16:16:0:0|t D|cff3FC7EBark|rM|cff3FC7EBode|r", "v|cff3FC7EB" .. DarkMode:GetVersion()}, {DarkMode:Trans("LID_LEFTCLICK"), DarkMode:Trans("LID_OPENSETTINGS")}, {DarkMode:Trans("LID_RIGHTCLICK"), DarkMode:Trans("LID_HIDEMINIMAPBUTTON")}},
						["funcL"] = function()
							DarkMode:ToggleSettings()
						end,
						["funcR"] = function()
							DarkMode:SetEnabled("MMBTN", false)
							DarkMode:HideMMBtn("DarkMode")
						end,
						["dbkey"] = "MMBTN"
					}
				)
			end

			if GameMenuFrame then
				GameMenuFrame:HookScript(
					"OnShow",
					function()
						if DarkMode:IsEnabled("COLORBUTTONS", true) then
							DarkMode:ForeachChildren(
								GameMenuFrame,
								function(child, x)
									if child.Left then
										DarkMode:UpdateColor(child.Left, "frames")
									end

									if child.Middle then
										DarkMode:UpdateColor(child.Middle, "frames")
									end

									if child.Center then
										DarkMode:UpdateColor(child.Center, "frames")
									end

									if child.Right then
										DarkMode:UpdateColor(child.Right, "frames")
									end
								end
							)
						end
					end
				)
			end

			DarkMode:RetryAddonsSearch()
		end
	elseif event == "ADDON_LOADED" then
		local from = ...
		DarkMode:AddonsSearch(from)
	elseif event == "START_LOOT_ROLL" then
		DarkMode:After(
			0.1,
			function()
				DarkMode:Debug(5, "GroupLootUpdate")
				DarkMode:GroupLootUpdate()
			end, "START_LOOT_ROLL"
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

function DarkMode:UpdateVigor()
	if UIWidgetPowerBarContainerFrame == nil then return end
	DarkMode:ForeachChildren(
		UIWidgetPowerBarContainerFrame,
		function(child)
			if child.DecorLeft and child.DecorLeft.GetAtlas then
				local atlas = child.DecorLeft:GetAtlas()
				if atlas and string.find(atlas, "vigor", 1, true) then
					DarkMode:UpdateColor(child.DecorLeft, "ui")
					DarkMode:UpdateColor(child.DecorRight, "ui")
				end
			end

			DarkMode:ForeachChildren(
				child,
				function(cchild)
					if cchild.Frame and cchild.Frame.GetAtlas then
						local atlas = cchild.Frame:GetAtlas()
						if atlas and string.find(atlas, "vigor", 1, true) then
							DarkMode:UpdateColor(cchild.Frame, "ui")
						end
					end
				end, "UpdateVigor 2"
			)
		end, "UpdateVigor 1"
	)
end

local vigor = CreateFrame("Frame")
vigor:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
vigor:RegisterEvent("PLAYER_ENTERING_WORLD")
vigor:SetScript(
	"OnEvent",
	function(sel, event)
		if event == "PLAYER_ENTERING_WORLD" then
			DarkMode:After(
				1,
				function()
					DarkMode:Debug(5, "UpdateVigor 1")
					DarkMode:UpdateVigor()
				end, "PLAYER_ENTERING_WORLD"
			)
		elseif event == "PLAYER_MOUNT_DISPLAY_CHANGED" then
			DarkMode:After(
				0.21,
				function()
					DarkMode:Debug(5, "UpdateVigor 2")
					DarkMode:UpdateVigor()
				end, "PLAYER_MOUNT_DISPLAY_CHANGED"
			)
		end
	end
)

local f = CreateFrame("Frame")
f:SetScript("OnEvent", DarkMode.Event)
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("START_LOOT_ROLL")
f.incombat = false
if false then
	C_Timer.After(
		1,
		function()
			DarkMode:SetDebug(true)
			DarkMode:DrawDebug(
				"DarkMode DrawDebug",
				function()
					local text = ""
					for i, v in pairs(DarkMode:GetCountAfter()) do
						if v > 100 then
							text = text .. i .. ": " .. v .. "\n"
						end
					end

					return text
				end, 14, 1440, 1440, "CENTER", UIParent, "CENTER", 400, 0
			)
		end
	)
end
