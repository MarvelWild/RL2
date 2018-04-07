local _=
{
	-- number indexes used to sort and name spells on client
	-- handler should be described in server/spells
	
	{
		name="Blink",
		code="blink",
		manaCost=2,
		radius=4,
	},
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




return _