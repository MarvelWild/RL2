local _={}

_.client=nil

local isLoading=false
local presets=nil

local onPresetPicked=function()
	_.client.switchToEnterNameState()
end

local onPresetsReceived=function(response)
	log("presets received")
	isLoading=false
	presets=response.presets
	
end



local onKeyPressed=function(key)
	local pick=tonumber(key)
	if pick==nil then return end
	
	-- log("Key:"..key.." tonumber:"..pick)
	
	if isLoading then return false end
	local option=presets[pick]
	if option==nil then return false end
	
	-- log("Picked option:"..TSerial.pack(option))
	
	_.client.send({cmd="preset_picked", pick=pick}, onPresetPicked)
end


_.activate=function()
	subscribe(S.keyPressedListeners, onKeyPressed)
	_.client.send({cmd="players_presets_get"}, onPresetsReceived)
	isLoading=true
end

_.deactivate=function()
	unsubscribe(S.keyPressedListeners,onKeyPressed)
end



_.update=function()
	
end

_.draw=function()
	LG.print("New player")
	
	if isLoading then 
		LG.print("loading..",0,20) 
		return
	end
	
	local y=40
	local yStep=40
	local x=10
	for k,preset in pairs(presets) do
		local sprite=Img[preset.spriteName]
		
		LG.print(k,x,y)
		LG.draw(sprite,x+16,y)
		LG.print(preset.name,x+64,y)
		
		y=y+yStep
	end
	
end


return _

