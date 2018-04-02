local _={}


local text=""

_.parentstate=nil



_.draw=function()
	-- LG.print(, 10, 480)
	
	LG.print("CHAT:"..text,10, 500)
end

local exit=function()
	_.parentstate.delSubstate(_)
end

local sendMessage=function()
	log("send chat message (wip):"..text)
	
	
	
	text=""
end



_.onKeyPressed=function(key, unicode)
	
	log("chat receive key:"..key.." u:"..unicode)
	
	if key=="escape" then
		exit()
	elseif key=="return" then
		sendMessage()
		exit()
	elseif not Allen.isBlank(key) then
		-- Tests if a given string contain any alphanumeric character
		log("Typing blank key:"..key)
	--else
		--log("not handled")
	end
	
	-- handle all the keys
	return true
end

_.textinput=function(t)
	log("chat input:"..t)
	
	text=text..t
end



return _