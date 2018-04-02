local _={}

_.client=nil

local onPresetPicked=function()
	_.client.switchToEnterNameState()
end


local onKeyPressed=function(key)
	local pick=tonumber(key)
	if pick==nil then return end
	
	-- log("Key:"..key.." tonumber:"..pick)
	
	local option=Registry.playerPresets[pick]
	if option==nil then return end
	
	-- log("Picked option:"..TSerial.pack(option))
	
	_.client.send({cmd="preset_picked", pick=pick}, onPresetPicked)
	
end


_.activate=function()
	subscribe(S.keyPressedListeners, onKeyPressed)
end

_.deactivate=function()
	unsubscribe(S.keyPressedListeners,onKeyPressed)
end



_.update=function()
	
end

_.draw=function()
	LG.print("New player")
	
	local y=40
	local yStep=40
	local x=10
	for k,preset in pairs(Registry.playerPresets) do
		
		local sprite=Img[preset.spriteName]
		
		LG.print(k,x,y)
		LG.draw(sprite,x+16,y)
		LG.print(preset.name,x+64,y)
		
		y=y+yStep
	end
	
end


return _

