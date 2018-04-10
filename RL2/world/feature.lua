local _={}

_.new=function(featureType)
	local result={}
	result.id=Id.new("feature")
	result.spriteName=Registry.spriteNameByFeatureType[featureType]
	--result.sprite=Img[result.spriteName]
	
	result.featureType=featureType
	if featureType=="portal" then
		
		result.dest="level2"
	end
	
	
	return result
end

return _