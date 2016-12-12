PlaneFactory = class("PlaneFactory")
local HeroPlane = require("app/Obj/HeroPlane")
local ArmyPlane = require("app/Obj/ArmyPlane")
local Bullet = require("app/Obj/Bullet")

--虚拟摇杆
local VirtualJoy = require("app/Obj/VirtualJoy")

function PlaneFactory:ctor(  )
	
end

function PlaneFactory:createEnemy( id_ )
	local str = string.format("#Enemy%02d.png", id_)
	local army = ArmyPlane.new(str)
	army:setId(id_)
	return army
end

function PlaneFactory:createPlane( id_ )
	local plane = self:createEnemy(id_)
	if id_ == 1 then 
	elseif id_ == 2 then
		plane:setGameAi(1)
	end
	plane:setScore( 2 )
	return plane
end

function PlaneFactory:createRole( id_ )
	local plane = nil
	if id_ == 1 then 
		plane = HeroPlane.new("#PlaneBlue1.png")
		plane:setMoveTime(0.3)
		plane:setBulletFireNum(2)
	elseif id_ == 2 then 
		plane = HeroPlane.new("#PlaneBlue2.png")
		plane:setMoveTime(0.5)
		plane:setBulletFireNum(4)
	end
	plane:setId(id_)
	plane:setBulletId(id_)
	--设置子弹冷却时间
	plane:setBulletCalmTime(0.04)

	return plane
end

function PlaneFactory:createBullet( id_ )
	if not id_ then id_ = 1 end
	local bullet
	if id_ == 1 then
		bullet = Bullet.new("#01Bullets.png")
	elseif id_ == 2 then 
		bullet = Bullet.new("#02Bullets.png")
	end
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
