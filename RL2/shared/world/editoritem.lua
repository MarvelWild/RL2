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
		cell.groundSpriteName=editorItem.spriteName
	elseif editorItem.type=="character" then
		-- if cell.entity~=nil then ok gc this current
		cell.entity=Character.new()
		cell.entity.spriteName=editorItem.spriteName
	elseif editorItem.type=="feature" then
		local feature=Feature.new(editorItem.featureType)
		feature.code=editorItem.code
		feature.code=editorItem.code
		feature.spriteName=editorItem.spriteName
		cell.feature=feature
	elseif editorItem.type=="wall" then
		cell.wall=Wall.new(editorItem.wall_type)
		cell.wall.spriteName=editorItem.spriteName
	elseif editorItem.type=="item" then
		if cell.items==nil then cell.items={} end
		local item=Item.clone(editorItem.item)
		table.insert(cell.items, item)
	else
		log("error:unk editor item type")
	end
end




_.draw=function(item,worldX,worldY)
	if item.spriteName~=nil then
		local sprite=Img.get(item.spriteName)
		LG.draw(sprite, worldX, worldY)
	end
end


return _