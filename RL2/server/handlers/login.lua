local login=function(data,clientId)
	for clId,client in pairs(Server.clients) do
		if client.login==data.login then
			log("WIP: Disconnect existing session")
		end
	end
	
	local client={login=data.login}
	Server.clients[clientId]=client
	Server.clientCount=Server.clientCount+1
	
	local player=W.players[data.login]
	
	--можно играть и мёртвыми ))
	--if player~=nil and player.isDead then player=nil end
	
	-- todo : multiple players for client
	client.player=player
	player.isLoggedIn=true
	
	Server.send({players={player}}, clientId, data.requestId)
	Server.sendPlayerStatus(client)
end

return login