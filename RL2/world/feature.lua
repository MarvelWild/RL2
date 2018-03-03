local _={}

_.new=function(featureType)
	local result={}
	result.spriteName=Registry.spriteNameByFeatureType[featureType]
	--result.sprite=Img[result.spriteName]
	
	return result
end

return _