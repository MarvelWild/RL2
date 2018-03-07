local _={}

_.client=nil

local options={}

_.init=function(players)
	local letter="a"
	
	for k,player in pairs(players) do
		options[letter]=player
		letter=Allen.succ(letter)
	end
	
	-- new player option
	options[letter]="new"
	
end

local onPlayerPicked=function(response)
	_.client.switchToGameState()
end


local pickExisting=function(playerId)
	local data={
		cmd="pick_player",
		playerId=playerId,
		isEditor=S.isEditor
	}
	_.client.send(data, onPlayerPicked)
end

local pickNew=function()
	_.client.switchToPickNewState()
end



local onKeyPressed=function(key)
	log("Pick player key pressed:"..key)
	
	local option = options[key]
	if option==nil then return end
	if option=="new" then
		pickNew()
	else
		local player=option
		pickExisting(player.id)
	end
	
	
	local a=1
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
	LG.print("picking player")
	
	local y=40
	local yStep=16
	
	for k,player in pairs(options) do
		local desc=""
		if player=="new" then
			desc="new"
		else
			desc=player.name
		end
		
		LG.print(k.." - "..desc,10,y)
		y=y+yStep
	end
	
end

return _