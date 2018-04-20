local _={}

local dump=function()
	local ww=Inspect(W)
	local ww2=pack(W)
	local cc=Inspect(C)
	
	love.filesystem.write("dump.w.txt",ww)
	love.filesystem.write("dump.w-ts.txt",ww2)
	love.filesystem.write("dump.c.txt",cc)
end


local consoledump=function()
	local playerCell = Level.getCell(W.cells,W.player.x,W.player.y)
	if playerCell~=nil then
		log("consoledump:"..pack(playerCell))
	end
end



_.draw=function()
	LG.print("Debugger")
	LG.print("F1-dump",0,16)
	LG.print("F2-consoledump",0,32)
	
	local playerCell = Level.getCell(W.cells,W.player.x,W.player.y)
	LG.printf("Cell:"..TSerial.pack(playerCell),0,400,800, "left")
end

_.onKeyPressed=function(key)
	if key=="escape" or key==C.keyDebugger then
		_.parentstate.delSubstate(_)
	elseif key=="f1" then
		dump()
	elseif key=="f2" then
		consoledump()
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