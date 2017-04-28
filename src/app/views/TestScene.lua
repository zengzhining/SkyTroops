
local TestScene = class("TestScene", cc.load("mvc").ViewBase)

local TAG_BULLET = 202


function TestScene:ctor()
	__G__LoadRes()
	local layer = display.newLayer()
	layer:onAccelerate(function(x,y,z,timeStap)
		print("x,y,z,timeStap~~~~~~~~",x, y, z, timeStap)
	end)

	--testJson
    require('cocos.cocos2d.json')
    local tbl = {}
    for i = 1, 100 do
    	local score = (101 - i)* 50
    	table.insert( tbl, score )
    end

    local text = json.encode(tbl)
    print("text~~~~", text)
    local fileUtils = cc.FileUtils:getInstance()
    local writePath = fileUtils:getWritablePath()
    print("writePath~~~~~", writePath)
    local isSuccess = fileUtils:writeValueVectorToFile( tbl, writePath.."score.plist")
    print("isSuccess~~~~", isSuccess)

    if isSuccess then 
    	local data = fileUtils:getValueVectorFromFile(writePath.."score.plist")
    end

    local decodeTbl = json.decode(text)
	--remove
	-- layer:removeKeypad()
	

	--竖屏
	-- x > 0.5 为向右旋转
	--  y> 0.5 为向前旋转

	--test emitter
	

	self:add(layer)

	--test label
	-- local title = display.newTTF("fonts/allura.otf", 48, "Pure Studio")
	-- title:pos(display.cx, display.cy)
	-- self:addChild(title)

	--生成plist文字
	-- local tbl = {"hello","World"}
	-- local isSuccess = gameio.writeVectorPlistToFile( tbl, "./res/gameTips.plist")

	--两个相机
	-- local plane = PlaneFactory:getInstance():createRole(1)
	-- plane:pos(display.cx, display.cy)
	-- plane:setCameraMask(cc.CameraFlag.USER1)
	-- self:addChild(plane)

	-- self:initControl()

	-- local camera = cc.Camera:createOrthographic(display.width, display.height,-11,1000)
	-- camera:setCameraFlag(cc.CameraFlag.USER1)

	-- self:addChild(camera)


	--测试图片的粒子特效
	-- local spTbl = {}
	-- local texture = display.loadImage("png/RedPlane.png")
	-- local size = texture:getContentSize()
	-- local perWidth = size.width / 50
	-- local perHeight = size.height /50
	-- for i = 1, 50 do
	-- 	for j = 1, 50 do
	-- 		local rect = cc.rect(perWidth * (i-1),perHeight * (j-1) ,perWidth,perHeight)
	-- 		local sp = cc.Sprite:createWithTexture(texture, rect)
	-- 		sp:setAnchorPoint(cc.p(0,0))
	-- 		sp:pos(display.cx + perWidth * (i-1), display.cy - perHeight * (j-1) )
	-- 		layer:add(sp)
	-- 		table.insert(spTbl, sp)
	-- 	end
	-- end

	-- for i,plane in pairs (spTbl) do
	-- 	local spawnAct = cc.Spawn:create( cc.MoveBy:create(0.2, cc.p(math.random(-200,200), math.random(-200, 200) )),
	-- 		cc.RotateBy:create(0.2, math.random( 1,180 ))
	-- 	 )
	-- 	local act = cc.Sequence:create(cc.DelayTime:create(i*0.001), spawnAct, cc.Hide:create())
	-- 	plane:runAction(act)
	-- end

	--使用shader
	
	-- local bgLayer = display.newLayer()
	-- self:add(bgLayer)
	-- local bg = display.newSprite("png/01Background.png")

	-- bg:setScaleX(display.width/bg:getContentSize().width)
	-- bg:pos(display.center)
	-- bgLayer:add(bg)

	-- local plane = display.newSprite("png/RedPlane.png")
	-- plane:pos(display.center)
	-- Effect.greySprite(plane)
	-- bgLayer:add(plane)

	-- local plane2 = display.newSprite("png/RedPlane.png")
	-- plane2:pos(display.cx, display.cy + 200)
	-- bgLayer:add(plane2)

	-- plane2:runAction(cc.MoveBy:create(10, cc.p(0, 500)))
	-- -- Effect.colorTo(plane,3)
	-- -- Effect.greyTo(plane2,2)
	-- -- Effect.blurSprite(bg)


	-- --renderTexture
	-- local rx = cc.RenderTexture:create(display.width, display.height)
	-- rx:retain()
	-- rx:begin()
	-- -- bg:visit()
	-- -- plane:visit()
	-- -- plane2:visit()
	-- bgLayer:visit()
	-- rx:endToLua()

	-- bgLayer:onTouch(function ( event )

	-- end)

	-- --可以通过设置相机mask让其不参与绘制
	-- bgLayer:setCameraMask(cc.CameraFlag.USER1)

	-- -- plane:removeSelf()
	-- -- plane2:removeSelf()
	-- -- bg:removeSelf()

	-- local shaderLayer = display.newLayer()
	-- self:add(shaderLayer)
	-- local sp = display.newSprite(rx:getSprite():getTexture())
	-- -- Effect.blurSprite(sp)
	-- -- Effect.testSprite(sp)
	-- Effect.circleOut(sp)
	-- -- Effect.bloomSprite(sp)
	-- sp:setFlippedY(true)
	-- sp:pos(display.center)

	-- shaderLayer:onUpdate(function ( dt )
	-- 	rx:beginWithClear(1, 1, 1, 1)
	-- 	-- bg:visit()
	-- 	-- plane:visit()
	-- 	-- plane2:visit()
	-- 	bgLayer:visit()
	-- 	rx:endToLua()
	-- end)
	
	-- shaderLayer:add(sp)
	

	-- sp:removeSelf()

	-- local nextRx = cc.RenderTexture:create(display.width, display.height)
	-- nextRx:begin()
	-- sp:visit()
	-- nextRx:endToLua()

	-- local mSp = display.newSprite(nextRx:getSprite():getTexture())
	-- mSp:setFlippedY(true)
	-- mSp:pos(display.center)
	-- Effect.bloomSprite(mSp)
	
	-- self:add(mSp)

	-- local mTexture = 


	--add control
	-- local controlLayer = display.newLayer()
	-- self:add(controlLayer)
	-- local bg = display.newSprite("ui/bg.png")
	-- bg:setAnchorPoint(cc.p(0.5, 0.5))
	-- bg:pos(display.cx, display.cy)
	-- controlLayer:add(bg)
	-- local size = bg:getContentSize()

	-- local radius = size.width * 0.5

	-- local btn = display.newSprite("ui/btn.png")
	-- btn:pos(size.width*0.5, size.height*0.5)
	-- btn:setAnchorPoint(cc.p(0.5, 0.5))
	-- btn.originPos_ = cc.p(size.width*0.5, size.height*0.5)
	-- bg:add(btn)

	-- local function getNewPos( pos_, length , originPos)
	-- 	local finalPosX = radius * (pos_.x - originPos.x )/length
	-- 	local finalPosY = radius * (pos_.y - originPos.y )/length
	-- 	local finalPos = cc.p( originPos.x + finalPosX, originPos.y + finalPosY )
	-- 	return finalPos
	-- end

	-- controlLayer:onTouch(function ( event )
	-- 	local point = cc.p(event.x, event.y)
	-- 	local rect = bg:getBoundingBox()
	-- 	local isContain = cc.rectContainsPoint(rect, point)
	-- 	local newPos = bg:convertToNodeSpace(point)

	-- 	local distance = cc.pGetDistance(newPos, btn.originPos_)
	-- 	-- print("distance~~~~", distance)
	-- 	local isInCircle = distance <= radius
	-- 	if event.name == "began" then 
	-- 		if isInCircle then
	-- 			btn:pos(newPos)
	-- 			return true
	-- 		end
	-- 	end

	-- 	if event.name == "moved" then 
	-- 		if isInCircle then
	-- 			btn:pos(newPos)
	-- 		else
	-- 			btn:pos(getNewPos(newPos, distance,btn.originPos_))
	-- 		end
	-- 	end

	-- 	if event.name == "ended" then 
	-- 		btn:pos(btn.originPos_)
	-- 	end
	-- end)
	-- local bgLayer = __G__createPngBg("bg/01Background.png")
	-- bgLayer:setSpeed(-1)
	-- self:add(bgLayer, -2)

	-- local frontBg =  __G__createPngBg( "bg/WhiteCloud.png" )
	-- frontBg:setSpeed(-3)
	-- self:add(frontBg,10)
	--virtual joy
	-- local controlLayer = PlaneFactory:getInstance():createJoy("ui/bg.png", "ui/btn.png")
	-- self:add(controlLayer)

	-- mainPlane:levelUp()
	-- mainPlane:levelUp()

	-- local armyPlane = PlaneFactory:getInstance():createPlane(1)
	-- armyPlane:pos(display.cx, display.cy * 1.5)
	-- layer:add(armyPlane)
	-- armyPlane:playDeadAnimation("PlaneExplose%02d.png")

	-- local bullet = PlaneFactory:getInstance():createBullet(id_)
	-- bullet:pos(display.cx * 1.5, display.cy * 1.5)
	-- layer:add(bullet)

	-- mainPlane:attachVirtualJoy(controlLayer)

	
	--test keycode
	-- layer:onKeypad(function( event )
	-- 	local keycode = event.keycode
	-- 	if keycode == cc.KeyCode.KEY_W then 
	-- 		self:cameraMove(1)
	-- 	elseif keycode == cc.KeyCode.KEY_S then 
	-- 		self:cameraMove(-1)
	-- 	end
	-- end)

	--label fnt
	-- local lb = display.newBMF("fonts/myFont.fnt", "Test")
	-- lb:pos(display.center)
	-- layer:add(lb)

	local tbl = {}

	-- local bullet = PlaneFactory:getInstance():createItem(1)
	-- bullet:pos(display.center)
	-- layer:add(bullet)
	

	-- local mainPlane

	-- Helper.showBossDeadParticle(layer, display.center)

	-- __G__FireBullet()

	local plane = PlaneFactory:getInstance():createEnemy(11)
	plane:pos(display.center)
	layer:add(plane,10)

	--拖尾
	-- local ms = cc.MotionStreak:create(0.5, 5, 20, display.COLOR_RED, "png/streak.png")
	-- ms:pos(display.center)
	-- ms:runAction(cc.MoveBy:create(1, cc.p(100,0)))
	-- layer:add(ms)

	-- layer:onTouch( function ( event )
	-- 	local x,y = event.x ,event.y
	-- 	ms:pos(x,y)
	-- end )

--http
	--post Data
	-- Helper.postMessage("http://codinggamer.net/test.php","x=100&y=1000&name='chun'&level=1")

	--getJson Data
	-- Helper.getJson("http://codinggamer.net/getData.php", function ( data )
	-- 	print("data~~~~~", data)
	-- 	print("data[1]~~~",data["1"])
	-- 	for index, info in pairs (data) do
	-- 		local bullet = display.newTTF(nil,nil,info.name)
	-- 		bullet:setColor(cc.c4f(255, 0, 0, 0))
	-- 		-- local bullet = PlaneFactory:getInstance():createItem(1)
	-- 		bullet:pos(info.x,info.y)
	-- 		layer:add(bullet)
	-- 	end
	-- end )

	self.gameLayer_ = layer
end

function TestScene:onEnemyFire( enemy, bulletId )
	print("onEnemyFire~~~~")
	local gameLayer = self.gameLayer_
	local posx,posy = enemy:getPosition()
	local aiId = enemy:getAiId()
	if aiId == 5 then 
		--发射散弹
		self:fireBullet(2, enemy, bulletId)
	elseif aiId == 6 then
		--发射两列子弹
		self:fireBullet(4, enemy, bulletId)
	elseif aiId == 9 then 
		self:fireBullet(4, enemy, bulletId )
	elseif aiId == 13 then
		--发射散弹
		self:fireBullet(2, enemy, bulletId)
	elseif aiId == 14 then
		--发射两列子弹
		self:fireBullet(4, enemy, bulletId)
	elseif aiId == 15 then
		--发射跟随子弹
		self:fireBullet(6, enemy, bulletId)
	elseif aiId == 21 then
		--大boss1,发射面向主角的散弹
		self:fireBullet(7, enemy, bulletId)
	elseif aiId == 22 then
		--大boss2,发射主角的散列散弹
		self:fireBullet(8, enemy, bulletId)

	else
		--普通发射
		self:fireBullet(1,enemy, bulletId)
	end
end

--发射子弹方法
function TestScene:fireBullet( typeId_ , enemy , bulletId)
	local gameLayer = self.gameLayer_
	local posx,posy = enemy:getPosition()
	local bulletY = posy - enemy:getViewRect().height *0.05
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
	end

end


function TestScene:cameraMove(speed)
	local camera = display.getDefaultCamera()
	-- camera:posByY(speed * display.cy)
	local act = cc.MoveBy:create(0.2, cc.p( 0, speed * display.cy ))
	camera:runAction(act)
end

return TestScene