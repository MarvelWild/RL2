local Player={}

local newId=function()
	local result = C.lastId.player
	C.lastId.player=C.lastId.player+1
	return result
end


Player.new=function()
	local r={}
	
	r.id=newId()
	r.x=0
	r.y=0
	r.name="Anonymous"
	r.hp=42
	r.level="start"
	r.fov=5
	return r
end

return Player