local activate_feature=function(data, clientId)
	local client=Server.clients[clientId]
	local player=client.player
	local level=W.levels[player.level]
	local cell=Level.getCell(level.cells,player.x,player.y)
	
	local feature=cell.feature
	
	if feature==nil then 
		Server.sendOk(clientId, data.requestId)
		return 
	end
	
	if feature.featureType=="portal" then
		player.level=feature.dest
	else
		log("error: not implemented")
	end
	
	-- local response={"ok"}
	Server.sendTurn(client, clientId, data.requestId)
	-- _.send(response, clientId, data.requestId)
end

return activate_feature