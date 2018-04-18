-- access: Registry.editorItems
-- todo: брать characters from registry
-- todo: editorItem as cell, as new item type.

local _={
	{type="ground",ground_type="grass",spriteName="floor_grass_1",	},
	{type="ground",ground_type="grass",spriteName="floor_grass_2",	},
	{type="ground",ground_type="grass",spriteName="floor_grass_3",	},
	{type="ground",ground_type="grass",spriteName="floor_grass_4",	},
	{type="ground",ground_type="grass",spriteName="floor_grass_5",	},
	{type="ground",ground_type="grass",spriteName="floor_grass_6",	},
	{type="ground",ground_type="grass",spriteName="floor_grass_7",	},
	{type="ground",ground_type="grass",spriteName="floor_grass_8",	},
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
	{type="ground",ground_type="cobble",spriteName="floor_cobble_1",	},	
	{type="ground",ground_type="cobble",spriteName="floor_cobble_2",	},	
	{type="ground",ground_type="cobble",spriteName="floor_cobble_yellow_1",	},	
	{type="ground",ground_type="cobble",spriteName="floor_cobble_blue_1",	},	
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
		["spriteName"]="rock_troll",
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
		["type"]="character",
		["spriteName"]="ice_crab",
	},
	{type="character",spriteName="spectral_imp",},
	{type="character",spriteName="crocodile",},
	{type="character",spriteName="fat_spider",},
	{type="character",spriteName="rat_brown",},
	{type="character",spriteName="rat_poisonous",},
	{type="character",spriteName="carniworm",},
	{type="character",spriteName="slime_red",},
	{type="character",spriteName="slime_blue_big",},
	{type="character",spriteName="mosquito",},
	{type="character",spriteName="crab_ghost",},
	{type="character",spriteName="redwing",},
	{type="character",spriteName="green_bob",},
	{type="character",spriteName="crystal_spawn",},
	{type="character",spriteName="frogbear",},
	{type="character",spriteName="quasit",},
	{type="character",spriteName="elemental_amber",},
	{type="character",spriteName="elemental_greenmass",},
	{type="character",spriteName="pinky_greeneye",},
	{type="character",spriteName="mage_corrupted",},
	{type="character",spriteName="hydra_3head",},
	{type="character",spriteName="dragon_steel",},
	{type="character",spriteName="dragon_black",},
	{type="character",spriteName="eye_mundane",},
	{type="character",spriteName="floating_brain",},
	{type="character",spriteName="eyeball_zombie",},
	{type="character",spriteName="eye_corrupted",},
	{type="character",spriteName="eye_ghost",},
	{type="character",spriteName="drake_swamp",},
	{type="character",spriteName="blade_demon",},
	{type="character",spriteName="xenoslime",},
	{type="character",spriteName="ooze_cosmic",},
	{type="character",spriteName="eyeorb_black",},
	{type="character",spriteName="tentacled_corruptor",},
	{type="character",spriteName="demon_rust",},
	{type="character",spriteName="impling_2",},
	{type="character",spriteName="steam_beast",},
	{type="character",spriteName="impling",},
	{type="character",spriteName="abomination_3feet",},
	{type="character",spriteName="golem_flesh",},
	{type="character",spriteName="golem_iron",},
	{type="character",spriteName="crystal_knight",},
	{type="character",spriteName="unseen_horror",},
	{type="character",spriteName="headless_caster",},
	{type="character",spriteName="antman",},
	{type="character",spriteName="quadhand",},
	{type="character",spriteName="floating_flesh",},
	{type="character",spriteName="sigmund",},
	{type="character",spriteName="wildman",},
	{type="character",spriteName="corruption_caster",},
	{type="character",spriteName="thunder_caster",},
	{type="character",spriteName="knight_red_boots",},
	{type="character",spriteName="golden_priest",},
	{type="character",spriteName="beggar",},
	{type="character",spriteName="feather_hat",},
	{type="character",spriteName="joker_green",},
	{type="character",spriteName="joker_yellow",},
	
	{type="feature",spriteName="portal",},
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
		["spriteName"]="pink_weed",
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


