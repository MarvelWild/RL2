local _={}

_.draw=function()
	local character=W.player.character
	local line1=W.player.name.." HP:"..character.hp.." Coords:"..W.player.x..","..W.player.y
	local line2="L:"..character.lvl.." xp:"..character.xp
	
	LG.print(line1,Ui.rightbox.x+10,Ui.rightbox.y+5)
	LG.print(line2,Ui.rightbox.x+10,Ui.rightbox.y+20)
end


return _