local _={}

_.receiveXp=function(player,amount)
	player.xp=player.xp+amount
	
	if player.xp > 1000 then
		player.xp=player.xp-1000
		player.lvl=player.lvl+1
	end
	
	
end

_.hit=function(player,damage)
	player.hp=player.hp-damage
	
	if player.hp<=0 then
		player.isDead=true
	end
	
end

_.heal=function(player,amt)
	player.hp=player.hp+amt
	
	if player.hp>player.maxHp then
		player.hp=player.maxHp
	end
end



_.new=function(preset)
	local r={}
	
	r.id=Id.new("player")
	r.x=0
	r.y=0
	r.isDead=false
	r.name="Anonymous"
	r.hp=42
	r.maxHp=42
	r.xp=0
	r.lvl=1
	r.levelCode="start_0"
	r.fov=6
	r.attackMin=1
	r.attackMax=5
	r.isEditor=false
	r.isLoggedIn=false;
	r.inventory={} -- indexed, handled by Inventory
	
	if preset.character~=nil then
		r.character=Character.clone(preset.character)
	else
		r.character=Character.new()
		r.character.spriteName=preset.spriteName
	end
	
	return r
end

return _