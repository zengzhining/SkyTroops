local MovedObject = require("app/Obj/MovedObject")
local BasePlane = class("BasePlane", MovedObject)
local TAG_GAS = 101

function BasePlane:ctor( fileName )
	BasePlane.super.ctor(self, fileName)
end

function BasePlane:initData()
	self.dir_ = cc.p(0, 0)
	self.speed_ = cc.p(0, 0)
	self.hp_ = 1
	self.maxHp_=1
	self.score_ = 0

	self.id_ = 1
	--发射子弹的id
	self.bulletId_ = 1
	--子弹冷却时间
	self.bulletCalmTime_ = 1
	self.lastFireTime_ = 0

	--发射子弹类型，直射还是散射，默认发射一个
	self.bulletFireTypeId_ = 1

end

function BasePlane:onEnter()
	BasePlane.super.onEnter(self)
	
end

function BasePlane:resetHp()
	self.hp_ = 1
end

function BasePlane:setHp( hp )
	self.hp_ = hp
end

function BasePlane:addHp(hp)
	local finalHp = self.hp_ + hp
	self.hp_ = finalHp > self:getMaxHp() and self:getMaxHp() or finalHp
end

function BasePlane:setMaxHp(hp)
	self.maxHp_ = hp
end

function BasePlane:getMaxHp()
	return self.maxHp_
end

function BasePlane:getHp(  )
	return self.hp_
end

--角色的id
function BasePlane:setId(id_)
	self.id_ = id_
end

function BasePlane:getId()
	return self.id_
end

--设置角色方向
function BasePlane:setDirX( dir_ )
	self.dir_.x = dir_
end

------------bullet Fire Type-----------
function BasePlane:setBulletFireType(id_)
	self.bulletFireTypeId_ = id_
end

function BasePlane:getBulletFireType()
	return self.bulletFireTypeId_
end

--设置对应子弹的冷却时间
function BasePlane:setBulletCalmTime( time )
	self.bulletCalmTime_ = time
end

function BasePlane:getBulletCalmTime()
	return self.bulletCalmTime_
end

--发射子弹的冷却时间
function BasePlane:isCanFireBullet()
	local flag = false
	local time = os.clock()
	if time - self:getLastFireTime() >= self:getBulletCalmTime() then 
		flag = true
	end

	return flag
end

function BasePlane:setLastFireTime( time )
	self.lastFireTime_ = time
end

function BasePlane:getLastFireTime()
	return self.lastFireTime_
end

function BasePlane:fireBullet()
end

--碰撞检测所用矩形
function BasePlane:getCollisionRect(  )
	local rect = self:getBoundingBox()
	local finalWidth  = rect.width * 0.5 
	local finalHeight = rect.height * 0.5
	-- local pos = cc.p( rect.x+ rect.width*0.5-finalWidth*0.5, rect.y+rect.height*0.5-finalHeight*0.5 ) 
	local pos = cc.p(rect.x + rect.width*0.5-finalWidth*0.5,rect.y + rect.height-finalHeight*0.5)
	local newRect = cc.rect( pos.x, pos.y, finalWidth, finalHeight )
	return newRect
end

function BasePlane:onCollisionBullet(other)
	self:hide()
end

--受伤回调
function BasePlane:onHurt( hp_ )
	self.hp_ = self.hp_ - hp_
end

function BasePlane:isDead(  )
	return self.hp_ <= 0
end

--左右的控制
function BasePlane:onLeft( x )

end

function BasePlane:onRight( x )
	
end

--获得的分数
function BasePlane:getScore(  )
	return self.score_
end

function BasePlane:setScore( score )
	self.score_ = score
end

function BasePlane:setBulletId( id_ )
	self.bulletId_ = id_
end

function BasePlane:getBulletId()
	return self.bulletId_
end

--死亡动画
function BasePlane:playDeadAnimation( formatFile_  )
	
end

--尾气的动画
function BasePlane:addGasAni()
	local rect = self:getViewRect()
	self:addAnimation("PlaneCloudGas%02d.png",1,4, -1, { pos_ = cc.p( rect.width*0.5, rect.height * 0.3 ),z_ = 0, tag_ = TAG_GAS})
end

function BasePlane:hideGas()
	local gas = self:getChildByTag(TAG_GAS)
	if gas then 
		gas:hide()
	end
end

return BasePlane