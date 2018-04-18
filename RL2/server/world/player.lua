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

return _