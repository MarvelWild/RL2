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
Inspect=require "lib/inspect/inspect"



-- Session
S={}
S.rootState=nil
S.frame=0
S.isServer=Lume.find(arg, "server")~=nil or Lume.find(arg, "s")~=nil
S.isEditor=(not S.isServer) and (Lume.find(arg, "editor")~=nil or Lume.find(arg, "e")~=nil)
S.keyPressedListeners={}
S.keysDown={}

-- Config
local configFile="config"
local saveDir

Debug = require "lib/debug"
-- lowercase Globals - frequently used
log=Debug.log

require "const"

-- bootstrapping config, it loaded later
C=require "gameconfig"


if S.isServer then
	saveDir=C.ServerSaveDir 
else 
	saveDir=C.QuickSaveDir 
end

if love.filesystem.exists(saveDir..configFile) then
	local configPacked=love.filesystem.read(saveDir..configFile)
	C=TSerial.unpack(configPacked)
	log("Config loaded")
else
	
	log("New config")
end

-- config cmd override

local loginParam=Lume.match(arg, function(arg) 
		return Allen.startsWith(arg,"l=")
	end
)

if loginParam~=nil then
	local login=string.sub(loginParam,3)
	C.clientLogin=login
	
end




require "util"




--log(TSerial.pack(arg))

-- ours
-- World
W={}

-- in turns
W.time=1

Level=require "world/level"
if S.isServer then 
	-- by login
	W.players={}
	W.levels={}
	W.levels.start=Level.new()
end



Player=require "world/player"
Character=require "world/character"

Cell=require "world/cell"

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
	
	Registry=require "registry"
	tryCall(S.rootState.activate)
end

love.draw=function()
	S.rootState.draw()
	
--	local info=TSerial.pack(S.keysDown)
--	LG.print(info,0,20)
end

love.update=function(dt)
	S.rootState.update(dt)
	S.frame=S.frame+1
end

love.keypressed=function(key, unicode)
	-- log("keypressed "..key)
	for k,listener in ipairs(S.keyPressedListeners) do
		listener(key, unicode)
	end
	-- S.keysDown[key]=true
end

love.keyreleased=function(key, scancode)
	--log("keyreleased "..key)
	--S.keysDown[key]=nil
end


local saveConfig=function()
	local configPacked=TSerial.pack(C)
	love.filesystem.write(saveDir..configFile, configPacked)
end


love.quit=function()
	tryCall(S.rootState.deactivate)
	saveConfig()
end

