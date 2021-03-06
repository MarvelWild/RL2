local _={}

_.requestId=0
_.responseHandlers={}

_.logComponent=require("client/component/log")

-- state_game | 
_.state=nil	
_.singleResponseHandlers={}
_.isLoggedIn=false

local switchState=function(state)
	
	if _.state~=nil and _.state.deactivate~=nil then
		_.state.deactivate()
	end
	
	_.state=state
	_.state.client=_
	tryCall(_.state.activate)
end

_.switchToPickNewState=function()
	local state=require "client/state_create_player"
	switchState(state)
end

_.switchToGameState=function()
	local gameState=require "client/state_game"
	Game=gameState
	switchState(gameState)
end

_.switchToEnterNameState=function()
	local state=require "client/state_enter_name"
	switchState(state)
end




local afterLogin=function(response)
	local players=response.players
	local state=require "client/state_pick_player"
	state.init(players)
	switchState(state)
	_.isLoggedIn=true
end


-- just a log message from server for test purposes
_.responseHandlers.message=function(data)
	log("message:"..data.text)
end

-- user displayed log
_.responseHandlers.log=function(data)
	log("Server LOG:"..data.text)
	
	_.logComponent.add(data)
end





loadScripts("client/handlers/", _.responseHandlers)

-- incomplete part accumulated here
local receiveBuffer=""

-- data is raw string, chunk of data flow (could be fragmented)
local recv=function(data) -- search alias: receive
	if not Allen.endsWith(data,NET_MSG_SEPARATOR) then
		-- todo: process completed parts
		receiveBuffer=receiveBuffer+data
		log("received incomplete data. buffering:"..data)
		return
	end
	
	if receiveBuffer~="" then
		data=receiveBuffer+data
		receiveBuffer=""
	end
	
	log("recv:"..data)	
	
	local isProcessed=false
	local dataParts=string.split(data,NET_MSG_SEPARATOR)
	
	for k,dataCommand in pairs(dataParts) do
		-- wip: unfinished data
		local response=TSerial.unpack(dataCommand)
		
		-- todo: mem leak
		local singleHandler=_.singleResponseHandlers[response.requestId]
		if singleHandler~=nil then
			singleHandler(response)
			_.singleResponseHandlers[response.requestId]=nil
			isProcessed=true
		end
		
		
		local handler=_.responseHandlers[response.responseType]
		if handler~=nil then 
			handler(response)
			isProcessed=true
		end
	
		if not isProcessed then
			log("error:data from server not processed:"..data)
		end
		
	end
end

local _netClient

-- единственная точка через которую клиент отправляет сообщения
-- onResponse=function(response)
_.send=function(data, onResponse)
	data.requestId=_.requestId
	_.requestId=_.requestId+1
	
	if onResponse~=nil then
		_.singleResponseHandlers[data.requestId]=onResponse
	end
	
	local packed=TSerial.pack(data)
	log("send:"..packed)
	_netClient:send(packed..NET_MSG_SEPARATOR)
end


local login=function()
	local data={
		cmd="login",
		login=C.clientLogin,
		-- isEditor=S.isEditor -- later, after character pick
	}
	_.send(data,afterLogin)
end


local connect=function()
	_netClient=Grease.tcpClient()
	_netClient.handshake=C.handshake
	_netClient.callbacks.recv=recv
	
	local ok, msg = _netClient:connect("lore", C.port, false)
	if not ok then
		log("error:Cannot connect:"..msg)
		return
	else
		log("connect ok")
	end
	login()
end


_.startGame=function()
	local state=require "client/state_connecting"
	switchState(state)
	connect()
end

_.activate=function()
	local state=require "client/state_start"
	switchState(state)
--	_.startGame()
end




_.deactivate=function()
	tryCall(_.state.deactivate)
	
	if _.isLoggedIn then 
		local data={
			cmd="logoff"
		}
		_.send(data)
		_.isLoggedIn=false
	end
	
end

_.draw=function()
	-- LG.print("client")
	_.state.draw()
end


_.update=function(dt)
	if _netClient~=nil then _netClient:update(dt) end
	tryCall(_.state.update)
end

_.resize=function(...)
	if _.state.resize~=nil then
		_.state.resize(...)
	end
end




_.textinput=function(t)
	-- log("client text input:"..t)
	
	if _.state.textinput~=nil then
		_.state.textinput(t)
	end
end


_.keypressed=function(...)
	local state=_.state
	if state~=nil and state.keypressed~=nil then
		state.keypressed(...)
	end
	
end

return _