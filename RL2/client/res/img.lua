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

Img.get=function(id)
	local result=Img[id]
	
	if result==nil then
		result=i(baseDir.."/"..id)
		Img[id]=result
	end
	
	if result==nil then
		log("error: no img by id:"..id)
	end
	
	return result
end



loadImg()


return Img