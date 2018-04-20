local player_status=function(data)
	local updatedPlayer=data.player
	if updatedPlayer.id==W.player.id then
		--log("Ignore self update")
	else
		--log("Others update")
		
		
		--  player is not at that cell now
		-- local cell=Level.getCell(W.cells,updatedPlayer.x,updatedPlayer.y)
		-- if cell==nil then return end
		
		local player,playerKey,oldCell=Level.findPlayer(W.cells, updatedPlayer.id)
		if player~=nil then
			log("Remove player from cell:"..pack(oldCell))
			Cell.removePlayer(oldCell,updatedPlayer.id)
			
		else
			log("Error: cannot find player")
		end
	
		if updatedPlayer.levelCode==W.player.levelCode
			and updatedPlayer.isLoggedIn 
		then
			local newCell=Level.getCell(W.cells, updatedPlayer.x,updatedPlayer.y)
			
			-- баг? надо осторожно с .players - оно не гарантировано
			if newCell.players==nil then newCell.players={} end
			table.insert(newCell.players, updatedPlayer)
		end
	end
end

return player_status