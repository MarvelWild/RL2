local _={}

_.draw=function()
	local character=W.player.character
	local line1=W.player.name.." HP:"..character.hp.." Coords:"..W.player.x..","..W.player.y
	local line2="L:"..character.lvl.." xp:"..character.xp
	local line3="effects:"
	
	local isFirst=true
	for k,effect in pairs(W.player.character.effects) do
		if not isFirst then line3=line3+"," end
		line3=line3+effect.name
		isFirst=false
	end
	
	
	
	
	LG.print(line1,Ui.rightbox.x+10,Ui.rightbox.y+5)
	LG.print(line2,Ui.rightbox.x+10,Ui.rightbox.y+20)
	LG.print(line3,Ui.rightbox.x+10,Ui.rightbox.y+35)
end


return _