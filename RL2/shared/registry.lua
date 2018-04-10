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
	["ladder_up"]="ladder_up",
	["ladder_down"]="ladder_down",
	["blood"]="blood_1",
	["altar_cards"]="altar_cards",
}

_.playerPresets=require("data/player_presets")


-- CLIENT ONLY
if not S.isServer then
	_.spriteByGroundType=
	{
		["grass"]=Img.floor_grass_1,
		["stone"]=Img.floor_stone_1,
		["stone_red"]=Img.floor_stone_red,
		["lava"]=Img.floor_lava,
		["acid"]=Img.floor_acid,
		["magic"]=Img.floor_magic,
		["water"]=Img.floor_water,
		["sand"]=Img.floor_sand,
		["water_shallow"]=Img.water_shallow,
	}
	

	_.spriteByFeatureType=
	{
		["portal"]=Img.portal,
		["tree"]=Img.tree,
		["ladder_up"]=Img.ladder_up,
		["ladder_down"]=Img.ladder_down,
		["blood"]=Img.blood_1,
		["altar_cards"]=Img.altar_cards,
	}
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

_.addWall("stone", "wall_stone")
_.addWall("bones", "wall_bones_1")
_.addWall("iron", "wall_iron")

_.spriteInfoByItemType=
{
	hat_green={spriteName="hat_green", sprite=Img.hat_green},
	seed={spriteName="seed", sprite=Img.seed},
}



-- stuff that depends on Registry
_.lateInit=function()
	_.editorItems=require("data/editor_items")
end

return _