local _={}

_.removePlayer=function(cell,playerId)
	if cell.players~=nil then
		for playerKey,player in pairs(cell.players) do
			if player.id==playerId then
				cell.players[playerKey]=nil
				return
			end
		end
	end
	
	return
end

_.new=function(x,y)
	local result = {}
	
	
	-- x,y решил пока что не добавлять, чтобы не дублировать данные и не создавать возможности битых
	result.ground_type=nil
	result.groundSpriteName=nil
	
	-- лестница, портал -рисуется под врагом, но над полом
	result.feature=nil
	
	-- противник или npc (-игрок). Character entity
	result.entity=nil
	
	result.wall=nil
	
	-- table. plants,
	result.misc=nil
	
	-- заполняется при передаче клиенту (todo: искать: )
	-- поячейково только передаваемая область: cell.players=getActivePlayersAt(player,x,y)
	-- сразу всех, для серверных обработок: Level.updatePlayers
	
	-- если же нужно получить - использовать 
	result.players=nil
	
	result.items=nil
	
	
	
	-- удобнее отлаживать, но первичные данные это level.cells
	result.x=x
	result.y=y
	
	
	return result
end


_.isEmpty=function(cell)
	if cell.ground_type~=nil then return false end
	if cell.groundSpriteName~=nil then return false end
	if cell.wall~=nil then return false end
	if cell.feature~=nil then return false end
	
	-- incomplete, but sufficient for fill
	
	return true
end

return _