local _={}

_.new=function()
	local r={}
	
	r.type=nil -- "paint"
	r.name=nil -- "paint"
	r.color=nil -- {255,255,0}
	r.isStacking=false --second effect of same type replaces previous (both adds if true)
	
	
	return r
end

_.hasEffectOfType=function(effects,effectType)
	for k,effect in pairs(effects) do
		if effect.type==effectType then return true end
	end
	
	return false
end

return _