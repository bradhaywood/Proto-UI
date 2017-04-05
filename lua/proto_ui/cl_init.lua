include "shared.lua"

include "cl_hud.lua"
include "cl_weaponswap.lua"
include "cl_pmessage.lua"

if (GetConVar("proto_ui_scoreboard"):GetBool()) then
	include "cl_scoreboard.lua"
end