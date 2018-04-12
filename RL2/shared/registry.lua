local _={}

--- BOOTSTRAP

_.spriteNameByWallType={}
_.spriteByWallType={}

_.spriteByCharacterType={}
_.spriteNameByCharacterType={}

--- FUNCTIONS
_.addWall=function(wallType, spriteName)
	_.spriteNameByWallType[wallType]=spriteName
	if not S.isServer then
		_.spriteByWallType[wallType]=Img[spriteName]
	end
end

_.addCharacter=function(characterType, spriteName)
	_.spriteNameByCharacterType[characterType]=spriteName
	if not S.isServer then
		_.spriteByCharacterType[characterType]=Img[spriteName]
	end
end


--- DATA




_.spriteNameByFeatureType=
{
	["portal"]="portal",
	["tree"]="tree",
	["blue_growth"]="blue_growth",
	["ladder_up"]="ladder_up",
	["ladder_down"]="ladder_down",
	["blood"]="blood_1",
	["altar_cards"]="altar_cards",
	["altar_cheibriados"]="altar_cheibriados",
	["door"]="door_closed",
}

_.playerPresets=require("data/player_presets")


-- CLIENT ONLY
if not S.isServer then
	_.spriteByGroundType=
	{
		["grass"]=Img.floor_grass_1,
		["grass_planted"]=Img.grass_planted_1,
		["stone"]=Img.floor_stone_1,
		["stone_red"]=Img.floor_stone_red,
		["lava"]=Img.floor_lava,
		["acid"]=Img.floor_acid,
		["magic"]=Img.floor_magic,
		["water"]=Img.floor_water,
		["sand"]=Img.floor_sand,
		["water_shallow"]=Img.water_shallow,
	}
	
	_.spriteByFeatureType={}
	for k,v in pairs(_.spriteNameByFeatureType) do
		_.spriteByFeatureType[k]=Img[v]
	end
end

local addCharacter=_.addCharacter

-- charType, spriteName
addCharacter("frog","frog")
addCharacter("skeleton","skeleton")
addCharacter("cat","cat_1")
addCharacter("octopod","octopod_red")
addCharacter("skelebat","skelebat")
addCharacter("necromancer","necromancer")
addCharacter("eyemold","eyemold")
addCharacter("reaper","reaper")
addCharacter("clawplant","clawplant")
addCharacter("living_shade","living_shade")
addCharacter("shade_violet","shade_violet")

_.addWall("stone", "wall_stone")
_.addWall("bones", "wall_bones_1")
_.addWall("iron", "wall_iron")

_.spriteInfoByItemType=
{
	hat_green={spriteName="hat_green", sprite=Img.hat_green},
	seed={spriteName="seed", sprite=Img.seed},
	book_blue={spriteName="book_blue", sprite=Img.book_blue},
}



-- stuff that depends on Registry
_.lateInit=function()
	_.editorItems=require("data/editor_items")
end

return _