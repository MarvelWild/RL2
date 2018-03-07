local Player={}

local newId=function()
	local result = C.lastId.player
	C.lastId.player=C.lastId.player+1
	return result
end


Player.new=function(preset)
	local r={}
	
	r.id=newId()
	r.x=0
	r.y=0
	r.isDead=false
	r.name="Anonymous"
	r.hp=42
	r.xp=0
	r.lvl=1
	r.level="start"
	r.fov=5
	r.attackMin=1
	r.attackMax=5
	r.spriteName=preset.spriteName
	r.isEditor=false
	return r
end

Player.receiveXp=function(player,amount)
	player.xp=player.xp+amount
	
	if player.xp > 1000 then
		player.xp=player.xp-1000
		player.lvl=player.lvl+1
	end
	
	
end

Player.hit=function(player,damage)
	player.hp=player.hp-damage
	
	if player.hp<=0 then
		player.isDead=true
	end
	
end


return Player