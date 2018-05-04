-- access: Registry.editorItems
-- todo: брать characters from registry
-- todo: editorItem as cell, as new item type.

--применение: EditorItem.applyToCell
local _={}

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
local editorWalls=require "data/editoritems/editor_walls"
table.append(_,editorCharacters)
table.append(_,groundItems)
table.append(_,editorFeatures)
table.append(_,editorWalls)


return _


