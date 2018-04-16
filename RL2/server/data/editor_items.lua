-- access: Registry.editorItems
-- todo: брать characters from registry
-- todo: editorItem as cell, as new item type.

local _={
	{
		["type"]="ground",
		["ground_type"]="grass",
		["spriteName"]="floor_grass_1",
	},
	{
		["type"]="ground",
		["ground_type"]="grass_planted",
		["spriteName"]="grass_planted_1",
	},	
	{
		["type"]="ground",
		["ground_type"]="sand",
		["spriteName"]="floor_sand",
	},
	{
		["type"]="ground",
		["ground_type"]="stone",
		["spriteName"]="floor_stone_1",
	},
	{
		["type"]="ground",
		["ground_type"]="stone_red",
		["spriteName"]="floor_stone_red",
	},
	{
		["type"]="ground",
		["ground_type"]="lava",
		["spriteName"]="floor_lava",
	},
	{
		["type"]="ground",
		["ground_type"]="acid",
		["spriteName"]="floor_acid",
	},
	{
		["type"]="ground",
		["ground_type"]="magic",
		["spriteName"]="floor_magic",
	},
	{
		["type"]="ground",
		["ground_type"]="water",
		["spriteName"]="floor_water",
	},
	{
		["type"]="ground",
		["ground_type"]="water_shallow",
		["spriteName"]="water_shallow",
	},	
	{
		["type"]="wall",
		["wall_type"]="stone",
		["spriteName"]="wall_stone",
	},
	{
		["type"]="wall",
		["wall_type"]="bones",
		["spriteName"]="wall_bones_1",
	},
	{
		["type"]="wall",
		["wall_type"]="iron",
		["spriteName"]="wall_iron",
	},
	{
		["type"]="character",
		["spriteName"]="frog",
	},
	{
		["type"]="character",
		["spriteName"]="skeleton",
	},
	{
		["type"]="character",
		["spriteName"]="cat_1",
	},
	{
		["type"]="character",
		["spriteName"]="octopod_red",
	},
	{
		["type"]="character",
		["spriteName"]="skelebat",
	},
	{
		["type"]="character",
		["spriteName"]="necromancer",
	},
	{
		["type"]="character",
		["spriteName"]="eyemold",
	},
	{
		["type"]="character",
		["spriteName"]="reaper",
	},
	{
		["type"]="character",
		["spriteName"]="clawplant",
	},
	{
		["type"]="character",
		["spriteName"]="living_shade",
	},
	{
		["type"]="character",
		["spriteName"]="shade_violet",
	},
	{
		["type"]="character",
		["spriteName"]="bat",
	},
	{
		["type"]="character",
		["spriteName"]="elephant",
	},
	{
		["type"]="character",
		["spriteName"]="sheep",
	},
	{
		["type"]="character",
		["spriteName"]="snake_brown",
	},
		{
		["type"]="character",
		["spriteName"]="eye_fire",
	},
	{
		["type"]="character",
		["spriteName"]="hound",
	},
	{
		["type"]="character",
		["spriteName"]="coyote",
	},
	{
		["type"]="feature",
		["spriteName"]="portal",
	},
	{
		["type"]="feature",
		["spriteName"]="tree",
	},
	{
		["type"]="feature",
		["spriteName"]="blue_growth",
	},
	{
		["type"]="feature",
		["spriteName"]="ladder_up",
	},
	{
		["type"]="feature",
		["spriteName"]="ladder_down",
	},
	{
		["type"]="feature",
		["spriteName"]="blood_1",
	},
	{
		["type"]="feature",
		["spriteName"]="altar_cards",
	},
	{
		["type"]="feature",
		["spriteName"]="altar_cheibriados",
	},	
	{
		["type"]="feature",
		["featureType"]="door",
		["spriteName"]="door_closed",
	},		
}



local addItems=function()
	for k,v in pairs(Registry.items) do
		local item={type="item", spriteName=v.spriteName,item=v}
		table.insert(_,item)
	end
end


addItems()


-- features v2 - mo trees of type "tree"
-- try tag system? pro: convenent, con: slower

local mangrove1=
{
	["type"]="feature",
	["feature_type"]="tree",
	["code"]="mangrove1",
	["spriteName"]="mangrove_1"
}
table.insert(_,mangrove1)

local mangrove2=
{
	["type"]="feature",
	["feature_type"]="tree",
	["code"]="mangrove2",
	["spriteName"]="mangrove_2"
}
table.insert(_,mangrove2)


local mangrove3=
{
	["type"]="feature",
	["feature_type"]="tree",
	["code"]="mangrove3",
	["spriteName"]="mangrove_3"
}
table.insert(_,mangrove3)

return _


