local _=function(data, clientId)	
	local response={presets=Registry.playerPresets}
	Server.send(response, clientId, data.requestId)
end	

return _