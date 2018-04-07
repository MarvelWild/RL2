local _=function(data, clientId)	
	local spells=require("data/spells")
	local response={spells=spells}
	Server.send(response, clientId, data.requestId)
end	

return _