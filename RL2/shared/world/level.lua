local _={}

-- Хоть new и используется на сервере, всегда ложим в shared чтобы понимать структуру
_.new=function(name,depth)
	local result={}
	
	if depth==nil then depth=0 end
	
	result.name=name -- name only, example: dungeon
	
	-- по этому полю левела лежат в глобале Levels
	result.code=name -- name_depth (default:0) dungeon_42
	result.depth=0
	result.cells={}
	
	return result
end

_.setDepth=function(level,depth)
	level.code=level.name.."_"..depth
	level.depth=depth
end


-- code:level_42 -> name:level, depth:42
_.splitCode=function(code)
	local parts=Lume.split(code,"_")
	
	-- name,depth
	return parts[1],tonumber(parts[2])
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