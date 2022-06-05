local T, C, L, _ = unpack(select(2, ...))
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	BindingUI skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local buttons = {
		"defaultsButton",
		"unbindButton",
		"okayButton",
		"cancelButton",
		"quickKeybindButton",
	}

	for _, v in pairs(buttons) do
		if KeyBindingFrame[v] then
			KeyBindingFrame[v]:SkinButton(true)
		end
	end

	KeyBindingFrame:StripTextures()
	KeyBindingFrame:SetTemplate("Transparent")

	if T.Classic then
		KeyBindingFrame.header:StripTextures()
		KeyBindingFrame.header:ClearAllPoints()
		KeyBindingFrame.header:SetPoint("TOP", KeyBindingFrame, "TOP", 0, -4)
	else
		KeyBindingFrame.Header:StripTextures()
		KeyBindingFrame.Header:ClearAllPoints()
		KeyBindingFrame.Header:SetPoint("TOP", KeyBindingFrame, "TOP", 0, -4)
	end

	KeyBindingFrame.bindingsContainer:StripTextures()
	KeyBindingFrame.bindingsContainer:SetTemplate("Overlay")
	KeyBindingFrame.bindingsContainer:SetFrameLevel(1)

	KeyBindingFrameCategoryList:StripTextures()
	KeyBindingFrameCategoryList:SetTemplate("Overlay")

	T.SkinCheckBox(KeyBindingFrame.characterSpecificButton)

	KeyBindingFrameScrollFrame:StripTextures()
	T.SkinScrollBar(KeyBindingFrameScrollFrameScrollBar)

	KeyBindingFrame.defaultsButton:ClearAllPoints()
	KeyBindingFrame.defaultsButton:SetPoint("TOPLEFT", KeyBindingFrameCategoryList, "BOTTOMLEFT", 0, -14)
	KeyBindingFrame.unbindButton:ClearAllPoints()
	KeyBindingFrame.unbindButton:SetPoint("TOPRIGHT", KeyBindingFrame.bindingsContainer, "BOTTOMRIGHT", 0, -14)
	KeyBindingFrame.okayButton:ClearAllPoints()
	KeyBindingFrame.okayButton:SetPoint("RIGHT", KeyBindingFrame.unbindButton, "LEFT", -4, 0)
	KeyBindingFrame.cancelButton:ClearAllPoints()
	KeyBindingFrame.cancelButton:SetPoint("RIGHT", KeyBindingFrame.okayButton, "LEFT", -4, 0)

	for i = 1, KEY_BINDINGS_DISPLAYED do
		local button1 = _G["KeyBindingFrameKeyBinding"..i.."Key1Button"]
		local button2 = _G["KeyBindingFrameKeyBinding"..i.."Key2Button"]

		button2:SetPoint("LEFT", button1, "RIGHT", 2, 0)
	end

	hooksecurefunc("BindingButtonTemplate_SetupBindingButton", function(_, button)
		if not button.IsSkinned then
			button:SetHeight(button:GetHeight() - 1)
			button:StripTextures(true)
			button:StyleButton()
			button:SetTemplate("Overlay")

			local selected = button.selectedHighlight
			selected:SetPoint("TOPLEFT", 2, -2)
			selected:SetPoint("BOTTOMRIGHT", -2, 2)
			selected:SetColorTexture(1, 0.82, 0, 0.3)

			button.IsSkinned = true
		end
	end)

	-- QuickKeybind
	if T.Mainline then
		QuickKeybindFrame:StripTextures()
		QuickKeybindFrame.Header:StripTextures()
		QuickKeybindFrame:SetTemplate("Transparent")

		local buttons = {
			"okayButton",
			"defaultsButton",
			"cancelButton"
		}

		for _, v in pairs(buttons) do
			QuickKeybindFrame[v]:SkinButton(true)
		end

		T.SkinCheckBox(QuickKeybindFrame.characterSpecificButton)
	end
end

T.SkinFuncs["Blizzard_BindingUI"] = LoadSkin

local function LoadSecondarySkin()
	local frame = ClickBindingFrame
	T.SkinCloseButton(frame.CloseButton)

	frame:StripTextures()
	frame:SetTemplate("Transparent")

	frame.TutorialButton.Ring:Hide()
	frame.TutorialButton:SetPoint("TOPLEFT", frame, "TOPLEFT", -12, 12)

	local function updateNewGlow(self)
		if self.NewOutline:IsShown() then
			self.backdrop:SetBackdropBorderColor(0, 0.8, 0)
		else
			self.backdrop:SetBackdropBorderColor(unpack(C.media.border_color))
		end
	end

	local function HandleScrollChild(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local button = select(i, self.ScrollTarget:GetChildren())
			local icon = button and button.Icon
			if icon and not icon.IsSkinned then
				button:CreateBackdrop("Overlay")
				button.backdrop:SetPoint("TOPLEFT", -4, 0)
				button.backdrop:SetPoint("BOTTOMRIGHT", 2, 0)

				icon:SkinIcon(true)
				icon:SetSize(32, 32)
				icon:ClearAllPoints()
				icon:SetPoint("TOPLEFT", button, "TOPLEFT", 3, -7)

				button.Background:Hide()

				button.DeleteButton:SkinButton()
				button.DeleteButton:SetSize(20, 20)
				button.FrameHighlight:SetInside(button.backdrop)
				button.FrameHighlight:SetColorTexture(1, 1, 1, 0.3)

				button.NewOutline:SetTexture("")
				hooksecurefunc(button, "Init", updateNewGlow)

				icon.IsSkinned = true
			end
		end
	end

	hooksecurefunc(frame.ScrollBox, "Update", HandleScrollChild)

	frame.ScrollBar:StripTextures()
	frame.ScrollBar.Background:Hide()
	frame.ScrollBoxBackground:Hide()

	local buttons = {
		"ResetButton",
		"AddBindingButton",
		"SaveButton"
	}

	for _, v in pairs(buttons) do
		frame[v]:SkinButton(true)
	end

	local tutorial = frame.TutorialFrame
	tutorial.NineSlice:StripTextures()
	tutorial.TitleBg:Hide()
	tutorial:SetTemplate("Transparent")
	T.SkinCloseButton(tutorial.CloseButton)
end

T.SkinFuncs["Blizzard_ClickBindingUI"] = LoadSecondarySkin
