local chat_message=function(data, clientId)
	log("chat msg received:"..pack(data))
	
	local client = Server.clients[clientId]
	local source=client.player.name
	Server.sendLog(data.text, source, data.requestId)
end

return chat_message