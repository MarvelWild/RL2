local _={}

local drawableCache={}

_.getDrawable=function(editorItem)
	local fromCache=drawableCache[editorItem]
	if fromCache~=nil then return fromCache end
	
	local cell=Cell.new()
end

_.applyToCell=function(editorItem,cell)
	if editorItem.type=="ground" then
		cell.ground_type=editorItem.ground_type
	elseif editorItem.type=="character" then
		local characterType=editorItem.character_type
		-- if cell.entity~=nil then ok gc this current
		cell.entity=Character.newByCharacterType(characterType,cell)
	elseif editorItem.type=="feature" then
		-- wip new trees
		local feature=Feature.new(editorItem.feature_type)
		feature.code=editorItem.code
		if editorItem.spriteName~=nil then
			feature.spriteName=editorItem.spriteName
		end
		
		cell.feature=feature
	elseif editorItem.type=="wall" then
		cell.wall=Wall.new(editorItem.wall_type)
	elseif editorItem.type=="item" then
		if cell.items==nil then cell.items={} end
		table.insert(cell.items, Item.new(editorItem.item_type))
	else
		log("error:unk editor item type")
	end
end




_.draw=function(item,worldX,worldY)
	if item.spriteName~=nil then
		local sprite=Img[item.spriteName]
		LG.draw(sprite, worldX, worldY)
		return
	end
	
	
	if item.type=="ground" then
		local itemDrawable=Registry.spriteByGroundType[item.ground_type]
		LG.draw(itemDrawable, worldX, worldY)
	elseif item.type=="character" then
		local drawable=Registry.spriteByCharacterType[item.character_type]
		if drawable==nil then
			LG.print("reg:addCharacter", worldX, worldY)
		else
			LG.draw(drawable, worldX, worldY)
		end
		
		
	elseif item.type=="feature" then
		local drawable=Registry.spriteByFeatureType[item.feature_type]
		if drawable~=nil then
			LG.draw(drawable, worldX, worldY)
		else
			LG.print("spriteByFeatureType",worldX,worldY)
		end
	elseif item.type=="wall" then		
		local drawable=Registry.spriteByWallType[item.wall_type]
		LG.draw(drawable, worldX, worldY)
	elseif item.type=="item" then		
		local spriteInfo=Registry.spriteInfoByItemType[item.item_type]
		LG.draw(spriteInfo.sprite, worldX, worldY)		
	else 
		log("error:unknown item type. Item:"..pack(item))
	end
end


return _