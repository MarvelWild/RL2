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
S.isServer=Lume.find(arg, "server")~=nil or Lume.find(arg, "s")~=nil
S.isEditor=(not S.isServer) and (Lume.find(arg, "editor")~=nil or Lume.find(arg, "e")~=nil)
S.keyPressedListeners={}

-- Config
C=require "gameconfig"

Debug = require "lib/debug"
require "util"

-- lowercase Globals - frequently used
log=Debug.log

--log(TSerial.pack(arg))

-- ours
-- World
W={}

-- in turns
W.time=1

if S.isServer then 
	-- by login
	W.players={}
end



Player=require "world/player"

-- configuration

if S.isServer then
	log("server mode")
end

require "bootstrap"

-- configuration end

Ui=require "ui"

-- end of globals area --



love.load=function()
	if S.isServer then 
		S.rootState=require "server/server" 
	else
		S.rootState=require "client/client" 
		Img=require "res/img"
	end
	
	tryCall(S.rootState.activate)
end

love.draw=function()
	S.rootState.draw()
end

love.update=function(dt)
	S.rootState.update(dt)
	S.frame=S.frame+1
end

love.keypressed=function(key, unicode)
    for k,listener in ipairs(S.keyPressedListeners) do
			listener(key, unicode)
		end
end

love.quit=function()
	tryCall(S.rootState.deactivate)
end

