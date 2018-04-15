local _={}
_.greyscale = love.graphics.newShader("res/shaders/blcknwht.frag","res/shaders/dummy.v")
_.technicolor1 = love.graphics.newShader("res/shaders/technicolor1.frag","res/shaders/dummy.v")
_.mess = love.graphics.newShader("res/shaders/mess.frag","res/shaders/dummy.v")
_.greentint = love.graphics.newShader("res/shaders/greentint.frag","res/shaders/dummy.v")
_.edges = love.graphics.newShader("res/shaders/edges.frag","res/shaders/dummy.v")
_.waterpaint = love.graphics.newShader("res/shaders/waterpaint.frag","res/shaders/dummy.v")
_.battlefield = love.graphics.newShader("res/shaders/battlefield.frag","res/shaders/dummy.v")
--_.crt = love.graphics.newShader("res/shaders/CRT.frag","res/shaders/dummy.v")
_.pictureinpicture = love.graphics.newShader("res/shaders/pictureinpicture.frag","res/shaders/dummy.v")

return _