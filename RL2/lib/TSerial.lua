-- TSerial v1.2, a simple table serializer which turns tables into Lua script
-- by Taehl (SelfMadeSpirit@gmail.com)

-- Usage: table = TSerial.unpack( TSerial.pack(table) )
local TSerial = {}

function TSerial.pack(t)
	assert(type(t) == "table", "Can only TSerial.pack tables.")
	if not t then return nil end
	local s = "{"
	for k, v in pairs(t) do
		local tk, tv = type(k), type(v)
		local isError=false
		if tk == "boolean" then 
			k = k and "[true]" or "[false]"
		elseif tk == "number" 
			then k = "["..k.."]"
		elseif tk == "string" then 
			-- no transform needed
		elseif tk == "table" 
			then k = "["..TSerial.pack(k).."]"
		else 
			TSerial.keyError("Attempted to Tserialize a table with an invalid key: "..tostring(k), tk)
			isError=true
		end -- if
	
		if tv == "boolean" 
			then v = v and "true" or "false"
		elseif tv == "number" 
			then -- no transform needed
		elseif tv == "string"
			then v = string.format("%q", v)
		elseif tv == "table"
			then v = TSerial.pack(v)
		else 
			TSerial.valueError("Attempted to Tserialize a table with an invalid value: "..tostring(v), tv)
			isError=true
		end -- if
		
		if not isError then
			s = s..k.."="..v..","
		end
	end --for
	return s.."}"
end

function TSerial.unpack(s)
	assert(type(s) == "string", "Can only TSerial.unpack strings.")
	loadstring("TSerial.table="..s)()
	local t = TSerial.table
	TSerial.table = nil
	return t
end

-- we can override this for custom handling
function TSerial.keyError(msg,key)
	error(msg)
end

function TSerial.valueError(msg,key)
	error(msg)
end

return TSerial