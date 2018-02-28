local debug={}

debug.useConsole=true
debug.useFile=false
debug.messages={}

debug.log=function(message)
	-- TODO: console
	-- local time = love.timer.getTime() -- "\t"..time
	local preparedMessage = S.frame.."\t"..message
	
	if debug.useFile then table.insert(debug.messages, preparedMessage) end
	
	if debug.useConsole then
		print(preparedMessage)
	end
	
end

-- вызывать например из love.quit
debug.writeLogs=function()
	if not debug.useFile then return end
	local log = ""
	
	for k, v in ipairs(debug.messages) do
		log=log..v.."\n"
	end
	
	love.filesystem.write("log.txt", log)
end


return debug