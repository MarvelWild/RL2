local _={}



local musicSource=nil

local currentIndex=1

_.startMusic=function()
	if not C.isMusicEnabled then return end
	local basePath="res/music/"
	local musicItems=love.filesystem.getDirectoryItems(basePath)
	local track = musicItems[currentIndex]
	if track==nil then
		currentIndex=1
		track = musicItems[currentIndex]
	end
	
--	local random=Lume.randomchoice(musicItems)
	musicSource=love.audio.newSource(basePath..track, "stream")
	log("audio track:"..track)
	love.audio.play(musicSource)
	
	currentIndex=currentIndex+1
end

_.toggleMusic=function()
	if musicSource==nil then
		C.isMusicEnabled=true
		_.startMusic()
		return 
	end
	
	if musicSource:isPlaying() then
		musicSource:stop()
		C.isMusicEnabled=false
	else
		musicSource:play()
		C.isMusicEnabled=true
	end
	
end

_.nextTrack=function()
	musicSource:stop()
end



local update=function()
--	log("music upd")
-- opt: slow updates channel
	if C.isMusicEnabled and not musicSource:isPlaying() then
		log("audio:new track")
		-- todo: prevent same track
		_.startMusic()
	end
end

local activate=function()
	table.insert(S.updateListeners, update)
end

activate()

return _