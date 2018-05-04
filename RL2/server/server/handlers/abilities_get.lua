local _=function(data, clientId)	
	
	local client=Server.clients[clientId]
	local player=client.player
	
	local response={abilities=player.character.abilities}
	Server.send(response, clientId, data.requestId)
end	

return _