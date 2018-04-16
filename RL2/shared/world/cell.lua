local _={}

_.new=function(x,y)
	local result = {}
	
	
	-- x,y решил пока что не добавлять, чтобы не дублировать данные и не создавать возможности битых
	result.ground_type=nil
	result.groundSpriteName=nil
	
	-- лестница, портал -рисуется под врагом, но над полом
	result.feature=nil
	
	-- противник или npc (-игрок)
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

_.clear=function(cell)
	cell.items=nil
	cell.wall=nil
	cell.entity=nil
	cell.feature=nil
	cell.ground_type=nil
	cell.misc=nil
end

-- не гарантирует результат (см cell.players)
_.findPlayer=function(cell, playerId)
	if cell.players~=nil then
		for playerKey,player in pairs(cell.players) do
			if player.id==playerId then
				return player, playerKey
			end
		end
	end
	
	return nil,nil
end


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

_.draw=function(cell,drawX,drawY)
	if cell.groundSpriteName~=nil then
		local drawable=Img[cell.groundSpriteName]
		LG.draw(drawable, drawX, drawY)
	else
--		LG.print("NoGround", drawX, drawY)
	end
	
	if cell.wall~=nil then
		local wallSprite=Img[cell.wall.spriteName]
		
		if wallSprite~=nil then
			LG.draw(wallSprite, drawX, drawY)
		end
	end
	
	if cell.feature~=nil then
		local featureSprite=Img[cell.feature.spriteName]
		if featureSprite==nil then
			log("error: no sprite for feat:"..cell.feature.spriteName)
			featureSprite=Img.error
		end
		
		LG.draw(featureSprite, drawX, drawY)
	end
		
		
	if cell.misc~=nil then
		for k,miscItem in pairs(cell.misc) do
			if miscItem.entityType=="plant" then
			
				local growState=miscItem.growStates[miscItem.currentGrowState]
				local img=Img[growState.spriteName]
				local height = img:getHeight()
				
				local offsetY=height-C.tileSize
				LG.draw(img,drawX, drawY-offsetY)
			end
		end
	end
	
	
	if cell.items~=nil then
		for k,item in pairs(cell.items) do
			if item.sprite==nil then
				item.sprite=Img[item.spriteName]
			end
			
			LG.draw(item.sprite, drawX, drawY)
			
		end
	end
	
	if cell.entity~=nil then
		if cell.entity.spriteName~=nil then 
			local sprite=Img[cell.entity.spriteName]
			LG.draw(sprite, drawX, drawY)
		end
	end
	
	-- others
	if cell.players~=nil then
			for k,player in pairs(cell.players) do
					LG.draw(Img[player.spriteName],drawX,drawY)
					
					table.insert(UiLayer, Lume.fn(LG.print, player.name, drawX, drawY-12))
			end
	end

end





return _