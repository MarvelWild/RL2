local _={}

local isInputLocked=false
_.drawCells=false
_.parentstate=nil
_.name="spell cast substate"
_.draw=function()
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


_.onKeyPressed=function(key)
	--log("spellcast pressed:"..key)
	if isInputLocked then return end
	
	if key=="escape" then
		_.parentstate.delSubstate(_)
	end
	
	if _.spells==nil then return end
	local abcPos=string.abcPos(key)
	local spell=_.spells[abcPos]
	if spell==nil then return true end
	
	local command={cmd="spell_cast", spell=spell}
	isInputLocked=true
	_.parentstate.client.send(command, afterCast)
	
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
	log("cast act")
	reset()
	
	_.parentstate.isDrawSelf=false
	
	-- state_game
	local command={cmd="spells_get"}
	_.parentstate.client.send(command, displaySpells)
end


_.deactivate=function()
	_.parentstate.isDrawSelf=true
end


return _