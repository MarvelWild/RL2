-- global Item
local _={}

_.applyThrow=function(item,cell)
	if item.code=="paint_yellow" then
		if cell.entity~=nil then
			local effect=Effect.new()
			effect.type="paint"
			effect.color={r=1,g=1,b=0}
			Character.applyEffect(cell.entity, effect)
		end
	elseif item.code=="paint_blue" then
		if cell.entity~=nil then
			local effect=Effect.new()
			effect.type="paint"
			effect.color={r=0,g=0,b=1}
			Character.applyEffect(cell.entity, effect)
		end
	end
end

return _