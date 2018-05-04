local ability_use=function(data, clientId)
	log("ability_use")
	
	local client=Server.clients[clientId]
	local player=client.player
	local ability=data.ability
	Server.abilities[ability.code](ability,player)
	
	Server.sendTurn(client, clientId, data.requestId)
end

return ability_use