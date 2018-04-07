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
	
-- wip: manual deact	
--	local prevState=_.substate
--	if prevState~=nil then
--		tryCall(prevState.deactivate)
--	end
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


_.enterEditorMode=function()
	-- if S.isEditor then return end
	
	S.isEditor=true
	
	-- логичней это сделать в сабстейте редактора - на будущее
	local editorSubstate=require "client/editor_substate"
	
	-- todo: после разрешения от сервера
	_.addSubstate(editorSubstate)
	
	_.dispatchCommand({cmd="enter_editor_mode"}, true, unlock)
end

-- 
_.dispatchCommand=function(command, isLocking, callback)
	--table.insert(_.commandsThisTurn,command)
	
	-- криво. лучше лок отдельно сделать.
	_.client.send(command, callback)
	
	if isLocking then
		lockInput(command)
	end
end

local commandMove=function(x,y)
	local command={
		cmd="move",
		x=x,
		y=y
	}
	
	_.dispatchCommand(command,true)
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
	_.dispatchCommand(command,true)--,onFeatureActivated)
	
	
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
	local state=require "client/substate/inventory"
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

		_.dispatchCommand(command,false)
		command.rand=love.math.random(1000)
		_.dispatchCommand(command,false)
		command.rand=love.math.random(1000)
		_.dispatchCommand(command,false)
	elseif key==C.keyCastSpell then
		startCastSpell()
	elseif key==C.keyInventory then
		openInventory()
	elseif key==C.keyAbilities then
		openAbilities()
	elseif key==C.keyDebugger then
		openDebugger()	
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
	
	
	
	
	local uiLayer={}
	
	-- в тайлах
	for screenY=startY,endY do
		for screenX=startX,endX do
			
			local cellX = player.x+screenX
			local cellY = player.y+screenY
			
			--log("draw cell "..cellX..","..cellY)
			local cell = Level.getCell(W.cells,cellX,cellY)
			
--			-- todo прямо в cell спрайты
			local groundSprite = Registry.spriteByGroundType[cell.ground_type]
			
			local drawX=startPixelX+(screenX*C.tileSize)
			local drawY=startPixelY+(-screenY*C.tileSize)
			
			if groundSprite~=nil then
				LG.draw(groundSprite, drawX, drawY)
			end
			

			
			if cell.wall~=nil then
				local wallSprite=Img[cell.wall.spriteName]
				
				if wallSprite~=nil then
					LG.draw(wallSprite, drawX, drawY)
				end
			end
			
			if cell.feature~=nil then
				local featureSprite=Img[cell.feature.spriteName]
				if featureSprite==nil then
					log("error: no sprite for feat:"..cell.feature.spriteName)
					featureSprite=Img.error
				end
				
				LG.draw(featureSprite, drawX, drawY)
			end
			
			if cell.items~=nil then
				for k,item in pairs(cell.items) do
					if item.sprite==nil then
						item.sprite=Img[item.spriteName]
					end
					
					LG.draw(item.sprite, drawX, drawY)
					
				end
			end
			
			if cell.entity~=nil then
				if cell.entity.spriteName~=nil then 
					local sprite=Img[cell.entity.spriteName]
					LG.draw(sprite, drawX, drawY)
				end
			end
			
			-- others
			if cell.players~=nil then
				for k,player in pairs(cell.players) do
					LG.draw(Img[player.spriteName],drawX,drawY)
					
					-- закрывается верхней ячейкой, поэтому откладываем
					table.insert(uiLayer, Lume.fn(LG.print, player.name, drawX, drawY-12))
				end
			end
			
		end
	end
	
	for k,v in pairs(uiLayer) do v() end

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
	
	LG.draw(playerSprite, Ui.gamebox.playerX, Ui.gamebox.playerY)
	
	if _.locked then
		LG.setColor(1,1,1,1)
		-- love.mouse.setCursor()
	end
	
	LG.print(W.player.name, Ui.gamebox.playerX, Ui.gamebox.playerY-12)
	
	local playerCell = Level.getCell(W.cells,W.player.x,W.player.y)
	LG.printf("Cell:"..TSerial.pack(playerCell),650,450,280, "left")
end


local startGame=function(response)
	log("startGame")
	--log("get_full_state result:"..TSerial.pack(response))
	W=response
	table.insert(S.keyPressedListeners, onKeyPressed)
end

-- afterPicked(x,y)
_.pickTarget=function(afterPicked)
	_.isDrawSelf=true
	local state=require "client/substate/pick_target"
	_.addSubstate(state)
	state.afterPicked=afterPicked
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


return _