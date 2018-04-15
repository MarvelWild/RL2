local _={}

_.new=function(x,y)
	local result = {}
	
	
	-- x,y решил пока что не добавлять, чтобы не дублировать данные и не создавать возможности битых
	result.ground_type=nil
	
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

local shader = love.graphics.newShader("res/shaders/technicolor1.frag","res/shaders/dummy.v")

SHEEP_HACK=1
SHEEP_HACK2=1
SHEEP_HACK3=1

_.draw=function(cell,drawX,drawY)
	local groundSprite = Registry.spriteByGroundType[cell.ground_type]
	
	if groundSprite~=nil then
		LG.draw(groundSprite, drawX, drawY)
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
			
			
			
			if cell.entity.spriteName=="sheep" then
				if S.frame%180==0 then
					SHEEP_HACK=love.math.random()
					SHEEP_HACK2=love.math.random()
					SHEEP_HACK3=love.math.random()
				end
				
				
				SHEEP_HACK=SHEEP_HACK+Lume.random(-0.006,0.004)
				SHEEP_HACK2=SHEEP_HACK2+Lume.random(-0.008,0.012)
				SHEEP_HACK3=SHEEP_HACK3+Lume.random(-0.004,0.008)
				
--				LG.print(SHEEP_HACK,10,10)
--				LG.print(SHEEP_HACK2,10,30)
--				LG.print(SHEEP_HACK3,10,50)
				
				LG.setColor(SHEEP_HACK2,SHEEP_HACK,SHEEP_HACK3,1)
--				love.graphics.setShader(shader)
			end
			LG.draw(sprite, drawX, drawY)
			
			if cell.entity.spriteName=="sheep" then
--				love.graphics.setShader()
				LG.setColor(1,1,1,1)
			end
		
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