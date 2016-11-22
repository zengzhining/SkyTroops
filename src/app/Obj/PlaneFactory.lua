PlaneFactory = class("PlaneFactory")
local HeroPlane = require("app/Obj/HeroPlane")
local ArmyPlane = require("app/Obj/ArmyPlane")
local Bullet = require("app/Obj/Bullet")

function PlaneFactory:ctor(  )
	
end

function PlaneFactory:createPlane( id_ )
	local plane = nil
	if id_ == 1 then 
		plane = ArmyPlane.new("#RedPlane.png")	
	elseif id_ == 2 then
		plane = ArmyPlane.new("#GreyPlane.png")
		plane:setGameAi(1)
	end
	plane:setId(id_)
	plane:setScore( 2 )
	return plane
end

function PlaneFactory:createRole( id_ )
	local plane = nil
	if id_ == 1 then 
		plane = HeroPlane.new("#FriendPlane01.png")
		plane:setMoveTime(0.3)
		plane:setBulletFireNum(2)
	elseif id_ == 2 then 
		plane = HeroPlane.new("#GreenPlane.png")
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
		bullet = Bullet.new("#BlueBullet03.png")
		bullet:setAnimationFormat("BlueBullet%02d.png")
	elseif id_ == 2 then 
		bullet = Bullet.new("#RedBullet03.png")
		bullet:setAnimationFormat("RedBullet%02d.png")
	end
	return bullet

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
