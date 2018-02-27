local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

-- the only Globals area --
LG=love.graphics

-- third party
Lume=require "lib/lume/lume"
Allen=require "lib/Allen/allen"
Grease=require "lib/grease/grease.init"
TSerial=require "lib/TSerial"
Async=require "lib/async/async"



-- Session
S={}
S.rootState=nil
S.frame=0


-- Config
C={}
C.handshake="RL"
C.port=4242

C.clientLogin="MW"
C.ViewRadiusTilesX=5
C.ViewRadiusTilesY=4

Debug = require "lib/debug"
require "util"

-- lowercase Globals - frequently used
log=Debug.log

--log(TSerial.pack(arg))

-- ours
-- World
W={}

-- end of globals area --


-- configuration

S.isServer=Lume.find(arg, "server")~=nil

if isDebug then S.isServer=false end

if S.isServer then
	log("server mode")
end

-- todo: check if port busy then we are client

require "bootstrap"

-- configuration end




love.load=function()
	if S.isServer then 
		S.rootState=require "server/server" 
	else
		S.rootState=require "client/client" 
		Img=require "res/img"
	end
	
	S.rootState.init()
end

love.draw=function()
	S.rootState.draw()
end

love.update=function(dt)
	S.rootState.update(dt)
	S.frame=S.frame+1
end
