local _={}

_.draw=function()
	local line1=W.player.name.." HP:"..W.player.hp.." Coords:"..W.player.x..","..W.player.y
	local line2="L:"..W.player.lvl.." xp:"..W.player.xp
	
	LG.print(line1,Ui.rightbox.x+10,Ui.rightbox.y+5)
	LG.print(line2,Ui.rightbox.x+10,Ui.rightbox.y+20)
end


return _