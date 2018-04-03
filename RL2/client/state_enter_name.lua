local _={}

_.text=""

local onNameEntered=function()
	_.client.switchToGameState()
end


local onKeyPressed=function(key)
	local len=string.len(key)
	if len~=1 then 
		if key=="return" then
			_.client.send({cmd="name_picked", name=_.text}, onNameEntered)
		end
		
		return 
	end
	
	log("name kp:"..key.." len:"..len)
	
	if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
		key=string.upper(key)
	end
	
	_.text=_.text+key
end


_.activate=function()
	subscribe(S.keyPressedListeners, onKeyPressed)
end

_.deactivate=function()
	unsubscribe(S.keyPressedListeners, onKeyPressed)
end



_.update=function()
end

_.draw=function()
	LG.print("Enter name")
	LG.print(_.text, 10, 40)
end


return _