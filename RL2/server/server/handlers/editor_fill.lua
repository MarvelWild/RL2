--[[
4-way flood

	local command={
		cmd="editor_fill",
		item=item,
		x=Player.x,
 		y=Player.y,
	}
]]--


-- это не учтёт стен
--local getPoints=function(maxDepth,x,y)
--	local result={}
	
	
--	return result
--end


-- filler(x,y) return isFilled
local function flood4(level,x,y,filler,maxRange,currX,currY)
	if currX==nil or currY==nil then 
		currX=x 
		currY=y
	end
	
	local currRange=Lume.distance(x,y,currX,currY)
	if currRange>maxRange then return end

	local isFilled=filler(currX,currY)
	if not isFilled then return end

	flood4(level,x,y,filler,maxRange,currX+1,currY)
	flood4(level,x,y,filler,maxRange,currX,currY+1)
	flood4(level,x,y,filler,maxRange,currX-1,currY)
	flood4(level,x,y,filler,maxRange,currX,currY-1)
end





local editor_fill=function(data,clientId)
	local editorItem=data.item
	
	local client = Server.clients[clientId]
	
	local player=client.player
	local level=Levels[player.levelCode]
	
	local range=5
	
--	dump(level.cells, "editor_place")
	
	local filler=function(x,y)
		local cell = Level.getCell(level.cells,x,y)
		if not Cell.isEmpty(cell) then return false end
	
		EditorItem.applyToCell(editorItem,cell)
		return true
	end
	
	flood4(level,data.x,data.y,filler,range)
	
	Server.sendTurn(client, clientId, data.requestId)
end

return editor_fill