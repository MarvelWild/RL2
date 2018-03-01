local _={}

-- ссылка на родительский стейт
_.client=nil


--_.commands={}
-- _.commandsThisTurn={}
_.locked=false

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
	if isLocking==nil or isLocking then
		_.locked=true
	end
end


local commandMove=function(x,y)
	local command={
		cmd="move",
		x=x,
		y=y
	}
	
	_.dispatchCommand(command)
end


local onKeyPressed=function(key, unicode)
	log("game receive kp:"..key..","..unicode)
	
	if _.substate~=nil then
		local isProcessed=_.substate.onKeyPressed(key,unicode)
		if isProcessed then return end
	end
	
	if _.locked then 
		log("input locked") 
		return
	end
	
		
	if key==C.moveRight then
		commandMove(W.player.x+1,W.player.y)
	elseif key==C.moveLeft then
		commandMove(W.player.x-1,W.player.y)
	elseif key==C.moveUp then
		commandMove(W.player.x,W.player.y+1)
	elseif key==C.moveDown then
		commandMove(W.player.x,W.player.y-1)		
	end
	
	
end

local onTurnReceived=function(response)
	log("received turn from server:"..TSerial.pack(response))
	W=response
	_.locked=false
end



local drawCells=function()
	-- в тайлах
	local startX = -C.ViewRadiusTilesX
	local endX = C.ViewRadiusTilesX
	
	local startY = -C.ViewRadiusTilesY
	local endY = C.ViewRadiusTilesY
	
	local startPixelX=Ui.gamebox.playerX
	local startPixelY=Ui.gamebox.playerY
	
	
	-- в тайлах
	for screenY=startY,endY do
		for screenX=startX,endX do
			
--			local cellX = W.player.x+screenX
--			local cellY = W.player.y+screenY
			
--			-- log("draw cell "..cellX..","..cellY)
--			local cell = LevelLogic.get_cell(cellX,cellY)
			
--			-- todo прямо в cell спрайты
--			local groundSprite = Registry.spriteByGroundType[cell.ground_type]
			
--			local drawX=startPixelX+(screenX*Config.TileSize)
--			local drawY=startPixelY+(-screenY*Config.TileSize)
			
----			if cellX==0 and cellY==0 then
----				-- debug cell
----				local c=cell
----			end
			
			
--			if groundSprite~=nil then
--				LG.draw(groundSprite, drawX, drawY)
--			end
			
--			if cell.feature~=nil then
--				LG.draw(cell.feature.sprite, drawX, drawY)
--			end
			
--			if cell.wall~=nil then
--				LG.draw(cell.wall.sprite, drawX, drawY)
--			end
			
			
--			if cell.entity~=nil then
--				if cell.entity.sprite==nil then 
--					log("no sprite:"..cellX..","..cellY)
--				else
--					LG.draw(cell.entity.sprite, drawX, drawY)
--				end
--			end
			
		end
	end
	
	LG.draw(Img.ogre_dcss_32, Ui.gamebox.playerX, Ui.gamebox.playerY)
end -- drawTiles()


local startGame=function(response)
	-- log("get_full_state result:"..TSerial.pack(response))
	W=response
	table.insert(S.keyPressedListeners, onKeyPressed)
end


_.activate=function()
	local data={
		cmd="get_full_state"
	}
	_.client.send(data, startGame)
	
	_.client.responseHandlers.turn=onTurnReceived
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
	LG.print("GAME")
	if W.player==nil then return end
	
	drawCells()
	_.ui.draw()
end

_.update=function()
	if _.substate~=nil then tryCall(_.substate.update) end
	
	tryCall(_.ui.update)
	
end




return _