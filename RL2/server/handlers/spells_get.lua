local _=function(data, clientId)	
	local spells=
	{
		spells=
		{
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
				amount=4
			}
		}
	}
	
	Server.send(spells, clientId, data.requestId)
end	

return _