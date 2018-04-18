-- server

local _={}

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

return _