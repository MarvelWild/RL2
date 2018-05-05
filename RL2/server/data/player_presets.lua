-- Registry.playerPresets


local abilities={}

abilities.blink={} --Ability.new(), no id
abilities.blink.name="Blink"
abilities.blink.code="blink"
abilities.blink.manaCost=2
abilities.blink.radius=4

abilities.heal={} --Ability.new()
abilities.heal.name="Heal"
abilities.heal.code="heal"
abilities.heal.manaCost=3
abilities.heal.amount=7

abilities.polymorph={} --Ability.new()
abilities.polymorph.name="Polymorph"
abilities.polymorph.code="polymorph"
abilities.polymorph.manaCost=5
abilities.polymorph.range=5
abilities.polymorph.isTargeted=true
abilities.polymorph.isRandom=true

abilities.fly={}
abilities.fly.name="Fly"
abilities.fly.code="fly"



--be sure Character.clone supports new preset fields
local human= --Character.new(), but no id
{
	spriteName="human",
	hp=42,
	maxHp=42,
	isPlayer=true,
	abilities={
		abilities.blink,
		abilities.heal,
	}
}

local eye=
{
	spriteName="floating_eye",
	hp=12,
	maxHp=12,
	isPlayer=true,
	abilities={
		abilities.blink,
		abilities.heal,
		abilities.polymorph,
		abilities.fly,
		
	}
}




local _=
{
	{name="Human",character=human},
	{name="Eye",character=eye},
}

return _