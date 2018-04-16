local _={}

_.new=function(itemType)
	local result={}
	result.id=Id.new("item")
	result.name="New item"
	result.code="blue_paint"
	result.spriteName=nil
	result.type=itemType
	result.tags=nil
	
	return result
end

return _