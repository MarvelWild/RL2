local _={}


_.draw=function()
	LG.print("OPTIONS")
	
	LG.print("m-music on/off",10,50)
	LG.print("n-next track",10,68)
end	

_.onKeyPressed=function(key)
	log("options key:"..key)
	
	if key=="escape" or key==C.keyOpenOptions then
		_.parentstate.delSubstate(_)
	elseif key==C.optionMute then
		Audio.toggleMusic()
	elseif key==C.optionNextTrack then
		Audio.nextTrack()
	end
	
	return true
end


_.activate=function()
	_.parentstate.isDrawSelf=false
end


_.deactivate=function()
	_.parentstate.isDrawSelf=true
end


return _