surface.CreateFont("MessageFont", {
	font = "Prototype",
	extended = false,
	size = 20,
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
	outline = false
})

PMessage = {}
PMessage.String = nil
PMessage.Displayed = false

surface.SetFont("MessageFont")

function DrawText()
	if (PMessage.String ~= nil and PMessage.Displayed) then

		local hudW = surface.GetTextSize(PMessage.String)+10
		local hudH = 43
		local hudCenter = (ScrW() / 2) - (hudW / 2)
		local hudCenterH = (ScrH() / 2) - (hudH / 2)-50
		draw.RoundedBox(0, hudCenter, hudCenterH, hudW, hudH, Color(0, 0, 0, 190))
		draw.SimpleText(PMessage.String, "MessageFont", hudCenter+10, hudCenterH+10, Color(255,255,255,255))
	end

	if (PMessage.Displayed and CurTime() > PMessage.Displayed+3) then
		PMessage.String = nil
		PMessage.Displayed = false
	end
end

hook.Add("HUDPaint", "DrawText", DrawText);

net.Receive("PMessage", function(len, ply)
	PMessage.String = net.ReadString()
	PMessage.Displayed = CurTime()
end)