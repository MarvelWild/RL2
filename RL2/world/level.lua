local _={}

_.new=function()
	local result={}
	
	result.cells={}
	
	return result
end


_.getCell=function(cells,x,y)
	local row = cells[x]
	if row == nil then
		row={}
		cells[x]=row
	end
	
	local cell = row[y]
	if cell ==  nil then
		cell= Cell.new(x,y)
		row[y]=cell
	end
	
	return cell
	
end

return _