local _={}

_.clone=function(ability)
	local result=Lume.clone(ability)
	result.id=Id.new("ability")
	return result
end

return _