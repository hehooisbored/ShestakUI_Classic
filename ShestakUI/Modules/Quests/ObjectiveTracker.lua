local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	Move ObjectiveTrackerFrame and hide background
----------------------------------------------------------------------------------------
local anchor = CreateFrame("Frame", "ObjectiveTrackerAnchor", UIParent)
anchor:SetPoint(C.position.quest[1], C.position.quest[2], C.position.quest[3], C.position.quest[4], C.position.quest[5] - (C.actionbar.micromenu and 27 or 0))
anchor:SetSize(224, 150)

ObjectiveTrackerFrame.IsUserPlaced = function() return true end
ObjectiveTrackerFrame:SetClampedToScreen(false)

hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", function(_, _, parent)
	if parent ~= anchor then
		ObjectiveTrackerFrame:ClearAllPoints()
		ObjectiveTrackerFrame:SetPoint("TOPLEFT", anchor, "TOPLEFT", 20, 3)
	end
end)

local headers = {
	SCENARIO_CONTENT_TRACKER_MODULE,
	BONUS_OBJECTIVE_TRACKER_MODULE,
	UI_WIDGET_TRACKER_MODULE,
	CAMPAIGN_QUEST_TRACKER_MODULE,
	QUEST_TRACKER_MODULE,
	ACHIEVEMENT_TRACKER_MODULE,
	WORLD_QUEST_TRACKER_MODULE,
	PROFESSION_RECIPE_TRACKER_MODULE,
	MONTHLY_ACTIVITIES_TRACKER_MODULE
}

for i = 1, #headers do
	local header = headers[i].Header
	if header then
		header.Background:Hide()
	end
end

ObjectiveTrackerFrame.HeaderMenu.Title:SetAlpha(0)

----------------------------------------------------------------------------------------
--	Skin ObjectiveTrackerFrame item buttons
----------------------------------------------------------------------------------------
local function HotkeyShow(self)
	local item = self:GetParent()
	if item.rangeOverlay then item.rangeOverlay:Show() end
end

local function HotkeyHide(self)
	local item = self:GetParent()
	if item.rangeOverlay then item.rangeOverlay:Hide() end
end

local function HotkeyColor(self, r)
	local item = self:GetParent()
	if item.rangeOverlay then
		if r == 1 then
			item.rangeOverlay:Show()
		else
			item.rangeOverlay:Hide()
		end
	end
end

hooksecurefunc("QuestObjectiveSetupBlockButton_Item", function(block)
	local item = block and block.itemButton

	if item and not item.skinned then
		item:SetSize(25, 25)
		item:SetTemplate("Default")
		item:StyleButton()

		item:SetNormalTexture(0)

		item.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		item.icon:SetPoint("TOPLEFT", item, 2, -2)
		item.icon:SetPoint("BOTTOMRIGHT", item, -2, 2)

		item.Cooldown:SetAllPoints(item.icon)

		item.Count:ClearAllPoints()
		item.Count:SetPoint("TOPLEFT", 1, -1)
		item.Count:SetFont(C.font.action_bars_font, C.font.action_bars_font_size, C.font.action_bars_font_style)
		item.Count:SetShadowOffset(C.font.action_bars_font_shadow and 1 or 0, C.font.action_bars_font_shadow and -1 or 0)

		local rangeOverlay = item:CreateTexture(nil, "OVERLAY")
		rangeOverlay:SetTexture(C.media.texture)
		rangeOverlay:SetInside()
		rangeOverlay:SetVertexColor(1, 0.3, 0.1, 0.6)
		item.rangeOverlay = rangeOverlay

		hooksecurefunc(item.HotKey, "Show", HotkeyShow)
		hooksecurefunc(item.HotKey, "Hide", HotkeyHide)
		hooksecurefunc(item.HotKey, "SetVertexColor", HotkeyColor)
		HotkeyColor(item.HotKey, item.HotKey:GetTextColor())
		item.HotKey:SetAlpha(0)

		item.skinned = true
	end
end)

hooksecurefunc("QuestObjectiveSetupBlockButton_FindGroup", function(block)
	if block.groupFinderButton and not block.groupFinderButton.styled then
		local icon = block.groupFinderButton
		icon:SetSize(26, 26)
		icon:SetNormalTexture(0)
		icon:SetHighlightTexture(0)
		icon:SetPushedTexture(0)
		icon.b = CreateFrame("Frame", nil, icon)
		icon.b:SetTemplate("Overlay")
		icon.b:SetPoint("TOPLEFT", icon, "TOPLEFT", 2, -3)
		icon.b:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -4, 3)
		icon.b:SetFrameLevel(1)

		icon:HookScript("OnEnter", function(self)
			if self:IsEnabled() then
				self.b:SetBackdropBorderColor(unpack(C.media.classborder_color))
				if self.b.overlay then
					self.b.overlay:SetVertexColor(C.media.classborder_color[1] * 0.3, C.media.classborder_color[2] * 0.3, C.media.classborder_color[3] * 0.3, 1)
				end
			end
		end)

		icon:HookScript("OnLeave", function(self)
			self.b:SetBackdropBorderColor(unpack(C.media.border_color))
			if self.b.overlay then
				self.b.overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
			end
		end)

		hooksecurefunc(icon, "Show", function(self)
			self.b:SetFrameLevel(1)
		end)

		icon.styled = true
	end
end)

-- WorldQuestsList button skin
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
	if not C_AddOns.IsAddOnLoaded("WorldQuestsList") then return end

	local orig = _G.WorldQuestList.ObjectiveTracker_Update_hook
	local function orig_hook(...)
		orig(...)
		for _, b in pairs(WorldQuestList.LFG_objectiveTrackerButtons) do
			if b and not b.skinned then
				b:SetSize(20, 20)
				b.texture:SetAtlas("socialqueuing-icon-eye")
				b.texture:SetSize(12, 12)
				b:SetHighlightTexture(0)

				local point, anchor, point2, x, y = b:GetPoint()
				if x == -18 then
					b:SetPoint(point, anchor, point2, -13, y)
				end

				b.b = CreateFrame("Frame", nil, b)
				b.b:SetTemplate("Overlay")
				b.b:SetPoint("TOPLEFT", b, "TOPLEFT", 0, 0)
				b.b:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 0, 0)
				b.b:SetFrameLevel(1)
				b.skinned = true
			end
		end
	end
	_G.WorldQuestList.ObjectiveTracker_Update_hook = orig_hook
end)

----------------------------------------------------------------------------------------
--	Difficulty color for ObjectiveTrackerFrame lines
----------------------------------------------------------------------------------------
hooksecurefunc(QUEST_TRACKER_MODULE, "Update", function()
	for i = 1, C_QuestLog.GetNumQuestWatches() do
		local questID = C_QuestLog.GetQuestIDForQuestWatchIndex(i)
		if not questID then
			break
		end
		local col = GetDifficultyColor(C_PlayerInfo.GetContentDifficultyQuestForPlayer(questID))
		local block = QUEST_TRACKER_MODULE:GetExistingBlock(questID)
		if block then
			block.HeaderText:SetTextColor(col.r, col.g, col.b)
			block.HeaderText.col = col
		end
	end
end)

hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddObjective", function(_, block)
	if block.module == ACHIEVEMENT_TRACKER_MODULE then
		block.HeaderText:SetTextColor(0.75, 0.61, 0)
		block.HeaderText.col = nil
	end
end)

hooksecurefunc("ObjectiveTrackerBlockHeader_OnLeave", function(self)
	local block = self:GetParent()
	if block.HeaderText.col then
		block.HeaderText:SetTextColor(block.HeaderText.col.r, block.HeaderText.col.g, block.HeaderText.col.b)
	end
end)

----------------------------------------------------------------------------------------
--	Skin ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
----------------------------------------------------------------------------------------
if C.skins.blizzard_frames == true then
	local button = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
	button:SetSize(17, 17)
	button:StripTextures()
	button:SetTemplate("Overlay")

	button.minus = button:CreateTexture(nil, "OVERLAY")
	button.minus:SetSize(7, 1)
	button.minus:SetPoint("CENTER")
	button.minus:SetTexture(C.media.blank)

	button.plus = button:CreateTexture(nil, "OVERLAY")
	button.plus:SetSize(1, 7)
	button.plus:SetPoint("CENTER")
	button.plus:SetTexture(C.media.blank)

	button:HookScript("OnEnter", T.SetModifiedBackdrop)
	button:HookScript("OnLeave", T.SetOriginalBackdrop)

	button.plus:Hide()
	hooksecurefunc("ObjectiveTracker_Collapse", function()
		button.plus:Show()
		button:SetNormalTexture(0)
		button:SetPushedTexture(0)
		if C.general.minimize_mouseover then
			button:SetAlpha(0)
			button:HookScript("OnEnter", function() button:SetAlpha(1) end)
			button:HookScript("OnLeave", function() button:SetAlpha(0) end)
		end
	end)

	hooksecurefunc("ObjectiveTracker_Expand", function()
		button.plus:Hide()
		button:SetNormalTexture(0)
		button:SetPushedTexture(0)
		if C.general.minimize_mouseover then
			button:SetAlpha(1)
			button:HookScript("OnEnter", function() button:SetAlpha(1) end)
			button:HookScript("OnLeave", function() button:SetAlpha(1) end)
		end
	end)

	local function SkinSmallMinimizeButton(button)
		button:SetSize(15, 15)
		button:StripTextures()
		button:SetTemplate("Overlay")

		button.minus = button:CreateTexture(nil, "OVERLAY")
		button.minus:SetSize(5, 1)
		button.minus:SetPoint("CENTER")
		button.minus:SetTexture(C.media.blank)

		button.plus = button:CreateTexture(nil, "OVERLAY")
		button.plus:SetSize(1, 5)
		button.plus:SetPoint("CENTER")
		button.plus:SetTexture(C.media.blank)

		button:HookScript("OnEnter", T.SetModifiedBackdrop)
		button:HookScript("OnLeave", T.SetOriginalBackdrop)

		button.plus:Hide()

		hooksecurefunc(button, "SetCollapsed", function(self, collapsed)
			if collapsed then
				button.plus:Show()
			else
				button.plus:Hide()
			end
			button:SetNormalTexture(0)
			button:SetPushedTexture(0)
		end)
	end

	for i = 1, #headers do
		local button = headers[i].Header.MinimizeButton
		if button then
			SkinSmallMinimizeButton(button)
		end
	end
end

----------------------------------------------------------------------------------------
--	Auto collapse Objective Tracker
----------------------------------------------------------------------------------------
if C.automation.auto_collapse ~= "NONE" then
	local collapse = CreateFrame("Frame")
	collapse:RegisterEvent("PLAYER_ENTERING_WORLD")
	collapse:SetScript("OnEvent", function()
		if C.automation.auto_collapse == "RAID" then
			if IsInInstance() then
				C_Timer.After(0.1, function()
					ObjectiveTracker_Collapse()
				end)
			elseif ObjectiveTrackerFrame.collapsed and not InCombatLockdown() then
				ObjectiveTracker_Expand()
			end
		elseif C.automation.auto_collapse == "SCENARIO" then
			local inInstance, instanceType = IsInInstance()
			if inInstance then
				if instanceType == "party" or instanceType == "scenario" then
					C_Timer.After(0.1, function() -- for some reason it got error after reload in instance
						for i = 3, #headers do
							local button = headers[i].Header.MinimizeButton
							if button and not headers[i].collapsed then
								button:Click()
							end
						end
					end)
				else
					C_Timer.After(0.1, function()
						ObjectiveTracker_Collapse()
					end)
				end
			else
				if not InCombatLockdown() then
					for i = 3, #headers do
						local button = headers[i].Header.MinimizeButton
						if button and headers[i].collapsed then
							button:Click()
						end
					end
					if ObjectiveTrackerFrame.collapsed then
						ObjectiveTracker_Expand()
					end
				end
			end
		elseif C.automation.auto_collapse == "RELOAD" then
			C_Timer.After(0.1, function()
				ObjectiveTracker_Collapse()
			end)
		end
	end)
end

----------------------------------------------------------------------------------------
--	Skin quest objective progress bar
----------------------------------------------------------------------------------------
local function SkinProgressBar(_, _, line)
	local progressBar = line.ProgressBar
	local bar = progressBar.Bar
	local label = bar.Label
	local icon = bar.Icon

	if not progressBar.styled then
		if bar.BarFrame then bar.BarFrame:Hide() end
		if bar.BarFrame2 then bar.BarFrame2:Hide() end
		if bar.BarFrame3 then bar.BarFrame3:Hide() end
		if bar.BarGlow then bar.BarGlow:Hide() end
		if bar.Sheen then bar.Sheen:Hide() end
		if bar.IconBG then bar.IconBG:SetAlpha(0) end
		if bar.BorderLeft then bar.BorderLeft:SetAlpha(0) end
		if bar.BorderRight then bar.BorderRight:SetAlpha(0) end
		if bar.BorderMid then bar.BorderMid:SetAlpha(0) end

		bar:SetSize(200, 16)
		bar:SetStatusBarTexture(C.media.texture)
		bar:CreateBackdrop("Transparent")

		label:ClearAllPoints()
		label:SetPoint("CENTER", 0, -1)
		label:SetFont(C.media.pixel_font, C.media.pixel_font_size, C.media.pixel_font_style)
		label:SetDrawLayer("OVERLAY")

		if icon then
			icon:SetPoint("RIGHT", 26, 0)
			icon:SetSize(20, 20)
			icon:SetMask("")

			local border = CreateFrame("Frame", "$parentBorder", bar)
			border:SetAllPoints(icon)
			border:SetTemplate("Transparent")
			border:SetBackdropColor(0, 0, 0, 0)
			bar.newIconBg = border

			hooksecurefunc(bar.AnimIn, "Play", function()
				bar.AnimIn:Stop()
			end)
		end

		progressBar.styled = true
	end

	if bar.newIconBg then bar.newIconBg:SetShown(icon:IsShown()) end
end

hooksecurefunc(QUEST_TRACKER_MODULE, "AddProgressBar", SkinProgressBar)
hooksecurefunc(CAMPAIGN_QUEST_TRACKER_MODULE, "AddProgressBar", SkinProgressBar)
hooksecurefunc(SCENARIO_TRACKER_MODULE, "AddProgressBar", SkinProgressBar)
hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", SkinProgressBar)
hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", SkinProgressBar)

----------------------------------------------------------------------------------------
--	Skin Timer bar
----------------------------------------------------------------------------------------
local function SkinTimer(_, _, line)
	local timerBar = line.TimerBar
	local bar = timerBar.Bar

	if not timerBar.styled then
		if bar.BorderLeft then bar.BorderLeft:SetAlpha(0) end
		if bar.BorderRight then bar.BorderRight:SetAlpha(0) end
		if bar.BorderMid then bar.BorderMid:SetAlpha(0) end

		bar:SetStatusBarTexture(C.media.texture)
		bar:CreateBackdrop("Transparent")
		timerBar.styled = true
	end
end

hooksecurefunc(QUEST_TRACKER_MODULE, "AddTimerBar", SkinTimer)
hooksecurefunc(SCENARIO_TRACKER_MODULE, "AddTimerBar", SkinTimer)
hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddTimerBar", SkinTimer)
hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "AddTimerBar", SkinTimer)

----------------------------------------------------------------------------------------
--	Set tooltip depending on position
----------------------------------------------------------------------------------------
hooksecurefunc("BonusObjectiveTracker_ShowRewardsTooltip", function(block)
	if T.IsFramePositionedLeft(ObjectiveTrackerFrame) then
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("TOPLEFT", block, "TOPRIGHT", 0, 0)
	end
end)

ScenarioStageBlock:HookScript("OnEnter", function(self)
	if T.IsFramePositionedLeft(ObjectiveTrackerFrame) then
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 50, -3)
	end
end)

----------------------------------------------------------------------------------------
--	Kill reward animation when finished dungeon or bonus objectives
----------------------------------------------------------------------------------------
ObjectiveTrackerScenarioRewardsFrame.Show = T.dummy
BonusObjectiveTrackerProgressBar_PlayFlareAnim = T.dummy

--BETA hooksecurefunc("BonusObjectiveTracker_AnimateReward", function()
	-- ObjectiveTrackerBonusRewardsFrame:ClearAllPoints()
	-- ObjectiveTrackerBonusRewardsFrame:SetPoint("BOTTOM", UIParent, "TOP", 0, 90)
-- end)

----------------------------------------------------------------------------------------
--	Skin ScenarioStageBlock
----------------------------------------------------------------------------------------
local StageBlock = _G["ScenarioStageBlock"]
StageBlock:CreateBackdrop("Overlay")
StageBlock.backdrop:SetPoint("TOPLEFT", ScenarioStageBlock.NormalBG, 3, -3)
StageBlock.backdrop:SetPoint("BOTTOMRIGHT", ScenarioStageBlock.NormalBG, -6, 5)

StageBlock.NormalBG:SetAlpha(0)
StageBlock.FinalBG:SetAlpha(0)
StageBlock.GlowTexture:SetTexture(0)

----------------------------------------------------------------------------------------
--	Skin ScenarioStageBlock
----------------------------------------------------------------------------------------
local ChallengeBlock = _G["ScenarioChallengeModeBlock"]
ChallengeBlock:CreateBackdrop("Overlay")
ChallengeBlock.backdrop:SetPoint("TOPLEFT", ChallengeBlock, 3, -3)
ChallengeBlock.backdrop:SetPoint("BOTTOMRIGHT", ChallengeBlock, -6, 3)
ChallengeBlock.backdrop.overlay:SetVertexColor(0.12, 0.12, 0.12, 1)

local bg = select(3, ChallengeBlock:GetRegions())
bg:SetAlpha(0)

ChallengeBlock.TimerBGBack:SetAlpha(0)
ChallengeBlock.TimerBG:SetAlpha(0)

ChallengeBlock.StatusBar:SetStatusBarTexture(C.media.texture)
ChallengeBlock.StatusBar:CreateBackdrop("Overlay")
ChallengeBlock.StatusBar.backdrop:SetFrameLevel(ChallengeBlock.backdrop:GetFrameLevel() + 1)
ChallengeBlock.StatusBar:SetStatusBarColor(0, 0.6, 1)
ChallengeBlock.StatusBar:SetFrameLevel(ChallengeBlock.StatusBar:GetFrameLevel() + 3)

-- Not tested TODO
-- hooksecurefunc("Scenario_ChallengeMode_SetUpAffixes", function(self)
	-- for _, frame in ipairs(self.Affixes) do
		-- frame.Border:SetTexture(nil)
		-- frame.Portrait:SetTexture(nil)
		-- if not frame.styled then
			-- frame.Portrait:SkinIcon()
			-- frame.styled = true
		-- end

		-- if frame.info then
			-- frame.Portrait:SetTexture(_G.CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
		-- elseif frame.affixID then
			-- local _, _, filedataid = C_ChallengeMode.GetAffixInfo(frame.affixID)
			-- frame.Portrait:SetTexture(filedataid)
		-- end
	-- end
-- end)

----------------------------------------------------------------------------------------
--	Skin MawBuffsBlock
----------------------------------------------------------------------------------------
TopScenarioWidgetContainerBlock.WidgetContainer:ClearAllPoints()
TopScenarioWidgetContainerBlock.WidgetContainer:SetPoint("TOP", ScenarioStageBlock.backdrop, "BOTTOM", 0, -3)

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function()
	C_Timer.After(0.1, function()
		local list = ScenarioBlocksFrame.MawBuffsBlock.Container.List
		if list then
			list:ClearAllPoints()
			if T.IsFramePositionedLeft(ObjectiveTrackerFrame) then
				list:SetPoint("TOPLEFT", ScenarioBlocksFrame.MawBuffsBlock.Container, "TOPRIGHT", 15, 0)
			else
				list:SetPoint("TOPRIGHT", ScenarioBlocksFrame.MawBuffsBlock.Container, "TOPLEFT", -15, 0)
			end
		end
		ObjectiveTracker_Update()	-- Fixed position of MinimizeButton if frame on right side

		-- TODO check
		-- BottomScenarioWidgetContainerBlock.WidgetContainer:ClearAllPoints()
		-- BottomScenarioWidgetContainerBlock.WidgetContainer:SetPoint("TOPLEFT", ScenarioStageBlock.backdrop, "TOPRIGHT", 10, 0)
	end)
end)

local Maw = ScenarioBlocksFrame.MawBuffsBlock.Container
Maw:SkinButton()
Maw:ClearAllPoints()
Maw:SetPoint("TOPLEFT", ScenarioStageBlock.backdrop, "BOTTOMLEFT", 0, -35)
Maw.List.button:SetSize(234, 30)
Maw.List:StripTextures()
Maw.List:SetTemplate("Overlay")

Maw.List:HookScript("OnShow", function(self)
	self.button:SetPushedTexture(0)
	self.button:SetHighlightTexture(0)
	self.button:SetWidth(234)
	self.button:SetButtonState("NORMAL")
	self.button:SetPushedTextOffset(0, 0)
	self.button:SetButtonState("PUSHED", true)
end)

Maw.List:HookScript("OnHide", function(self)
	self.button:SetPushedTexture(0)
	self.button:SetHighlightTexture(0)
	self.button:SetWidth(234)
end)

----------------------------------------------------------------------------------------
--	Ctrl+Click to abandon a quest or Alt+Click to share a quest(by Suicidal Katt)
----------------------------------------------------------------------------------------
hooksecurefunc("QuestMapLogTitleButton_OnClick", function(self)
	if IsControlKeyDown() then
		CloseDropDownMenus()
		QuestMapQuestOptions_AbandonQuest(self.questID)
	elseif IsAltKeyDown() and C_QuestLog.IsPushableQuest(self.questID) then
		CloseDropDownMenus()
		QuestMapQuestOptions_ShareQuest(self.questID)
	end
end)

hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderClick", function(_, block)
	if IsControlKeyDown() then
		CloseDropDownMenus()
		QuestMapQuestOptions_AbandonQuest(block.id)
	elseif IsAltKeyDown() and C_QuestLog.IsPushableQuest(block.id) then
		CloseDropDownMenus()
		QuestMapQuestOptions_ShareQuest(block.id)
	end
end)