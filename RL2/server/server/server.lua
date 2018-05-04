local _={}

local _server

_.abilities=require("server/abilities_implementation")


-- client info(login) by clientId
_.clients={}
_.clientCount=0
_.commandHandlers={}


-- current excluded
local getActivePlayersAt=function(currentPlayer,x,y,levelCode)
	-- opt:could be index by xy
	local result=nil
	for k,client in pairs(_.clients) do
		local player=client.player
		if player~=nil and player.levelCode==currentPlayer.levelCode then
			if player.x==x and player.y==y and player~=currentPlayer then
				if result==nil then result={} end
				table.insert(result, player)
			end
		end
	end
	
	return result
end


_.getActivePlayersAtCell=function(levelCode,x,y)
	-- opt:could be index by xy
	local result=nil
	for k,client in pairs(_.clients) do
		local player=client.player
		if player~=nil and player.levelCode==levelCode then
			if player.x==x and player.y==y then
				if result==nil then result={} end
				table.insert(result, player)
			end
		end
	end
	
	return result
end

_.getVisibleCells=function(player)
	local startX=player.x-player.fov
	local endX=player.x+player.fov
	local startY=player.y-player.fov
	local endY=player.y+player.fov
	
	local level=Levels[player.levelCode]
	
	local result={}
	
	local cells=level.cells
	
--	dump(cells,"getVisibleCells")
	
	for x=startX,endX do
		local column={}
		result[x]=column
		for y=startY,endY do
			local cell=Level.getUpdatedCell(cells,x,y)
			column[y]=cell
			cell.players=getActivePlayersAt(player,x,y)
			
--			if x==-1 and y==1 then
--				local a=1
--			end
			
		end
	end
	
	
	local test2=TSerial.pack(result)
	return result
end


_.sendTurn=function(client,clientId,requestId)
	local response={}
	response.responseType="turn"
	response.time=W.time
	
	response.player=client.player
	response.cells=_.getVisibleCells(client.player)

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
	data.requestId=requestId
	local packed=TSerial.pack(data)
	
	local sendLen=string.len(packed)
	local sendInfo="sending size="..sendLen
	if sendLen<8192 then
		sendInfo=sendInfo.." data:"..packed
	end
	log(sendInfo)
	
	_server:send(packed..NET_MSG_SEPARATOR, clientId)
end



_.commandHandlers.enter_editor_mode=function(data,clientId)
	local client = _.clients[clientId]
	local player=client.player
	player.isEditor=true
	
	_.send({"ok"}, clientId, data.requestId)
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


loadScripts("server/handlers/", _.commandHandlers)

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
	local file=SERVER_SAVE_DIR..C.WorldSaveName
	
	local info=love.filesystem.getInfo(file)
	if info~=nil then
		local packed=love.filesystem.read(file)
		W=TSerial.unpack(packed)
	end
	
	local playersDir=SERVER_SAVE_DIR..PLAYERS_SAVE_DIR
	local playerSaves=love.filesystem.getDirectoryItems(playersDir)
	for k,login in pairs(playerSaves) do
		local packed=love.filesystem.read(playersDir..login)
		Players[login]=TSerial.unpack(packed)
	end
	
	local levelsDir=SERVER_SAVE_DIR..LEVELS_SAVE_DIR
	local levelSaves=love.filesystem.getDirectoryItems(levelsDir)
	

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

_.save = function()
	love.filesystem.createDirectory(SERVER_SAVE_DIR)
	
	local worldPacked=TSerial.pack(W,true,true)
	love.filesystem.write(SERVER_SAVE_DIR..C.WorldSaveName, worldPacked)
	
	local playersDir=SERVER_SAVE_DIR..PLAYERS_SAVE_DIR
	love.filesystem.createDirectory(playersDir)
	
	for login,player in pairs(Players) do
		local playerPacked=pack(player,true,true)
		love.filesystem.write(playersDir..login,playerPacked)
	end
	
	local levelsDir=SERVER_SAVE_DIR..LEVELS_SAVE_DIR
	love.filesystem.createDirectory(levelsDir)
	
	for levelName,level in pairs(Levels) do
		local levelPacked=pack(level,true,true)
		love.filesystem.write(levelsDir..levelName,levelPacked)
	end
	
	
end

_.deactivate=function()
	_.save()
end


_.draw=function()
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



-- except self
-- isForce: ignore level difference (was on level case)
_.sendPlayerStatus=function(client,isForce)
	log("sendPlayerStatus:"..pack(client))
	
	if client.player==nil then return end
	
	local data={responseType="player_status",player=client.player}
	
	for otherClientId,otherClient in pairs(_.clients) do
		if otherClient~=client and otherClient.player~=nil then 
			if client.player.levelCode==otherClient.player.levelCode or isForce then
				_.send(data, otherClientId, nil)
				log("Sending status to:"..otherClient.player.name)
			end
			
		end
	end
	
	
end

return _
