local login=function(data,clientId)
	for clId,client in pairs(Server.clients) do
		if client.login==data.login then
			log("WIP: Disconnect existing session")
		end
	end
	
	local client={login=data.login}
	Server.clients[clientId]=client
	Server.clientCount=Server.clientCount+1
	
	
	-- здесь показываем всех доступных сейчас только 1
	local player=W.players[data.login]
	
	-- но биндим уже после выбора
	--client.player=player
	--Server.sendPlayerStatus(client)
	
	Server.send({players={player}}, clientId, data.requestId)
	
end

return login