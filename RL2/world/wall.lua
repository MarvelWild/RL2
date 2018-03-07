local _={}

_.new=function(wallType)
	local result={}
	result.spriteName=Registry.spriteNameByWallType[wallType]
	--result.sprite=Img[result.spriteName]
	
	return result
end

return _