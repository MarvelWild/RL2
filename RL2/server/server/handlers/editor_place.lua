local editor_place=function(data,clientId)
	local editorItem=data.item
	
	local client = Server.clients[clientId]
	
	local player=client.player
	local level=Levels[player.levelCode]
	
--	dump(level.cells, "editor_place")
	
	local cell = Level.getCell(level.cells,data.x,data.y)
	
	EditorItem.applyToCell(editorItem,cell)
	
	Server.sendTurn(client, clientId, data.requestId)
end


return editor_place