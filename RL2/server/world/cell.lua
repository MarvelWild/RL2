local _={}



_.clear=function(cell)
	cell.items=nil
	cell.wall=nil
	cell.entity=nil
	cell.feature=nil
	cell.ground_type=nil
	cell.groundSpriteName=nil
	cell.misc=nil
end

-- не гарантирует результат (см cell.players)
_.findPlayer=function(cell, playerId)
	if cell.players~=nil then
		for playerKey,player in pairs(cell.players) do
			if player.id==playerId then
				return player, playerKey
			end
		end
	end
	
	return nil,nil
end





return _