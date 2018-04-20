local _={}

-- Хоть new и используется на сервере, всегда ложим в shared чтобы понимать структуру
_.new=function(name)
	local result={}
	
	result.name=name
	result.depth=0
	result.cells={}
	
	return result
end

_.getCell=function(cells,x,y)

	assert(x~=nil)
	assert(y~=nil)
	
	local col = cells[x]
	if col == nil then
		col={}
		cells[x]=col
	end
	
	local cell = col[y]
	if cell ==  nil then
		cell= Cell.new(x,y)
		col[y]=cell
	end
	
	return cell
end

-- не гарант, юзать updatePlayers для гарант
_.findPlayer=function(cells, playerId)
	local player=nil
	
	--log("Columns count:"..#cells) -- lies
	for colIndex,col in pairs(cells) do
		for rowIndex,cell in pairs(col) do
			-- log("Checking cell for player:"..pack(cell))
			
			if cell.players~=nil then
				for playerKey,player in pairs(cell.players) do
					if player.id==playerId then
						return player, playerKey, cell
					end
				end
			end
		end
	end
	
	return nil,nil,nil
end

return _