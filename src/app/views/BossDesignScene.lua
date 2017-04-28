
local BossDesignScene = class("BossDesignScene", cc.load("mvc").ViewBase)

local TAG_BULLET = 202


function BossDesignScene:ctor()
	__G__LoadRes()
	local layer = display.newLayer()
	self:add(layer)

	local plane = PlaneFactory:getInstance():createEnemy(11)
	plane:pos(display.cx,display.cy * 1.7)
	layer:add(plane,10)

	local role = PlaneFactory:getInstance():createRole(1)
	role:pos(display.cx,display.cy * 0.3)
	layer:add(role,10)

	GameData:getInstance():setRole(role)

	--添加虚拟摇杆
	local controlLayer = PlaneFactory:getInstance():createJoy("ui/bg.png", "ui/btn.png")
	self:addChild(controlLayer, 2)

	role:attachVirtualJoy(controlLayer)

	--按键事件
	local keyCallback = function ( event )
		if event.keycode == cc.KeyCode.KEY_BACK then
			self:onCut()
        end

        if (device.platform ~= android) and role and role.onKeyPad then 
        	role:onKeyPad(event)
        end
    end
	layer:onKeypad( keyCallback )


	self.gameLayer_ = layer
end

function BossDesignScene:onEnemyFire( enemy, bulletId )
	local gameLayer = self.gameLayer_
	local posx,posy = enemy:getPosition()
	local aiId = enemy:getAiId()
	local fireType = enemy:getFireType()

	self:fireBullet(fireType, enemy, bulletId)
	
	-- if aiId == 5 then 
	-- 	--发射散弹
	-- 	self:fireBullet(2, enemy, bulletId)
	-- elseif aiId == 6 then
	-- 	--发射两列子弹
	-- 	self:fireBullet(4, enemy, bulletId)
	-- elseif aiId == 9 then 
	-- 	self:fireBullet(4, enemy, bulletId )
	-- elseif aiId == 13 then
	-- 	--发射散弹
	-- 	self:fireBullet(2, enemy, bulletId)
	-- elseif aiId == 14 then
	-- 	--发射两列子弹
	-- 	self:fireBullet(4, enemy, bulletId)
	-- elseif aiId == 15 then
	-- 	--发射跟随子弹
	-- 	self:fireBullet(6, enemy, bulletId)
	-- elseif aiId == 21 then
	-- 	--大boss1,发射面向主角的散弹
	-- 	self:fireBullet(7, enemy, bulletId)
	-- elseif aiId == 22 then
	-- 	--大boss2,发射主角的散列散弹
	-- 	self:fireBullet(8, enemy, bulletId)

	-- else
	-- 	--普通发射
	-- 	self:fireBullet(1,enemy, bulletId)
	-- end
end

--发射子弹方法,第一个为子弹的发射类型
function BossDesignScene:fireBullet( typeId_ , enemy , bulletId)
	local gameLayer = self.gameLayer_
	local posx,posy = enemy:getPosition()
	local bulletY = posy - enemy:getViewRect().height *0.05

	typeId_ = 9

	if typeId_ == 1 then 
		--普通发射
		local bullet = PlaneFactory:getInstance():createEmenyBullet(bulletId)
		bullet:pos(posx, bulletY)
		bullet:onFire()
		bullet:setSpeed(cc.p(0, -5))
		gameLayer:addChild(bullet, 0, TAG_BULLET)
		-- table.insert(armyBulletSet, bullet)
	elseif typeId_ == 2 then 
		--发射散弹
		local speedX = 3
		for i = -1, 1,1 do
			local bullet = PlaneFactory:getInstance():createEmenyBullet(bulletId)
			bullet:pos(posx, bulletY)
			bullet:onFire()
			bullet:setSpeed(cc.p(speedX * i, -5))
			gameLayer:addChild(bullet, 0, TAG_BULLET)
			-- table.insert(armyBulletSet, bullet)
		end
	elseif typeId_ == 3 then 
		--发射一串的子弹
		local speedY = 10
		local DEL_HEIGHT = 30
		for i = 0,2,1 do
			local bullet = PlaneFactory:getInstance():createEmenyBullet(bulletId)
			bullet:pos(posx, bulletY - DEL_HEIGHT*i )
			bullet:onFire()
			bullet:setSpeed(cc.p(0, -speedY))
			gameLayer:addChild(bullet, 0, TAG_BULLET)
			-- table.insert(armyBulletSet, bullet)
		end
	elseif typeId_ == 4 then 
		--发射两列子弹
		local PER_WIDTH = 30
		for i = -1, 1, 2 do 
			local bullet = PlaneFactory:getInstance():createEmenyBullet(bulletId)
			bullet:pos(posx + PER_WIDTH * i, bulletY)
			bullet:onFire()
			bullet:setSpeed(cc.p(0, -5))
			gameLayer:addChild(bullet, 0, TAG_BULLET)
			-- table.insert(armyBulletSet, bullet)
		end
	elseif typeId_ == 5 then 
		--发射全场的子弹
		local PER_DREE = math.pi/6
		local SPEED = 5
		for i = 1, 12 do
			--
			local dgree = i * PER_DREE 
			local bullet = PlaneFactory:getInstance():createEmenyBullet(bulletId)
			bullet:pos(posx , posy )
			bullet:onFire()
			bullet:setSpeed(cc.p( SPEED* math.cos(dgree), SPEED * math.sin(dgree) ))
			gameLayer:addChild(bullet, 0, TAG_BULLET)
			-- table.insert(armyBulletSet, bullet)
		end 
	elseif typeId_ == 6 then
		--跟随子弹
		--普通发射
		local bullet = PlaneFactory:getInstance():createEmenyBullet(bulletId)
		bullet:pos(posx, bulletY)
		bullet:onFire()

		local role = GameData:getInstance():getRole()
		local rolex, roley = role:getPosition()
		local dx = rolex - posx
		local dy = roley - bulletY

		local speedY = 5

		local speedX = dx/dy * speedY

		bullet:setSpeed(cc.p(-speedX, -speedY))
		gameLayer:addChild(bullet, 0, TAG_BULLET)
		-- table.insert(armyBulletSet, bullet)
	elseif typeId_ ==7 then
		--发射一半的散弹
		local PER_DREE = math.pi/6
		local SPEED = 5
		for i = 6, 12 do
			--
			local dgree = i * PER_DREE 
			local bullet = PlaneFactory:getInstance():createEmenyBullet(bulletId)
			bullet:pos(posx , posy )
			bullet:onFire()
			bullet:setSpeed(cc.p( SPEED* math.cos(dgree), SPEED * math.sin(dgree) ))
			gameLayer:addChild(bullet, 0, TAG_BULLET)
			-- table.insert(armyBulletSet, bullet)
		end 
	elseif typeId_ == 8 then
		--发射三列的子弹
		local PER_WIDTH = 30
		for i = -1, 1, 1 do 
			local bullet = PlaneFactory:getInstance():createEmenyBullet(bulletId)
			bullet:pos(posx + PER_WIDTH * i, bulletY)
			bullet:onFire()
			bullet:setSpeed(cc.p(0, -5))
			gameLayer:addChild(bullet, 0, TAG_BULLET)
			-- table.insert(armyBulletSet, bullet)
		end
	elseif typeId_ == 9 then
		--连续发射
		--普通发射
		local function fireOneBullet()
			if enemy:isDead() then return end

			local posx,posy = enemy:getPosition()

			local bullet = PlaneFactory:getInstance():createEmenyBullet(bulletId)
			bullet:pos(posx, bulletY)
			bullet:onFire()
			bullet:setSpeed(cc.p(0, -5))
			gameLayer:addChild(bullet, 0, TAG_BULLET)
		end

		for i = 1,6 do
			__G__actDelay(enemy, function (  )
				fireOneBullet()
			end, i*0.3)
		end
	end

end


function BossDesignScene:cameraMove(speed)
	local camera = display.getDefaultCamera()
	-- camera:posByY(speed * display.cy)
	local act = cc.MoveBy:create(0.2, cc.p( 0, speed * display.cy ))
	camera:runAction(act)
end

return BossDesignScene