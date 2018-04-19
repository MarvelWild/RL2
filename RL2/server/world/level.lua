-- server only

local _={}

_.new=function(name)
	local result={}
	
	result.name=name
	result.depth=0
	result.cells={}
	
	return result
end


--должна оставаться единственной точкой получения ячейки

_.getUpdatedCell=function(cells,x,y)

	local cell=Level.getCell(cells,x,y)
	Life.updateCell(cell)
	
	return cell
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