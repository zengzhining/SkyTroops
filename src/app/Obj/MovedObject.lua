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
	self.speed_= cc.p( 0, 5 )
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

function MovedObject:playAnimation( formatFile )
	local name = string.format(formatFile,1)
	local ani = display.getAnimationCache(name)
	if not ani then 
		local frames = display.newFrames( formatFile, 1, 3, true )
		ani = display.newAnimation(frames, 0.15)
		display.setAnimationCache( name, ani )
	end

	local act = cc.Sequence:create(cc.Animate:create( ani ), cc.CallFunc:create(function(target)
			-- target:debugDraw()
			end) )
			
	self:runAction(act)
end

return MovedObject