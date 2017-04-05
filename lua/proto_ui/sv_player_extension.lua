PLAYER = FindMetaTable("Player")

function PLAYER:PMessage(str)
	net.Start("PMessage")
	net.WriteString(str)
	net.Send(self)
end