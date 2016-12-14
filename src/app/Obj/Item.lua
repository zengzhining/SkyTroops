local MovedObject = require("app/Obj/MovedObject")
local Item = class("Item", MovedObject)

function Item:ctor()
	self.super.ctor(self)

	self.id_ = 0

	self.recoverHp_ = 0

	self.bombNum_ = 0
end

function Item:setId(id_)
	self.id_ = id_
end

function Item:getId()
	return self.id_
end

--获得道具时候回复的hp
function Item:setRecoverHp(hp)
	self.recoverHp_ = hp
end

function Item:getRecoverHp()
	return self.recoverHp_
end

--增加炸弹个数
function Item:setBombNum(num)
	self.bombNum_ = num
end

function Item:getBombNum()
	return self.bombNum_
end

function Item:onGot()
	self:removeSelf()
end

return Item