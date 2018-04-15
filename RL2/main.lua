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
--Cron = require "lib/cron/cron"

--local f=function()
--	log("after 3 seconds")
--end

--Cron.after(3, f)

Fonts={}
Fonts.main=LG.getFont()
Fonts.chat=love.graphics.newFont("res/LiberationSans-Regular.ttf", 18)




-- Session
S=require "data/session"


-- Config
local configFile="config"
local saveDir

Debug = require "lib/debug"




-- lowercase Globals - frequently used
log=Debug.log
pack=TSerial.pack

require "data/const"


if S.isServer then
	saveDir=SERVER_SAVE_DIR
else 
	saveDir=CLIENT_SAVE_DIR
end
S.saveDir=saveDir

-- конфиг важно загрузить пораньше
local confFileInfo=love.filesystem.getInfo(saveDir..configFile)
if confFileInfo~=nil then
	
	local configPacked=love.filesystem.read(saveDir..configFile)
	C=TSerial.unpack(configPacked)
	
	local defaultConfig=require "data/gameconfig"
	if defaultConfig.version>C.version then
		-- вторая приоритетней
		С=Lume.merge(defaultConfig,C)
		--C=defaultConfig
		log("Old config merged")
	end
	log("Config loaded")
else
	log("New config")
	
	C=require "data/gameconfig"
end

-- compat
C.ServerSaveDir=SERVER_SAVE_DIR
C.QuickSaveDir=CLIENT_SAVE_DIR

if S.isServer then
	love.window.setTitle("Server: "..love.window.getTitle( ))
	love.window.setPosition(0,300)
	Life=require "world/life"
else 
	UiLayer={}
	love.window.setTitle("Client: "..love.window.getTitle( ))
	Audio=require "tech/audio"
end

Id=require "tech/id"


-- delete data (clear start)
if Lume.find(arg, "d")~=nil then
	log("d param not implemented")
end


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
	-- key=login
	Players={}
	
	-- key==name
	Levels={}
	
	-- todo: dynamic
	Levels.start=Level.new("start")
	Levels.level2=Level.new("level2")
end



Player=require "world/player"
Character=require "world/character"
Feature=require "world/feature"
Inventory=require "world/inventory"

Cell=require "world/cell"
Wall=require "world/wall"
Item=require "world/item"
EditorItem=require "world/editoritem"

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
		Shaders=require "res/shaders"
		Client=S.rootState
		Audio.startMusic()
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
	for k,listener in ipairs(S.updateListeners) do
		listener(dt)
	end
	S.rootState.update(dt)
	
	--if S.frame % 600 == 0 then
		-- log("slow update")
		-- ideas: partial update
		-- fov only
		-- update on cell request
		-- квантовая неопределённость - в момент наблюдения и обновить
	--end
	
	
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
	local configPacked=TSerial.pack(C,true,true)
	love.filesystem.createDirectory(saveDir)
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

