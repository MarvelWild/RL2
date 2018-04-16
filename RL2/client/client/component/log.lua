local _={}

local messages={}

_.add=function(data)
	table.insert(messages, data)
	
	log("log msg added:"..data.text.." from:"..data.source)
end

_.last=function(count)
	return Lume.last(messages, count)
	--return messages
end

_.draw=function()
	love.graphics.setFont(Fonts.chat)
	
	local messages = _.last(5)
	local y=380
	for k,message in pairs(messages) do
		local text = message.source..":"..message.text
		LG.printf(text, 10, y, 400, "left")
		y=y+20
	end
	love.graphics.setFont(Fonts.main)
end

return _