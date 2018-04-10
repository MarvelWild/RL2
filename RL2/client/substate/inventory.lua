local _={}

_.parentstate=nil

_.name="Inventory"

local inventory=nil
local actions=nil


-- table k=id v=item
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
	
	-- actions
	
	LG.print("ACTIONS",10,400)
	y=420
	for k,action in pairs(actions) do
		local text=k.." "..pack(action)
		LG.print(text,10,y)
		y=y+24
	end
end

_.activate=function()
	_.parentstate.isDrawSelf=false
	inventory=W.player.inventory
	selectedIds={}
	actions={}
end

_.deactivate=function()
	_.parentstate.isDrawSelf=true
end

local addAction=function(newAction)
	for k,action in pairs(actions) do
		if action.code==newAction.code then return end
	end
	
	table.insert(actions,newAction)
end

local addActionsForItem=function(item)
	if item.type=="seed" then
		addAction({name="Plant", code="plant"})
	end
end


local updateActions=function()
	actions={}
	for id,item in pairs(selectedIds) do
		addActionsForItem(item)
	end
	
end

local toggleSelection=function(item)
	if selectedIds[item.id]~=nil then
		selectedIds[item.id]=nil
	else 
		selectedIds[item.id]=item
	end
	
	updateActions()
end

local performAction=function(action)
	
end


_.onKeyPressed=function(key)
	log("inventory received key:"..key)
	
	if key=="escape" or key=="space" then
		_.parentstate.delSubstate(_)
		return true
	end
	
	-- item selection
	
	local abcPos=string.abcPos(key)
	local item=inventory[abcPos]
	if item~=nil then
		toggleSelection(item)
		return true
	end
	
	-- actions
	local keyNumber=tonumber(key)
	if keyNumber~=nil then
		log("keynumber:"..keyNumber)
		local action=actions[keyNumber]
		if action~=nil then
			performAction(action)
			return true
		end
	end
	
	return true -- catch all the keys
end

return _