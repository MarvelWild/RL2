local editor_place_area=function(data,clientId)
	local editorItem=data.item
	
	--[[
	local command={
		cmd="editor_place_area",
		item=item,
		x1=x1,
		y1=y1,
		x2=x2,
		y2=y2,
	}	
	]]--
	
	local client = Server.clients[clientId]
	
	local player=client.player
	local level=Levels[player.levelCode]
	
--	dump(level.cells, "editor_place")
	
	local x1=data.x1
	local x2=data.x2
	local y1=data.y1
	local y2=data.y2
	
	local yInc=Lume.sign(y2-y1)
	local xInc=Lume.sign(x2-x1)
	for y=y1,y2,yInc do
		for x=x1,x2,xInc do
			local cell = Level.getCell(level.cells,x,y)
			EditorItem.applyToCell(editorItem,cell)
		end
	end
	
	Server.sendTurn(client, clientId, data.requestId)
end


return editor_place_area