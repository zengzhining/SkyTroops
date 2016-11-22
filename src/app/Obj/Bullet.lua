local MovedObject = require("app/Obj/MovedObject")
local Bullet = class(Bullet, MovedObject)

local BULLET_FLY_FACTOR = 100
function Bullet:ctor()
	self.super.ctor(self)

	--子弹的存活时间，一般是时间越长越快的
	self.liveTime_ = 0
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
	local finalWidth  = rect.width* 0.8
	local finalHeight = rect.height * 0.9
	local newRect = cc.rect( rect.x  , rect.y, finalWidth, finalHeight )
	return newRect
end

function Bullet:onCollision(army)
	local act = cc.Sequence:create( cc.FadeOut:create(0.1), cc.RemoveSelf:create(true) )
	self:runAction(act)
end

function Bullet:step(dt)
	self.liveTime_ = self.liveTime_ + dt
	local gameSpeed = GameData:getInstance():getGameSpeed()
	local speedY = self.speed_.y * gameSpeed + self.liveTime_ * BULLET_FLY_FACTOR
	self:posByY(speedY)
	self:posByX(self.speed_.x * gameSpeed)
end



return Bullet