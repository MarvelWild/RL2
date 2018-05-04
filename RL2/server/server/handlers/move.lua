local afterMoved=function(player,prevCell,cell)
	if cell.feature~=nil then
		if cell.feature.featureType=="door" then
			cell.feature.spriteName="door_open"
		end
	end
	
	if prevCell.feature~=nil then
		if prevCell.feature.featureType=="door" and love.math.random()>0.3 then
			prevCell.feature.spriteName="door_closed"
		end
	end
end


local move=function(data, clientId)
	local client=Server.clients[clientId]
	local player=client.player
	--player.
	
	-- todo: prevent cheating
	
	local canMove=true -- ok let ghost fly not player.isDead
	
	local level=Levels[player.levelCode]
	local desiredCell=Level.getCell(level.cells,data.x,data.y)
	local prevCell=Level.getCell(level.cells,player.x,player.y)
	
	if not player.isEditor and not player.isDead then
		local entityAtDest=desiredCell.entity
		if entityAtDest~=nil then
			if entityAtDest.faction=="enemy" then
				canMove=false
				
				local damage = math.random(player.attackMin, player.attackMax)
				local isHit,isDead=Character.hit(entityAtDest,damage,desiredCell)
				if isDead then
					Character.receiveXp(player.character, entityAtDest.xpReward)
				end
				
				
				local damageFromMonster=math.random(entityAtDest.attackMin, entityAtDest.attackMax)
				Character.hit(player.character,damageFromMonster)
			end
		end
		
		if desiredCell.wall~=nil then
			canMove=false
		elseif desiredCell.ground_type=="water" or desiredCell.ground_type=="lava" then
			canMove=false
		end
	end
	
	local prevX=player.x
	local prevY=player.y
	
	if canMove then
		player.x=data.x
		player.y=data.y
		
		afterMoved(player,prevCell,desiredCell)
	end
	
	Server.sendTurn(client, clientId, data.requestId)
	Server.sendPlayerStatus(client)
end

return move