local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

local time=love.timer.getTime()
love.math.setRandomSeed(time)

-- the only Globals area --
LG=love.graphics

-- third party
Utf8 = require("utf8")
Lume=require "shared/lib/lume/lume"
Allen=require "shared/lib/Allen/allen"
Grease=require "shared/lib/grease/grease.init"
TSerial=require "shared/lib/TSerial"
Async=require "shared/lib/async/async"
Inspect=require "shared/lib/inspect/inspect"

-- Session
S=require "shared/data/session"

-- Config
require "shared/data/const"
require "data/const"

Debug = require "shared/lib/debug"

-- lowercase Globals - frequently used
log=Debug.log
pack=TSerial.pack

-- конфиг важно загрузить пораньше
local confFileInfo=love.filesystem.getInfo(SERVER_SAVE_DIR..CONFIG_SAVE_NAME)
if confFileInfo~=nil then
	
	local configPacked=love.filesystem.read(SERVER_SAVE_DIR..CONFIG_SAVE_NAME)
	C=TSerial.unpack(configPacked)
	
	local defaultConfig=require "shared/data/gameconfig"
	if defaultConfig.version>C.version then
		-- вторая приоритетней
		С=Lume.merge(defaultConfig,C)
		log("Old config merged")
	end
	log("Config loaded")
else
	log("New config")
	
	C=require "shared/data/gameconfig"
end

-- compat

Life=require "world/life"
Id=require "shared/tech/id"
Id.init(SERVER_SAVE_DIR)
Id.load()


require "shared/util"


-- ours
-- World
W={}

-- in turns
W.time=1

Level=require "world/level"
LevelUtil=require "shared/world/levelutil"

-- key=login
Players={}

-- key==name
Levels={}

-- todo: dynamic
Levels.start=Level.new("start")
Levels.level2=Level.new("level2")

Player=require "shared/world/player"
local sharedCharacter=require "shared/world/character"
local serverCharacter=require "world/character"

Character=Lume.merge(sharedCharacter,serverCharacter)
Feature=require "shared/world/feature"
Inventory=require "shared/world/inventory"

Cell=require "world/cell"
Wall=require "shared/world/wall"
Item=require "shared/world/item"
ItemUtil=require "world/itemutil"
EditorItem=require "shared/world/editoritem"
Effect=require "shared/world/effect"

-- end of globals area --



love.load=function()
	S.rootState=require "server/server" 
	Server=S.rootState
	Img={}
	
	Registry=require "data/registry"
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
	love.filesystem.createDirectory(SERVER_SAVE_DIR)
	love.filesystem.write(SERVER_SAVE_DIR..CONFIG_SAVE_NAME, configPacked)
	
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

