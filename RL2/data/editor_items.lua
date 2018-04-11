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
	{
		["type"]="item",
		["item_type"]="hat_green",
	},
	{
		["type"]="item",
		["item_type"]="seed",
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


return _