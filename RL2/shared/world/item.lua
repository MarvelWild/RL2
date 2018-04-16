local _={}

_.new=function(itemType)
	local result={}
	result.id=Id.new("item")
	result.name="New item"
	result.code=nil
	result.spriteName=nil
	result.type=itemType
	result.tags=nil
	
	return result
end

_.clone=function(item)
	local result=deepcopy(item)
	result.id=Id.new("item")
	return result
end



return _