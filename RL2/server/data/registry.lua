-- Registry aka Db

local _={}

--- BOOTSTRAP
_.spriteNameByWallType={}
_.spriteByWallType={}

_.spriteByCharacterType={}

--- FUNCTIONS
_.addWall=function(wallType, spriteName)
	_.spriteNameByWallType[wallType]=spriteName
	if not S.isServer then
		_.spriteByWallType[wallType]=Img[spriteName]
	end
end

--- DATA


_.playerPresets=require("data/player_presets")

_.addWall("stone", "wall_stone")
_.addWall("bones", "wall_bones_1")
_.addWall("iron", "wall_iron")

-- also item types
_.items=require "data/items"

-- stuff that depends on Registry
_.lateInit=function()
	_.editorItems=require("data/editor_items")
end

-- Data transformation
_.getEntitySpriteNames=function()
	local result={}
	for k,item in pairs(_.editorItems) do 
		if item.type=="character" then
			table.insert(result, item.spriteName)
		end
	end
	
	return result
end


return _