local _={}

_.new=function()
	local result={}
	
	result.cells={}
	
	return result
end


_.getCell=function(cells,x,y)
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