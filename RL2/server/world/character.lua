-- server side part, merged into Character module
local _={}

_.new=function()
	local result={}
	result.id=Id.new("character")
	result.faction="enemy"
	result.isPlayer=false
	result.spriteName=nil
	result.xp=0
	result.lvl=1
	result.hp=30
	result.maxHp=30
	result.xpReward=14
	result.attackMin=2
	result.attackMax=4
	result.inventory={}
	result.effects={}
	result.abilities={}
	--result.x=x
	--result.y=y
	return result
end

_.applyEffect=function(character,effect)
	log("Character.applyEffect")
	
	if character.effects==nil then character.effects={} end
	
	if not effect.isStacking then
		local isProcessed=false
		for k,existingEffect in pairs(character.effects) do
			if existingEffect.type==effect.type then
				character.effects[k]=effect
				isProcessed=true
				break
			end
		end
		
		if not isProcessed then 
			table.insert(character.effects,effect)
		end
	else
		table.insert(character.effects,effect)
	end
end

_.removeEffect=function(character,effectType)
	log("Character.removeEffect:"..effectType)
	
	local effects=character.effects
	local toRemove={}
	for k,v in pairs(effects) do
		if v.type==effectType then
			table.insert(toRemove,k)
		end
	end
	
	for k,v in pairs(toRemove) do
		table.remove(effects, v)
	end
end


-- incomplete, just enough to create player from preset
_.clone=function(character)
	local result=Character.new()
	
	-- можно функцию копирования только строк и чисел
	result.hp=character.hp
	result.maxHp=character.maxHp
	result.spriteName=character.spriteName
	result.abilities={}
	if character.abilities~=nil then
		for k,v in pairs(character.abilities) do
			table.insert(result.abilities,Ability.clone(v))
		end
	end
	
	return result
end



_.receiveXp=function(character,amount)
	character.xp=character.xp+amount
	
	if character.xp > 1000 then
		character.xp=character.xp-1000
		character.lvl=character.lvl+1
	end
	
	
end

_.hit=function(character,damage,cell)
	character.hp=character.hp-damage
	
	if character.hp<=0 then
		character.isDead=true
		if not character.isPlayer then
			cell.entity=nil
		end
		
	end
	
	return true,character.isDead
end



_.heal=function(character,amt)
	character.hp=character.hp+amt
	
	if character.hp>character.maxHp then
		character.hp=character.maxHp
	end
end

return _