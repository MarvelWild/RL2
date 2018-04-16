local _={}

--local _cursorWaitArrow = love.mouse.getSystemCursor("waitarrow")

-- ссылка на родительский стейт
_.client=nil


--_.commands={}
-- _.commandsThisTurn={}


-- locks input for this state only
_.locked=false
_.lockInfo=nil

-- 
_.isDrawSelf=true
_.isDrawUi=true

-- behaviour: update, draw, onKeyPressed
-- examples: client/editor_substate
-- multi state support
_.substates={}

local ui=require("client/game_ui")


_.addSubstate=function(substate)
	table.insert(_.substates, substate)
	substate.parentstate=_
	tryCall(substate.activate)
end

_.delSubstate=function(substate)
	tryCall(substate.deactivate)
	
	for k,v in pairs(_.substates)do
		if v == substate then
			table.remove(_.substates, k)
			break
		end
	end
end


-- возможность дочерних закрыться

local lockInput=function(info)
	log("input lock")
	_.locked=true
	_.lockInfo=info
end

local unlock=function(response)
	log("input unlock")
	_.locked=false
	_.lockInfo=nil
end

local dispatchCommand=function(command, isLocking, callback)
	_.client.send(command, callback)
	
	if isLocking then
		lockInput(command)
	end
end

local onEnteredEditorMode=function()
	unlock()
	local editorSubstate=require "client/editor_substate"
	_.addSubstate(editorSubstate)
end


_.enterEditorMode=function()
	S.isEditor=true
	dispatchCommand({cmd="enter_editor_mode"}, true, onEnteredEditorMode)
end


local commandMove=function(x,y)
	local command={
		cmd="move",
		x=x,
		y=y
	}
	
	dispatchCommand(command,true)
end

--local onFeatureActivated=function(response)
--	log("Feature activated:"..TSerial.pack(response))
--end

local refresh=function()
end

local activateFeature=function()
	local command={
		cmd="activate_feature",
	}
	
	-- generic turn as callback
	-- or generic ok
	dispatchCommand(command,true)--,onFeatureActivated)
	
	
end

local startCastSpell=function()
	log("Cast spell start")
	
	local spellSubstate=require "client/substate/spell_cast"
	_.addSubstate(spellSubstate)
end

-- активирует поле для чата, которое принимает инпут
-- отображение в общем логе
local enterChat=function()
	log("enter chat")
	
	local substate=require "client/substate/chat"
	_.addSubstate(substate)
end



local openInventory=function()
	local state=require "client/substate/state_inventory"
	_.addSubstate(state)
end

local openAbilities=function()
	log("opening abilities")
	local abilities=require "client/substate/abilities"
	_.addSubstate(abilities)
end

local openDebugger=function()
	local state=require "shared/substate/debugger"
	_.addSubstate(state)
end


local startPickupItems=function()
	log("startPickupItems")
	local currentCell=LevelUtil.getCell(W.cells,W.player.x,W.player.y)
	if currentCell.items~=nil then
		log("cell has items")
		
		local command={}
		command.cmd="pickup_item"
		command.x=W.player.x
		command.y=W.player.y
		command.itemIds={}
		for k,item in pairs(currentCell.items) do
			table.insert(command.itemIds,item.id)
		end
		
		dispatchCommand(command,true,unlock)
		
	else
		log("no items")
	end
	
end

local openOptions=function()
	local state=require "client/substate/options"
	_.addSubstate(state)
end



local onKeyPressed=function(key, unicode)
	log("game receive kp:"..key..","..unicode.." abcPos:"+string.abcPos(key))
	
	-- для оптимизации можно _.substates разбить на обработчики, хотя бы для draw-update
	for k,substate in pairs(_.substates) do
		if substate.onKeyPressed~=nil then
			local isProcessed=substate.onKeyPressed(key,unicode)
			if isProcessed then return end
		end
	end
	
	if _.locked then 
		log("input locked by:"..TSerial.pack(_.lockInfo)) 
		return
	end
	
	local nextX=W.player.x
	local nextY=W.player.y
	local isMoving=false
	if key==C.moveRight then
		nextX=W.player.x+1
		isMoving=true
	elseif key==C.moveLeft then
		nextX=W.player.x-1
		isMoving=true
	elseif key==C.moveUp then
		nextY=W.player.y+1
		isMoving=true
	elseif key==C.moveDown then
		nextY=W.player.y-1
		isMoving=true
	elseif key==C.moveUpLeft then
		nextY=W.player.y+1
		nextX=W.player.x-1
		isMoving=true
	elseif key==C.moveUpRight then
		nextY=W.player.y+1
		nextX=W.player.x+1
		isMoving=true
	elseif key==C.moveDownLeft then
		nextY=W.player.y-1
		nextX=W.player.x-1
		isMoving=true
	elseif key==C.moveDownRight then
		nextY=W.player.y-1
		nextX=W.player.x+1
		isMoving=true		
	elseif unicode==C.climbDown then
		-- simple, no shifts while we have free keys
		--if love.keyboard.isDown("lshift") then
		log("climb down")
		activateFeature()
--		else
--			log("no shift")
		--end
		
	elseif key==C.testCommand then
		local command={
			cmd="test",
			rand=love.math.random(1000),
		}

		dispatchCommand(command,false)
		command.rand=love.math.random(1000)
		dispatchCommand(command,false)
		command.rand=love.math.random(1000)
		dispatchCommand(command,false)
	elseif key==C.keyCastSpell then
		startCastSpell()
	elseif key==C.keyInventory then
		openInventory()
	elseif key==C.keyAbilities then
		openAbilities()
	elseif key==C.keyDebugger then
		openDebugger()
	elseif key==C.pickupItem then
		startPickupItems()
	elseif key==C.keyOpenOptions then
		openOptions()
	end
	
	if isMoving then
		commandMove(nextX,nextY)
	end
	
	if key_is_enter(key) then
		enterChat()
	end
end

local onTurnReceived=function(response)
	log("received turn from server") -- ..TSerial.pack(response)) -- logged on recv
	W=response
	unlock()
end

local onOkReceived=function(response)
	log("received ok from server")
	unlock()
end



local drawCells=function()
	local player=W.player
	
	-- в тайлах
	local fov=W.player.fov
	
--	log("fov:"..fov)
	
	local startX = -fov
	local endX = fov
	
	local startY = -fov
	local endY = fov
	
	local startPixelX=Ui.gamebox.playerX
	local startPixelY=Ui.gamebox.playerY
	
	-- в тайлах
	for screenY=startY,endY do
		for screenX=startX,endX do
			
			-- в тайлах
			local cellX = player.x+screenX
			local cellY = player.y+screenY
			
			local drawX=startPixelX+(screenX*C.tileSize)
			local drawY=startPixelY+(-screenY*C.tileSize)
			
			--log("draw cell "..cellX..","..cellY)
			local cell = LevelUtil.getCell(W.cells,cellX,cellY)
			
			CellUtil.draw(cell,drawX,drawY)
		end
	end
end -- drawTiles()

local drawPlayer=function()
		
	local player=W.player
	
	local playerSprite
	if player.isDead then
		playerSprite=Img.ghost
	else
		playerSprite=Img[player.spriteName]
	end

	
	-- make player transparent when waiting for blocking response
	if _.locked then
		LG.setColor(1,1,1,0.5)
		-- это на разных системах по разному, поэтому не юзаем
		-- love.mouse.setCursor(_cursorWaitArrow)
	end
	
	if playerSprite~=nil then
		LG.draw(playerSprite, Ui.gamebox.playerX, Ui.gamebox.playerY)
	end
	
	if _.locked then
		LG.setColor(1,1,1,1)
		-- love.mouse.setCursor()
	end
	
	LG.print(W.player.name, Ui.gamebox.playerX, Ui.gamebox.playerY-12)
	
	local playerCell = LevelUtil.getCell(W.cells,W.player.x,W.player.y)
	LG.printf("Cell:"..TSerial.pack(playerCell),480,400,440, "left")
end


local startGame=function(response)
	log("startGame")
	--log("get_full_state result:"..TSerial.pack(response))
	W=response
	table.insert(S.keyPressedListeners, onKeyPressed)
end

-- afterPicked(x,y)
_.pickTarget=function(afterPicked)
	local prevDrawSelf=_.isDrawSelf
	_.isDrawSelf=true
	local state=require "client/substate/pick_target"
	_.addSubstate(state)
	state.afterPicked=Lume.combine(
		afterPicked,
		function()
			_.isDrawSelf=prevDrawSelf
		end
	)
end



_.activate=function()
	local data={
		cmd="get_full_state"
	}
	_.client.send(data, startGame)
	
	_.client.responseHandlers.turn=onTurnReceived
	_.client.responseHandlers.ok=onOkReceived
	
	CScreen.init(960, 540, true)
	
	if S.isEditor then
		_.enterEditorMode()
	end	
end

_.resize=function(width, height)
	CScreen.update(width, height)
end



_.deactivate=function()
	local listenerIndex=Lume.find(S.keyPressedListeners, onKeyPressed)
	if listenerIndex~=nil then
		S.keyPressedListeners[listenerIndex]=nil
	end
	
	_.client.responseHandlers.turn=nil
end

local doDraw=function()
	if W.player~=nil then
		if W.player.spriteName=="hound" or W.player.spriteName=="coyote"  then
			love.graphics.setShader(Shaders.greyscale)
		elseif W.player.spriteName=="cat_1" then
			love.graphics.setShader(Shaders.technicolor1)
		elseif W.player.spriteName=="necromancer" then
			love.graphics.setShader(Shaders.mess)
		elseif W.player.spriteName=="sorceress" then
			love.graphics.setShader(Shaders.greentint)
		elseif W.player.spriteName=="skeleton" then
			love.graphics.setShader(Shaders.edges)
		elseif W.player.spriteName=="octopod_red" then
			love.graphics.setShader(Shaders.waterpaint)
		elseif W.player.spriteName=="bat" then
			love.graphics.setShader(Shaders.battlefield)					
		elseif W.player.spriteName=="eyemold" then
			love.graphics.setShader(Shaders.pictureinpicture)					
		else
			love.graphics.setShader()
		end
	end
	ui.draw()
	drawCells()
	drawPlayer()
	_.client.logComponent.draw()
end


_.draw=function()
	--LG.print("GAME")
	-- всё что выше это дебаг, без скейла
	CScreen.apply()
	if W.player==nil then return end
	
	
	doDraw()
	if not _.isDrawSelf then
		love.graphics.setColor(0, 0.2, 0.2, 0.8)
		
		local width, height = love.window.getMode( )
		LG.rectangle("fill",0,0,width,height)
		
		love.graphics.setColor( 1, 1, 1, 1)
	end
	
	for k,substate in pairs(_.substates) do
		tryCall(substate.draw)
	end
	
	for k,drawFn in pairs(UiLayer) do
		drawFn()
	end
	
	UiLayer={}
	
	CScreen.cease()
end

_.update=function()
	for k,substate in pairs(_.substates) do
		tryCall(substate.update)
	end
	
	tryCall(ui.update)
	
end

_.textinput=function(t)
	-- log("game text:"..t)
	for k,substate in pairs(_.substates) do
		if substate.textinput~=nil then
			substate.textinput(t)
		end
	end
end


-- exports

_.dispatchCommand=dispatchCommand

return _