local LoadingScene = class("LoadingScene", cc.load("mvc").ViewBase)

LoadingScene.RESOURCE_FILENAME = "Layer/Loading.csb"

local LOADING_DT = 0.1

local musicTbl = { 
	"sfx/main.mp3",
	"sfx/mainMenu.mp3",
	"sfx/result.mp3",
	"sfx/level01.mp3",
	"sfx/level02.mp3",
	"sfx/level03.mp3",
	"sfx/level04.mp3",
	"sfx/level05.mp3",

 }

local fxTbl = {
	"sfx/sound/cancel.wav",
	"sfx/sound/click.wav",
	"sfx/sound/explosion.wav",
	"sfx/sound/fire.wav",
}

local index = 1
local flag = 1

function LoadingScene:onCreate(  )
	local root = self:getResourceNode()
	self.time_ = 0
	self.needAds_ = false


	local touchLayer = display.newLayer()
	touchLayer:onTouch(function ( event )
		Helper.showClickParticle(touchLayer, cc.p(event.x, event.y))
	end)
	self:add(touchLayer)
end

function LoadingScene:setNeedAds( needAds_ )
	self.needAds_ = needAds_
end

function LoadingScene:setNextScene( sceneName )
	self.sceneName_ = sceneName
end

function LoadingScene:onEnter()
	self:unUpdate()
	audio.stopMusic(false)
	self:onUpdate(handler(self, self.step))
end

function LoadingScene:step(dt)
	self.time_ = self.time_ + dt
	if self.time_ >=  3*LOADING_DT then 
		self.time_ = 0
		self:unUpdate()
		local callback = function()
			__G__actDelay(self, function (  )
				self:getApp():enterScene(self.sceneName_)
			end, 1.0)
		end

		
		callback()
	elseif self.time_ >= 2* LOADING_DT then 
		--加载资源
		__G__LoadRes()
	elseif self.time_ >= LOADING_DT then
		if flag == 1 then
			if index <= #musicTbl then 
				local music = musicTbl[index]
				audio.preloadMusic(music)
				index = index + 1
			else
				index = 1
				flag = 2
			end
		end

		if flag == 2 then 
			if index <= #fxTbl then 
				local sound = fxTbl[index]
				audio.preloadSound(sound)
				index = index + 1
			else
				index = 1
				flag = 3
			end
		end

	end
end

function LoadingScene:onExit()
	self:unUpdate()
end

return LoadingScene