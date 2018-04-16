local _={}

_.getCell=function(cells,x,y)

	assert(x~=nil)
	assert(y~=nil)
	
	local col = cells[x]
	if col == nil then
		col={}
		cells[x]=col
	end
	
	local cell = col[y]
	if cell ==  nil then
		cell= Cell.new(x,y)
		col[y]=cell
	end
	
	return cell
	
end

return _