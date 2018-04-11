local item_action=function(data,clientId)
	log("item action wip. Data:"..pack(data))
	
	--data example:	{requestId=3,cmd="item_action",itemIds={[1]=2},actionCode="plant"}
	
	local client=Server.clients[clientId]
	local player=client.player
	local inventory=player.inventory
	
	local actionCode=data.actionCode
	local level=Levels[player.level]
	local cell=Level.getCell(level.cells,player.x,player.y)
	
	if actionCode=="plant" then
		for k,itemId in pairs(data.itemIds) do
			Inventory.removeItem(inventory,itemId)
			-- todo: что вырастет - это свойство семечки, и сущность
			cell.ground_type="grass_planted"
		end
	elseif actionCode=="drop" then
		for k,itemId in pairs(data.itemIds) do
			local removedItem=Inventory.removeItem(inventory,itemId)
			if cell.items==nil then cell.items={} end
			table.insert(cell.items, removedItem)
		end
	end
	
	
	
	Server.sendTurn(client, clientId, data.requestId)
end


return item_action