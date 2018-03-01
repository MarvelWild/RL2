local _={}

_.parentstate=nil


local getCurrentItem=function()
	local registryPos = (C.editorCurrentRow-1)*C.editorCols+C.editorCurrentCol
	return Registry.editorItems[registryPos]
end


local placeItem=function()
	log("editor:place item")
	
	local item=getCurrentItem()
	
	local command={
		cmd="editor_place",
		item=item,
		x=W.player.x,
		y=W.player.y
	}
	
	_.parentstate.dispatchCommand(command)
end


local moveFocus=function(dx,dy)
	local nextX=C.editorCurrentCol
	local nextY=C.editorCurrentRow
	
	if dx~=0 then
		
		nextX=math.overflow(1,C.editorCurrentCol+dx,C.editorCols)
		
	end
	
	if dy~=0 then
		nextY=math.overflow(1,C.editorCurrentRow+dy,C.editorRows)
	end
	
	local registryPos = (nextY-1)*C.editorCols+nextX
	local nextItem=Registry.editorItems[registryPos]
	if nextItem~=nil then
		C.editorCurrentCol=nextX
		C.editorCurrentRow=nextY
	end
	
end


--called from parent state, not subscribed globally
_.onKeyPressed=function(key, unicode)
	-- log("editor receiving key:"..key)
	
	-- isProcessed means parents should not react
	local isProcessed=false
	
	if love.keyboard.isDown(C.editorActivate) then
		if key==C.moveLeft then
			-- shift not working here
			moveFocus(-1,0)
			isProcessed=true
		elseif key==C.moveRight then
			moveFocus(1,0)
			isProcessed=true
		elseif key==C.moveUp then
			moveFocus(0,1)
			isProcessed=true
		elseif key==C.moveDown then
			moveFocus(0,-1)
			isProcessed=true			
		end
	end -- kb.isDown C.editorActivate
	
	if key==C.editorPlaceItem then
		placeItem()
	end
	
	
	return isProcessed
end


_.activate=function()
	--table.insert(S.keyPressedListeners, onKeyPressed)
end


_.update=function()
end


return _