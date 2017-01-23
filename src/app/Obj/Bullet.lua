local MovedObject = require("app/Obj/MovedObject")
local Bullet = class(Bullet, MovedObject)

local BULLET_FLY_FACTOR = 100
function Bullet:ctor()
	self.super.ctor(self)

	self.damge_ = 1
end

function Bullet:setDamge( damge )
	self.damge_ = damge
end

function Bullet:getDamge()
	return self.damge_
end

--发射时候的回调函数
function Bullet:onFire()
	if self.aniFormat_ then
		--发射子弹时候播放音效
		__G__FireBullet()
		self:playAnimation(self.aniFormat_)
	end
end

function Bullet:getCollisionRect()
	local rect = self:getBoundingBox()
	local finalWidth  = rect.width* 0.3
	local finalHeight = rect.height * 0.5
	local newRect = cc.rect( rect.x  , rect.y, finalWidth, finalHeight )
	return newRect
end

function Bullet:onCollision(army)
	local act = cc.RemoveSelf:create(true)
	self:runAction(act)
end

function Bullet:step(dt)
	local gameSpeed = GameData:getInstance():getGameSpeed()
	local speedY = self.speed_.y * gameSpeed
	self:posByY(speedY)
	self:posByX(self.speed_.x * gameSpeed)
end



return Bullet