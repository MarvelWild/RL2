local _={}

_.new=function()
	local result={}
	
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



_.updatePlayers=function(levelName,cells)
	for k,cell in pairs(cells) do
		cell.players=nil
		
		for k2,player in pairs() do
			if player.x==cell.x and player.y==cell.y and player.level==levelName then
				if cell.players==nil then cell.players={} end
				table.insert(cell.players,player)
			end
		end
		
	end
end

return _