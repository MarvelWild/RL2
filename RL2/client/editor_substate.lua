local _={}

_.parentstate=nil
_.lastPlace={}
_.lastPlace.x=nil
_.lastPlace.y=nil
_.lastPlace.item=nil


local getCurrentItem=function()
	local registryPos = (C.editorCurrentRow-1)*C.editorCols+C.editorCurrentCol
	return Registry.editorItems[registryPos]
end


local placeItem=function(isLocking,x,y)
	
	local item=getCurrentItem()
	if _.lastPlace.x==x and _.lastPlace.y==y and _.lastPlace.item==item then
		return
	end
	
	log("editor:place item")
	
	
	
	local command={
		cmd="editor_place",
		item=item,
		x=x,
		y=y
	}
	
	_.lastPlace.x=command.x
	_.lastPlace.y=command.y
	_.lastPlace.item=command.item
	
	_.parentstate.dispatchCommand(command,isLocking)
end


local moveFocus=function(dx,dy)
	local nextX=C.editorCurrentCol
	local nextY=C.editorCurrentRow
	
	if dx~=0 then
		
		nextX=math.overflow(1,C.editorCurrentCol+dx,C.editorCols)
		
	end
	
	if dy~=0 then
		nextY=math.overflow(1,C.editorCurrentRow-dy,C.editorRows)
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
	else 
--		if (key==C.moveRight or key==C.moveLeft or key==C.moveUp or key==C.moveDown) 
--			and love.keyboard.isDown(C.editorPlaceItem) 
--		then
--			placeItem(false)
--		end
		
	end -- kb.isDown C.editorActivate
	
--	if key==C.editorPlaceItem then
--		placeItem(true)
--	end
	
	
	return isProcessed
end




_.activate=function()
	
	--table.insert(S.keyPressedListeners, onKeyPressed)
end


_.update=function()
	if love.keyboard.isDown(C.editorPlaceItem) then
		placeItem(false,W.player.x,W.player.y)
--		if W.player.x~=_.lastPlace.x or W.player.y~=_.lastPlace.y then
			
--		end
		
	end
	
end


return _