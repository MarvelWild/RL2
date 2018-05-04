-- Registry.playerPresets


local abilities={}

abilities.blink=Ability.new()
abilities.blink.name="Blink"
abilities.blink.code="blink"
abilities.blink.manaCost=2
abilities.blink.radius=4

--be sure Character.clone supports new preset fields
local human= --Character.new(), but no id
{
	spriteName="human",
	hp=42,
	abilities={
		abilities.blink,
	}
}




local _=
{
	{
		name="Ogre",
		spriteName="ogre_dcss_32",
	},
	{
		name="Troll",
		spriteName="troll_green",
	},
	{
		name="Sorceress",
		spriteName="sorceress"
	},
	{
		name="Skeleimp",
		spriteName="skeleimp"
	},
	{
		name="Eye",
		spriteName="floating_eye"
	},
	{name="Minotaur",spriteName="minotaur"},
	{name="Human",character=human},
}

return _