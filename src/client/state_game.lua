local _={}

-- ссылка на родительский стейт
_.client=nil

local drawCells=function()
	if W.player==nil then return end
	
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
			
			local cellX = W.player.x+screenX
			local cellY = W.player.y+screenY
			
			-- log("draw cell "..cellX..","..cellY)
			local cell = LevelLogic.get_cell(cellX,cellY)
			
			-- todo прямо в cell спрайты
			local groundSprite = Registry.spriteByGroundType[cell.ground_type]
			
			local drawX=startPixelX+(screenX*Config.TileSize)
			local drawY=startPixelY+(-screenY*Config.TileSize)
			
--			if cellX==0 and cellY==0 then
--				-- debug cell
--				local c=cell
--			end
			
			
			if groundSprite~=nil then
				LG.draw(groundSprite, drawX, drawY)
			end
			
			if cell.feature~=nil then
				LG.draw(cell.feature.sprite, drawX, drawY)
			end
			
			if cell.wall~=nil then
				LG.draw(cell.wall.sprite, drawX, drawY)
			end
			
			
			if cell.entity~=nil then
				if cell.entity.sprite==nil then 
					log("no sprite:"..cellX..","..cellY)
				else
					LG.draw(cell.entity.sprite, drawX, drawY)
				end
			end
			
		end
	end
	
	LG.draw(Img.ogre_dcss_32, Ui.gamebox.playerX, Ui.gamebox.playerY)
end -- drawTiles()

_.activate=function()
end
_.draw=function()
	LG.print("GAME")
end

_.update=function()
	_.client.send()
end




return _