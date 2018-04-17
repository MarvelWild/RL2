local _={}

_.new=function()
	local r={}
	
	r.type=nil -- "paint"
	r.color=nil -- {255,255,0}
	r.isStacking=false --second effect of same type replaces previous (both adds if true)
	
	
	return r
end


return _