local editor_place=function(data,clientId)
	local editorItem=data.item
	
	local client = Server.clients[clientId]
	
	local player=client.player
	local level=W.levels[player.level]
	
--	dump(level.cells, "editor_place")
	
	local cell = Level.getCell(level.cells,data.x,data.y)
	if editorItem.type=="ground" then
		cell.ground_type=editorItem.ground_type
	elseif editorItem.type=="character" then
		local characterType=editorItem.character_type
		-- if cell.entity~=nil then ok gc this current
		cell.entity=Character.newByCharacterType(characterType,cell)
	elseif editorItem.type=="feature" then
		cell.feature=Feature.new(editorItem.feature_type)
	elseif editorItem.type=="wall" then
		cell.wall=Wall.new(editorItem.wall_type)
	elseif editorItem.type=="item" then
		if cell.items==nil then cell.items={} end
		table.insert(cell.items, Item.new(editorItem.item_type))
	else
		log("error:unk editor item type")
	end
	
	Server.sendTurn(client, clientId, data.requestId)
end


return editor_place