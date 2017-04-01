local SBDerma = nil;
local PlayerList  = nil

surface.CreateFont("SBFont", {
	font = "Prototype",
	extended = false,
	size = 18,
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

hook.Add("ScoreboardShow", "Show Scoreboard", function()
	if not IsValid(SBDerma) then
		SBDerma = vgui.Create("DFrame")
		SBDerma:SetSize(750, 500)
		SBDerma:SetPos(ScrW() / 2 - 325, ScrH() / 2 - 250)
		SBDerma:SetTitle("")
		SBDerma:SetDraggable(false)
		SBDerma:ShowCloseButton(false)
		SBDerma.Paint = function()
			draw.SimpleText(sbTitle, "SBFont", 25, 4, Color(255,255,255,255))
			draw.RoundedBox(2, 0, 0,
				SBDerma:GetWide(),
				SBDerma:GetTall(),
				Color(0, 0, 0, 225) -- color of scoreboard
			)
		end

		local PlayerScrollPanel = vgui.Create('DScrollPanel', SBDerma)
		PlayerScrollPanel:SetSize(SBDerma:GetWide(), SBDerma:GetTall())
		PlayerScrollPanel:SetPos(0, 0)

		PlayerList = vgui.Create('DListLayout', PlayerScrollPanel)
		PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())
		PlayerList:SetPos(0, 0)
	end

	if IsValid(SBDerma) then
		PlayerList:Clear()
		local TitlePanel = vgui.Create('DPanel', PlayerList)
		TitlePanel:SetSize(PlayerList:GetWide(), 25)
		TitlePanel:SetPos(0, 0)
		TitlePanel.Paint = function()
			draw.RoundedBox(0, 0, 0,
				TitlePanel:GetWide(),
				TitlePanel:GetTall(),
				Color(0, 0, 0, 200)
			)
			--[[draw.RoundedBox(0, 0, 24,
				TitlePanel:GetWide(),
				1,
				TeamColors[ply:Team()][2]
			)]]

			draw.SimpleText(GetHostName(), "SBFont", 25, 4, Color(255,255,255,255))
		end

		for _, ply in pairs(player.GetAll()) do
			local PlayerPanel = vgui.Create('DPanel', PlayerList)
			PlayerPanel:SetSize(PlayerList:GetWide(), 25)
			PlayerPanel:SetPos(0, 0)
			PlayerPanel.Paint = function()
				--[[draw.RoundedBox(0, 0, 0,
					PlayerPanel:GetWide(),
					PlayerPanel:GetTall(),
					Color(54, 54, 54, 140)
				)]]
				draw.RoundedBox(0, 0, 24,
					PlayerPanel:GetWide(),
					1,
					Color(54, 54, 54, 225)
				)

				draw.SimpleText(ply:Name(), "SBFont", 25, 4, Color(255,255,255,255))
				draw.SimpleText("Ping: " .. ply:Ping(),
					"SBFont",
					PlayerList:GetWide() / 2,
					4,
					Color(255,255,255,255),
					TEXT_ALIGN_RIGHT
				)

				draw.SimpleText("K: " .. ply:Frags() .. " / D: " .. ply:Deaths(),
					"SBFont",
					PlayerList:GetWide() - 40,
					4,
					Color(255,255,255,255),
					TEXT_ALIGN_RIGHT
				)
			end
		end

		SBDerma:Show()
		SBDerma:MakePopup()
		SBDerma:SetKeyboardInputEnabled(false)
	end

	return true
end)

hook.Add("ScoreboardHide", "Hide Scoreboard", function()
	if IsValid(SBDerma) then
		SBDerma:Hide()
	end

	return true
end)