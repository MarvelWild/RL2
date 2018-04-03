local pick_player=function(data,clientId)
	local response={}
	local playerId=data.playerId
	local isEditor=data.isEditor
	
	local player=nil
	for k,v in pairs(W.players) do
		if v.id==playerId then 
			player=v
			break
		end
	end
	
	assert(player~=nil)
	
	local client=Server.clients[clientId]
	client.player=player
	player.isEditor=isEditor
	
	response.responseType="pick_player_ok"
	Server.send(response, clientId, data.requestId)
end


return pick_player