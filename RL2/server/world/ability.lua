local _={}

_.clone=function(ability)
	-- todo: table clone support
	local result=Lume.clone(ability)
	result.id=Id.new("ability")
	return result
end

return _