-- 

local pick_player=function(data,clientId)
	local response={}
	local playerId=data.playerId
	local isEditor=data.isEditor
	
	local player=nil
	for k,v in pairs(Players) do
		if v.id==playerId then 
			player=v
			break
		end
	end
	
	assert(player~=nil)
	
	local client=Server.clients[clientId]
	client.player=player
	player.isEditor=isEditor
	player.isLoggedIn=true
	
	Level.load(player.levelCode)
	
	response.responseType="pick_player_ok"
	Server.send(response, clientId, data.requestId)
	
	Server.sendPlayerStatus(client)
end


return pick_player