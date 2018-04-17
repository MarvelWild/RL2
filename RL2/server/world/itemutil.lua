-- global ItemUtil
local _={}

local applyEffect=function(target, effect)
end


_.applyThrow=function(item,cell)
	if item.code=="paint_yellow" then
		if cell.entity~=nil then
			local effect={type="paint", color={255,255,0}}
			Character.applyEffect(cell.entity, effect)
		end
	end
end

return _