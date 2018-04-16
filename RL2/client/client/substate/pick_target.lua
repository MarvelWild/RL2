-- ideas: dim area outside range
-- limit moving range
-- remember target
-- iterate targets7

local _={}

-- cell coords
local _targetX=nil
local _targetY=nil

local _centerX=nil
local _centerY=nil

local _minX=nil
local _maxX=nil
local _minY=nil
local _maxY=nil

_.range=3


_.afterPicked=nil

_.draw=function()
	
	
	local gameX,gameY=coord_cell_to_game(_targetX,_targetY)
	
	LG.draw(Img.target, gameX, gameY)
	LG.print("PICK TARGET:".._targetX..",".._targetY.." scr:"..gameX..","..gameY)
end

_.onKeyPressed=function(key)
	log("pick_target key pressed:"..key)
	if key=="escape" then
		_.parentstate.delSubstate(_)
		
		if _.afterPicked~=nil then
			_.afterPicked() 
		end
	end
	
	local dx,dy=get_direction_8(key)
	
	if dx~=nil then
		_targetX=Lume.clamp(_targetX+dx, _minX, _maxX)
		_targetY=Lume.clamp(_targetY+dy, _minY, _maxY)
	end

	if key==C.pickTarget then
		log("target selected")
		_.parentstate.delSubstate(_)
		
		if _.afterPicked==nil then
			log("error: afterPicked not defined for targeting")
		end
		
		_.afterPicked(_targetX,_targetY)
		
	end
	
	return true
end

_.activate=function()
	_centerX=W.player.x
	_centerY=W.player.y
	
	_targetX=_centerX
	_targetY=_centerY
	
	_minX=_centerX-_.range
	_minY=_centerY-_.range
	
	_maxX=_centerX+_.range
	_maxY=_centerY+_.range
	
	log("targeting mid:"..xy(W.player).." min:"..xy(_minX,_minY).." max:"..xy(_maxX,_maxY))
end

_.deactivate=function()
	-- _.afterPicked=nil
end

return _