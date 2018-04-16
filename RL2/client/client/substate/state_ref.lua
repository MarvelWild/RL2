-- boilerplate and documentation for state

local _={}

--populated by parent state
_.parentstate=nil

-- to make debugging easier
_.name="New state"

--_.draw=function()
--	LG.print(_.name.." active")
--end

--_.onKeyPressed=function(key)
--end

--_.activate=function()
--	log("State ".._.name.." activated")
--end

--_.deactivate=function()
--	log("State ".._.name.." deactivated")
--end

--_.update=function()
--end



return _