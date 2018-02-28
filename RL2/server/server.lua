local _={}

local _server

-- client info(login) by clientId
_.clients={}
_.clientCount=0
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
	
	local client={login=data.login}
	_.clients[clientId]=client
	_.clientCount=_.clientCount+1
	
	local player=W.players[data.login]
	if player==nil then
		log("new player")
		player=Player.new()
		W.players[data.login]=player
	end
	
	client.player=player
	
	_.send({response="login_ok", requestId=data.requestId}, clientId)
end

_.commandHandlers.get_full_state=function(data, clientId)
	local clientWorld={}
	clientWorld.requestId=data.requestId
	clientWorld.time=W.time
	
	local client = _.clients[clientId]
	
	clientWorld.player=client.player
	clientWorld.cells={"wip"}
	
	_.send(clientWorld, clientId)
end

_.commandHandlers.logoff=function(data,clientId)
	_.clients[clientId]=nil
	_.clientCount=_.clientCount-1	
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
	local handler=_.commandHandlers[command.cmd]
	if handler==nil then 
		log("error: no handler for cmd:"..command.cmd) 
	else
		handler(command,id)
	end
end

local disconnect=function(ip, port)
	log("disconnect:"..ip..":"..port)
end




local loadWorld=function()
	local file=C.ServerSaveDir..C.WorldSaveName
	if love.filesystem.exists(file) then
		local packed=love.filesystem.read(file)
		W=TSerial.unpack(packed)
	end
end



_.activate=function()
	loadWorld()
	_server=Grease.tcpServer()
	-- server:createSocket()
	
	_server.callbacks.connect=connect
	_server.callbacks.recv=recv
	_server.callbacks.disconnect=disconnect
	_server.handshake=C.handshake
	
	_server:listen(C.port)
	log("server started")
end

local save = function()
	local saveDir=C.ServerSaveDir
	love.filesystem.createDirectory(saveDir)
	
	local worldPacked=TSerial.pack(W)
	love.filesystem.write(saveDir..C.WorldSaveName, worldPacked)
end

_.deactivate=function()
	save()
end


_.draw=function()
	local servInfo="LRL server. Players:".._.clientCount
	LG.print(servInfo)
end


_.update=function(dt)
	_server:update(dt)
end


return _
