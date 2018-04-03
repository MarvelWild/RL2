local _={}

local _server

_.spells=require("server/spells")


-- client info(login) by clientId
_.clients={}
_.clientCount=0
_.commandHandlers={}


-- current excluded
local getActivePlayersAt=function(currentPlayer,x,y)
	-- opt:could be index by xy
	local result=nil
	for k,client in pairs(_.clients) do
		local player=client.player
		if player~=nil then
			if player.x==x and player.y==y and player~=currentPlayer then
				if result==nil then result={} end
				table.insert(result, player)
			end
		end
	end
	
	return result
end

local getVisibleCells=function(player)
	local startX=player.x-player.fov
	local endX=player.x+player.fov
	local startY=player.y-player.fov
	local endY=player.y+player.fov
	
	local level=W.levels[player.level]
	
	local result={}
	
	for x=startX,endX do
		local column={}
		result[x]=column
		for y=startY,endY do
			local cell=Level.getCell(level.cells,x,y)
			column[y]=cell
			cell.players=getActivePlayersAt(player,x,y)
			
--			if x==-1 and y==1 then
--				local a=1
--			end
			
		end
	end
	
	
	local test=TSerial.pack(result)
	return result
end


_.sendTurn=function(client,clientId,requestId)
	local response={}
	response.responseType="turn"
	-- clientWorld.requestId=data.requestId
	response.time=W.time
	
	response.player=client.player
	response.cells=getVisibleCells(client.player)

	_.send(response, clientId,requestId)
end


-- unlocks input on client - generic response
_.sendOk=function(clientId,requestId)
	local response={}
	response.responseType="ok"
	-- clientWorld.requestId=data.requestId
	_.send(response, clientId,requestId)
end


-- единственная точка через которую сервер отправляет сообщения
_.send=function(data, clientId,requestId)
	assert(requestId~=nil)
	data.requestId=requestId
	local packed=TSerial.pack(data)
	log("sending:"..packed)
	_server:send(packed..NET_MSG_SEPARATOR, clientId)
end



_.commandHandlers.enter_editor_mode=function(data,clientId)
	local client = _.clients[clientId]
	local player=client.player
	player.isEditor=true
	
	_.send({"ok"}, clientId, data.requestId)
end

_.commandHandlers.editor_place=function(data,clientId)
	local editorItem=data.item
	
	local client = _.clients[clientId]
	
	local player=client.player
	local level=W.levels[player.level]
	local cell = Level.getCell(level.cells,data.x,data.y)
	if editorItem.type=="ground" then
		cell.ground_type=editorItem.ground_type
	elseif editorItem.type=="character" then
		local characterType=editorItem.character_type
		-- if cell.entity~=nil then ok gc this current
		cell.entity=Character.newByCharacterType(characterType,cell)
	elseif editorItem.type=="feature" then
		cell.feature=Feature.new(editorItem.feature_type)
	elseif editorItem.type=="wall" then
		cell.wall=Wall.new(editorItem.wall_type)
	else
		log("error:unk editor item type")
	end
	
	_.sendTurn(client, clientId, data.requestId)
end

_.commandHandlers.preset_picked=function(data,clientId)
	log("new player")
	local pickNumber=data.pick
	local preset=Registry.playerPresets[pickNumber]
	local player=Player.new(preset)
	local client=_.clients[clientId]
	W.players[client.login]=player
	client.player=player
	
	local test=W.players[client.login]
	_.send({"ok"}, clientId, data.requestId)
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
	
	--можно играть и мёртвыми ))
	--if player~=nil and player.isDead then player=nil end
	
	-- todo : multiple players for client
	client.player=player
	
	_.send({players={player}}, clientId, data.requestId)
end

_.commandHandlers.get_full_state=function(data, clientId)
	local clientWorld={}
	clientWorld.time=W.time
	
	local client = _.clients[clientId]
	
	clientWorld.player=client.player
	clientWorld.cells=getVisibleCells(client.player)
	
	_.send(clientWorld, clientId, data.requestId)
end

_.commandHandlers.logoff=function(data,clientId)
	_.clients[clientId]=nil
	_.clientCount=_.clientCount-1	
end

_.commandHandlers.test=function(data,clientId)
	_.send({responseType="message",text="test ok",data=data},clientId,data.requestId)
end




_.commandHandlers.name_picked=function(data, clientId)
	local client = _.clients[clientId]
	local player=client.player
	player.name=data.name
	_.send({"ok"}, clientId, data.requestId)
end




local loadHandlers=function()
	local baseDir="server/handlers/"
	
	local files=love.filesystem.getDirectoryItems(baseDir)
	for k,item in ipairs(files) do
		if Allen.endsWith(item, ".lua") then
			local name=Allen.strLeftBack(item, ".lua")
			_.commandHandlers[name]=require(baseDir..name)
		end
	end
end

loadHandlers()

local connect=function(id)
	-- id is userdata if tcp
	log("Client connected")

	-- report back to the client with ID
	--self:sendWelcome(id)
	--self:sendSnapshot(id)
end

local recv=function(data, id)
	log("recv:"..data)
	local dataParts=string.split(data,NET_MSG_SEPARATOR)
	
	for k,dataCommand in pairs(dataParts) do
		local command=TSerial.unpack(dataCommand)
		local handler=_.commandHandlers[command.cmd]
		if handler==nil then 
			log("error: no handler for cmd:"..command.cmd) 
		else
			handler(command,id)
		end
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
--	local servInfo="LRL server. Players:".._.clientCount.."\n"
--	servInfo=servInfo..Inspect.inspect(W.players)
--	LG.print(servInfo)

	local servInfo="LRL server. Clients:".._.clientCount.."\n"
	servInfo=servInfo..Inspect.inspect(_.clients)
	LG.print(servInfo)
end


_.update=function(dt)
	_server:update(dt)
end

_.textinput=function(t)
end

--Броадкаст
_.sendLog=function(text, source, requestId)	
	local data={text=text,responseType="log",channel="chat",source=source}
	_.send(data, nil, requestId)
end


return _
