local _={}

local drawItem=function(item,cellX,cellY)
	

	-- log("drawing item:"..cellX..","..cellY..TSerial.pack(item))
	
	local worldX = Ui.rightbox.x+(cellX*C.tileSize)
	local worldY = Ui.rightbox.y+(cellY*C.tileSize)
	
	if item.type=="ground" then
		local itemDrawable=Registry.spriteByGroundType[item.ground_type]
		LG.draw(itemDrawable, worldX, worldY)
	elseif item.type=="character" then
		local drawable=Registry.spriteByCharacterType[item.character_type]
		LG.draw(drawable, worldX, worldY)
	elseif item.type=="feature" then
		local drawable=Registry.spriteByFeatureType[item.feature_type]
		LG.draw(drawable, worldX, worldY)
	elseif item.type=="wall" then		
		local drawable=Registry.spriteByWallType[item.wall_type]
		--LG.draw(drawable, worldX, worldY)
		LG.draw(Img.wall_stone, worldX, worldY)
	else 
		log("error:unknown item type")
	end
	
	if cellX==C.editorCurrentCol and cellY==C.editorCurrentRow then
		LG.draw(Img.active_frame_32, worldX, worldY)
	end
end

_.draw=function()
	local line1="Editor coords:"..W.player.x..","..W.player.y
	LG.print(line1,Ui.rightbox.x+10,Ui.rightbox.y+5)
	
	local itemsCount = #Registry.editorItems
	
	if itemsCount==0 then return end
	
	local itemIndex=1
	local nextItem = Registry.editorItems[itemIndex]
	
	for y=1,C.editorRows do
		for x=1,C.editorCols do
			drawItem(nextItem,x,y)
			
			itemIndex=itemIndex+1
			nextItem = Registry.editorItems[itemIndex]
			
			if nextItem==nil then break end
		end
		if nextItem==nil then break end
	end
	
end

_.update=function()
end



return _







