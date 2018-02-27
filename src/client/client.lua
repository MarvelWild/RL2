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
	
	local hander=_.responseHandlers[response.response]
	hander(command,id)
end

local _netClient

_.send=function(data, onResponse)
	data.requestId=_.requestId
	_.requestId=_.requestId+1
	
	if onResponse~=nil then
		
	end
	
	`
	
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


_.init=function()
	_.state=require "client/state_connecting"
	connect()
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