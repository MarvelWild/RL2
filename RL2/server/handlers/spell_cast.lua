local spell_cast=function(data, clientId)
	log("spell_cast")
	
	local client=Server.clients[clientId]
	local player=client.player
	local spell=data.spell
	Server.spells[spell.code](spell,player)
	
	Server.sendTurn(client, clientId, data.requestId)
end

return spell_cast