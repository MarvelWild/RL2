local _={}

_.activate=function(feature,player,level)
	-- input examples:
	-- feature={featureType="ladder",id=15,code="ladder_down",spriteName="ladder_down"}}
	
	local isSuccess=true
	
	local featType=feature.featureType
	if featType=="portal" then
		player.level=feature.dest
	elseif featType=="ladder" then
		-- wip
		local a=1
		
		-- wip:lvl name
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
		
		local levelName=level.name.."_"..nextDepth
		
		local a=1
		
		
		
	else
		log("error: Feature not activated:"..pack(feature))
	end
end

return _