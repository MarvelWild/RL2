local Img={}

local i=LG.newImage

local loadImg=function()
	local baseDir="res/img"
	
	local imageItems=love.filesystem.getDirectoryItems(baseDir)
	for k,item in ipairs(imageItems) do
		if Allen.endsWith(item, ".png") then
			local name=Allen.strLeftBack(item, ".png")
			Img[name]=i(baseDir.."/"..item)
		end
		
	end
	
	
	
end


loadImg()


return Img