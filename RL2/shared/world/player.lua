-- global module Player
local Player={}

local newId=function()
	return Id.new("player")
end


Player.new=function(preset)
	local r={}
	
	r.id=newId()
	r.x=0
	r.y=0
	r.isDead=false
	r.name="Anonymous"
	r.hp=42
	r.maxHp=42
	r.xp=0
	r.lvl=1
	r.levelCode="start_0"
	r.fov=6
	r.attackMin=1
	r.attackMax=5
	r.spriteName=preset.spriteName
	r.isEditor=false
	r.isLoggedIn=false;
	r.inventory={} -- indexed, handled by Inventory
	return r
end



return Player