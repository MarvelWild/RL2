_={}

_.new=function(spriteName)
	local result={}
	result.spriteName=spriteName
	return result
end

_.newByCharacterType=function(characterType)
	local spriteName=Registry.spriteNameByCharacterType[characterType]
	local result=_.new(spriteName)
	return result
end


return _
