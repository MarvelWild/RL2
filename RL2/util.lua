tryCall=function(func)
	if func~=nil then func() end
end

math.limit=function(min,val,max)
	if val<min then return min end
	if val>max then return max end
	return val
end

math.overflow=function(min,val,max)
	if val<min then return max-(val-min+1) end
	if val>max then return min+(val-max-1) end
	return val
end


math.limitWithRemainder=function(min,val,max)
	if val<min then return min,val-min end
	if val>max then return max,val-max end
	return val,0
end