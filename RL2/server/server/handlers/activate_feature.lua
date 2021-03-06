-- use ladder, portal, fountain
local activate_feature=function(data, clientId)
	--activate_feature. data={requestId=8,cmd="activate_feature"}
	log("activate_feature. data="..pack(data))
	local client=Server.clients[clientId]
	local player=client.player
	local level=Levels[player.levelCode]
	local cell=Level.getCell(level.cells,player.x,player.y)
	
	local feature=cell.feature
	
	if feature==nil then 
		Server.sendOk(clientId, data.requestId)
		return 
	end
	
	
	local statusBeforeActivation=
	{
		x=player.x,
		y=player.y,
		levelCode=player.levelCode,
		hp=player.hp,
	}

	Feature.activate(feature,player,level)
	local isStatusChanged=not table.existingEquals(statusBeforeActivation,player)
	
	-- local response={"ok"}
	Server.sendTurn(client, clientId, data.requestId)
	-- _.send(response, clientId, data.requestId)
	if isStatusChanged then
		Server.sendPlayerStatus(client,true)
	end
end

return activate_feature