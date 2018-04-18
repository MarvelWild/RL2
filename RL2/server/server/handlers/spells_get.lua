local _=function(data, clientId)	
	local spells=Registry.spells
	local response={spells=spells}
	Server.send(response, clientId, data.requestId)
end	

return _