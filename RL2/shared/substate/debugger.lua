local _={}

local dump=function()
	local ww=pack(W,true,true)
	local cc=pack(C,true,true)
	
	love.filesystem.write("dump.w.txt",ww)
	love.filesystem.write("dump.c.txt",cc)
	
	log("dumped to dump*.txt")
end

local cellX=nil
local cellY=nil


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
	
	local cell = Level.getCell(W.cells,cellX,cellY)
	LG.printf("Cell:"..TSerial.pack(cell),0,400,800, "left")
	
	local player=W.player
	LG.printf("Player:"..TSerial.pack(player),0,450,800, "left")
end

_.onKeyPressed=function(key)
	if key=="escape" or key==C.keyDebugger then
		_.parentstate.delSubstate(_)
	elseif key=="f1" then
		dump()
	elseif key=="f2" then
		consoledump()
	elseif key=="kp8" then
		cellY=cellY+1
	elseif key=="kp2" then
		cellY=cellY-1		
	elseif key=="kp4" then
		cellX=cellX-1
	elseif key=="kp6" then
		cellX=cellX+1		
	end
	
	return true
end

_.activate=function()
	_.parentstate.isDrawSelf=false
	cellX=W.player.x
	cellY=W.player.y
end


_.deactivate=function()
	_.parentstate.isDrawSelf=true
end

return _