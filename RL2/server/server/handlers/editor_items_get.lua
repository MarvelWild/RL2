local _=function(data, clientId)	
	local response={editorItems=Registry.editorItems}
	Server.send(response, clientId, data.requestId)
end	

return _