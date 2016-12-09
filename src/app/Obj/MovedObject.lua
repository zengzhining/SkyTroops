local MovedObject = class("MovedObject", function ( fileName )
	return display.newSprite( fileName )
end)

function MovedObject:ctor( fileName )
	self:enableNodeEvents()
	self:initData()
	self:debugDraw()

	self.originFileName_ = fileName
end

function MovedObject:debugDraw()
	if CC_DEBUG_RECT then 
		local draw = display.newDrawNode()
		self:addChild(draw, 999)
		--draw a rectangle
		local rect = self:getCollisionRect()
		local viewRect = self:getViewRect()
        draw:drawRect(cc.p( (viewRect.width - rect.width) * 0.5 , (viewRect.height - rect.height) * 0.5 ), cc.p(rect.width + (viewRect.width - rect.width) * 0.5,rect.height +  (viewRect.width - rect.width) * 0.5), cc.c4f(1,1,0,1))
        -- draw:drawRect(cc.p( 0 , viewRect.height), cc.p(rect.width ,rect.height), cc.c4f(1,1,0,1))
	end
end

function MovedObject:initData()
	self.speed_= cc.p( 0, 0 )
	self.aniFormat_ = nil
end

function MovedObject:setSpeed(speed)
	self.speed_ = speed
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
	local finalWidth  = rect.width * 0.5
	local finalHeight = rect.height 
	local newRect = cc.rect( rect.x, rect.y, finalWidth, finalWidth )
	return newRect
end

function MovedObject:getViewRect(  )
	return self:getBoundingBox()
end

--碰撞检测回调
function MovedObject:onCollision( other )
	self:hide()
end

function MovedObject:onEnter()
	self:onUpdate(handler(self, self.step))
end

function MovedObject:onExit()
	self:unUpdate()
end

function MovedObject:setAnimationFormat(formatFile)
	self.aniFormat_ = formatFile
end

function MovedObject:restoreOriginSprite()
	local frame = display.newSpriteFrame(self.originFileName_)
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

function MovedObject:playAnimation( formatFile , fromIdx, length, repeatTime )
	if not repeatTime then repeatTime = 1 end 
	local name = string.format(formatFile,1)
	local ani = display.getAnimationCache(name)
	if not ani then 
		local frames = display.newFrames( formatFile, fromIdx, length, true )
		ani = display.newAnimation(frames, 0.15)
		display.setAnimationCache( name, ani )
	end

	local act = nil

	if repeatTime >= 1 then 
		act =  cc.Repeat:create(cc.Animate:create( ani ), repeatTime) 
	else
		act = cc.RepeatForever:create(cc.Animate:create( ani ))
	end
				
	self:runAction(act)
end

return MovedObject