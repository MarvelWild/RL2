local _={}

local messages={}

_.add=function(data)
	table.insert(messages, data)
	
	log("log msg added:"..data.text.." from:"..data.source)
end

_.last=function(count)
	return Lume.last(messages, count)
	--return messages
end


return _