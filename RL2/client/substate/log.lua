local _={}

_.draw=function()
	--LG.print("LOG WIP")
	love.graphics.setFont(Fonts.chat)
	
	local messages = _.parentstate.client.logComponent.last(3)
	local y=380
	for k,message in pairs(messages) do
		local text = message.source..":"..message.text
		LG.printf(text, 10, y, 400, "left")
		y=y+20
	end
	love.graphics.setFont(Fonts.main)
end


return _