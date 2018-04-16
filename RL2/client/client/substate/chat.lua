-- text input part
-- visual part is log substate
local _={}


local text=""

_.parentstate=nil



_.draw=function()
	-- LG.print(, 10, 480)
	
	love.graphics.setFont(Fonts.chat)
	LG.print("CHAT:"..text,10, 500)
	love.graphics.setFont(Fonts.main)
end

local exit=function()
	_.parentstate.delSubstate(_)
end

local onMessageSent=function()
	log("Message sent")
end


local sendMessage=function()
	log("send chat message:"..text)
	
	local data={cmd="chat_message", text=text}
	_.parentstate.client.send(data,onMessageSent)
	
	text=""
end



_.onKeyPressed=function(key, unicode)
	
	log("chat receive key:"..key.." u:"..unicode)
	
	if key=="escape" then
		exit()
	elseif key_is_enter(key) then
		sendMessage()
		exit()
	elseif key=="backspace" then
		-- get the byte offset to the last UTF-8 character in the string.
		local byteoffset = Utf8.offset(text, -1)

		if byteoffset then
				-- remove the last UTF-8 character.
				-- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
				text = string.sub(text, 1, byteoffset - 1)
		end
		
		
--moved to textinput		
--	elseif not Allen.isBlank(key) then
--		-- Tests if a given string contain any alphanumeric character
--		log("Typing blank key:"..key)
	--else
		--log("not handled")
	end
	
	-- handle all the keys
	return true
end

_.textinput=function(t)
	log("chat textinput:"..t)
	
	text=text..t
end



return _