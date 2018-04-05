local _={}

_.parentstate=nil

_.name="Abilities"

_.draw=function()
	LG.print("ABILITIES")
	if W.player.spriteName=="troll_green" then
		LG.print("[Passive] Troll skin (Regen+1) | todo",10, 24)
	end
	
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