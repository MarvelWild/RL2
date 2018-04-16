_={}

_.new=function()
	local result={}
	result.id=Id.new("character")
	result.faction="enemy"
	result.spriteName=nil
	result.hp=30
	result.xpReward=14
	result.attackMin=2
	result.attackMax=4
	result.inventory={}
	--result.x=x
	--result.y=y
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
