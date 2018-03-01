local _={}

_.requestId=0
_.responseHandlers={}
_.state=nil	
_.singleResponseHandlers={}

local switchState=function(state)
	
	if _.state~=nil and _.state.deactivate~=nil then
		_.state.deactivate()
	end
	
	_.state=state
	_.state.client=_
	tryCall(_.state.activate)
end


_.responseHandlers.login_ok=function()
	local gameState=require "client/state_game"
	switchState(gameState)
	
end





local recv=function(data)
	log("recv:"+data)
	
	local response=TSerial.unpack(data)
	
	local singleHandler=_.singleResponseHandlers[response.requestId]
	if singleHandler~=nil then
		singleHandler(response)
		_.singleResponseHandlers[response.requestId]=nil
		return
	end
	
	
	local handler=_.responseHandlers[response.responseType]
	handler(response)
end

local _netClient

-- onResponse=function(response)
_.send=function(data, onResponse)
	data.requestId=_.requestId
	_.requestId=_.requestId+1
	
	if onResponse~=nil then
		_.singleResponseHandlers[data.requestId]=onResponse
	end
	
	local packed=TSerial.pack(data)
	log("send:"..packed)
	_netClient:send(packed)
end


local login=function()
	local data={
		cmd="login",
		login=C.clientLogin
	}
	_.send(data)
end


local connect=function()
	_netClient=Grease.tcpClient()
	_netClient.handshake=C.handshake
	_netClient.callbacks.recv=recv
	
	local ok, msg = _netClient:connect("127.0.0.1", C.port, false)
	if not ok then
		log("error:Cannot connect:"..msg)
		return
	else
		log("connect ok")
	end
	login()
end


_.activate=function()
	_.state=require "client/state_connecting"
	connect()
end

_.deactivate=function()
	tryCall(_.state.deactivate)
end

_.draw=function()
	-- LG.print("client")
	_.state.draw()
end


_.update=function(dt)
	_netClient:update(dt)
	_.state.update()
end


return _