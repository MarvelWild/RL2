local _={}

-- ссылка на родительский стейт
_.client=nil

if S.isEditor then
	_.ui=require "client/editor_ui"
else	
	_.ui=require "client/game_ui"
end	

local onKeyPressed=function(key, unicode)
	log("game receive kp:"..key..","..unicode)
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
end


_.draw=function()
	LG.print("GAME")
	if W.player==nil then return end
	
	drawCells()
	_.ui.draw()
end

_.update=function()
	tryCall(_.ui.update)
end




return _