local _={}

_.blink=function(params,player)
	log("blink. params:"..pack(params))
	
	log("player before blink:"..pack(player))
	
	local dx=	math.random(-5,5)
	local dy=	math.random(-5,5)
	player.x=player.x+dx
	player.y=player.y+dy
	
	log("player after blink:"..pack(player))
end

_.heal=function(params,player)
	log("heal spell")
	
	Player.heal(player, params.amount)
end

_.polymorph=function(params,player)
	log("casting polymorph")
	-- wip cast on others
	
	player.spriteName=Lume.randomchoice(Registry.playerPresets).spriteName
	
end




return _