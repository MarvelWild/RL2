local _={}

_.editorItems=
{
	{
		["type"]="ground",
		["ground_type"]="grass",
	},
	{
		["type"]="ground",
		["ground_type"]="sand",
	},
	{
		["type"]="ground",
		["ground_type"]="stone",
	},
	{
		["type"]="ground",
		["ground_type"]="acid",
	},
	{
		["type"]="ground",
		["ground_type"]="magic",
	},
	{
		["type"]="ground",
		["ground_type"]="water",
	},
	{
		["type"]="character",
		["character_type"]="frog",
	},
	{
		["type"]="character",
		["character_type"]="skeleton",
	},
	{
		["type"]="feature",
		["feature_type"]="portal",
	},
	{
		["type"]="feature",
		["feature_type"]="tree",
	},
}

_.spriteNameByCharacterType=
{
	["frog"]="frog",
	["skeleton"]="skeleton",
}

_.spriteNameByFeatureType=
{
	["portal"]="portal",
	["tree"]="tree",
}



if not S.isServer then
	_.spriteByGroundType=
	{
		["grass"]=Img.floor_grass_1,
		["stone"]=Img.floor_stone_1,
		["acid"]=Img.floor_acid,
		["magic"]=Img.floor_magic,
		["water"]=Img.floor_water,
		["sand"]=Img.floor_sand,
	}
	
	_.spriteByCharacterType=
	{
		["frog"]=Img.frog,
		["skeleton"]=Img.skeleton,
	}
	
	_.spriteByFeatureType=
	{
		["portal"]=Img.portal,
		["tree"]=Img.tree,
	}
end


return _
	