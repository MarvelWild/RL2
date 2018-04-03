local move=function(data, clientId)
	local client=Server.clients[clientId]
	local player=client.player
	--player.
	
	-- todo: prevent cheating
	
	local canMove=true -- ok let ghost fly not player.isDead
	
	local level=W.levels[player.level]
	local desiredCell=Level.getCell(level.cells,data.x,data.y)
	
	if not player.isEditor and not player.isDead then
		local entityAtDest=desiredCell.entity
		if entityAtDest~=nil then
			if entityAtDest.faction=="enemy" then
				canMove=false
				
				local damage = math.random(player.attackMin, player.attackMax)
				local isDead=Character.hit(entityAtDest,damage,desiredCell)
				if isDead then
					Player.receiveXp(player, entityAtDest.xpReward)
				end
				
				
				local damageFromMonster=math.random(entityAtDest.attackMin, entityAtDest.attackMax)
				Player.hit(player,damageFromMonster)
			end
		end
		
		if desiredCell.wall~=nil then
			canMove=false
		end
	end
	
	
	if canMove then
		player.x=data.x
		player.y=data.y
	end
	
	Server.sendTurn(client, clientId, data.requestId)
end

return move