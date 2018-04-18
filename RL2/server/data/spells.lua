-- access: Registry.spells
-- handler should be described in server/spells

local _=
{
	-- number indexes used to sort and name spells on client
}


local s
s=Spell.new()
s.name="Blink"
s.code="blink"
s.manaCost=2
s.radius=4
table.insert(_,s)

s=Spell.new()
s.name="Heal"
s.code="heal"
s.manaCost=3
s.radius=4 -- not impl
s.amount=7
table.insert(_,s)

s=Spell.new()
s.name="Polymorph"
s.code="polymorph"
s.manaCost=5
s.range=5
s.isTargeted=true
s.isRandom=true
table.insert(_,s)

return _