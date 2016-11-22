local SelectScene = class("SelectScene", cc.load("mvc").ViewBase)

SelectScene.RESOURCE_FILENAME = "Layer/SelectRole.csb"

local TAG_ROLE_1 = 101
local TAG_ROLE_2 = 102

function SelectScene:onCreate()

	if DEBUG == 2 then
		display.loadSpriteFrames("Plane.plist", "Plane.png")
	end

	self.roleId_ = 1
	local root = self:getResourceNode()

	--title
	local title = root:getChildByName("Des")
	self.title_ = title
	--button
	local startBtn = root:getChildByName("Go")
	startBtn:onTouch(function ( event )
		if event.name == "began" then 
			local size = startBtn:getSize()
			Helper.showClickParticle(startBtn, cc.p(size.width * 0.5, size.height * 0.5))
		elseif event.name == "ended" then
			__G__MenuCancelSound()
			GameData:getInstance():setRoleId(self.roleId_)
			__G__actDelay(self, function (  )
				self:getApp():enterLoading("GameScene")
			end, 0.5)
		end
	end)
	--left
	local leftBtn = root:getChildByName("Left")
	self.leftBtn_ = leftBtn
	leftBtn:onTouch(function ( event )
		if event.name == "ended" then
			__G__MenuCancelSound()
			self:onLeft()
		end
	end)

	local rightBtn = root:getChildByName("Right")
	self.rightBtn_ = rightBtn
	rightBtn:onTouch(function ( event )
		if event.name == "ended" then
			__G__MenuCancelSound()
			self:onRight()
		end
	end)

	if self.roleId_ == 1 then 
		leftBtn:hide()
	elseif self.roleId_ == 2 then 
		rightBtn:hide()
	end

	self:updateTitle(self.roleId_)

	self:createRole(1)
	self:createRole(2)

	self:updateRole()
end

function SelectScene:createRole(id_)
	local role = PlaneFactory:getInstance():createRole(id_)
	role:pos(display.cx, display.cy)
	if id_ == 1 then
		self:addChild(role,100, TAG_ROLE_1)
	elseif id_ == 2 then 
		self:addChild(role,100, TAG_ROLE_2)
	end
end

function SelectScene:updateRole()
	local role1 = self:getChildByTag(TAG_ROLE_1)
	local role2 = self:getChildByTag(TAG_ROLE_2)
	if self.roleId_ == 1 then 
		role1:show()
		role2:hide()
	elseif self.roleId_ == 2 then 
		role1:hide()
		role2:show()
	end
	-- local role = PlaneFactory:getInstance():createRole(self.roleId_)
	-- role:pos(display.cx, display.cy)
	-- self:addChild(role,100, TAG_ROLE)
end

function SelectScene:onLeft(  )
	-- body
	self.roleId_ = 1
	self.leftBtn_:hide()
	self.rightBtn_:show()
	self:updateTitle(self.roleId_)
	self:updateRole()
end

function SelectScene:onRight(  )
	-- body
	self.roleId_ = 2
	self.rightBtn_:hide()
	self.leftBtn_:show()
	self:updateTitle(self.roleId_)
	self:updateRole()
end

function SelectScene:updateTitle( id )
	local str = nil
	if id == 1 then 
		str = "Faster,Less Bullet"
	elseif id == 2 then 
		str = "Slower, More Bullet"
	end
	self.title_:setString(str)
end
function SelectScene:onEnter()

end

function SelectScene:onExit()

end

return SelectScene