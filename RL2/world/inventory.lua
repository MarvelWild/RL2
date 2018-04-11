local _={}

_.removeItem=function(inventory, id)
	for k,item in pairs(inventory) do
		if item.id==id then
			inventory[k]=nil
			return item
		end
	end
	
	return nil
end


return _