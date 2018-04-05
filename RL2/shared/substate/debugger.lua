local _={}

local dump=function()
	local ww=Inspect(W)
	local ww2=pack(W)
	local cc=Inspect(C)
	
	love.filesystem.write("dump.w.txt",ww)
	love.filesystem.write("dump.w-ts.txt",ww2)
	love.filesystem.write("dump.c.txt",cc)
end



_.draw=function()
	LG.print("Debugger")
	LG.print("F1-dump",0,16)
end

_.onKeyPressed=function(key)
	if key=="escape" then
		_.parentstate.delSubstate(_)
	elseif key=="f1" then
		dump()
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