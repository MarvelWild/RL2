local _={}

_.new=function(wallType)
	local result={}
	result.id=Id.new("wall")
	result.spriteName=nil
	--Registry.spriteNameByWallType[wallType]
	--result.sprite=Img[result.spriteName]
	
	return result
end

return _