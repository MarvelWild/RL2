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
	log("heal ability")
	
	if params.amount~=nil then
		Charatcer.heal(player.character, params.amount)
	end
end

_.polymorph=function(params,player)
	log("casting polymorph")
	
	local level=Levels[player.levelCode]
	local cell=Level.getCell(level.cells,params.x,params.y)
	
	local entity=cell.entity
	if entity~=nil then
		-- cast on npc
		entity.spriteName=Lume.randomchoice_anytable(Registry.getEntitySpriteNames())
	end
	
	local cellPlayers=Server.getActivePlayersAtCell(player.levelCode,params.x,params.y)
	
	-- cast on players
	if cellPlayers~=nil then
		for k,cellPlayer in pairs(cellPlayers) do
			
			local allSprites=Registry.getEntitySpriteNames()

			for k,preset in pairs(Registry.playerPresets) do
				table.insert(allSprites, preset.spriteName)
			end
			
			cellPlayer.spriteName=Lume.randomchoice(allSprites)
		end
	end
	
end




return _