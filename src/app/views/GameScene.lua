local GameScene = class("GameScene", cc.load("mvc").ViewBase)

local TAG_UI = 101
local TAG_CUT = 100
local TAG_GAME_LAYER = 102
local TAG_BG = 103
local TAG_FRONT = 106  --前景，云神马的
local TAG_CONTINUE_LAYER = 104
local TAG_CONTROL_LAYER = 105
local TAG_TITLE_LAYER = 107 --关卡文字
local TAG_ARMY = 201
local TAG_BULLET = 202
local TAG_ROLE_BULLET = 203

local TAG_DEBUG_TITLE = 204
local TAG_DEBUG_LEVEL = 210
local TAG_DEBUG_SUM = 211


local armySet = {}
local itemSet = {}

local armyInScreen = {}

local pointSet = {}  --连击显示红点

local ARMY_TIME = 0.6 --敌人生成时间
local tempTime = 0

local armyIndex = 1 --敌人的索引
local ARMY_LENGTH = 9 --一次生成敌人的长度
local fly_height = 0 --飞行的高度

local hitSameArmyNum = 0 --打击到相同敌人的数目
local lastHitArmyId = 1 --上次子弹打到的敌人的id
local commboTimes = 0

local ContinueTimes = 2  -- 只能有两次继续游戏机会

local DEFAULT_HIEGHT =  display.height * 1.2

local scheduler = cc.Director:getInstance():getScheduler()

function GameScene:onCreate()
	self:initData()
	--addSpriteFrames
	-- body
	local fileName = "Layer/HUD.csb"
	local uiLayer = display.newCSNode(fileName)	

	self:initUI(uiLayer)
	self:addChild(uiLayer, 10, TAG_UI )

	self:initObj()
	self:initControl()

	local str = string.format("bg/%02dBackground.png", GameData:getInstance():getWorld())
	local bg = __G__createPngBg( str )
	bg:setSpeed(-1)
	self:add(bg, -2, TAG_BG)

	local frontBg =  __G__createPngBg( "bg/WhiteCloud.png" )
	frontBg:setSpeed(-5)
	self:add(frontBg,10, TAG_FRONT )

	self:updateHpBar()

	if DEBUG >= 1 then
		self:addDebugTitle()
	end
end

function GameScene:addDebugTitle()
	local title = display.newTTF("fonts/pen.ttf", 32,"sum:70")
	title:setAnchorPoint(cc.p(0, 0.5))
	title:pos(display.left_center)
	self:add(title,999, TAG_DEBUG_TITLE)

	local level = display.newTTF("fonts/pen.ttf", 32,"level:70")
	level:setAnchorPoint(cc.p(0, 0.5))
	level:pos(cc.p(display.left,display.cy + 100  ) )
	self:add(level,999, TAG_DEBUG_LEVEL)

	local sum = display.newTTF("fonts/pen.ttf", 32,"sum:70")
	sum:setAnchorPoint(cc.p(0, 0.5))
	sum:pos(cc.p(display.left,display.cy + 200  ) )
	self:add(sum,999, TAG_DEBUG_SUM)
end

function GameScene:updateDebugTitle(sum_)
	local title = self:getChildByTag(TAG_DEBUG_TITLE)
	if title then
		local str = string.format("sum:%d", sum_)
		title:setString(str)
	end

	title = self:getChildByTag(TAG_DEBUG_LEVEL)
	if title then
		local str = string.format("level:%d", GameData:getInstance():getLevel()  )
		title:setString(str)
	end

	title = self:getChildByTag(TAG_DEBUG_SUM)
	if title then
		local children = self.gameLayer_:getChildren()
		local str = string.format("all Object:%d", #children  )
		title:setString(str)
	end
end

function GameScene:initData()

	--测试默认载入plist
	__G__LoadRes()

	armySet = {}
	--如果已经连击完

	itemSet = {}


	armyInScreen = {}

	hitSameArmyNum = 0
	commboTimes = 0
	ContinueTimes = 2

	--默认进入后台就暂停游戏,播放广告例外
	self.isNeedPause_ = true

	self.gameLayer_ = nil

	self.cutBtn_ = nil
	self.scoreLb_ = nil
	self.levelLb_ = nil

	--炸弹个数
	self.bombLb_ = nil

	--血条
	self.hpBar_ = nil

	--标记只有一次全部敌人死亡的回调
	self.isAllDead_ = false
end

function GameScene:step( dt )

	fly_height = fly_height + 1
	--遍历处理
	local roleRect = self.role_:getCollisionRect()
	local rolePosY = self.role_:getPositionY()

	armyInScreen = {}
	local children = self.gameLayer_:getChildren()
	for i , army in pairs (children) do
		if army:getTag() == TAG_ARMY then
			if army:getPositionY() >= 0 and army:getPositionY()<= display.height + army:getViewRect().height*0.5 then
				table.insert(armyInScreen, army)
			end
		end
	end
	--遍历敌人
	for k, army in pairs(armyInScreen) do
		local rect = army:getCollisionRect()
		local iscollision = cc.rectIntersectsRect(roleRect, rect) 
		local isRelive = self.role_:isRelive()
		local isDead = self.role_:isDead()
		--碰撞检测成功判断下角色是否处于复活状态
		if iscollision and (not isRelive) and (not isDead) and (not army:isDead()) then 
			self.role_:onCollision( army )
			army:onCollision( self.role_ )
		end

		local armyPosY = army:getPositionY()
		local isBeyound = ((armyPosY <= rolePosY - roleRect.height * 0.5 ) and true or false)
		if isBeyound then 
			--只进行一次回调
			if not army.hasBeyound_ then
				army.hasBeyound_ = true
				self:onBeyoundArmy(army)
			end
		end
	end
	
	--遍历子弹处理子弹碰撞逻辑
	local allChildren = self.gameLayer_:getChildren()
	for i, bullet in pairs(allChildren) do
		if bullet:getTag() == TAG_ROLE_BULLET then
			repeat
				local bulletRect = bullet:getCollisionRect()
				for k, army in pairs(armyInScreen) do
					repeat
						local armyRect = army:getCollisionRect()
						local iscollision = cc.rectIntersectsRect(armyRect, bulletRect) 
						if iscollision and (not army:isDead() )  then
							army:onCollisionBullet(bullet)
							bullet:onCollision(army)
							self:onBulletHitArmy( bullet, army )
							--最后再处理去除逻辑
							if army:isDead() then
								table.remove(armyInScreen, k)
							-- 	break
							end
						end
					until true
					
				end
				--子弹超出边界就去除掉
				if bullet:getPositionY() >= display.height then 
					bullet:removeSelf()
					break
				end
			until true
		end
	end

	--遍历处理敌人子弹逻辑
	local gameChildren = self.gameLayer_:getChildren()
	for i,bullet in pairs(gameChildren) do
		if bullet:getTag() == TAG_BULLET then
			local bulletRect = bullet:getCollisionRect()

			-- 如果有主角就判断主角
			if not self.role_:isDead() then
				local roleRect = self.role_:getCollisionRect()
				local iscollision = cc.rectIntersectsRect(roleRect, bulletRect) 
				if iscollision then
					self.role_:onCollision(bullet)
					bullet:onCollision(self.role_)
					self:onBulletHitRole( bullet )
					break
				end
			end

			--子弹超出边界就去除掉
			if (bullet:getPositionY() <= -bullet:getViewRect().height* 0.5) or (bullet:getPositionY() >= display.height) or 
				(bullet:getPositionX() < -bullet:getViewRect().width * 0.5) or (bullet:getPositionX() >= display.width + bullet:getViewRect().width * 0.5 ) then 
				bullet:removeSelf()
			end
		end
	end

	--遍历处理物品逻辑
	for i, item in pairs (itemSet) do
		local itemRect = item:getCollisionRect()
		-- 如果有主角就判断主角
		if not self.role_:isDead() then
			local roleRect = self.role_:getCollisionRect()
			local iscollision = cc.rectIntersectsRect(roleRect, itemRect) 
			if iscollision then
				self.role_:onGetItem(item)
				item:onGot()
				self:onRoleGetItem(item)
				table.remove(itemSet, i)
				break
			end
		end

		if item:getPositionY() <= -item:getViewRect().height * 0.5 then
			item:removeSelf()
			table.remove(itemSet, i)
		end
	end

	--生成敌人
	tempTime = tempTime + dt
	local armtTime = self:getArmyTime()
	if tempTime >= armtTime then
		tempTime = 0 

		--超出界面去除
		local tbl = self.gameLayer_:getChildren()
		for k, item in pairs (tbl) do
			if item:getTag() == TAG_ARMY then
				if item:getPositionY() < -100 then
					item:removeSelf()
				end
			end
		end

		self:removeOutWindowArmy()

		local sum = 0
		local armytbl = self.gameLayer_:getChildren()

		for k, m_army in pairs (armytbl) do
			if m_army:getTag() == TAG_ARMY then
				sum = sum + 1
			end
		end

		--debug 计数
		if DEBUG >= 1 then
			self:updateDebugTitle(sum)
		end
		--没有敌人时候需要进入下一个关卡生成敌人
		if sum <= 0 then
			if self.isAllDead_ == false then
				self:onAllArmyGone()
				self.isAllDead_ = true
			end
		end
	end
end

--清理子弹
function GameScene:clearBullet()

end

--主角获得物品的场景回调
function GameScene:onRoleGetItem(item)
	__G__pickUpItem()
	self:updateUI()
end

--子弹击中敌人的回调，这里可以处理连击
function GameScene:onBulletHitArmy( bullet_, army_ )
	local id = army_:getId()
	--如果是和之前打到的是相同的id就增加
	--如果已经连击完
	if hitSameArmyNum ~= 0 then
		if id == lastHitArmyId then 
			hitSameArmyNum = hitSameArmyNum + 1
		else
			commboTimes = 0
			hitSameArmyNum = 0
			lastHitArmyId = id 
			-- self:updateCommbo()
		end
	else
		hitSameArmyNum = hitSameArmyNum + 1
		lastHitArmyId = id 
	end

	-- self:updateSameHit()

	--一般保持在三个连击
	if hitSameArmyNum >= 3 then 
		commboTimes = commboTimes + 1
		--连击时候恢复能量
		if self.role_ and self.role_.resetPower then
			self.role_:resetPower()
		end
		hitSameArmyNum = 0
		-- self:updateCommbo()
	end
end

--子弹击中自己回调
function GameScene:onBulletHitRole(bullet_)
	self:onRoleHurt(bullet_)
end

function GameScene:onRoleHurt(target)
	self:updateHpBar()
end

function GameScene:updateSameHit( )
	-- body
	if hitSameArmyNum > 0 and hitSameArmyNum < 3  then
		for c,point in pairs(pointSet) do
			if c > hitSameArmyNum then
				point:hide()
			else
				point:show()
			end
		end
	elseif hitSameArmyNum > 0 and hitSameArmyNum >= 3 then
		for c,point in pairs(pointSet) do
			-- point:show()
			local act = cc.Sequence:create(
				cc.Show:create(),
				cc.ScaleTo:create(0.3, 1.2),
				cc.Hide:create()
				)
			point:runAction(act)

		end
	else
		for c,point in pairs(pointSet) do
			point:hide()
		end
	end
end

function GameScene:getArmyTime()
	local time = ARMY_TIME
	local armySpeed = self:getArmySpeed()
	time = 0.01* math.abs(armySpeed)
	return time
end

--角色超越敌机瞬间的回调函数
function GameScene:onBeyoundArmy( army_ )

end

--角色死亡回调函数
function GameScene:onPlayerDead( target )
	if target then 
		target:setLocalZOrder(100)
	end
	__G__ExplosionSound()
	self.cutBtn_:setTouchEnabled(false)
	__G__MusicFadeOut(self, 1)

	__G__actDelay( self, function (  )
		--直接进入结算关卡,相当于按下取消
		self:onContinueCancel()
	end, 0.5 )

	--死亡震动
	-- device.vibrate( 0.2 )
end

function GameScene:isNeedPause()
	return self.isNeedPause_
end

--玩家复活继续游戏
function GameScene:onContinue()
	local callback = function ()
		__G__actDelay(self, function()
			self.gameLayer_:resumeAllInput()	
			self.cutBtn_:setTouchEnabled(true)
			if self.role_ then 
				self.role_:setVisible(true)
				self.role_:relive()

				
				-- self:onUpdate(handler(self, self.step))
			end
			ContinueTimes = ContinueTimes - 1
			self.isNeedPause_ = true
		end, 0.2)
	end

	--判断能否播放广告，可以就播放,原型测试暂时关闭
	self.isNeedPause_ = false

	if DEBUG == 2 and device.platform ~= "android" then 
		callback()
	end
end

--玩家不复活继续游戏
function GameScene:onContinueCancel()
	--这里保存数据	
	__G__actDelay(self,function (  )
		self:unUpdate()
		self:getApp():enterLoading("ResultScene", "VEDIO")
	end, 1.0)
end

--敌人死亡的回调函数
--只有敌人死亡时候才更新分数和排名
function GameScene:onArmyDead( target)
	__G__ExplosionSound()

	GameData:getInstance():addKillNum(1)

	local score = target:getScore() 

	--是否是boss
	-- if target:getMaxHp() >= 100 then
	-- 	__G__actDelay(self,function (  )
	-- 		Helper.showBossDeadParticle(self.gameLayer_)
	-- 	end,0.1)

	-- end

	GameData:getInstance():addScore( score ) 
	--分数改变时候更新分数
	self:updateScore( score )

	--敌机死亡之后显示增加的分数
	local posx,posy = target:getPosition()
	local param = {}
	param.pos_ = cc.p(posx,posy)
	self:showAddScore(score, param)

	local aiId = target:getAiId()

	local role = GameData:getInstance():getRole()
	local hp = role:getHp()
	local maxHp = role:getMaxHp()

	local hpPer = hp/maxHp
	math.randomseed(os.clock())
	local randomNum = math.random(1,1000)

	if hpPer <= 0.3 then
		if randomNum > 700 then
			self:createItem(2, param.pos_)
		end
	end

	if aiId == AI.DEAD_ITEM then 
		local id = math.random(1,3)

		self:createItem(id, param.pos_)
	elseif aiId == AI.DEAD_TO_FIRE then 
		--死亡发射子弹
		local fireType = target:getFireType()
		self:fireBullet(fireType, target, target:getBulletId() )
	end
end

function GameScene:showAddScore(dScore, params)
	local str = string.format("+%d", dScore)
	local title = display.newTTF("fonts/pen.ttf", 32,str)
	local uiLayer = self:getChildByTag(TAG_UI)
	if params.pos_ then 
		title:pos(params.pos_)
	end

	title:setColor(display.COLOR_RED)

	uiLayer:add(title)

	local act = cc.Spawn:create( cc.MoveBy:create(2,cc.p(0,10)),
		cc.FadeOut:create(2) )
	title:runAction(cc.Sequence:create( act, cc.RemoveSelf:create(true) ))

end

function GameScene:initUI( ui_ )
	local cutBtn = ui_:getChildByName("CutButton")
	cutBtn:onClick(function (  )
		self:onCut()
	end)

	self.cutBtn_ = cutBtn
	local scoreLb = ui_:getChildByName("Score")
	self.scoreLb_ = scoreLb
	local rankLb = ui_:getChildByName("Rank")
	self.levelLb_ = rankLb
	--直接更新
	self:flashScore()

	local bombBtn = ui_:getChildByName("Boom1")
	bombBtn:onClick(function (  )
		self:onBomb()
	end)
	self.bombBtn_ = bombBtn

	local bombLb = bombBtn:getChildByName("boomNum")
	self.bombLb_ = bombLb
	self:flashBomb()

	local hpBar = ui_:getChildByName("HpBar")
	self.hpBar_ = hpBar
end

function GameScene:hideUI(  )
	local uiLayer = self:getChildByTag(TAG_UI)
	if uiLayer then 
		uiLayer:hide()
	end
	self:hideController()
end

function GameScene:showUI(  )
	local uiLayer = self:getChildByTag(TAG_UI)
	if uiLayer then 
		uiLayer:show()
	end
	self:showController()
end

function GameScene:hideUIWithAnimation()

end

function GameScene:showUIWithAnimation()
	self:showUI()
end

function GameScene:hideController()
	self:setVisibleController(false)
end

function GameScene:showController()
	self:setVisibleController(true)
end

function GameScene:setVisibleController(flag)
	local controlLayer = self:getChildByTag(TAG_CONTROL_LAYER)
	if controlLayer then
		if flag then
			controlLayer:show()
		else
			controlLayer:hide()
		end
	end
end

--获得关卡的描述
function GameScene:getLevelDes()
	local world = GameData:getInstance():getWorld()
	local str = LEVEL_DES[world]
	if not str then 
		error("not level_des in world "..world)
	end
	return str
end

--展示关卡文字
function GameScene:showLevelTitle()
	local TAG = 213
	local str = self:getLevelDes()
	local layer = __G__createLevelTitleLayer(str)

	local title = layer:getChildByTag(TAG)
	if title then 
		title:setOpacity(0)
		title:runAction(cc.FadeIn:create(0.5))
	end
	self:add(layer, 100, TAG_TITLE_LAYER)

	__G__actDelay(self,function (  )
		self:removeLevelTitle()
		
	end, 4)
end

function GameScene:removeLevelTitle()
	local TAG = 213
	local layer = self:getChildByTag(TAG_TITLE_LAYER)
	local title = layer:getChildByTag(TAG)
	if title then 
		title:runAction(cc.FadeOut:create(2))
	end
	local act = cc.Sequence:create(cc.DelayTime:create(2), cc.RemoveSelf:create(true))
	layer:runAction(act)
end

function GameScene:onBomb()
	local bombNum = GameData:getInstance():getBomb()
	if bombNum > 0 then
		Helper.showBoomParticle(self.gameLayer_)

		for c,army in pairs(armyInScreen) do
			if not army:isDead() then
				local posy = army:getPositionY()
				local time = 1.3 * posy/ display.height
				-- __G__actDelay(army, function (  )
					army:onCollisionBomb()
				-- end, time)
			end
		end

		local children = self.gameLayer_:getChildren()

		for c,bullet in pairs(children) do
			if bullet:getTag() == TAG_BULLET then
				bullet:onCollision()
			end
		end
		GameData:getInstance():minBomb(1)
		self:flashBomb()
	end
end

--更新炸弹个数
function GameScene:flashBomb()
	local num = GameData:getInstance():getBomb()
	self.bombLb_:setString(num)
end

--更新分数
function GameScene:flashScore()
	local score = GameData:getInstance():getScore()
	self.scoreLb_:setString(string.format("%04d", score))
end

function GameScene:updateScore( changeScore )
	__G__actDelay(self, function (  )
		self:flashScore()
	end, 0.4)
end

--更新commbo,更新数字
function GameScene:updateCommbo()
	-- commboTimes
	if commboTimes <= 0 then 
		--hide
		self.commboTitle_:hide()
		self.commboLb_:hide()
		--如果已经连击完
	else
		self.commboTitle_:show()
		self.commboLb_:show()
		self.commboLb_:setString(commboTimes)
	end
end

--更新等级
function GameScene:updateLevelNum()
	self.levelLb_:setString( self.role_:getLevel() )
end

--更新血量
function GameScene:updateHpBar()
	local role = self.role_
	local hp = role:getHp()
	local maxHp = role:getMaxHp()
	local hurtHp = maxHp - hp
	local percent = 100* hurtHp/maxHp
	self.hpBar_:setPercent(percent)
end

--更新UI元素
function GameScene:updateUI()
	self:updateHpBar()
	self:updateScore()
	self:updateLevelNum()
	self:flashBomb()
end

function GameScene:initControl()
	local controlLayer = PlaneFactory:getInstance():createJoy("ui/bg.png", "ui/btn.png")
	self:addChild(controlLayer, 2, TAG_CONTROL_LAYER)

	self.role_:attachVirtualJoy(controlLayer)
end

function GameScene:initObj()
	local gameLayer = display.newLayer()
	self:addChild(gameLayer, 1, TAG_GAME_LAYER)
	self.gameLayer_ = gameLayer
	local id = GameData:getInstance():getRoleId()
	local plane = PlaneFactory:getInstance():createRole(id)
	local width = plane:getViewRect().width
	plane:pos(display.cx, display.height /2 )
	gameLayer:addChild(plane)
	self.role_ = plane
	GameData:getInstance():setRole(plane)

	--按键事件
	local keyCallback = function ( event )
		if event.keycode == cc.KeyCode.KEY_BACK then
			self:onCut()
        end

        if (device.platform ~= android) and plane and plane.onKeyPad then 
        	plane:onKeyPad(event)
        end
    end
	gameLayer:onKeypad( keyCallback )
end

--主角发射炮弹的回调函数
function GameScene:onFireBullet( id_ )

	__G__FireBullet()

	local role = self.role_
	local gameLayer = self.gameLayer_
	local roleX,roleY = role:getPosition()
	local fireId = self.role_:getBulletFireType()

	if fireId == 1 then
		--发射一列
		local bullet = PlaneFactory:getInstance():createBullet(id_)
		bullet:pos(roleX, roleY + role:getViewRect().height *0.25)
		bullet:onFire()
		bullet:setSpeed(cc.p(0, 15))
		gameLayer:addChild(bullet,0, TAG_ROLE_BULLET)
	elseif fireId == 2 then
		--发射两列
		local tbl = {-1,1}
		for c,dir in pairs(tbl) do
			local bullet = PlaneFactory:getInstance():createBullet(id_)
			bullet:pos(roleX + 30*dir, roleY + role:getViewRect().height *0.25)
			bullet:onFire()
			bullet:setSpeed(cc.p(0, 15))
			gameLayer:addChild(bullet,0, TAG_ROLE_BULLET)
		end
	elseif fireId == 3 then
		--发射三列
		local tbl = {-1,0, 1}
		for c,dir in pairs(tbl) do
			local bullet = PlaneFactory:getInstance():createBullet(id_)
			bullet:pos(roleX + 50*dir, roleY + role:getViewRect().height *0.25)
			bullet:onFire()
			bullet:setSpeed(cc.p(0, 15))
			gameLayer:addChild(bullet,0, TAG_ROLE_BULLET)
		end
	elseif fireId == 4 then
		--散发射三列
		local tbl = {-1,0, 1}
		local speedX = 5
		for c,dir in pairs(tbl) do
			local bullet = PlaneFactory:getInstance():createBullet(id_)
			bullet:pos(roleX + 50*dir, roleY + role:getViewRect().height *0.25)
			bullet:onFire()
			bullet:setSpeed(cc.p(speedX * dir, 15))
			gameLayer:addChild(bullet,0, TAG_ROLE_BULLET)
		end
	elseif fireId == 5 then
		
	elseif fireId == 6 then
		
	end
	
end

--发射子弹方法
function GameScene:fireBullet( typeId_ , enemy , bulletId)
	local gameLayer = self.gameLayer_
	local posx,posy = enemy:getPosition()
	local bulletY = posy - enemy:getViewRect().height *0.05

	if typeId_ == 1 then 
		--普通发射
		local bullet = PlaneFactory:getInstance():createEmenyBullet(bulletId)
		bullet:pos(posx, bulletY)
		bullet:onFire()
		bullet:setSpeed(cc.p(0, -10))
		gameLayer:addChild(bullet, 0, TAG_BULLET)
	elseif typeId_ == 2 then 
		--发射散弹
		local speedX = 3
		for i = -1, 1,1 do
			local bullet = PlaneFactory:getInstance():createEmenyBullet(bulletId)
			bullet:pos(posx, bulletY)
			bullet:onFire()
			bullet:setSpeed(cc.p(speedX * i, -5))
			gameLayer:addChild(bullet, 0, TAG_BULLET)
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

		local ALL_SPEED = 10


		local dis = math.sqrt( dx*dx + dy*dy )

		local speedY = ALL_SPEED/dis * dy

		local speedX = ALL_SPEED/dis * dx

		bullet:setSpeed(cc.p(speedX, speedY))
		gameLayer:addChild(bullet, 0, TAG_BULLET)
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
	elseif typeId_ == 10 then
		local function fireOneBullet()
			if enemy:isDead() then return end

			local posx,posy = enemy:getPosition()

			local PER_DREE = math.pi/6
			local SPEED = 5
			for i = 8, 10 do
				--
				local dgree = i * PER_DREE 
				local bullet = PlaneFactory:getInstance():createEmenyBullet(bulletId)
				bullet:pos(posx , posy )
				bullet:onFire()
				bullet:setSpeed(cc.p( SPEED* math.cos(dgree), SPEED * math.sin(dgree) ))
				gameLayer:addChild(bullet, 0, TAG_BULLET)
			end 
		end

		for i = 1,4 do
			__G__actDelay(enemy, function (  )
				fireOneBullet()
			end, i*0.3)
		end
	end

end

--敌人发射子弹的回调函数
function GameScene:onEnemyFire( enemy, bulletId )
	local gameLayer = self.gameLayer_
	local posx,posy = enemy:getPosition()
	local aiId = enemy:getAiId()
	local fireType = enemy:getFireType()

	self:fireBullet(fireType, enemy, bulletId)
		

end

--获得army的数据，根据数据来创建敌机
function GameScene:getArmyData(  )
	local level = GameData:getInstance():getLevel()
	local world = GameData:getInstance():getWorld()
	local armyData = GameData:getInstance():getArmyConfig(world,level)

	return armyData
end

--创建下一个关卡的逻辑
function GameScene:nextLevel()
	local world = GameData:getInstance():getWorld()
	local level = GameData:getInstance():getLevel()

	armyIndex = 1 --将敌人索引置1
	fly_height = 0 -- 将飞行高度置0
	local str = string.format("config/level%02d/army%02d.plist", world,level)
	local isExit = gameio.isExist(str)
	if isExit then 
		--存在下一个的配置就生成敌人
		--是boss需要切换背景音乐
		if self:isBossLevel() then
			__G__GameBgm(GameData:getInstance():getWorld(), GameData:getInstance():getLevel())
		end
		
		__G__actDelay(self,function (  )
			self:onCreateArmy()
		end, 2.0)
	else
		--不存在就进入下一个世界
		GameData:getInstance():addWorld(1)
		GameData:getInstance():resetLevel()
		local world = GameData:getInstance():getWorld()
		--如果超过就进入游戏结束场景
		if GameData:getInstance():getWorld() > GameData:getInstance():getMaxWorld() then
			GameData:getInstance():reset()
			self:getApp():enterLoading("GameEndScene")
		else
			--要先展示一下文本
			self:unUpdate()
			--更新背景
			local bg = self:getChildByTag(TAG_BG)
			bg:fadeOut(5)

			__G__MusicFadeOut(self, 5)

			__G__actDelay(self, function (  )
				-- audio.stopMusic(true)
				
			end, 5.2)

			__G__actDelay(bg,function (  )
				local str = string.format("bg/%02dBackground.png", world)
				bg:change(str)
				bg:fadeIn(5)
				-- self:showLevelTitle()
			end, 6)

			-- self:onCreateArmy()
			__G__actDelay(self,function (  )
				self:startGame()
			end, 10)
		end
	end
end

--全部敌人离开屏幕或者死掉的回调，用来判断是否进入下一个关卡
function GameScene:onAllArmyGone()
	local world = GameData:getInstance():getWorld()

	--这里是否进入下一个关卡

	GameData:getInstance():addLevel(1)		

	self:nextLevel()


	
end

--生成物品
function GameScene:createItem( id, pos_ )
	if not pos_ then pos_ = cc.p(display.cx, display.height) end
	local item = PlaneFactory:getInstance():createItem(id)
	item:pos(pos_)
	local speedY = math.random(1,5)
	item:setSpeed(cc.p(0,-speedY))
	self.gameLayer_:add(item,-1)

	table.insert(itemSet, item)
end


--移除超出屏幕的敌人
function GameScene:removeOutWindowArmy()
	--先去除主角发射的子弹
	local tbl = self.gameLayer_:getChildren()
	for k, item in pairs(tbl) do
		local tag = item:getTag()
		if tag == TAG_ARMY then
			local posY = item:getPositionY()
			if posY < -100 then
				item:removeSelf()
			end
		elseif tag == TAG_BULLET then
			if item:getPositionY() > display.height * 1.2  then
				item:removeSelf()
			elseif item:getPositionY() < -display.height * 0.2 then
				item:removeSelf()
			elseif item:getPositionX() > display.width * 1.2 then
				item:removeSelf()
			elseif item:getPositionX()< -display.width * 0.2 then
				item:removeSelf()
			end
		elseif tag == TAG_ROLE_BULLET then
			if item:getPositionY() > display.height * 1.2  then
				item:removeSelf()
			end
		end
	end

	print("removeOutWindowArmy~~~~", #tbl)


end

function GameScene:createArmyFromIndex( formId, toId, armyData, height_ )
	if not height_ then height_ = 0 end


	local scene = self

	local bottonArmyY = 0

	for i = formId, toId,1 do
		local armyInfo = armyData[i]

		if not armyInfo then 
			armyIndex = i
			break
		end

		local id = armyInfo.id
		local army = PlaneFactory:getInstance():createEnemy(id)

		local posy = 0

		if i == formId then
			bottonArmyY =  armyInfo.y

			--默认将敌机放在一个高度
			posy = DEFAULT_HIEGHT

		else
			--算出距离，然后在最低点加上距离
			local dy = math.abs(armyInfo.y - bottonArmyY) 
			posy = DEFAULT_HIEGHT + dy
		end

		local width = army:getViewRect().width
		-- local armyPos = cc.p(armyInfo.x, armyInfo.y - height_ )
		local armyPos = cc.p(armyInfo.x, posy )
		army:pos(armyPos)
		army:setTag(TAG_ARMY)
		self.gameLayer_:addChild(army,100)

		--最后一个消灭时候生成下一个
		if i == toId then
			function army:onInScreen(  )
				self:updateOriginSpeed()
				scene:onCreateArmy()
			end
		end
	end

	--长度增加一
	armyIndex = toId + 1

end


function GameScene:onCreateArmy(  )
	

	self:removeOutWindowArmy()

	--读取plist数据创建敌人
	local armyData = self:getArmyData()

	if armyIndex> #armyData then return end

	local nextIndex = armyIndex + ARMY_LENGTH > #armyData and  #armyData or armyIndex + ARMY_LENGTH
	self:createArmyFromIndex( armyIndex, nextIndex,  armyData , fly_height)

	--调整一下游戏背景速度
	local bgSpeed = self:getBgSpeed()
	local bg = self:getChildByTag(TAG_BG)
	if bg and bg.setSpeed then 
		bg:setSpeed(bgSpeed)
	end

	self.isAllDead_ = false
end

function GameScene:isBossLevel()
	local world = GameData:getInstance():getWorld()
	local level = GameData:getInstance():getLevel()

	local flag = false
	local bossTbl = { 5,3,2,3,3 }

	if level == bossTbl[world] then
		flag = true
	end

	return flag
end

function GameScene:getBgSpeed()
	local speed = 1

	--最快到8
	return (0-speed)
end

function GameScene:getArmySpeed()
	--根据排名来获得分数
	local speed = 3
	--最大到三十
	return (0-speed)
end

function GameScene:onCut(  )
	if not self:getChildByTag(TAG_CUT) then 
		__G__MenuClickSound()
		self:hideUI()
		self.gameLayer_:setTouchEnabled(false)	
		self.cutBtn_:setTouchEnabled(false)
		local layer = __G__createCutLayer( "Layer/ResumeLayer.csb" )
		self:addChild(layer, 100, TAG_CUT)
		__G__actDelay(self, function (  )
			
			display.pause()
		end,0.2)

	end
end

--暂停的回调方法-----
function GameScene:onResume()
	__G__MenuCancelSound()
	display.resume()
	self:showUI()
	self.gameLayer_:setTouchEnabled(true)
	self:removeChildByTag(TAG_CUT, true)
	self.cutBtn_:setTouchEnabled(true)

end

function GameScene:onRestart()
	display.resume()
	__G__MenuCancelSound()
	GameData:getInstance():reset()
	self:getApp():enterLoading("SelectScene")

end


function GameScene:onMenu()
	display.resume()
	__G__MenuCancelSound()
	self:getApp():enterLoading("MainMenu")
end

--------------------------------

function GameScene:startGame()
	-- audio.stopMusic()
	__G__GameBgm(GameData:getInstance():getWorld(), GameData:getInstance():getLevel())
	self:showUIWithAnimation()
	self:onUpdate(handler(self, self.step))
	self:onCreateArmy()
end

function GameScene:onEnter()
	GameData:getInstance():resetGameTime()
	-- armySet = {}
	-- score = 0
	self:unUpdate()

	-- self:hideUI()
	--首先展示一下文本
	-- self:showLevelTitle()
	
--背景淡入
	local bg = self:getChildByTag(TAG_BG)
	bg:opacity(0)
	bg:fadeIn(2)
	__G__actDelay(self,function (  )
		self:showAdsLayer()
		self:startGame()
	end, 2)
end

function GameScene:showAdsLayer()
	local layer = display.newLayer(display.COLOR_DARK)
	__G__actDelay(self,function (  )
		layer:removeSelf()
	end,5)

	
	self:add(layer,999)
end

function GameScene:onExit()
	self.gameLayer_:removeKeypad()
	self.gameLayer_:removeAccelerate()
	self:unUpdate()

end


return GameScene