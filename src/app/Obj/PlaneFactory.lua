PlaneFactory = class("PlaneFactory")
local HeroPlane = require("app/Obj/HeroPlane")
local ArmyPlane = require("app/Obj/ArmyPlane")
local Bullet = require("app/Obj/Bullet")
local Item = require("app/Obj/Item")

--虚拟摇杆
local VirtualJoy = require("app/Obj/VirtualJoy")

function PlaneFactory:ctor(  )
	
end

function PlaneFactory:createEnemy( id_ )
	--最高到11
	local army = self:createPlane(id_)
	army:setGameAi(ENEMY_AI_TBL[id_])
	army:setAiTimeLimit(ENEMY_AI_TIME_TBL[id_])
	army:setBulletId(ENEMY_BULLET_TBL[id_])
	army:setScore( ENEMY_SCORE_TBL[id_] )
	army:setMaxHp(ENEMY_HP_TBL[id_])
	army:setHp(ENEMY_HP_TBL[id_])
	army:setFloat(ENEMY_FLOAT_TBL[id_])
	if not DESIGN then
		army:setSpeed(cc.p(0,-3))
	end

	function army:onInScreen()
		army:setSpeed(ENEMY_SPEED_TBL[id_])
	end
	return army
end

function PlaneFactory:createPlane( id_ )
	local str = string.format("#Enemy%02d.png", id_)
	local plane = ArmyPlane.new(str)
	plane:setId(id_)
	return plane
	
end

function PlaneFactory:createRole( id_ )
	
	local plane = nil
	local pattern = nil
	if id_ == 1 then 
		plane = HeroPlane.new("#PlaneBlue1.png")
		pattern = "#PlaneBlue%d.png"
	elseif id_ == 2 then 
		plane = HeroPlane.new("#PlaneGreen1.png")
		pattern = "#PlaneGreen%d.png"
	elseif id_ == 3 then
		plane = HeroPlane.new("#PlaneGrey1.png")
		pattern = "#PlaneGrey%d.png"
	elseif id_ == 4 then
		plane = HeroPlane.new("#PlaneOrage1_01.png")
		pattern = "PlaneOrage%d_%%02d.png"
	elseif id_ == 5 then 
		plane = HeroPlane.new("#PlaneYellow1_01.png")
		pattern = "PlaneYellow%d_%%02d.png"
	elseif id_ == 6 then
		plane = HeroPlane.new("#PlanePink1_01.png")
		pattern = "PlanePink%d_%%02d.png"
	end
	if id_ >= 4 and id_ <= 6 then
		plane:setAnimationFormat(pattern)
	else
		plane:setFileFormat(pattern)
	end

	local config = PLANE_CONFIG[id_]
	plane:setId(id_)
	plane:setHp(config.maxHp_)
	plane:setMaxHp(config.maxHp_)
	--设置子弹的id
	plane:setBulletId(config.bulletId_)
	--设置子弹发射的类型
	--设置发射的类型,2为两列发射
	plane:setBulletFireType(config.bulletType_)
	--设置子弹冷却时间
	plane:setBulletCalmTime(config.bulletCalmTime_)
	plane:updateAvatar()
	plane:addGasAni()

	return plane
end

function PlaneFactory:createBullet( id_ )
	if not id_ then id_ = 1 end
	--一共9个子弹
	local str = string.format("#%02dBullets.png", id_)

	local bullet =Bullet.new(str)

	bullet:setDamge(BULLET_DAMAGE_TBL[id_])

	return bullet
end

function PlaneFactory:createEmenyBullet( id_ )
	if not id_ then id_ = 1 end
	local bullet = self:createBullet(id_)
	bullet:setRotation(180)

	return bullet
end

function PlaneFactory:createItem( id_ )
	if not id_ then id_ = 1 end
	--1为星星
	local item = nil
	if id_ == 1 then
		item = Item.new("#chick.png")
	elseif id_ == 2 then 
		item = Item.new("#HealthBoxSprite01.png")
		item:playAnimation("HealthBoxSprite%02d.png",1,2,-1, 0.5)
		item:setRecoverHp(2)
	elseif id_ == 3 then 
		item = Item.new("#bombboxsprite01.png")
		item:playAnimation("bombboxsprite%02d.png",1,2,-1, 0.5)
		item:setBombNum(1)
	end

	item:setId(id_)
	return item
end

function PlaneFactory:createJoy( bgFile, joyFile )
	local joy = VirtualJoy.new(bgFile, joyFile)
	return joy
end

--单例
local plane_factory_instance = nil
function PlaneFactory:getInstance()
	if not plane_factory_instance then 
		plane_factory_instance = PlaneFactory.new()
	end

	PlaneFactory.new = function (  )
		error("PlaneFactory Cannot use new operater,Please use geiInstance")
	end

	return plane_factory_instance
end
