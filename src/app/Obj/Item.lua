local MovedObject = require("app/Obj/MovedObject")
local Item = class("Item", MovedObject)

function Item:ctor()
	self.super.ctor(self)

	self.id_ = 0
end

function Item:setId(id_)
	self.id_ = id_
end

function Item:getId()
	return self.id_
end

function Item:onGot()
	-- self:removeSelf()
	self:hide()
end

return Item