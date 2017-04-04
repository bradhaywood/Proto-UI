
CreateConVar("proto_ui_scoreboard", "1", FCVAR_REPLICATED, "Enable the Proto UI Scoreboard")
CreateConVar("proto_ui_admin_team", "1", FCVAR_REPLICATED, "The team number for admins")
CreateConVar("proto_ui_vip_team", "2", FCVAR_REPLICATED, "The team number for vip users")
CreateConVar("proto_ui_tag_vip", "[ViP]", FCVAR_REPLICATED, "The tag to use for ViPs")
CreateConVar("proto_ui_tag_admin", "[Admin]", FCVAR_REPLICATED, "The tag to use for Admins")

local logColor = Color(161, 255, 133, 255)
function PLog(str) MsgC(logColor, "[Proto UI] " .. str .. "\n") end

if (CLIENT) then
	PROTO_TEAM_ADMIN = GetConVar("proto_ui_admin_team"):GetInt()
	PROTO_TEAM_VIP   = GetConVar("proto_ui_vip_team"):GetInt()
	PROTO_TAG_VIP    = GetConVar("proto_ui_tag_vip"):GetString()
	PROTO_TAG_ADMIN  = GetConVar("proto_ui_tag_admin"):GetString()
end