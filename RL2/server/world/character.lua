-- server side part, merged into Character module
local _={}

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

-- incomplete, just enough to create player from preset
_.clone=function(character)
	local result=Character.new()
	
	result.hp=character.hp
	result.spriteName=character.spriteName
	result.abilities={}
	if character.abilities~=nil then
		for k,v in pairs(character.abilities) do
			table.insert(result.abilities,Ability.clone(v))
		end
	end
	
	return result
end

return _