local _={}

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
			
			if item.sprite==nil then
				log("error: item has no sprite"..pack(item))
			end
			
			LG.draw(item.sprite, drawX, drawY)
			
		end
	end
	
	if cell.entity~=nil then
		local isVideoAltered=false
		if cell.entity.effects~=nil then
			for k,effect in pairs(cell.entity.effects) do
				if effect.type=="paint" then
					if effect.color.r~=nil then
						LG.setColor(effect.color.r,effect.color.g,effect.color.b)
					end
					isVideoAltered=true
				end
			end
		end
		
		
		if cell.entity.spriteName~=nil then 
			local sprite=Img[cell.entity.spriteName]
			LG.draw(sprite, drawX, drawY)
		end
		
		if isVideoAltered then
			LG.setColor(1,1,1,1)
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