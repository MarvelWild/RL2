local _={}

local isInputLocked=false
local isTargeting=false

_.drawCells=false
_.parentstate=nil
_.name="spell cast substate"
_.draw=function()
	if isTargeting then return end
	
	if _.spells==nil then
		LG.print("loading")
	else
		
		local y=50
		for k,v in pairs(_.spells) do
			LG.print(string.abcChar(k)..":"..pack(v),10,y)
			y=y-20
		end
		
	end
	
end

_.spells=nil

local afterCast=function()
	isInputLocked=false
	_.parentstate.delSubstate(_)
end

local doCastSpell=function(spell)
	local command={cmd="spell_cast", spell=spell}
	isInputLocked=true
	_.parentstate.client.send(command, afterCast)
end

local afterTargetPicked=function(spell, cellX,cellY)
	log("after target picked")
	isTargeting=false
	doCastSpell(spell)
	
	-- wip coords
end


local startPickTarget=function(spell)
	-- log("Targeting")
	
	-- wip: unlock after targeting
	assert(not isInputLocked)
	
	isTargeting=true
	
	-- signature fx(x,y) now matches generic pickTarget
	local fiWithParam=Lume.fn(afterTargetPicked,spell)
--	 _.parentstate.pickTarget(afterTargetPicked)
	_.parentstate.pickTarget(fiWithParam)
end




local onSpellKeyPressed=function(spell)
	log("Before cast spell:"..pack(spell))
	
	if spell.isTargeted then
		startPickTarget(spell)
	else
		doCastSpell(spell)
	end
end


_.onKeyPressed=function(key)
	--log("spellcast pressed:"..key)
	if isInputLocked then return true end
	if isTargeting then return false end
	
	if key=="escape" then
		_.parentstate.delSubstate(_)
	end
	
	if _.spells==nil then return end
	local abcPos=string.abcPos(key)
	local spell=_.spells[abcPos]
	if spell~=nil then
		onSpellKeyPressed(spell)
		return true 
	end

	return true
end

local displaySpells=function(response)
	_.spells=response.spells
	log("display spells:"..TSerial.pack(_.spells))
	
end



local reset=function()
	_.spells=nil
end

_.activate=function()
	log("spellcast activate")
	reset()
	
	_.parentstate.isDrawSelf=false
	
	-- state_game
	local command={cmd="spells_get"}
	_.parentstate.client.send(command, displaySpells)
end


_.deactivate=function()
	log("spellcast deactivate")
	_.parentstate.isDrawSelf=true
end


return _