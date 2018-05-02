local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

require "shared/lib/strict"
_G.common=nil
Img=nil
Shaders=nil
Client=nil
Game=nil -- state_game

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
CScreen = require "shared/lib/CScreen/cscreen"
--Cron = require "lib/cron/cron"

--local f=function()
--	log("after 3 seconds")
--end

--Cron.after(3, f)

Fonts={}
Fonts.main=LG.getFont()
Fonts.chat=love.graphics.newFont("res/LiberationSans-Regular.ttf", 18)


S=require "shared/data/session"
Debug = require "shared/lib/debug"

-- lowercase Globals - frequently used
log=Debug.log
pack=TSerial.pack

require "shared/data/const"
require "data/const"




-- конфиг важно загрузить пораньше
local confFileInfo=love.filesystem.getInfo(CLIENT_SAVE_DIR..CONFIG_SAVE_NAME)
if confFileInfo~=nil then
	local configPacked=love.filesystem.read(CLIENT_SAVE_DIR..CONFIG_SAVE_NAME)
	C=TSerial.unpack(configPacked)
	
	local defaultConfig=require "shared/data/gameconfig"
	if defaultConfig.version>C.version then
		-- вторая приоритетней
		local mergedC=Lume.merge(defaultConfig,C)
		C=mergedC
		--C=defaultConfig
		log("Old config merged")
	end
	log("Config loaded")
else
	log("New config")
	
	C=require "shared/data/gameconfig"
end

UiLayer={}
Audio=require "tech/audio"
Id=require "shared/tech/id"
Id.init(CLIENT_SAVE_DIR)

local loginParam=Lume.match(arg, function(arg) 
		return Allen.startsWith(arg,"l=")
	end
)

if loginParam~=nil then
	local login=string.sub(loginParam,3)
	C.clientLogin=login
end


require "shared/util"

-- ours
-- World
W={}

-- in turns
W.time=1

Level=require "shared/world/level"
Cell=multirequire("shared/world/cell","world/cell")
Player=require "shared/world/player"
Character=require "shared/world/character"
Feature=require "shared/world/feature"
Inventory=require "shared/world/inventory"

Wall=require "shared/world/wall"
Item=require "shared/world/item"
EditorItem=require "shared/world/editoritem"


Ui=require "data/ui"

-- end of globals area --



love.load=function()
	Id.load()
	S.rootState=require "client/client" 
	Img=require "res/img"
	Shaders=require "res/shaders"
	Client=S.rootState
	Audio.startMusic()
	
	tryCall(S.rootState.activate)
	
	require "tech/tests"
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
	love.filesystem.createDirectory(CLIENT_SAVE_DIR)
	love.filesystem.write(CLIENT_SAVE_DIR..CONFIG_SAVE_NAME, configPacked)
	
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

