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