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

	--是否被超越
	self.hasBeyound_ = false

	self.aiStrategy_ = nil
end

function ArmyPlane:onCollision( other )
	self.isHurtRole_ = true
end

function ArmyPlane:onCollisionBullet(bullet)
	local damge = bullet:getDamge()
	local role = GameData:getInstance():getRole()
	if not role:isDead() then 
		damge = bullet:getDamge() * role:getLevel()
	end
	self:onHurt(damge)
	if self:isDead() then
		self:playDeadAnimation("PlaneExplose%02d.png")
	else
		-- local act = cc.Sequence:create(cc.FadeOut:create(0.1), cc.FadeIn:create(0.1))
		local act = cc.Sequence:create(cc.TintTo:create( 0.1,255,0,0 ),cc.TintTo:create( 0.1,255,255,255 ) )
		self:runAction(act)

	end
end

function ArmyPlane:onCollisionBomb()
	self:onHurt(999)
	if self:isDead() then
		self:playDeadAnimation("PlaneExplose%02d.png")
	end
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
	end ), cc.Hide:create())
	self:runAction(act)
end

function ArmyPlane:setGameAi( typeId_ )
	self.aiStrategy_ = Strategy.new(typeId_)
end

function ArmyPlane:getAiId()
	if self.aiStrategy_ then 
		return self.aiStrategy_:getAiId()
	end

	return 0
end

function ArmyPlane:setAiTimeLimit(time)
	if self.aiStrategy_ then
		self.aiStrategy_:setAiTimeLimit(time)
	end
end

function ArmyPlane:onHalfDisplayHeight()

end

--发射子弹
function ArmyPlane:fireBullet()
	--如果死掉时候不能发射子弹
	if self:isDead() then return end
	local scene = self:getParent():getParent()
	if scene and scene.onEnemyFire then 
		local target = self
		scene:onEnemyFire( target, self:getBulletId())
	end
end

--发射物品
function ArmyPlane:fireItem( id_ )
	local scene = self:getParent():getParent()
	if scene and scene.onEnemyFire then 
		local target = self
		scene:onEnemyFire( target, self:getBulletId())
	end
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
		--突然加速
		if self:getPositionY() <= AI_HEIGHT and (not strategy:hasUseAi() ) then
			self:addSpeed(cc.p(0, -5))
			strategy:useAi()
		end
	elseif aiId == 3 then 
		--转向主角
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
			strategy:useAi()
		end
	elseif aiId == 4 then
		--看见主角才发射
		if strategy:canAi() then
			strategy:resetAiTime()
			local role = GameData:getInstance():getRole()
			local posx, posy = self:getPosition()
			local rolePosX, rolePosY = role:getPosition()
			if math.abs(rolePosX - posx) <= strategy:getAiWidth() then
				self:fireBullet()
			end
		end
		strategy:addAiTime(dt)
	elseif aiId == 5 then 
		--发射散弹
		if strategy:canAi() then
			strategy:resetAiTime()
			self:fireBullet()
		end
		strategy:addAiTime(dt)
	elseif aiId == 8 then 
		--会根据主角位置移动，如果主角到攻击范围局攻击
		if strategy:canAi() then
			strategy:resetAiTime()
			local role = GameData:getInstance():getRole()
			local posx, posy = self:getPosition()
			local rolePosX, rolePosY = role:getPosition()
			local dir = posx > rolePosX and -1 or 1
			local speedX = dir * 5
			self:setSpeedX(speedX)

			if math.abs(rolePosX - posx) <= strategy:getAiWidth() and (posy > rolePosY )then
				self:fireBullet()
			end
		end
		strategy:addAiTime(dt)
	elseif aiId == 9 then
		--发射两列子弹,看见主角才发射
		if strategy:canAi() then
			strategy:resetAiTime()
			local role = GameData:getInstance():getRole()
			local posx, posy = self:getPosition()
			local rolePosX, rolePosY = role:getPosition()
			if math.abs(rolePosX - posx) <= strategy:getAiWidth() then
				self:fireBullet()
			end
		end
		strategy:addAiTime(dt)
	elseif aiId == 10 then 
		
	end
end

function ArmyPlane:step(dt)
	ArmyPlane.super.step(self,dt)
	if DESIGN then return end

	self:aiMove(dt)
	
end

return ArmyPlane