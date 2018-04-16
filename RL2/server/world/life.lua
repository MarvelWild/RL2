local _={}

local updatePlant=function(plant)
	local now = os.time()
	local currentGrowState=plant.growStates[plant.currentGrowState]
	if currentGrowState.timeNextState~=nil then
		
		-- todo: skip states (now it can grow every turn)
		if currentGrowState.timeNextState<=now then
			plant.currentGrowState=plant.currentGrowState+1
		end
	end
end


-- обновляем только интересующие ячейки (квантовый принцип)
-- todo: live update
_.updateCell=function(cell)
	if cell.misc~=nil then
		for k,miscItem in pairs(cell.misc) do
			if miscItem.entityType=="plant" then
				updatePlant(miscItem)
			end
		end
		
	end
	
end

return _