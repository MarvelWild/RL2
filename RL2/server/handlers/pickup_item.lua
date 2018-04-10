local pickup_item=function(data,clientId)
	local x=data.x
	local y=data.y
	local itemIds=data.itemIds
	
	local client = Server.clients[clientId]
	
	local player=client.player
	local level=W.levels[player.level]
	
	local cell=Level.getCell(level.cells,x,y)
	
	local cellItems=cell.items
	
	local pickKeys={}
	
	if cellItems~=nil then
		for k,cellItem in pairs(cell.items) do
			local cellItemId=cellItem.id
			for k2,pickId in pairs(itemIds) do
				if pickId==cellItemId then
					table.insert(pickKeys,k)
					break
				end
			end
		end
	end
	
	for k,pickKey in ipairs(pickKeys) do
		local item=cellItems[pickKey]
		cellItems[pickKey]=nil
		table.insert(player.inventory, item)
	end
	
	Server.sendTurn(client, clientId, data.requestId)
end


return pickup_item