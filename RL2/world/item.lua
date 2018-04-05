local _={}

_.new=function(itemType)
	local result={}
	local spriteInfo=Registry.spriteInfoByItemType[itemType]
	result.spriteName=spriteInfo.spriteName
	
	--result.sprite=Img[result.spriteName]
	
	return result
end

return _