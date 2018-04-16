local get_full_state=function(data, clientId)
	local clientWorld={}
	clientWorld.time=W.time
	
	local client = Server.clients[clientId]
	
	clientWorld.player=client.player
	clientWorld.cells=Server.getVisibleCells(client.player)
	
	Server.send(clientWorld, clientId, data.requestId)
end


return get_full_state