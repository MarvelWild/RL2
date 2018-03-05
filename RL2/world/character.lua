_={}

_.new=function(spriteName,hp)
	local result={}
	result.spriteName=spriteName
	result.hp=hp
	return result
end

_.newByCharacterType=function(characterType)
	local spriteName=Registry.spriteNameByCharacterType[characterType]
	local hp=30
	local result=_.new(spriteName,hp)
	return result
end


return _
