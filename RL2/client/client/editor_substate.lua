local _={}

local isDrawFrame=false

local drawX=nil
local drawY=nil


_.name="editor_substate"
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
local pageSize=C.editorRows*C.editorCols-C.editorCols

local mode="single"--,"square"
local isInputLocked=false

local modes={
	"single",
	"square",
	"fill",
}


_.startItemIndex=1

local getCurrentItem=function()
	local registryPos = (C.editorCurrentRow-1)*C.editorCols+C.editorCurrentCol+_.startItemIndex-1
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

local placeArea=function(x1,y1,x2,y2)
	local item=getCurrentItem()

	local command={
		cmd="editor_place_area",
		item=item,
		x1=x1,
		y1=y1,
		x2=x2,
		y2=y2,
	}
	
	_.parentstate.dispatchCommand(command,true)
end

local switchPage=function(num)
	_.startItemIndex=_.startItemIndex+(pageSize*num)
	
	if _.startItemIndex<1 then _.startItemIndex=1 end
	currentItem=getCurrentItem()
end


local moveFocus=function(dx,dy)
	local nextX=C.editorCurrentCol
	local nextY=C.editorCurrentRow
	
	if dx~=0 then
		
		nextX=math.overflow(1,C.editorCurrentCol+dx,C.editorCols)
		
	end
	
	if dy~=0 then
		nextY=C.editorCurrentRow-dy
		if nextY>C.editorRows then
			nextY=1
			switchPage(1)
		elseif nextY<1 then
			nextY=C.editorRows
			switchPage(-1)
		else
			-- were fine
			-- nextY=nextRow
		end
	end
	
	local registryPos = (nextY-1)*C.editorCols+nextX+_.startItemIndex-1
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





local modeSwitch=function()
	local nextMode=table.nextInCircle(modes,mode)
	
	mode=nextMode
	log("editor mode switched to:"..mode)
end



local afterSquarePicked=function(x1,y1,x2,y2)
	log("after square picked:"..xy(x1,y1).." to "..xy(x2,y2))
	placeArea(x1,y1,x2,y2)
	
	isInputLocked=false
end


local handleSquareKey=function()
	isInputLocked=true
	_.parentstate.pickSquare(afterSquarePicked)
end



local fill=function()
	local item=getCurrentItem()

	local command={
		cmd="editor_fill",
		item=item,
		x=W.player.x,
 		y=W.player.y,
	}
	
	_.parentstate.dispatchCommand(command,true)
end


--called from parent state, not subscribed globally
_.onKeyPressed=function(key, unicode)
	-- log("editor receiving key:"..key)
	
	if isInputLocked then return false end
	
	-- isProcessed means parents should not react
	local isProcessed=false
	
	isDrawFrame=false
	if love.keyboard.isDown(C.editorActivate) then
		isDrawFrame=true
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
	end
	
	if key==C.editorDeleteItem then
		deleteCurrentItem()
		isProcessed=true	
	elseif key==C.editorNextPage then
		switchPage(1)
		isProcessed=true	
	elseif key==C.editorPrevPage then	
		switchPage(-1)
		isProcessed=true	
	elseif key==C.editorModeSwitch then
		modeSwitch()
		isProcessed=true	
	elseif key==C.editorPlaceItem then
		if mode=="square" then
			handleSquareKey()
			isProcessed=true	
		elseif mode=="fill" then
			fill()
			isProcessed=true
		end
	end 
	
	-- C.editorPlaceItem handled in update for 1tile
	
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
	
	drawX=Ui.rightbox.x-140
	drawY=Ui.rightbox.y+100
end

_.deactivate=function()
	_.parentstate.isDrawUi=true
end


_.update=function()
	if not isInputLocked and love.keyboard.isDown(C.editorPlaceItem) and mode=="single" then
		placeItem(false,W.player.x,W.player.y)
	end
end

local drawItem=function(item,cellX,cellY)
	local worldX = drawX+(cellX*C.tileSize)
	local worldY = drawY+(cellY*C.tileSize)
	EditorItem.draw(item,worldX,worldY)

	if cellX==C.editorCurrentCol and cellY==C.editorCurrentRow then
		-- LG.draw(Img.active_frame_32, worldX+16, worldY+16, S.frame/60,1,1,16,16)
		LG.draw(Img.active_frame_32, worldX, worldY)
	end
end




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
	
	LG.print("Mode:"..mode,640,100)
end




return _