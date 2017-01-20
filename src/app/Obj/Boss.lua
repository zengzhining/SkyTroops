local ArmyPlane = require "app/Obj/BasePlane"
local BossPlane = class("BossPlane", ArmyPlane)

function BossPlane:ctor()
	self.super.ctor(self)
	
end

return BossPlane
