local _={}


_.draw=function()
	LG.print("Rogue Love 2", 100, 100)
	LG.print("Powered by LÖVE 11.0 'Mysterious Mysteries'", 100, 150)
	LG.print("Press any key to start", 100, 200)
	
	LG.print("Thanks:", 100,300)
	LG.print("Anders Ruud for LÖVE", 100, 320)
	LG.print("Paul Kulchenko for ZeroBrane", 100, 340)
	
end

_.keypressed=function()
	_.client.startGame()
end


return _