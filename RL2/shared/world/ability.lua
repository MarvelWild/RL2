local _={}


_.new=function()
	local result={}
	result.id=Id.new("ability")
	result.name="New ability"
	result.code=nil
	result.spriteName=nil
	result.type=nil
	result.tags=nil
	result.manaCost=1
	result.radius=3
	result.isTargeted=false
	
	return result
end


return _