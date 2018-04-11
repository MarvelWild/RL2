local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

local time=love.timer.getTime()
love.math.setRandomSeed(time)

-- the only Globals area --
LG=love.graphics

-- third party
Utf8 = require("utf8")
Lume=require "lib/lume/lume"
Allen=require "lib/Allen/allen"
Grease=require "lib/grease/grease.init"
TSerial=require "lib/TSerial"
Async=require "lib/async/async"
Inspect=require "lib/inspect/inspect"
CScreen = require "lib/CScreen/cscreen"


Fonts={}
Fonts.main=LG.getFont()
Fonts.chat=love.graphics.newFont("res/LiberationSans-Regular.ttf", 18)




-- Session
S={}
S.rootState=nil
S.frame=0
S.isServer=Lume.find(arg, "server")~=nil or Lume.find(arg, "s")~=nil
S.isEditor=(not S.isServer) and (Lume.find(arg, "editor")~=nil or Lume.find(arg, "e")~=nil)
S.keyPressedListeners={} -- это уйдёт, инпут пустить по цепочке стейтов, начиная с нижнего
S.keysDown={}
S.saveDir=nil

-- Config
local configFile="config"
local saveDir

Debug = require "lib/debug"
-- lowercase Globals - frequently used
log=Debug.log
pack=TSerial.pack

require "data/const"

C=require "data/gameconfig"



if S.isServer then
	saveDir=C.ServerSaveDir 
	
	love.window.setTitle("Server: "..love.window.getTitle( ))
	love.window.setPosition(0,300)
	
else 
	saveDir=C.QuickSaveDir 
	love.window.setTitle("Client: "..love.window.getTitle( ))
end
S.saveDir=saveDir

Id=require "tech/id"


-- delete data (clear start)
if Lume.find(arg, "d")~=nil then
	log("d param not implemented")
end


local confFileInfo=love.filesystem.getInfo(saveDir..configFile)
if confFileInfo~=nil then
	
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




require "shared/util"




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
	W.levels.level2=Level.new()
end



Player=require "world/player"
Character=require "world/character"
Feature=require "world/feature"
Inventory=require "world/inventory"

Cell=require "world/cell"
Wall=require "world/Wall"
Item=require "world/Item"

-- configuration

if S.isServer then
	log("server mode")
end

-- configuration end

Ui=require "data/ui"

-- end of globals area --



love.load=function()
	Id.load()
	if S.isServer then 
		S.rootState=require "server/server" 
		Server=S.rootState
		Img={}
	else
		S.rootState=require "client/client" 
		Img=require "res/img"
		Client=S.rootState
	end
	
	Registry=require "shared/registry"
	Registry.lateInit()
	tryCall(S.rootState.activate)
end

love.draw=function()
	S.rootState.draw()
	
--	local info=TSerial.pack(S.keysDown)
	-- LG.print(tostring(love.timer.getFPS( )),0,0)
end

love.update=function(dt)
	S.rootState.update(dt)
	S.frame=S.frame+1
end

love.keypressed=function(key, unicode)
	 log("keypressed "..key.."unicode:"..unicode)
	for k,listener in ipairs(S.keyPressedListeners) do
		listener(key, unicode)
	end
	-- S.keysDown[key]=true
	
	local stateKp=S.rootState.keypressed
	if stateKp~=nil then
		stateKp()
	end
	
	if key=="f12" and not S.isEditor then
		
		tryCall(S.rootState.state.enterEditorMode)
	end
	
end

love.textinput=function(t)
    S.rootState.textinput(t)
end

love.keyreleased=function(key, scancode)
	--log("keyreleased "..key)
	--S.keysDown[key]=nil
end


local saveConfig=function()
	local configPacked=TSerial.pack(C)
	love.filesystem.write(saveDir..configFile, configPacked)
	
	Id.save()
end

function love.resize(...)
	if S.rootState.resize~=nil then
		S.rootState.resize(...)
	end
end


love.quit=function()
	tryCall(S.rootState.deactivate)
	saveConfig()
end

