local _={}

_.new=function(featureType)
	local result={}
	result.id=Id.new("feature")
	result.spriteName=Registry.spriteNameByFeatureType[featureType]
	--result.sprite=Img[result.spriteName]
	
	result.featureType=featureType
	if featureType=="portal" then
		result.dest="level2"
		
		-- todo: implement
		result.destX=0
		result.destY=0
	elseif featureType=="door" then
		result.isOpen=false
		result.spriteName="door_closed"
	end
	
	
	return result
end

return _