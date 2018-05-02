local _={}
--[[
активируется из редактора в режиме square

wip:
free targeting
выбираем точку 1+
выбираем точку 2+
в динамике рисуем область

]]--


local x1,x2,y1,y2
_.range=5

_.name="select_square"


_.afterPicked=nil

--_.onKeyPressed=function(key)
	-- log("square ")
--end

local onSecondTargetPicked=function(x,y)
	log("second target picked:"..xy(x,y))
	
	x2=x
	y2=y
	
	_.afterPicked(x1,y1,x2,y2)
	_.parentstate.delSubstate(_)
	
end

local onFirstTargetPicked=function(x,y)
	log("first target picked:"..xy(x,y))
	
	x1=x
	y1=y
	Game.pickTarget(onSecondTargetPicked,_.range)
end




_.activate=function()
	log("select_square activate")
	Game.pickTarget(onFirstTargetPicked,_.range)
	
end



_.draw=function()
	LG.print("select square")
end


return _