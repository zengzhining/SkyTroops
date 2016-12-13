PlaneFactory = class("PlaneFactory")
local HeroPlane = require("app/Obj/HeroPlane")
local ArmyPlane = require("app/Obj/ArmyPlane")
local Bullet = require("app/Obj/Bullet")

--虚拟摇杆
local VirtualJoy = require("app/Obj/VirtualJoy")

function PlaneFactory:ctor(  )
	
end

local armyHpTbl = {
	3,3,5,3,3,3

}
function PlaneFactory:createEnemy( id_ )
	id_ = 6
	local army = self:createPlane(id_)
	army:setGameAi(id_)
	army:setBulletId(3)
	army:setScore( 2 )
	army:setHp(armyHpTbl[id_])

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
	elseif id == 3 then
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
	plane:setHp(10)
	plane:updateAvatar()
	plane:setMoveTime(0.3)
	plane:setBulletFireNum(2)
	plane:setId(id_)
	plane:setBulletId(2)
	--设置子弹冷却时间
	plane:setBulletCalmTime(0.1)
	--设置发射的类型,2为两列发射
	plane:setBulletFireType(2)
	plane:addGasAni()



	return plane
end

function PlaneFactory:createBullet( id_ )
	if not id_ then id_ = 1 end
	--一共9个子弹
	local str = string.format("#%02dBullets.png", id_)

	local bullet =Bullet.new(str)
	return bullet
end

function PlaneFactory:createEmenyBullet( id_ )
	if not id_ then id_ = 1 end
	local bullet = self:createBullet(id_)
	bullet:setRotation(180)

	return bullet
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
