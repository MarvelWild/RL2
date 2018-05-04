local _={}

_.activate=function(feature,player,level)
	-- input examples:
	-- feature={featureType="ladder",id=15,code="ladder_down",spriteName="ladder_down"}}
	
	local isSuccess=true
	
	local featType=feature.featureType
	if featType=="portal" then
		player.levelCode=feature.dest
	elseif featType=="ladder" then
		-- lvl name
		local currentDepth=level.depth
		local nextDepth=currentDepth
		if feature.code=="ladder_down" then
			nextDepth=nextDepth-1
		elseif 	feature.code=="ladder_up" then
			nextDepth=nextDepth+1
		else
			log("error: unknown ladder code:"..pack(feature))
			return
		end
		
		local levelCode=level.name.."_"..nextDepth
		
		local level,isNew=Level.load(levelCode)
		player.levelCode=levelCode
		
		if isNew then
			local cell=Level.getCell(level.cells,player.x,player.y)
			local ladder=Feature.new("ladder")
			
			if feature.code=="ladder_down" then
				ladder.code="ladder_up"
			elseif 	feature.code=="ladder_up" then
				ladder.code="ladder_down"
			end
			ladder.spriteName=ladder.code
			
			cell.feature=ladder
		end
	elseif featType=="bed" then
		Player.heal(player,9000)
	else
		log("error: Feature not activated:"..pack(feature))
	end
end

return _