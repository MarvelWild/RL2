-- server only

local _={}

--должна оставаться единственной точкой получения ячейки

-- загружает уровень если ещё не загружен
-- возвращает уровень
_.load=function(levelName)
	
-- prev load
--	for k,levelName in pairs(levelSaves) do
--		local packed=love.filesystem.read(levelsDir..levelName)
--		Levels[levelName]=TSerial.unpack(packed)
--	end	
	
	local result=Levels[levelName]
	if result==nil then
		
		local file=SERVER_SAVE_DIR..LEVELS_SAVE_DIR..levelName
		local info=love.filesystem.getInfo(file)
		if info~=nil then
			local packed=love.filesystem.read(file)
			result=TSerial.unpack(packed)
			log("loading level:"..levelName)
		else
			result=Level.new(levelName)
			log("creating level:"..levelName)
		end
		
		Levels[levelName]=result
	end
	
	return result
end

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