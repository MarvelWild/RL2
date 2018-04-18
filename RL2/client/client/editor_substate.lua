local _={}

_.parentstate=nil
_.lastPlace={}
_.lastPlace.x=nil
_.lastPlace.y=nil
_.lastPlace.item=nil

local pageNumber=1
-- pop on activate
local maxPages=nil
local isLoading=false
local editorItems=nil
local currentItem=nil


local getCurrentItem=function()
	local registryPos = (C.editorCurrentRow-1)*C.editorCols+C.editorCurrentCol
	-- todo: read from server
	return editorItems[registryPos]
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
	local nextItem=editorItems[registryPos]
	if nextItem~=nil then
		C.editorCurrentCol=nextX
		C.editorCurrentRow=nextY
		log("editor current item:"..pack(nextItem))
		currentItem=nextItem
	end
end

local deleteCurrentItem=function()
	local command={
		cmd="editor_delete",
		x=W.player.x,
		y=W.player.y
	}
	
	_.parentstate.dispatchCommand(command,true)
end



--called from parent state, not subscribed globally
_.onKeyPressed=function(key, unicode)
	-- log("editor receiving key:"..key)
	
	-- isProcessed means parents should not react
	local isProcessed=false
	local pageSize=C.editorRows*C.editorCols-C.editorCols
	
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
		elseif key==C.moveUpRight then
			moveFocus(1,1)
			isProcessed=true			
		elseif key==C.moveUpLeft then
			moveFocus(-1,1)
			isProcessed=true			
		elseif key==C.moveDownRight then
			moveFocus(1,-1)
			isProcessed=true			
		elseif key==C.moveDownLeft then
			moveFocus(-1,-1)
			isProcessed=true			
		end
	elseif key==C.editorDeleteItem then
		deleteCurrentItem()
	elseif key==C.editorNextPage then
		_.startItemIndex=_.startItemIndex+pageSize
	elseif key==C.editorPrevPage then	
		_.startItemIndex=_.startItemIndex-pageSize
		if _.startItemIndex<1 then _.startItemIndex=1 end
	end 
	
	
	
	return isProcessed
end



local onEditorItemsReceived=function(response)
	log("Editor items received")
	isLoading=false
	editorItems=response.editorItems
end


_.activate=function()
	--инпут идёт по цепочке стейтов, начиная с дочерних
	--table.insert(S.keyPressedListeners, onKeyPressed)
	_.parentstate.isDrawUi=false
	isLoading=true
	local command={cmd="editor_items_get"}
	Client.send(command, onEditorItemsReceived)
end

_.deactivate=function()
	_.parentstate.isDrawUi=true
end


_.update=function()
	if love.keyboard.isDown(C.editorPlaceItem) then
		placeItem(false,W.player.x,W.player.y)
	end
end

local drawItem=function(item,cellX,cellY)
	local worldX = Ui.rightbox.x+(cellX*C.tileSize)-140
	local worldY = Ui.rightbox.y+(cellY*C.tileSize)+100
	EditorItem.draw(item,worldX,worldY)

	if cellX==C.editorCurrentCol and cellY==C.editorCurrentRow then
		LG.draw(Img.active_frame_32, worldX, worldY)
	end
end


_.startItemIndex=1

_.draw=function()
	
	if not _.parentstate.isDrawSelf then return end
--	local line1="Editor coords:"..W.player.x..","..W.player.y
--	LG.print(line1,Ui.rightbox.x+10,Ui.rightbox.y+5+100)

	if isLoading or editorItems==nil then
		LG.print("Loading")
		return
	end
	
	
	local itemIndex=_.startItemIndex
	local nextItem = editorItems[itemIndex]
	if nextItem==nil then return end
	
	for y=1,C.editorRows do
		for x=1,C.editorCols do
			if nextItem==nil then break end
			drawItem(nextItem,x,y)
			
			itemIndex=itemIndex+1
			nextItem = editorItems[itemIndex]
		end
		if nextItem==nil then break end
	end
	
	if currentItem~=nil then
		LG.print(pack(currentItem),20,460)
	end
	
	
end




return _