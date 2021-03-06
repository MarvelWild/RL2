-- global scope
tryCall=function(func)
	if func~=nil then func() end
end

math.limit=function(min,val,max)
	if val<min then return min end
	if val>max then return max end
	return val
end

math.overflow=function(min,val,max)
	if val<min then return max-(val-min+1) end
	if val>max then return min+(val-max-1) end
	return val
end


math.limitWithRemainder=function(min,val,max)
	if val<min then return min,val-min end
	if val>max then return max,val-max end
	return val,0
end


--net_send=function(data)
--end

net_receive=function()
end

function string.split(str, div)
    assert(type(str) == "string" and type(div) == "string", "invalid arguments")
    local result = {}
    while true do
			if str==nil or str=="" then break end
			local pos1,pos2 = str:find(div)
			if not pos1 then
					result[#result+1] = str
					break
			end
			
			local part=str:sub(1,pos1-1)
			if part~="" then
				result[#result+1]=part
				str=str:sub(pos2+1)
			end
    end
    return result
end



local lettersLow = 'abcdefghijklmnopqrstuvwxyz'

string.abcPos=function(charLower)
	local b=string.byte(charLower)
	local result=b-96
	return result
end

string.abcChar=function(num)
	return string.char(num+96)
end



subscribe=function(listeners, listener)
	table.insert(listeners, listener)
end

unsubscribe=function(listeners, listener)
	local listenerIndex=Lume.find(listeners, listener)
	if listenerIndex~=nil then
		listeners[listenerIndex]=nil
	else
		log("error: no listener")
	end
end


-- example: loadScripts("server/handlers/", destTable)
loadScripts=function(dir, container)
	local files=love.filesystem.getDirectoryItems(dir)
	for k,item in ipairs(files) do
		if Allen.endsWith(item, ".lua") then
			local name=Allen.strLeftBack(item, ".lua")
			container[name]=require(dir..name)
		end
	end
end

-- for debug purpose. name is optional
dump=function(content, name)
	if name==nil then name="dump" end
	
	local str=pack(content)
	local time = love.timer.getTime( )
	love.filesystem.write(name.."_ts_"..time,str)
	
	local ins=Inspect(content)
	love.filesystem.write(name.."_ins_"..time,ins)
end



key_is_enter=function(key)
	return key=="return" or key=="kpenter"
end


-- read input from keypad
-- y[down-|up+]
get_direction_8=function(key)
	local x=nil
	local y=nil
	
	if key==C.moveRight then
		x=1
		y=0
	elseif key==C.moveLeft then
		x=-1
		y=0
	elseif key==C.moveUp then
		y=1
		x=0
	elseif key==C.moveDown then
		y=-1
		x=0
	elseif key==C.moveUpLeft then
		y=1
		x=-1
	elseif key==C.moveUpRight then
		y=1
		x=1
	elseif key==C.moveDownLeft then
		y=-1
		x=-1
	elseif key==C.moveDownRight then
		y=-1
		x=1
	end
		
	return x,y
end

-- grid to pixel
coord_cell_to_game=function(cellX, cellY)
	local player=W.player
	
	local relToPlayerX=cellX-player.x
	local relToPlayerY=cellY-player.y
	
	local gameX=Ui.gamebox.playerX+(relToPlayerX*C.tileSize)
	local gameY=Ui.gamebox.playerY+(-relToPlayerY*C.tileSize)
	
	return gameX,gameY
end


xy=function(x,y)
	if type(x) == "table" then
		assert(y==nil)
		y=x.y
		x=x.x
	end
	
	if x==nil then x="nil" end
	if y==nil then y="nil" end
	
	return x..","..y
end

HSL=function(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m)*255,(g+m)*255,(b+m)*255,a
end


function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- multi-file module, members are merged
function multirequire(...)
	local params={...}
	local result=nil
	for k,path in ipairs(params) do
		if result==nil then
			result=require(path)
		else
			result=Lume.merge(result, require(path))
		end
	end
	
	return result
end


-- omit keys, just insert  values
table.append=function(t,t2)
	for k,v in pairs(t2) do
		table.insert(t,v)
	end
end

-- проверяет что все значения из t1 равны значениям из t2
-- пример использования: обнаружение изменений в сабсете данных
-- пока что только value типы, без таблиц
table.existingEquals=function(t1,t2)
	for k1,v1 in pairs(t1) do
		local v2=t2[k1]
		if v2~=v1 then
			return false
		end
	end
	
	return true
end


table.nextInCircle=function(t,prevv)
	
	local curr=nil
	local nxt=nil
	local first=nil
	
	for k,currv in pairs(t) do
		if first==nil then first=currv end
		
		if currv==prevv then
			curr=currv
		elseif curr~=nil then
			nxt=currv
			break
		end
	end
	
	if curr==nil then return nil end
	
	local result
	if nxt==nil then
		result=first
	else
		result=nxt
	end
	
	return result
	
end


-- local scope
local _={}



return _