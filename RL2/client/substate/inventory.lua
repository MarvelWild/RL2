local _={}

_.parentstate=nil

_.name="Inventory"

local inventory={}


-- table k=id v~=nil
local selectedIds=nil

_.draw=function()
	LG.print("INVENTORY")
	
	-- LG.print("You carry nothing", 10, 42)
	local y=40
	for k,item in ipairs(inventory) do
		local text = pack(item)
		if selectedIds[item.id] then text="+ "..text end
		
		text = string.abcChar(k).." "..text
		
		LG.print(text,10,y)
		y=y+24
	end
end

_.activate=function()
	_.parentstate.isDrawSelf=false
	inventory=W.player.inventory
	selectedIds={}
end

_.deactivate=function()
	_.parentstate.isDrawSelf=true
end


local toggleSelection=function(item)
	if selectedIds[item.id]~=nil then
		selectedIds[item.id]=nil
	else 
		selectedIds[item.id]=true
	end
end


_.onKeyPressed=function(key)
	if key=="escape" or key=="space" then
		_.parentstate.delSubstate(_)
	end
	
	-- item selection wip
	
	local abcPos=string.abcPos(key)
	local item=inventory[abcPos]
	if item~=nil then
		toggleSelection(item)
	end
	
	return true -- catch all the keys
end

return _