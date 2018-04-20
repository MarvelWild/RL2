-- server only

local _={}

--должна оставаться единственной точкой получения ячейки

-- загружает уровень если ещё не загружен
-- возвращает уровень

-- levelName example:start,start_-1
_.load=function(code)
	
-- prev load
--	for k,levelName in pairs(levelSaves) do
--		local packed=love.filesystem.read(levelsDir..levelName)
--		Levels[levelName]=TSerial.unpack(packed)
--	end	
	
	local result=Levels[code]
	local isNew=false
	if result==nil then
		
		local file=SERVER_SAVE_DIR..LEVELS_SAVE_DIR..code
		local info=love.filesystem.getInfo(file)
		if info~=nil then
			local packed=love.filesystem.read(file)
			result=TSerial.unpack(packed)
			log("loading level:"..code)
		else
			local levelName,depth=Level.splitCode(code)
			
			result=Level.new(levelName)
			Level.setDepth(result,depth)
			
			isNew=true
			log("creating level:"..levelName)
		end
		
		Levels[code]=result
	end
	
	return result,isNew
end

_.getUpdatedCell=function(cells,x,y)

	local cell=Level.getCell(cells,x,y)
	Life.updateCell(cell)
	
	return cell
end






--[[
_.updatePlayers=function(levelCode,cells)
	for k,cell in pairs(cells) do
		cell.players=nil
		
		for k2,player in pairs() do
			if player.x==cell.x and player.y==cell.y and player.levelCode==levelCode then
				if cell.players==nil then cell.players={} end
				table.insert(cell.players,player)
			end
		end
		
	end
end
]]--
return _