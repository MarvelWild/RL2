log("running tests")

local t12345={1,2,3,4,5}
local t12345s={"1","2","3","4","5"}
local v

local v1=table.nextInCircle(t12345,5)
local v5=table.nextInCircle(t12345,4)
local v2=table.nextInCircle(t12345,1)
local vNil=table.nextInCircle(t12345,6)
v=table.nextInCircle(t12345,"1"); assert(v==nil)
assert(v1==1)
assert(v2==2)
assert(v5==5)
assert(vNil==nil)


local v1s=table.nextInCircle(t12345s,"5")
local v5s=table.nextInCircle(t12345s,"4")
local v2s=table.nextInCircle(t12345s,"1")
v=table.nextInCircle(t12345s,6); assert(v==nil)
v=table.nextInCircle(t12345s,"6"); assert(v==nil)
assert(v1s=="1")
assert(v2s=="2")
assert(v5s=="5")