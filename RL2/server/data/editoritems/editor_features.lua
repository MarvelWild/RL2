local _=
{
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
		code="ladder_up",
		featureType="ladder",
	},
	{
		["type"]="feature",
		["spriteName"]="ladder_down",
		featureType="ladder",
		code="ladder_down",
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