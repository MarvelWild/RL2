local preset_picked=function(data,clientId)
	log("new player")
	local pickNumber=data.pick
	local preset=Registry.playerPresets[pickNumber]
	local player=Player.new(preset)
	player.isLoggedIn=true
	local client=Server.clients[clientId]
	Players[client.login]=player
	client.player=player
	
	Level.load(player.levelCode)
	
	-- local test=Players[client.login]
	Server.send({"ok"}, clientId, data.requestId)
end


return preset_picked