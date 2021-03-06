local MovedObject = class("MovedObject", function ( fileName )
	return display.newSprite( fileName )
end)

function MovedObject:ctor( fileName )
	self:enableNodeEvents()
	self:initData()

	self.originFileName_ = fileName
end

function MovedObject:debugDraw()
	if CC_DEBUG_RECT then 
		local draw = display.newDrawNode()
		self:addChild(draw, 999)
		--draw a rectangle
		local rect = self:getCollisionRect()
		local viewRect = self:getViewRect()
        draw:drawRect(cc.p( (viewRect.width - rect.width) * 0.5 , (viewRect.height - rect.height) * 0.5 ), cc.p(rect.width + (viewRect.width - rect.width) * 0.5,rect.height +  (viewRect.height - rect.height) * 0.5), cc.c4f(1,1,0,1))
        -- draw:drawRect(cc.p( 0 , 0 ), cc.p(viewRect.width,viewRect.height), cc.c4f(1,1,0,1))
	end
end

function MovedObject:initData()
	self.speed_= cc.p( 0, 0 )
	self.aniFormat_ = nil --动画模式，用来切换等级时候显示动画的对象使用
	self.fileFormat_ = nil -- 图片模式，用来切换等级时候的图片
end

function MovedObject:setSpeed(speed)
	self.speed_ = speed
end

function MovedObject:setSpeedX(speedX)
	self.speed_.x = speedX
end

function MovedObject:setSpeedY(speedY)
	self.speed_.y = speedY
end

function MovedObject:getSpeed()
	return self.speed_
end

function MovedObject:addSpeed(speed)
	self.speed_ = cc.pAdd(self.speed_, speed)
end

function MovedObject:minSpeed( speed )
	self.speed_ = cc.pSub(self.speed_,speed)
end

--更新逻辑,每帧调用一次
function MovedObject:updateLogic( time  )
	-- body
end

function MovedObject:step(dt)
	self:updateLogic(dt)
	local gameSpeed = GameData:getInstance():getGameSpeed()
	self:posByY(self.speed_.y * gameSpeed)
	self:posByX(self.speed_.x * gameSpeed)
end

--碰撞检测所用矩形
function MovedObject:getCollisionRect(  )
	local rect = self:getBoundingBox()
	local finalWidth  = rect.width
	local finalHeight = rect.height
	-- local newRect = cc.rect( -finalWidth*0.5, -finalHeight*0.5, finalWidth, finalHeight )
	return rect
end

function MovedObject:getViewRect(  )
	return self:getBoundingBox()
end

--碰撞检测回调
function MovedObject:onCollision( other )
	self:hide()
end

function MovedObject:onEnter()
	self:debugDraw()

	self:onUpdate(handler(self, self.step))
end

function MovedObject:onExit()
	self:unUpdate()
end

function MovedObject:setFileFormat( formatFile )
	self.fileFormat_ = formatFile
end

function MovedObject:getFileFormat()
	return self.fileFormat_
end

function MovedObject:setAnimationFormat(formatFile)
	self.aniFormat_ = formatFile
end

function MovedObject:getAnimationFormat()
	return self.aniFormat_
end

function MovedObject:restoreOriginSprite()
	self:setNewSpriteFrame(self.originFileName_)
end

function MovedObject:setNewSpriteFrame(fileName)
	local frame = display.newSpriteFrame(fileName)
	self:setSpriteFrame(frame)
end

function MovedObject:addAnimation(formatFile , fromIdx, length, repeatTime, objParams)
	local obj = MovedObject.new()
	local size = self:getViewRect()

	local finalPos = cc.p(size.width*0.5, size.height*0.5)
	if objParams and objParams.pos_ then 
		finalPos = objParams.pos_
	end

	local z = 0
	if objParams and objParams.z_ then 
		z = objParams.z_
	end

	local tag = 0
	if objParams and objParams.tag_ then 
		tag = objParams.tag_
	end

	obj:pos(finalPos)
	self:add(obj,z,tag)
	obj:playAnimation(formatFile , fromIdx, length, repeatTime)
end

function MovedObject:playAnimation( formatFile , fromIdx, length, repeatTime, time )
	if not time then time = 0.15 end
	if not repeatTime then repeatTime = 1 end 
	local name = string.format(formatFile,1)
	local ani = display.getAnimationCache(name)
	if not ani then 
		local frames = display.newFrames( formatFile, fromIdx, length, true )
		ani = display.newAnimation(frames, time)
		display.setAnimationCache( name, ani )
	end

	local act = nil

	if repeatTime >= 1 then 
		act =  cc.Repeat:create(cc.Animate:create( ani ), repeatTime) 
	else
		act = cc.RepeatForever:create(cc.Animate:create( ani ))
	end

	act:setTag(213)
	self:stopActionByTag(213)	
	self:runAction(act)
end

return MovedObject