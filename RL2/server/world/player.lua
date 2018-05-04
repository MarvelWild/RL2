local _={}


_.new=function(preset)
	local r={}
	
	r.id=Id.new("player")
	r.x=0
	r.y=0
	r.isDead=false
	r.name="Anonymous"
	r.levelCode="start_0"
	r.fov=6
	r.attackMin=1
	r.attackMax=5
	r.isEditor=false
	r.isLoggedIn=false;
	r.inventory={} -- indexed, handled by Inventory
	
	if preset.character~=nil then
		r.character=Character.clone(preset.character)
	else
		r.character=Character.new()
		r.character.spriteName=preset.spriteName
	end
	
	return r
end

return _