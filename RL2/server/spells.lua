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
	
	local level=W.levels[player.level]
	local cell=Level.getCell(level.cells,params.x,params.y)
	
	local entity=cell.entity
	if entity~=nil then
		entity.spriteName=Lume.randomchoice_anytable(Registry.spriteNameByCharacterType)
	end
	
	local cellPlayers=Server.getActivePlayersAtCell(player.level,params.x,params.y)
	
	if cellPlayers~=nil then
		for k,cellPlayer in pairs(cellPlayers) do
			cellPlayer.spriteName=Lume.randomchoice(Registry.playerPresets).spriteName
		end
	end
	
end




return _