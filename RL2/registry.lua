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
end

return _
	