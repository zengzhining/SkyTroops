local SelectScene = class("SelectScene", cc.load("mvc").ViewBase)

SelectScene.RESOURCE_FILENAME = "Layer/SelectRole.csb"

local TAG_ROLE_1 = 101
local TAG_ROLE_2 = 102

local bullets = {}

function SelectScene:onCreate()

	__G__LoadRes()

	self.roleId_ = GameData:getInstance():getRoleId()
	local root = self:getResourceNode()
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
				self:getApp():enterLoading("GameScene", "FULLAD")
			end, 1)
		end
	end)
	--left
	local leftBtn = root:getChildByName("Left")
	self.leftBtn_ = leftBtn
	leftBtn:onClick(function ( sender )
		__G__MenuCancelSound()
		self:onLeft()
	end)

	local rightBtn = root:getChildByName("Right")
	self.rightBtn_ = rightBtn
	rightBtn:onClick(function ( sender )
		__G__MenuCancelSound()
		self:onRight()
	end)

	local layer = display.newLayer()
	self:add(layer)
	self.roleLayer_ =layer

	bullets = {}

	self:updateRole()
end

--主角发射炮弹的回调函数
function SelectScene:onFireBullet( id_ )
	if not self:roleUnlock() then return end
	local role = self.roleLayer_:getChildByTag(TAG_ROLE_1)
	local gameLayer = self.roleLayer_
	local roleX,roleY = role:getPosition()
	local fireId = role:getBulletFireType()

	if fireId == 1 then
		--发射一列
		local bullet = PlaneFactory:getInstance():createBullet(id_)
		bullet:pos(roleX, roleY + role:getViewRect().height *0.25)
		bullet:setSpeed(cc.p(0, 10))
		gameLayer:addChild(bullet)
	elseif fireId == 2 then
		--发射两列
		local tbl = {-1,1}
		for c,dir in pairs(tbl) do
			local bullet = PlaneFactory:getInstance():createBullet(id_)
			bullet:pos(roleX + 30*dir, roleY + role:getViewRect().height *0.25)
			bullet:setSpeed(cc.p(0, 10))
			gameLayer:addChild(bullet)
		end
	elseif fireId == 3 then
		--发射三列
		local tbl = {-1,0, 1}
		for c,dir in pairs(tbl) do
			local bullet = PlaneFactory:getInstance():createBullet(id_)
			bullet:pos(roleX + 50*dir, roleY + role:getViewRect().height *0.25)
			bullet:setSpeed(cc.p(0, 10))
			gameLayer:addChild(bullet)
		end
	elseif fireId == 4 then
		--散发射三列
		local tbl = {-1,0, 1}
		local speedX = 5
		for c,dir in pairs(tbl) do
			local bullet = PlaneFactory:getInstance():createBullet(id_)
			bullet:pos(roleX + 50*dir, roleY + role:getViewRect().height *0.25)
			bullet:setSpeed(cc.p(speedX * dir, 10))
			gameLayer:addChild(bullet)
		end
	elseif fireId == 5 then
		
	elseif fireId == 6 then
		
	end

	for c,bullet in pairs (bullets) do
		if bullet:getPositionY() > display.height*1.5 then 
			bullet:removeSelf()
			table.remove(bullets, c)
		end
	end
	
end

function SelectScene:updateRole()
	local id = self.roleId_
	local role = PlaneFactory:getInstance():createRole(id)
	role:pos(display.cx, display.cy)

	if not self:roleUnlock() then 
		Effect.greySprite(role)
	else
		Effect.colorSprite(role)
	end

	local plane = self.roleLayer_:getChildByTag(TAG_ROLE_1)
	if plane then 
		plane:removeSelf()
	end
	self.roleLayer_:addChild(role,100, TAG_ROLE_1)

	self:updateUI()
end

function SelectScene:updateUI()
	local root = self:getResourceNode()
	local rightBtn = root:getChildByName("Right")
	local leftBtn = root:getChildByName("Left")
	local startBtn = root:getChildByName("Go")

	if self.roleId_ == 1 then 
		leftBtn:hide()
	elseif self.roleId_ == 6 then 
		rightBtn:hide()
	else
		leftBtn:show()
		rightBtn:show()
	end


	--如果角色解锁才显示
	if not self:roleUnlock() then 
		startBtn:hide()

	else
		startBtn:show()

	end
end

function SelectScene:roleUnlock()
	local score = 0
	local id = self.roleId_-1
	if id == 0 then 
		return true 
	end
	
	for i = 1, id do
		score =score + ROLE_SCORE_TBL[i]
	end

	local allScore = GameData:getInstance():getAllScore()
	if allScore >= score then 
		return true
	else
		return false
	end
end

function SelectScene:onLeft(  )
	-- body
	local id = self.roleId_ - 1
	self.roleId_ = id > 0 and id or 1
	self:updateRole()
end

function SelectScene:onRight(  )
	-- body
	local id = self.roleId_ + 1
	self.roleId_ = id < 7 and id or 6
	self:updateRole()
end


function SelectScene:onEnter()

end

function SelectScene:onExit()

end

return SelectScene