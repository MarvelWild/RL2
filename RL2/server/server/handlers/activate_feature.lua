-- use ladder, portal, fountain
local activate_feature=function(data, clientId)
	--activate_feature. data={requestId=8,cmd="activate_feature"}
	log("activate_feature. data="..pack(data))
	local client=Server.clients[clientId]
	local player=client.player
	local level=Levels[player.level]
	local cell=Level.getCell(level.cells,player.x,player.y)
	local isStatusChanged=false
	
	local feature=cell.feature
	
	if feature==nil then 
		Server.sendOk(clientId, data.requestId)
		return 
	end
	
	if feature.featureType=="portal" then
		player.level=feature.dest
		isStatusChanged=true
	else
		--error: not implemented for feature:{spriteName="ladder_down",id=5}
		log("error: not implemented for feature:"..pack(feature))
	end
	
	-- local response={"ok"}
	Server.sendTurn(client, clientId, data.requestId)
	-- _.send(response, clientId, data.requestId)
	if isStatusChanged then
		Server.sendPlayerStatus(client,true)
	end
end

return activate_feature