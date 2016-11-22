local BasePlane = require "app/Obj/BasePlane"
local ArmyPlane = class("ArmyPlane", BasePlane)

--角色id
local GREY_PLANE = 1
local RED_PLABNE = 2

local MOVE_TIME = 0.2

local AI_HEIGHT = display.height * 2 /3

function ArmyPlane:ctor(  )
	self.super.ctor(self)
	self:flipY(true)

	self.id_ = GREY_PLANE -- id默认1
	self.isHurtRole_ = false

	self.moveTime_ = MOVE_TIME

	--是否被超越
	self.hasBeyound_ = false

	--是否到达屏幕一半以下
	self.hasUnderHalfDisplayHeight_ = false

	--设置游戏AI,--默认0不作为
	self.gameAiId_ = 0
end

function ArmyPlane:onCollision( other )
	self.isHurtRole_ = true
end

function ArmyPlane:onCollisionBullet(other)
	self:onHurt(1)
	self:playDeadAnimation("PlaneExplose%02d.png")
end

function ArmyPlane:playDeadAnimation(fileFormat_)
	local ani = display.getAnimationCache("PlaneDeadAnimation")
	if not ani then 
		local frames = display.newFrames( fileFormat_, 1, 4, false )
		ani = display.newAnimation(frames, 0.2)
		display.setAnimationCache( "PlaneDeadAnimation", ani )
	end

	local originVol = DEFAULT_SOUND_VOL
	local act = cc.Sequence:create( cc.CallFunc:create( function ( target )
		--播放前调整一下音效声音大小
		audio.setSoundsVolume( originVol - 0.2)
		local view = self:getParent():getParent()
		if view and view.onArmyDead then 
			view:onArmyDead(target)
		end
	end ),cc.Animate:create( ani ), cc.CallFunc:create( function ( target )
		audio.setSoundsVolume(originVol)
	end ), cc.RemoveSelf:create(true))
	self:runAction(act)
end

function ArmyPlane:setGameAi( typeId_ )
	self.gameAiId_ = typeId_
end

function ArmyPlane:onLeft(x)
	if self.dir_.x == -1 then return end
	__G__actDelay(self, function (  )
		self.isMoved_ = false
	end, self.moveTime_)
	self:moveTo({ x = display.cx - x, time = self.moveTime_ })
	self.dir_.x = -1
end

function ArmyPlane:onRight(x)
	if self.dir_.x == 1 then return end
	self:moveTo({ x = display.cx + x, time = self.moveTime_ })
	__G__actDelay(self, function (  )
		self.isMoved_ = false
	end, self.moveTime_)
	self.dir_.x = 1
end

function ArmyPlane:onHalfDisplayHeight()

end

function ArmyPlane:aiMove( aiId )
	--人物死亡时候没有Ai
	if self:isDead() then return end
	if aiId == 1 then
		if self:getPositionY() <= AI_HEIGHT and (self.hasUnderHalfDisplayHeight_ == false) then 
			if self.dir_.x == 1 then 
				self:onLeft(self:getViewRect().width * 0.6)
			elseif self.dir_.x == -1 then 
				self:onRight(self:getViewRect().width * 0.6)
			end
		end

		if self:getPositionY() <= AI_HEIGHT then 
			self.hasUnderHalfDisplayHeight_ = true
		end
	end
end

function ArmyPlane:step(dt)
	ArmyPlane.super.step(self,dt)

	self:aiMove(self.gameAiId_)
	
end

return ArmyPlane