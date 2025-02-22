local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end -- incomplete

-- importing bs

local GetTradeSkillNumReagents = GetTradeSkillNumReagents
local GetTradeSkillInfo = GetTradeSkillInfo
local GetTradeSkillItemLink = GetTradeSkillItemLink
local GetTradeSkillReagentInfo = GetTradeSkillReagentInfo
local GetTradeSkillReagentItemLink = GetTradeSkillReagentItemLink

local GetItemQualityByID = C_Item.GetItemQualityByID
local GetItemQualityColor = C_Item.GetItemQualityColor


----------------------------------------------------------------------------------------
--	TradeSkillUI skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	TRADE_SKILLS_DISPLAYED = 25

	UIPanelWindows["TradeSkillFrame"] = {area = "doublewide", pushable = 0, whileDead = 1}

	local SkinTradeSkills = _G["TradeSkillFrame"]
	SkinTradeSkills:StripTextures(true)
	SkinTradeSkills:CreateBackdrop("Transparent")
	SkinTradeSkills.backdrop:SetPoint("TOPLEFT", 10, -12)
	SkinTradeSkills.backdrop:SetPoint("BOTTOMRIGHT", -34, 0)
	SkinTradeSkills:SetSize(720, 508)

	SkinTradeSkills.bg1 = CreateFrame("Frame", nil, TradeSkillFrame)
	SkinTradeSkills.bg1:SetTemplate("Transparent")
	SkinTradeSkills.bg1:SetPoint("TOPLEFT", 14, -92)
	SkinTradeSkills.bg1:SetPoint("BOTTOMRIGHT", -367, 4)
	SkinTradeSkills.bg1:SetFrameLevel(SkinTradeSkills.bg1:GetFrameLevel() - 1)

	SkinTradeSkills.bg2 = CreateFrame("Frame", nil, TradeSkillFrame)
	SkinTradeSkills.bg2:SetTemplate("Transparent")
	SkinTradeSkills.bg2:SetPoint("TOPLEFT", SkinTradeSkills.bg1, "TOPRIGHT", 3, 0)
	SkinTradeSkills.bg2:SetPoint("BOTTOMRIGHT", TradeSkillFrame, "BOTTOMRIGHT", -38, 4)
	SkinTradeSkills.bg2:SetFrameLevel(SkinTradeSkills.bg2:GetFrameLevel() - 1)

	TradeSkillRankFrameBorder:StripTextures()

	TradeSkillRankFrame:StripTextures()
	TradeSkillRankFrame:CreateBackdrop()
	TradeSkillRankFrame:SetSize(420, 18)
	TradeSkillRankFrame:ClearAllPoints()
	TradeSkillRankFrame:SetPoint("TOP", -10, -38)
	TradeSkillRankFrame:SetStatusBarTexture(C.media.blank)

	TradeSkillRankFrameSkillName:Hide()
	TradeSkillRankFrameSkillRank:ClearAllPoints()
	TradeSkillRankFrameSkillRank:SetParent(TradeSkillRankFrame)
	TradeSkillRankFrameSkillRank:SetPoint("CENTER", TradeSkillRankFrame, "CENTER", 58, 0)

	TradeSkillListScrollFrame:StripTextures()
	TradeSkillListScrollFrame:SetSize(310, 405)
	TradeSkillListScrollFrame:ClearAllPoints()
	TradeSkillListScrollFrame:SetPoint("TOPLEFT", 17, -95)

	TradeSkillDetailScrollFrame:StripTextures()
	TradeSkillDetailScrollFrame:SetSize(300, 381)
	TradeSkillDetailScrollFrame:ClearAllPoints()
	TradeSkillDetailScrollFrame:SetPoint("TOPRIGHT", TradeSkillFrame, -60, -95)
	TradeSkillDetailScrollFrame.scrollBarHideable = nil

	TradeSkillDetailScrollChildFrame:StripTextures()
	TradeSkillDetailScrollChildFrame:SetSize(300, 150)

	T.SkinScrollBar(TradeSkillListScrollFrameScrollBar)
	T.SkinScrollBar(TradeSkillDetailScrollFrameScrollBar)
	TradeSkillDetailScrollFrameScrollBar:SetPoint("TOPLEFT", TradeSkillDetailScrollFrame, "TOPRIGHT", 3, -16)

	T.SkinDropDownBox(TradeSkillInvSlotDropdown, 160)
	TradeSkillInvSlotDropdown:ClearAllPoints()
	TradeSkillInvSlotDropdown:SetPoint("RIGHT", TradeSkillRankFrame, "RIGHT", 9, -30)

	T.SkinDropDownBox(TradeSkillSubClassDropdown, 160)
	TradeSkillSubClassDropdown:SetPoint("RIGHT", TradeSkillInvSlotDropdown, "LEFT", 10, 0)

	TradeSkillCancelButton:SetWidth(75)
	TradeSkillCancelButton:ClearAllPoints()
	TradeSkillCancelButton:SetPoint("TOPRIGHT", TradeSkillDetailScrollFrame, "BOTTOMRIGHT", 19, -3)
	TradeSkillCancelButton:SkinButton()

	TradeSkillCreateButton:SetWidth(75)
	TradeSkillCreateButton:ClearAllPoints()
	TradeSkillCreateButton:SetPoint("TOPRIGHT", TradeSkillCancelButton, "TOPLEFT", -3, 0)
	TradeSkillCreateButton:SkinButton()

	TradeSkillCreateAllButton:ClearAllPoints()
	TradeSkillCreateAllButton:SetPoint("TOPLEFT", TradeSkillDetailScrollFrame, "BOTTOMLEFT", 0, -3)
	TradeSkillCreateAllButton:SkinButton()

	T.SkinNextPrevButton(TradeSkillDecrementButton)

	T.SkinEditBox(TradeSkillInputBox)
	TradeSkillInputBox:SetSize(40, 16)
	TradeSkillInputBox:SetPoint("LEFT", TradeSkillDecrementButton, "RIGHT", 4, 0)

	T.SkinNextPrevButton(TradeSkillIncrementButton)
	TradeSkillIncrementButton:SetPoint("LEFT", TradeSkillInputBox, "RIGHT", 4, 0)

	TradeSkillSkillIcon:StripTextures()
	TradeSkillSkillIcon:SetTemplate("Default")
	TradeSkillSkillIcon:StyleButton(true)
	TradeSkillSkillIcon:SetSize(47, 47)
	TradeSkillSkillIcon:SetPoint("TOPLEFT", 1, -3)

	TradeSkillSkillName:SetPoint("TOPLEFT", 55, -3)

	TradeSkillRequirementLabel:SetTextColor(1, 0.80, 0.10)

	T.SkinCloseButton(TradeSkillFrameCloseButton, SkinTradeSkills.backdrop)

	TradeSkillExpandButtonFrame:StripTextures()
	TradeSkillCollapseAllButton:SetPoint("LEFT", TradeSkillExpandTabLeft, "RIGHT", -1, 6)

	TradeSkillCollapseAllButtonText:ClearAllPoints()
	TradeSkillCollapseAllButtonText:SetPoint("LEFT", TradeSkillCollapseAllButton, "RIGHT", 6, 0)

	TradeSkillCollapseAllButton:SetSize(14, 14)
	TradeSkillCollapseAllButton:SetPoint("CENTER")
	TradeSkillCollapseAllButton:SetHitRectInsets(1, 1, 1, 1)

	hooksecurefunc(TradeSkillCollapseAllButton, "SetNormalTexture", function(self, texture)
		self:StripTextures()
		self:SetTemplate("Overlay")

		self.minus = self:CreateTexture(nil, "OVERLAY")
		self.minus:SetSize(7, 1)
		self.minus:SetPoint("CENTER")
		self.minus:SetTexture(C.media.blank)

		if not string.find(texture, "MinusButton") then
			self.plus = self:CreateTexture(nil, "OVERLAY")
			self.plus:SetSize(1, 7)
			self.plus:SetPoint("CENTER")
			self.plus:SetTexture(C.media.blank)
		end
	end)

	for i = 9, 25 do
		CreateFrame("Button", "TradeSkillSkill"..i, TradeSkillFrame, "TradeSkillSkillButtonTemplate"):SetPoint("TOPLEFT", _G["TradeSkillSkill"..i - 1], "BOTTOMLEFT")
	end

	local function UpdateTradeskill()
		local numSkills = GetNumTradeSkills()
		local offset = FauxScrollFrame_GetOffset(TradeSkillListScrollFrame)
		local index, button, highlight, text

		for i = 1, TRADE_SKILLS_DISPLAYED do
			button = _G["TradeSkillSkill"..i]
			highlight = _G["TradeSkillSkill"..i.."Highlight"]
			text = _G["TradeSkillSkill"..i.."Text"]
			index = offset + i

			if index <= numSkills then
				local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(index)

				if skillType == "header" then
					button:SetSize(14, 14)
					button:SetPoint("CENTER")
					button:SetHitRectInsets(1, 1, 1, 1)

					highlight:SetTexture(0)
					highlight.SetTexture = T.dummy

					text:ClearAllPoints()
					text:SetPoint("LEFT", button, "RIGHT", 6, 0)

					hooksecurefunc(button, "SetNormalTexture", function(self, texture)
						self:StripTextures()
						self:SetTemplate("Overlay")

						self.minus = self:CreateTexture(nil, "OVERLAY")
						self.minus:SetSize(7, 1)
						self.minus:SetPoint("CENTER")
						self.minus:SetTexture(C.media.blank)

						if not string.find(texture, "MinusButton") then
							self.plus = self:CreateTexture(nil, "OVERLAY")
							self.plus:SetSize(1, 7)
							self.plus:SetPoint("CENTER")
							self.plus:SetTexture(C.media.blank)
						end
					end)
				end
			end
		end
	end
	hooksecurefunc("TradeSkillFrame_Update", UpdateTradeskill)

	for i = 1, MAX_TRADE_SKILL_REAGENTS do
		local reagent = _G["TradeSkillReagent"..i]
		local icon = _G["TradeSkillReagent"..i.."IconTexture"]
		local count = _G["TradeSkillReagent"..i.."Count"]
		local name = _G["TradeSkillReagent"..i.."Name"]
		local nameFrame = _G["TradeSkillReagent"..i.."NameFrame"]

		reagent:SetTemplate("Default")
		reagent:StyleButton(true)
		reagent:SetSize(143, 40)

		icon.backdrop = CreateFrame("Frame", nil, reagent)
		icon.backdrop:SetTemplate("Default")
		icon.backdrop:SetPoint("TOPLEFT", icon, -1, 1)
		icon.backdrop:SetPoint("BOTTOMRIGHT", icon, 1, -1)

		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		icon:SetDrawLayer("OVERLAY")
		icon:SetSize(38, 38)
		icon:SetPoint("TOPLEFT", 1, -1)
		icon:SetParent(icon.backdrop)

		count:SetParent(icon.backdrop)
		count:SetDrawLayer("OVERLAY")

		name:SetPoint("LEFT", nameFrame, "LEFT", 20, 0)

		nameFrame:Kill()
	end

	TradeSkillReagentLabel:ClearAllPoints()
	TradeSkillReagentLabel:SetPoint("TOPLEFT", TradeSkillSkillIcon, "BOTTOMLEFT", 5, -10)

	TradeSkillReagent1:SetPoint("TOPLEFT", TradeSkillReagentLabel, "BOTTOMLEFT", -3, -3)
	TradeSkillReagent2:SetPoint("LEFT", TradeSkillReagent1, "RIGHT", 3, 0)
	TradeSkillReagent4:SetPoint("LEFT", TradeSkillReagent3, "RIGHT", 3, 0)
	TradeSkillReagent6:SetPoint("LEFT", TradeSkillReagent5, "RIGHT", 3, 0)
	TradeSkillReagent8:SetPoint("LEFT", TradeSkillReagent7, "RIGHT", 3, 0)

	hooksecurefunc("TradeSkillFrame_SetSelection", function(id)
		TradeSkillRankFrame:SetStatusBarColor(0.13, 0.28, 0.85)

		if TradeSkillSkillIcon:GetNormalTexture() then
			TradeSkillReagentLabel:SetAlpha(1)
			TradeSkillSkillIcon:SetAlpha(1)
			TradeSkillSkillIcon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
			TradeSkillSkillIcon:GetNormalTexture():SetInside()
		else
			TradeSkillReagentLabel:SetAlpha(0)
			TradeSkillSkillIcon:SetAlpha(0)
		end

		--[[
		local skillLink = GetTradeSkillItemLink(id) -- Causing crashes
		if skillLink then
			local _, _, quality = GetItemInfo(string.match(skillLink, "item:(%d+)"))
			if quality then
				local R, G, B = GetItemQualityColor(quality)
				TradeSkillSkillIcon:SetBackdropBorderColor(R, G, B)
				TradeSkillSkillName:SetTextColor(R, G, B)
			else
				TradeSkillSkillIcon:SetBackdropBorderColor(unpack(C.media.border_color))
				TradeSkillSkillName:SetTextColor(1, 1, 1)
			end
		end
		--]]

		local numReagents = GetTradeSkillNumReagents(id)
		for i = 1, numReagents, 1 do
			local _, _, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i)
			local reagentLink = GetTradeSkillReagentItemLink(id, i)
			local reagent = _G["TradeSkillReagent"..i]
			local icon = _G["TradeSkillReagent"..i.."IconTexture"]
			local name = _G["TradeSkillReagent"..i.."Name"]
			local count = _G["TradeSkillReagent"..i.."Count"]

			if reagentLink then
				local _, _, quality = GetItemInfo(string.match(reagentLink, "item:(%d+)"))
				if quality then
					local R, G, B = GetItemQualityColor(quality)
					icon.backdrop:SetBackdropBorderColor(R, G, B)
					reagent:SetBackdropBorderColor(R, G, B)
					if playerReagentCount < reagentCount then
						name:SetTextColor(0.5, 0.5, 0.5)
					else
							name:SetTextColor(R, G, B)
					end
					count:ClearAllPoints()
					count:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT", 0, -1)
				else
					reagent:SetBackdropBorderColor(unpack(C.media.border_color))
					icon.backdrop:SetBackdropBorderColor(unpack(C.media.border_color))
				end
			end
		end
		--]]
	end)
end

T.SkinFuncs["Blizzard_TradeSkillUI"] = LoadSkin
