local LoadingScene = class("LoadingScene", cc.load("mvc").ViewBase)

LoadingScene.RESOURCE_FILENAME = "Layer/Loading.csb"

local LOADING_DT = 1

local musicTbl = { 
	"sfx/main.mp3",
	"sfx/mainMenu.mp3",
	"sfx/result.mp3",
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
	self.title_ = root:getChildByName("Loading") 

	self.time_ = 0
	self.needAds_ = false

	local bg = __G__createBg( "Layer/BackGround.csb" )
	bg:setSpeed(-5)
	self:add(bg, -1)

	local touchLayer = display.newLayer()
	touchLayer:onTouch(function ( event )
		Helper.showClickParticle(touchLayer, cc.p(event.x, event.y))
	end)
	self:add(touchLayer)
	--展示tips
	self:showTips()
end

function LoadingScene:showTips(  )
	math.randomseed(os.time())
	local tipsTbl = gameio.getVectorPlistFromFile("gameTips.plist")

	local str = tipsTbl[math.random(1,#tipsTbl)]
	local tips = display.newTTF("Pixel.ttf", 72, str)
	tips:setOpacity(0)
	tips:setScale(0.5)
	tips:pos(display.cx, display.cy * 1.5)
	local act = cc.Spawn:create( cc.ScaleTo:create(1.2, 1), cc.FadeIn:create(2) )
	tips:runAction(act)
	self:addChild(tips, 100)
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
	self:onUpdate(handler(self, self.update))
end

function LoadingScene:update(dt)
	self.time_ = self.time_ + dt

	if self.time_ >=  3*LOADING_DT then 
		self.title_:setString("Loading...")
		self.time_ = 0
		self:unUpdate()
		local callback = function()
			__G__actDelay(self, function (  )
				self:getApp():enterScene(self.sceneName_)
			end, 1.0)
			SDKManager:getInstance():setFULLADCallback( nil)
		end

		if self.needAds_ and SDKManager:getInstance():isFULLADAvailable() then
			SDKManager:getInstance():setFULLADCallback( callback)
			SDKManager:getInstance():showFULLAD()
		else
			callback()
		end
	elseif self.time_ >= 2* LOADING_DT then 
		self.title_:setString("Loading..")
		--加载资源
		display.loadSpriteFrames("Plane.plist", "Plane.png")
	elseif self.time_ >= LOADING_DT then
		self.title_:setString("Loading.")

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