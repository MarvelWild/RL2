local _={}

_.new=function(x,y)
	local result = {}
	
	
	-- x,y решил пока что не добавлять, чтобы не дублировать данные и не создавать возможности битых
	result.ground_type=nil
	
	-- лестница, портал -рисуется под врагом, но над полом
	result.feature=nil
	
	-- противник или npc (-игрок)
	result.entity=nil
	
	result.wall=nil
	
	-- заполняется при передаче клиенту
	result.players=nil
	
	
	
	-- удобнее отлаживать, но первичные данные это level.cells
	result.x=x
	result.y=y
	
	
	return result
end


return _