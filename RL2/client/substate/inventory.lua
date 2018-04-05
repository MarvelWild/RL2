local _={}

_.parentstate=nil

_.name="Inventory"

_.draw=function()
	LG.print("INVENTORY")
	
	LG.print("You carry nothing", 10, 42)
end

_.activate=function()
	_.parentstate.isDrawSelf=false
end

_.deactivate=function()
	_.parentstate.isDrawSelf=true
end

_.onKeyPressed=function(key)
	if key=="escape" or key=="space" then
		_.parentstate.delSubstate(_)
	end
	
	return true -- catch all the keys
end

return _