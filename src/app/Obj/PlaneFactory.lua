PlaneFactory = class("PlaneFactory")
local HeroPlane = require("app/Obj/HeroPlane")
local ArmyPlane = require("app/Obj/ArmyPlane")
local Bullet = require("app/Obj/Bullet")

--虚拟摇杆
local VirtualJoy = require("app/Obj/VirtualJoy")

function PlaneFactory:ctor(  )
	
end

function PlaneFactory:createEnemy( id_ )
	id_ = 3
	local army = self:createPlane(id_)

	army:setGameAi(id_)
	army:setScore( 2 )

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
	plane:updateAvatar()
	plane:setMoveTime(0.3)
	plane:setBulletFireNum(2)
	plane:setId(id_)
	plane:setBulletId(id_)
	--设置子弹冷却时间
	plane:setBulletCalmTime(0.04)
	plane:addGasAni()

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
