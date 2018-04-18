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

return _