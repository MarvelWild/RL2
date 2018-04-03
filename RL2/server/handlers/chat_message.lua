local chat_message=function(data, clientId)
	log("chat msg received:"..pack(data))
	--Server.send({"ok"}, clientId, data.requestId)
	
	-- wip : send log update, клиентом обработается и лог, и в чат стейт должен прийти ок
	-- wip : broadcast
	
	local client = Server.clients[clientId]
	local source=client.player.name
	Server.sendLog(data.text, source, data.requestId)
end

return chat_message