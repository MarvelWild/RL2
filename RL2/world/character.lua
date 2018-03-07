_={}

_.new=function(spriteName,hp)
	local result={}
	result.faction="enemy"
	result.spriteName=spriteName
	result.hp=hp
	result.xpReward=14
	result.attackMin=2
	result.attackMax=4
	--result.x=x
	--result.y=y
	return result
end

_.newByCharacterType=function(characterType)
	local spriteName=Registry.spriteNameByCharacterType[characterType]
	local hp=30
	local result=_.new(spriteName,hp)
	return result
end


_.hit=function(character,damage,cell)
	local isDead=false
	character.hp=character.hp-damage
	
	if character.hp<=0 then
		cell.entity=nil
		isDead=true
	end
	
	
	return isDead
end


return _
