local BasePlane = require "app/Obj/BasePlane"
local Strategy = require "app/Obj/Strategy"
local ArmyPlane = class("ArmyPlane", BasePlane)

--角色id
local GREY_PLANE = 1
local RED_PLABNE = 2

local MOVE_TIME = 0.2

local AI_HEIGHT = display.height * 2 /3

function ArmyPlane:ctor(  )
	self.super.ctor(self)
	-- self:flipY(true)
	self:setRotation(180)

	self.id_ = GREY_PLANE -- id默认1
	self.isHurtRole_ = false

	self.moveTime_ = MOVE_TIME

	--是否被超越
	self.hasBeyound_ = false

	self.aiStrategy_ = nil
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
	self.aiStrategy_ = Strategy.new(typeId_)
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

function ArmyPlane:aiMove(dt)
	--人物死亡时候没有Ai
	if self:isDead() then return end

	--ai只有进入到游戏场景高度才开始运行
	local posx,posy = self:getPosition()
	if posy > display.height then return end 
	local strategy = self.aiStrategy_
	local aiId = strategy:getAiId()
	if aiId == 1 then 
		--匀速直线，默认就是
	elseif aiId == 2 then
		if self:getPositionY() <= AI_HEIGHT and (not strategy:hasUseAi() ) then
			self:addSpeed(cc.p(0, -5))
			strategy:useAi()
		end
	elseif aiId == 3 then 
		if self:getPositionY() <= AI_HEIGHT and (not strategy:hasUseAi() ) then
			local role = GameData:getInstance():getRole()
			local speed = self:getSpeed()
			local posx, posy = self:getPosition()
			local rolePosX, rolePosY = role:getPosition()
			local delPos = cc.pSub(cc.p(rolePosX, rolePosY),cc.p(posx,posy) )
			local speedX = speed.y * delPos.x/delPos.y
			--当角色比较上的时候
			if delPos.y > 0 then 
				return 
			end
			self:addSpeed(cc.p(speedX, 0))
			local angle = cc.pToAngleSelf(delPos)/math.pi * 180
			if delPos.x < 0 then 
				angle = -angle -90
			end
			self:runAction(cc.RotateBy:create(0.2, angle))
			strategy:useAi()
		end
	end
end

function ArmyPlane:step(dt)
	ArmyPlane.super.step(self,dt)

	self:aiMove(dt)
	
end

return ArmyPlane