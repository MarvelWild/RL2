-- all ingame items
local _={}

--local itemSprites={
--	"hat_green",
--	"seed",
--	"book_blue",
--	"flask_blue",
--	"flask_yellow",
--	"ring_eye",
--}


local greenHat=Item.new("hat")
greenHat.spriteName="hat_green"
table.insert(_,greenHat)

local seed=Item.new("armor")
seed.spriteName="seed"
table.insert(_,seed)

local item=Item.new("book")
item.name="Frost magic tutorial"
item.spriteName="book_blue"
table.insert(_,item)

item=Item.new("flask")
item.name="Blue paint"
item.spriteName="flask_blue"
table.insert(_,item)

item=Item.new("flask")
item.name="Yellow paint"
item.spriteName="flask_yellow"
table.insert(_,item)

item=Item.new("ring")
item.name="Eyebind"
item.spriteName="ring_eye"
table.insert(_,item)


return _