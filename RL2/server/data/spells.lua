-- access: Registry.spells

local _=
{
	-- number indexes used to sort and name spells on client
	-- handler should be described in server/spells
	

	{
		name="Heal",
		code="heal",
		manaCost=3,
		amount=4,
	},
	{
		name="Polymorph",
		code="polymorph",
		manaCost=5,
		range=5,
		isTargeted=true,
	},
}


local blink=Spell.new()
blink.name="Blink"
blink.code="blink"
blink.manaCost=2
blink.radius=4
table.insert(_,blink)

local heal=Spell.new()
heal.name="Heal"
heal.code="heal"
heal.manaCost=3
heal.radius=4
table.insert(_,heal)


return _