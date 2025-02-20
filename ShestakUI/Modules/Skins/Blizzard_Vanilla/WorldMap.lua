local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	WorldMap skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	if C_AddOns.IsAddOnLoaded("Mapster") then return end

	WorldMapFrame:StripTextures()
	WorldMapFrame:CreateBackdrop("Transparent")

	WorldMapFrame.BorderFrame:SetFrameStrata(WorldMapFrame:GetFrameStrata())

	T.SkinDropDownBox(WorldMapContinentDropdown)
	T.SkinDropDownBox(WorldMapZoneDropdown)

	T.SkinDropDownBox(WorldMapZoneMinimapDropdown)

	WorldMapZoneDropdown:SetPoint("LEFT", WorldMapContinentDropdown, "RIGHT", 5, 0)
	WorldMapZoomOutButton:SetPoint("LEFT", WorldMapZoneDropdown, "RIGHT", 5, 0)

	WorldMapZoomOutButton:SkinButton()
	
	WorldMapFrame.MaximizeMinimizeFrame.MinimizeButton:SkinButton()
	-- WorldMapFrame.MaximizeMinimizeFrame.MaximizeButton:Kill()
	
	T.SkinCloseButton(WorldMapFrameCloseButton, WorldMapFrame.backdrop)
	WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapFrame.BorderFrame, "TOPRIGHT", 5, 4);

	if Questie_Toggle then
		Questie_Toggle:SkinButton()
		Questie_Toggle:ClearAllPoints()
		Questie_Toggle:SetHeight(22)
		Questie_Toggle:SetPoint("LEFT", WorldMapZoomOutButton, "RIGHT", 6, 0)
		Questie_Toggle.SetPoint = T.dummy
	end

	WorldMapFrame:RegisterEvent("PLAYER_LOGIN")
	WorldMapFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	WorldMapFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	WorldMapFrame:HookScript("OnEvent", function(self, event)
		if event == "PLAYER_LOGIN" then
			WorldMapFrame:Show()
			WorldMapFrame:Hide()
		elseif event == "PLAYER_REGEN_DISABLED" then
			if WorldMapFrame:IsShown() then
				HideUIPanel(WorldMapFrame)
			end
		end
	end)
end

tinsert(T.SkinFuncs["ShestakUI"], LoadSkin)
