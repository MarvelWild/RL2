-- access: Registry.editorItems
-- todo: брать characters from registry
-- todo: editorItem as cell, as new item type.

--применение: EditorItem.applyToCell
local _={
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
	
}

local addItems=function()
	for k,v in pairs(Registry.items) do
		local item={type="item", spriteName=v.spriteName,item=v}
		table.insert(_,item)
	end
end


addItems()

local groundItems=require "data/editoritems/ground"
local editorCharacters=require "data/editoritems/editor_characters"
local editorFeatures=require "data/editoritems/editor_features"
table.append(_,editorCharacters)
table.append(_,groundItems)
table.append(_,editorFeatures)


return _


