local _={}

-- ссылка на родительский стейт
_.client=nil


--_.commands={}
-- _.commandsThisTurn={}
_.locked=false
_.lockCommand=nil

_.substate=nil

if S.isEditor then
	_.ui=require "client/editor_ui"
	local editorSubstate=require "client/editor_substate"
	editorSubstate.parentstate=_
	editorSubstate.activate()
	_.substate=editorSubstate
else	
	_.ui=require "client/game_ui"
end	

_.dispatchCommand=function(command, isLocking)
	--table.insert(_.commandsThisTurn,command)
	
	_.client.send(command, startGame)
	
	--true by default
	if isLocking then
		_.locked=true
		_.lockCommand=command
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


local onKeyPressed=function(key, unicode)
	log("game receive kp:"..key..","..unicode)
	
	if love.keyboard.isDown("space") and love.keyboard.isDown("kp4") then
		local a=1
	end
	
	
	if _.substate~=nil then
		local isProcessed=_.substate.onKeyPressed(key,unicode)
		if isProcessed then return end
	end
	
	if _.locked then 
		log("input locked by:"..TSerial.pack(_.lockCommand)) 
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
	end
	
	if isMoving then
		commandMove(nextX,nextY)
--		if _.substate.onKeyPressedAfterMove~=nil then
--			_.substate.onKeyPressedAfterMove(key,unicode,nextX,nextY)
--		end
	end
end

local onTurnReceived=function(response)
	log("received turn from server") -- ..TSerial.pack(response)) -- logged on recv
	W=response
	_.locked=false
end



local drawCells=function()
	-- в тайлах
	local fov=W.player.fov
	
	local startX = -fov
	local endX = fov
	
	local startY = -fov
	local endY = fov
	
	local startPixelX=Ui.gamebox.playerX
	local startPixelY=Ui.gamebox.playerY
	
	
	-- в тайлах
	for screenY=startY,endY do
		for screenX=startX,endX do
			
			local cellX = W.player.x+screenX
			local cellY = W.player.y+screenY
			
			--log("draw cell "..cellX..","..cellY)
			local cell = Level.getCell(W.cells,cellX,cellY)
			
--			-- todo прямо в cell спрайты
			local groundSprite = Registry.spriteByGroundType[cell.ground_type]
			
			local drawX=startPixelX+(screenX*C.tileSize)
			local drawY=startPixelY+(-screenY*C.tileSize)
			
			if groundSprite~=nil then
				LG.draw(groundSprite, drawX, drawY)
			end
			
			-- others
			if cell.players~=nil then
				for k,player in pairs(cell.players) do
					LG.draw(Img[player.spriteName],drawX,drawY)
				end
			end
			
			
			if cell.feature~=nil then
				local featureSprite=Registry.spriteByFeatureType[cell.feature.spriteName]
				LG.draw(featureSprite, drawX, drawY)
			end
			
--			if cell.wall~=nil then
--				LG.draw(cell.wall.sprite, drawX, drawY)
--			end
			
			
			if cell.entity~=nil then
				if cell.entity.spriteName~=nil then 
					local sprite=Img[cell.entity.spriteName]
					LG.draw(sprite, drawX, drawY)
				end
			end
			
		end
	end
	
	--self
	LG.draw(Img.ogre_dcss_32, Ui.gamebox.playerX, Ui.gamebox.playerY)
	
	local playerCell = Level.getCell(W.cells,W.player.x,W.player.y)
	LG.print(TSerial.pack(playerCell),0,100)
end -- drawTiles()


local startGame=function(response)
	log("startGame")
	--log("get_full_state result:"..TSerial.pack(response))
	W=response
	table.insert(S.keyPressedListeners, onKeyPressed)
end


_.activate=function()
	local data={
		cmd="get_full_state"
	}
	_.client.send(data, startGame)
	
	_.client.responseHandlers.turn=onTurnReceived
	
	CScreen.init(960, 540, true)
end

_.resize=function(width, height)
	CScreen.update(width, height)
end



_.deactivate=function()
	local listenerIndex=Lume.find(S.keyPressedListeners, onKeyPressed)
	if listenerIndex~=nil then
		S.keyPressedListeners[listenerIndex]=nil
	end
	
	
	local data={
		cmd="logoff"
	}
	_.client.send(data)
	
	_.client.responseHandlers.turn=nil
end


_.draw=function()
	--LG.print("GAME")
	CScreen.apply()
	if W.player==nil then return end
	
	drawCells()
	_.ui.draw()
	CScreen.cease()
end

_.update=function()
	if _.substate~=nil then tryCall(_.substate.update) end
	
	tryCall(_.ui.update)
	
end

return _