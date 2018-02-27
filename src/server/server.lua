local _={}

local _server

_.clients={}
_.commandHandlers={}

_.send=function(data, clientId)
	local packed=TSerial.pack(data)
	log("sending:"..packed)
	_server:send(packed, clientId)
	
end


_.commandHandlers.login=function(data,clientId)
	local existingClient=_.clients[login]
	
	if existingClient~=nil then
		log("error:client already logged in")
	end
	
	_.clients[clientId]={login=data.login}
	
	_.send({response="login_ok", requestId=data.requestId}, clientId)
end


local connect=function(id)
	-- id is userdata if tcp
	log("Client connected")

	-- report back to the client with ID
	--self:sendWelcome(id)
	--self:sendSnapshot(id)
end

local recv=function(data, id)
	log("recv:"..data)
	local command=TSerial.unpack(data)
	local hander=_.commandHandlers[command.cmd]
	hander(command,id)
end

local disconnect=function(ip, port)
	log("disconnect:"..ip..":"..port)
end






_.init=function()
	_server=Grease.tcpServer()
	-- server:createSocket()
	
	_server.callbacks.connect=connect
	_server.callbacks.recv=recv
	_server.callbacks.disconnect=disconnect
	_server.handshake=C.handshake
	
	_server:listen(C.port)
	log("server started")
end


_.draw=function()
	LG.print("server")
end


_.update=function(dt)
	_server:update(dt)
end


return _