local _={}


_.draw=function()
	LG.print("Rogue Love 2", 100, 100)
	LG.print("Powered by LÖVE 11.0 'Mysterious Mysteries'", 100, 150)
	LG.print("Press any key to start", 100, 200)

	
end

_.keypressed=function()
	_.client.startGame()
end


return _