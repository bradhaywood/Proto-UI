include "shared.lua"

ProtoWeap = {}
ProtoWeap.Cache = {}
ProtoWeap.ShowSelection = false
ProtoWeap.Opened = CurTime()+3
ProtoWeap.SlotSelection = 1
ProtoWeap.LastSlotChecked = 1
ProtoWeap.SelectedWeapon = false

ProtoWeap.Icons = {}
surface.CreateFont("WeapFont", {
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

function ProtoWeap:DrawSelection()
	local itemWidth = 250
	local hudColor  = Color(0, 0, 0, 230)
	local hudX = 5
	local hudY = 100
	local icontbl = {}
	local textColor = Color(255, 255, 255, 255)
	for k,v in pairs(ProtoWeap.Cache) do
		if (k == ProtoWeap.SlotSelection) then
			hudColor = Color(54, 54, 54, 180)
			ProtoWeap.SelectedWeapon = k
		end

		draw.RoundedBox(0, hudX, hudY, itemWidth, 100, hudColor)
		draw.DrawText(v:GetPrintName(), "WeapFont", hudX+10, hudY+10, textColor)

		local icon = vgui.Create("ModelImage")
		icon:SetModel(v:GetWeaponWorldModel())
		icon:SetPos(hudX+40, hudY+20)
		icon:SetSize(80, 80)
		table.insert(ProtoWeap.Icons, icon)
		hudY = hudY + 110
		hudColor = Color(0, 0, 0, 230)
	end
end

function ProtoWeap:CheckSlot(idx)
	local slottbl = {}
	local weptbl = LocalPlayer():GetWeapons()
	for k,v in pairs(weptbl) do
		if v:GetSlot() == idx then table.insert(slottbl, v) end
	end

	if (#slottbl > 0) then
		if (#ProtoWeap.Icons > 0) then for k,v in pairs(ProtoWeap.Icons) do v:Remove() end end
		if (ProtoWeap.ShowSelection) then
			if (ProtoWeap.LastSlotChecked != idx) then ProtoWeap.SlotSelection = 0 end
			local nextidx = ProtoWeap.SlotSelection+1
			if (nextidx <= #ProtoWeap.Cache) then
				ProtoWeap.SlotSelection = nextidx
			else
				ProtoWeap.SlotSelection = 1
			end
		end
		ProtoWeap.Cache = slottbl
		ProtoWeap.ShowSelection = true
		ProtoWeap.Opened = CurTime()+3
		ProtoWeap.LastSlotChecked = idx
		return true
	else
		-- no weapons found in this slot
		return false
	end
end

hook.Add("PlayerBindPress", "Proto WeaponSwap", function(ply, bind, pressed)
	if string.sub(bind, 1, 4) == "slot" and pressed then
    local idx = tonumber(string.sub(bind, 5, -1)) or 1
    ProtoWeap:CheckSlot(idx-1)
  elseif (bind == "+attack" and ProtoWeap.ShowSelection) then
  	local swep = ProtoWeap.Cache[ProtoWeap.SelectedWeapon]
  	net.Start("ProtoSelectWeapon")
  	net.WriteString(swep:GetClass())
  	net.SendToServer()
  	ProtoWeap.ShowSelection = false
  	return true
  end
end)

local function ShowSelection()
	if ProtoWeap.ShowSelection and CurTime() > ProtoWeap.Opened then
		ProtoWeap.SlotSelection = 1
		ProtoWeap.ShowSelection = false
	end
	if not ProtoWeap.ShowSelection and #ProtoWeap.Icons > 0 then
		for k,v in pairs(ProtoWeap.Icons) do v:Remove() end
		ProtoWeap.Icons = {}
	end
	if ProtoWeap.ShowSelection then ProtoWeap:DrawSelection() end
end

hook.Add("HUDPaint", "WeaponSelection", ShowSelection)