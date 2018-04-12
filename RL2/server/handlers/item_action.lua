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
		-- todo: can we?
		for k,itemId in pairs(data.itemIds) do
			local seed=Inventory.removeItem(inventory,itemId)
			-- todo: что вырастет - это свойство семечки, и сущность
			cell.ground_type="grass_planted"
			
			if cell.misc==nil then cell.misc={} end
			
			local plantedTime=os.time()
			local plant={
				entityType="plant",
				seed=seed,
				plantedTime=plantedTime,
				growStates={
					[1]={
						spriteName="tomato_grow_1",
						timeNextState=plantedTime+10,
					},
					[2]={
						spriteName="tomato_grow_2",
						timeNextState=plantedTime+30,
					},
					[3]={
						spriteName="tomato_grow_3",
						timeNextState=plantedTime+60,
					},
					[4]={
						spriteName="tomato_grow_4",
					},
					-- harvested: manual state switch
					[5]={
						spriteName="tomato_grow_5",
					},					
				},
				currentGrowState=1,
			}
			
			table.insert(cell.misc, plant)
			
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