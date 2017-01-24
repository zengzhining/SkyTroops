
--全局函数

__G__createCutLayer = function ( fileName )
	local layer = display.newLayer(cc.c4b(0, 0, 0, 255*0.8))

	local node = display.newCSNode(fileName)
	layer:addChild(node)

	local resume = node:getChildByName("Close")
	resume:onClick(function (  )
		local scene = layer:getParent()
		if scene and scene.onResume then 
			scene:onResume()
				
		end		
	end)

	local restart = node:getChildByName("Restart")
	restart:onClick(function (  )
		local scene = layer:getParent()
		if scene and scene.onRestart then 
			scene:onRestart()
		end		
	end)

	local exit = node:getChildByName("Menu")
	exit:onClick(function (  )
		local scene = layer:getParent()
		if scene and scene.onMenu then 
			scene:onMenu()
		end		
	end)

	return layer
end

__G__createLevelTitleLayer = function ( str )
	local layer = display.newLayer()

	local title = display.newTTF(nil, 48, str)
	title:pos(display.cx, display.cy*1.5)
	layer:add(title,0, 213)
	return layer
end

__G__createOverLayer = function ( fileName )
	local layer = display.newLayer(cc.c4b(255, 255, 255, 0))

	local node = display.newCSNode(fileName)
	layer:addChild(node)

	local Retry = node:getChildByName("Retry")
	Retry:onTouch(function ( event )
		if event.name == "ended" then
			local scene = layer:getParent()
			if scene and scene.onRetry then 
				scene:onRetry()
			end		
		end
	end, false, true)

	local exit = node:getChildByName("Exit")
	exit:onTouch(function ( event )
		if event.name == "ended" then
			local scene = layer:getParent()
			if scene and scene.onGameExit then 
				scene:onGameExit()
			end		
		end
	end,  false, true)


	return layer
end

__G__createBg = function (fileName)
	local layer = display.newLayer()
	local node = display.newCSNode(fileName)
	layer.speed_ = -2

	layer:enableNodeEvents()
	
	layer:addChild(node)

	function layer:onEnter()
		layer:unUpdate()
		layer:onUpdate(handler(layer, layer.update))
	end

	function layer:setSpeed(speed)
		self.speed_ = speed
	end

	function layer:update(dt)
		local gameSpeed = GameData:getInstance():getGameSpeed()
		local tbl ={ "Bg", "BgUp" }
		for c, key in pairs (tbl) do
			local bg = node:getChildByName(key)
			if bg:getPositionY() <= 0 then
				bg:posY(display.height * 2)
			end
			bg:posByY(self.speed_ * gameSpeed)
		end
	end

	return layer
end

__G__createPngBg = function ( fileName )
	local TAG_UP = 101
	local TAG_DOWN = 102

	local layer = display.newLayer()
	layer:enableNodeEvents()
	
	layer.speed_ = 0

	function layer:onEnter()
		layer:unUpdate()
		layer:onUpdate(handler(layer, layer.update))
	end

	function layer:setSpeed(speed)
		self.speed_ = speed
	end

	local bg = display.newSprite(fileName)
	bg:setAnchorPoint(cc.p(0.5,1))
	bg:setScale(display.width/bg:getContentSize().width)
	bg:pos(display.cx, bg:getBoundingBox().height)
	layer:add(bg,0, TAG_UP)

	function bg:fadeIn( time )
		self:runAction(cc.FadeIn:create(time))
	end

	function bg:fadeOut(time)
		self:runAction(cc.FadeOut:create(time))
	end

	local downBg = display.newSprite(fileName)
	downBg:setAnchorPoint(cc.p(0.5,1))
	downBg:pos(display.cx, 2 * bg:getBoundingBox().height)
	downBg:setScale(display.width/downBg:getContentSize().width)
	layer:add(downBg,0, TAG_DOWN)

	function downBg:fadeIn( time )
		self:runAction(cc.FadeIn:create(time))
	end

	function downBg:fadeOut(time)
		self:runAction(cc.FadeOut:create(time))
	end


	function layer:update(dt)
		local upBg = self:getChildByTag(TAG_UP)
		local downBg = self:getChildByTag(TAG_DOWN)
		local tbl = { upBg, downBg }
		for c, bg in pairs( tbl ) do
			local nextBg = bg:getTag() == TAG_UP and downBg or upBg
			if bg:getPositionY() <= 0 then
				bg:posY(bg:getBoundingBox().height + nextBg:getPositionY())
			end
			bg:posByY(self.speed_)
		end
	end

	function layer:change( fileName )
		local upBg = self:getChildByTag(TAG_UP)
		local downBg = self:getChildByTag(TAG_DOWN)
		upBg:setSprite(fileName)
		downBg:setSprite(fileName)
	end

	function layer:fadeIn( time )
		local upBg = self:getChildByTag(TAG_UP)
		local downBg = self:getChildByTag(TAG_DOWN)
		upBg:fadeIn(time)
		downBg:fadeIn(time)
	end

	function layer:fadeOut( time )
		local upBg = self:getChildByTag(TAG_UP)
		local downBg = self:getChildByTag(TAG_DOWN)
		upBg:fadeOut(time)
		downBg:fadeOut(time)
	end

	function layer:opacity(num)	
		-- body
		local upBg = self:getChildByTag(TAG_UP)
		local downBg = self:getChildByTag(TAG_DOWN)
		upBg:setOpacity(num)
		downBg:setOpacity(num)
	end

	return layer
end

--死亡之后弹窗是否继续
__G__createContinueLayer = function ( fileName )
	local layer = display.newLayer(cc.c4b(255, 255, 255, 0))
	local node = display.newCSNode(fileName)
	-- node:pos(0, display.cy * 0.5)
	layer:addChild(node)

	local Sure = node:getChildByName("Continue")
	Sure:onClick(function (  )
		__G__MenuCancelSound()
		local scene = layer:getParent()
		if scene and scene.onContinue then 
			scene:onContinue()
		end
		layer:removeSelf()		
	end)

	local Cancel = node:getChildByName("Close")
	Cancel:onClick(function ( )
		__G__MenuCancelSound()
		local scene = layer:getParent()
		if scene and scene.onContinueCancel then 
			scene:onContinueCancel()
		end	
		layer:removeSelf()	
	end)

	local exit = node:getChildByName("Menu")
	exit:onClick(function (  )
		__G__MenuCancelSound()
		local scene = layer:getParent()
		if scene and scene.onMenu then 
			scene:onMenu()
		end		
	end)

	local Time = node:getChildByName("Time")
	local time = 15
	local allTime = 0
	layer:onUpdate(function ( dt )
		allTime = allTime + dt
		if allTime >= 1 then
			allTime = 0
			time = time - 1
		end

		Time:setString(time)

		if time <= 0 then 
			layer:unUpdate()
			local scene = layer:getParent()
			if scene and scene.onContinueCancel then 
				scene:onContinueCancel()
			end	
		end
	end)


	return layer
end

--解锁的弹窗
__G__createUnLockLayer = function(fileName)
	local layer = display.newLayer(cc.c4b(0, 0, 0, 0.9*255))
	local node = display.newCSNode(fileName)
	layer:add(node)

	local closeBtn = node:getChildByName("Close")
	closeBtn:onClick(function (  )
		__G__MenuCancelSound()
		local scene = layer:getParent()
		if scene and scene.onUnlockClose then
			scene:onUnlockClose()
		end
		layer:removeSelf()
	end)
	return layer
end

--延时执行动作
__G__actDelay = function (target, callback, time)
	local act = cc.Sequence:create( cc.DelayTime:create(time), cc.CallFunc:create(function ( obj )
		callback(obj)
	end)) 
	target:runAction(act)
end

--背景音乐淡出
__G__MusicFadeOut = function(target, time)
	local time_ = 0
	local originVol = audio.getMusicVolume()
	local dVol = originVol / time
	target:onUpdate( function ( dt )
		time_ = time_ + dt
		audio.setMusicVolume(originVol-(dVol* time_))

		if time_ > time then 
			target:unUpdate()				
			audio.setMusicVolume(originVol)
		end
	end )
end

--菜单点击音效播放
__G__MenuClickSound = function (  )
	audio.playSound("sfx/sound/click.wav", false)
end

--菜单点击取消的音效
__G__MenuCancelSound = function (  )
	audio.playSound("sfx/sound/cancel.wav", false)
end

--爆炸音效
__G__ExplosionSound = function (  )
	audio.playSound("sfx/sound/explosion.wav", false)
end

--发射子弹音效
__G__FireBullet = function(  )
	audio.playSound("sfx/sound/fire.wav", false)
end

--背景音乐播放，1为菜单，2为游戏场景，3为结算场景
__G__MainMusic = function( id )
	if not id then id = 1 end
	audio.stopMusic()
	local fileName = "sfx/mainMenu.mp3"
	if id == 2 then
		fileName = "sfx/main.mp3"
	elseif id == 3 then
		fileName = "sfx/result.mp3"
	end
	audio.playMusic(fileName)
end

__G__GameBgm = function ( world,level )
	local isBoss = false
	local index = 1

	if world >= 5 then 
		index = 3
	elseif world >= 3 then 
		index = 2
	end

	if level == 2 then
		isBoss = true
	end

	if isBoss then
		index = 4
		if world >= 3 then 
			index = 5
		end
	end

	local str = string.format("sfx/level%02d.mp3",index)
	audio.playMusic(str)
	
end

__G__LoadRes = function ()
	-- if DEBUG == 2 then 
		display.loadSpriteFrames("Planes.plist", "Planes.png")
		display.loadSpriteFrames("Planes2.plist", "Planes2.png")
		display.loadSpriteFrames("Object.plist", "Object.png")
		display.loadSpriteFrames("Animation.plist", "Animation.png")
		display.loadSpriteFrames("Animation.plist", "Animation.png")
		display.loadSpriteFrames("Animation.plist", "Animation.png")
		for i = 1, 6 do
			local str = string.format("bg/%02dBackground.png", i)
			display.loadImage(str)
		end
	-- end
end