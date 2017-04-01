surface.CreateFont("AmmoFont", {
	font = "Prototype",
	extended = false,
	size = 40,
	weight = 600,
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

surface.CreateFont("WeaponFont", {
	font = "Prototype",
	extended = false,
	size = 22,
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

local function ProtoHud()
	if (LocalPlayer():Alive()) then
		local health = LocalPlayer():Health()
		local hudX = ScrW() / 2
		local hudY = ScrH() - 15 - 20
		local hudWidth = 300
		local alertHealth = 35
		local weapon = LocalPlayer():GetActiveWeapon()
		local clip1 = -1
		local mag = -1
		if (IsValid(weapon)) then
			clip1 = weapon:Clip1()
			mag   = LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType())
		end
		if (mag < 0) then mag = "-" end
		if (clip1 < 0) then clip1 = "-" end
		local weapStr = clip1 .. " / " .. LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType())
		-- weapon hud
		draw.RoundedBox(0, hudX, ScrH() - 145, hudWidth, 100, Color(54, 54, 54, 120))
		draw.DrawText(weapStr, "AmmoFont", hudX+40, ScrH() - 120, Color(255, 255, 255))
		draw.DrawText(string.upper(weapon:GetPrintName()), "WeaponFont", hudX+40, ScrH() - 80, Color(255, 255, 255))

		-- health hud
		draw.RoundedBox(0, hudX, hudY, hudWidth, 20, Color(255,255,255,50))
		if (health < 100) then
			local width = hudWidth * math.Clamp( health / 100, 0, 1 );
			if (health < alertHealth) then
				draw.RoundedBox(0, hudX, hudY, width, 20, Color(255, 0, 0, 200))
			else
				draw.RoundedBox(0, hudX, hudY, width, 20, Color(255, 255, 255))
			end
		end

		-- armor hud
		local armor = LocalPlayer():Armor()
		if (armor > 0) then
			local armorHudWidth = 25
			local armorHudHeight = 130
			local alertArmor = 35
			local armorX = hudX-35
			local armorY = hudY-110
			draw.RoundedBox(0, armorX, armorY, armorHudWidth, armorHudHeight, Color(135, 206, 235, 120))
			if (armor < 100) then
				local height = armorHudHeight * math.Clamp( armor / 100, 0, 1 );
				if (armor < alertArmor) then
					draw.RoundedBox(0, armorX, armorY, armorHudWidth, height, Color(255, 0, 0, 200))
				else
					draw.RoundedBox(0, armorX, armorY, armorHudWidth, height, Color(135, 206, 235))
				end
			end
		end
	end
end

hook.Add("HUDPaint", "ProtoHud", ProtoHud)

-- Nameplates
local function GetScreenCenterBounce(bounce)
	return ScrW() / 2 + 20, (ScrH() / 2) + 32 + (math.sin(CurTime()) * (bounce or 0) )
end

hook.Add("HUDDrawTargetID", "Proto PlayerNameplate", function()
	if (LocalPlayer():Alive()) then
		local fadeDistance = 100
		local tr = LocalPlayer():GetEyeTrace();
		if ( tr.Entity:IsPlayer() or tr.Entity:IsNPC()) then
			local alpha = math.Clamp(255 - ((255 / fadeDistance) * (LocalPlayer():GetPos():Distance(tr.Entity:GetPos()))), 0, 255)
			
			local x, y = GetScreenCenterBounce()
			
			local hudWidth = 100
			local health = tr.Entity:Health()
			draw.RoundedBox(0, x, y+20, hudWidth, 10, Color(255,255,255,50))
			if (health < 100) then
				local width = hudWidth * math.Clamp( health / 100, 0, 1 );
				draw.RoundedBox(0, x, y+20, width, 10, Color(255,255,255,255))
			end
			local entname = (function()
				if tr.Entity:IsPlayer() then return tr.Entity:Name() end
				return ""
			end)()
			y = draw.DrawText(entname, "WeaponFont", x, y, Color(255, 255, 255), alpha)
		end
	end

	return true
end)

-- hide the default stuff
local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true
}

hook.Add("HUDShouldDraw", "HideHUD", function(name)
	if ( hide[ name ] ) then return false end
end)