local _={}

_.parentstate=nil
_.name="Inventory"

-- local inventory=nil
local actions=nil
local isInputLocked=false

local inventoryData=nil

local isTargeting=false


-- table k=id v=item
local selectedIds=nil

_.draw=function()
	if isTargeting then return end
	
	LG.print("INVENTORY")
	
	-- LG.print("You carry nothing", 10, 42)
	local y=40
	-- ipairs ломает удаление
	for k,item in pairs(inventoryData) do
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

local sortFn = function(a, b) return a.id < b.id end

_.activate=function()
	_.parentstate.isDrawSelf=false
	local inventory=W.player.inventory
	local inventoryIndexed={}
	for k,v in pairs(inventory) do
		table.insert(inventoryIndexed,v)
	end
	
	
	log("before sort:"..pack(inventoryIndexed))
	inventoryData=Lume.sort(inventoryIndexed, sortFn)
	
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
	elseif item.type=="flask" then -- evo: isThrowable
		addAction({name="Throw", code="throw"})
	end
	
	addAction({name="Drop", code="drop"})
end


local updateActions=function()
	actions={}
	local selectionCount=0
	for id,item in pairs(selectedIds) do
		addActionsForItem(item)
		selectionCount=selectionCount+1
	end
	
	if selectionCount==1 then
		
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

local afterAction=function(response)
	log("inventory afterAction:"..pack(response))
	
	isInputLocked=false
	_.parentstate.delSubstate(_)
end

local doPerformAction=function(action)
	local command=
	{
		cmd="item_action",
		actionCode=action.code,
		itemIds=Lume.keys(selectedIds)
	}
	
	log("action cmd:"..pack(command))
	
	isInputLocked=true
	Client.send(command, afterAction)
end

local afterTargetPicked=function(action,x,y)
	log("target picked:"..xy(x,y))
	isTargeting=false
	
	action.x=x
	action.y=y
	doPerformAction(action)
end



local pickThrowTarget=function(action)
	assert(not isInputLocked)
	
	isTargeting=true
	
	-- signature fx(x,y) now matches generic pickTarget
	local f=Lume.fn(afterTargetPicked,action)
	_.parentstate.pickTarget(f)
end



local performAction=function(action)
	if action.code=="throw" then
		pickThrowTarget(action)
	else
		doPerformAction(action)
	end
end




_.onKeyPressed=function(key)
	if isInputLocked then return false end
	if isTargeting then return false end
	
	log("inventory received key:"..key)
	
	if key=="escape" or key=="space" then
		_.parentstate.delSubstate(_)
		return true
	end
	
	-- item selection
	
	local abcPos=string.abcPos(key)
	local item=inventoryData[abcPos]
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