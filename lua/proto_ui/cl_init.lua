include "shared.lua"

include "cl_hud.lua"
include "cl_weaponswap.lua"

if (GetConVar("proto_ui_scoreboard"):GetBool()) then
	include "cl_scoreboard.lua"
end