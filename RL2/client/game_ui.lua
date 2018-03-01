local _={}

_.draw=function()
	local line1=W.player.name.." HP:"..W.player.hp.." Coords:"..W.player.x..","..W.player.y
	
	LG.print(line1,Ui.rightbox.x+10,Ui.rightbox.y+5)
end


return _