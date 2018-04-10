local _={}

_.new=function(itemType)
	local result={}
	local spriteInfo=Registry.spriteInfoByItemType[itemType]
	result.id=Id.new("item")
	result.spriteName=spriteInfo.spriteName
	result.type=itemType
	
	--result.sprite=Img[result.spriteName]
	
	return result
end

return _