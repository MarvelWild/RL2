-- shared

local _={}

local drawableCache={}

_.getDrawable=function(editorItem)
	local fromCache=drawableCache[editorItem]
	if fromCache~=nil then return fromCache end
	
	local cell=Cell.new()
end


_.draw=function(item,worldX,worldY)
	if item.spriteName~=nil then
		local sprite=Img.get(item.spriteName)
		LG.draw(sprite, worldX, worldY)
	end
end


return _