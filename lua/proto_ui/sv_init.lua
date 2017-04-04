include "shared.lua"
include "sv_manifest.lua"

hook.Add("PlayerDeath", "Proto PlayerDeath", function(ply, inflictor, attacker)
	-- if someone suicides, we don't want their frags returning negative numbers
	if attacker:IsPlayer() and attacker:Name() == ply:Name() then
		attacker:AddFrags(1)
	end
end)

hook.Add("Initialize", "Proto Initialize", function()
	PLog("Enjoy your slick interface")
end)

-- add font
resource.AddFile("resource/fonts/prototype.ttf")
resource.AddFile("sound/proto_ui/weaponselection/switch1.wav")
resource.AddFile("sound/proto_ui/weaponselection/switch2.wav")
resource.AddFile("sound/proto_ui/weaponselection/switch3.wav")
resource.AddFile("sound/proto_ui/weaponselection/switch4.wav")
resource.AddFile("sound/proto_ui/weaponselection/switch5.wav")
resource.AddFile("sound/proto_ui/weaponselection/switch6.wav")

util.AddNetworkString("ProtoSelectWeapon")
net.Receive("ProtoSelectWeapon", function(len, ply)
	local swep = net.ReadString()
	ply:SelectWeapon(swep)
end)