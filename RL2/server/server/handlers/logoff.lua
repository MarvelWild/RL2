local logoff=function(data,clientId)
	local client=Server.clients[clientId]
	Server.clients[clientId]=nil
	Server.clientCount=Server.clientCount-1	
	
	if client.player~=nil then
		client.player.isLoggedIn=false
	end
	
	Server.sendPlayerStatus(client)
	Server.save()
end

return logoff