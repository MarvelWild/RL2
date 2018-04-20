local editor_delete=function(data,clientId)
	local client = Server.clients[clientId]
	
	local player=client.player
	local level=Levels[player.levelCode]
	
	local cell = Level.getCell(level.cells,data.x,data.y)
	Cell.clear(cell)
	
	Server.sendTurn(client, clientId, data.requestId)
end


return editor_delete