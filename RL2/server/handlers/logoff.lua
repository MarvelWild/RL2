local logoff=function(data,clientId)
	local client=Server.clients[clientId]
	Server.clients[clientId]=nil
	Server.clientCount=Server.clientCount-1	
	client.player.isLoggedIn=false
	Server.sendPlayerStatus(client)
end

return logoff