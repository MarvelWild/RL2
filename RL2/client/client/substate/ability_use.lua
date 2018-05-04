local _={}

local isInputLocked=false
local isTargeting=false

_.drawCells=false
_.parentstate=nil
_.name="ability use substate"
_.draw=function()
	if isTargeting then return end
	
	if _.abilities==nil then
		LG.print("loading")
	else
		LG.print("Abilities")
		
		local y=50
		for k,v in ipairs(_.abilities) do
			LG.print(string.abcChar(k)..":"..pack(v),10,y)
			y=y+20
		end
		
	end
	
end

_.abilities=nil

local afterCast=function()
	isInputLocked=false
	_.parentstate.delSubstate(_)
end

local doUseAbility=function(ability,x,y)
	ability.x=x
	ability.y=y
	local command={cmd="ability_use", ability=ability}
	isInputLocked=true
	_.parentstate.client.send(command, afterCast)
end

local afterTargetPicked=function(ability, cellX,cellY)
	log("after target picked:"..xy(cellX,cellY))
	isTargeting=false
	
	if cellX~=nil then
		doUseAbility(ability,cellX,cellY)
	else
		-- ok, stay at curr state
	end
end


local startPickTarget=function(ability)
	-- log("Targeting")
	
	assert(not isInputLocked)
	
	isTargeting=true
	
	-- signature fx(x,y) now matches generic pickTarget
	local fiWithParam=Lume.fn(afterTargetPicked,ability)
--	 _.parentstate.pickTarget(afterTargetPicked)
	_.parentstate.pickTarget(fiWithParam)
end




local onAbilityKeyPressed=function(ability)
	log("Before use ability:"..pack(ability))
	
	if ability.isTargeted then
		startPickTarget(ability)
	else
		doUseAbility(ability)
	end
end


_.onKeyPressed=function(key)
	if isInputLocked then return true end
	if isTargeting then return false end
	
	if key=="escape" then
		_.parentstate.delSubstate(_)
	end
	
	if _.abilities==nil then return end
	local abcPos=string.abcPos(key)
	local ability=_.abilities[abcPos]
	if ability~=nil then
		onAbilityKeyPressed(ability)
		return true 
	end

	return true
end

local displayAbilities=function(response)
	_.abilities=response.abilities
	log("display abilities:"..TSerial.pack(_.abilities))
	
end



local reset=function()
	_.abilities=nil
end

_.activate=function()
	log("ability_use activate")
	reset()
	
	_.parentstate.isDrawSelf=false
	
	-- state_game
	local command={cmd="abilities_get"}
	_.parentstate.client.send(command, displayAbilities)
end


_.deactivate=function()
	log("ability_use state deactivate")
	_.parentstate.isDrawSelf=true
end


return _