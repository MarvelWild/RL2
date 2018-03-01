local Player={}

Player.new=function()
	local r={}
	
	r.x=0
	r.y=0
	r.name="Anonymous"
	r.hp=42
	r.level="start"
	r.fov=5
	return r
end

return Player