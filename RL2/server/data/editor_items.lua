-- todo: брать characters from registry
local _={
	{
		["type"]="ground",
		["ground_type"]="grass",
	},
	{
		["type"]="ground",
		["ground_type"]="grass_planted",
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
		["ground_type"]="stone_red",
	},
	{
		["type"]="ground",
		["ground_type"]="lava",
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
		["type"]="ground",
		["ground_type"]="water_shallow",
	},	
	{
		["type"]="wall",
		["wall_type"]="stone",
	},
	{
		["type"]="wall",
		["wall_type"]="bones",
	},
	{
		["type"]="wall",
		["wall_type"]="iron",
	},
}

local addCharacters=function()
	for charType,v in pairs(Registry.spriteNameByCharacterType) do
		local item={type="character", character_type=charType}
		table.insert(_,item)
	end
	
end


addCharacters()

local addFeatures=function()
	for featType,v in pairs(Registry.spriteNameByFeatureType) do
		local item={type="feature", feature_type=featType}
		table.insert(_,item)
	end
end

addFeatures()


local addItems=function()
	for k,v in pairs(Registry.spriteInfoByItemType) do
		local item={type="item", item_type=k}
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


