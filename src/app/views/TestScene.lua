
local TestScene = class("TestScene", cc.load("mvc").ViewBase)

function TestScene:ctor()
	display.loadSpriteFrames("Planes.plist", "Planes.png")
	local layer = display.newLayer()
	layer:onAccelerate(function(x,y,z,timeStap)
		print("x,y,z,timeStap~~~~~~~~",x, y, z, timeStap)
	end)

	--test keycode
	layer:onKeypad(function( event )
		
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
    	dump(data)
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
	-- local title = display.newTTF("Pixel.ttf", 48, "Hello World")
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
	
	local controlLayer = PlaneFactory:getInstance():createJoy("ui/bg.png", "ui/btn.png")
	self:add(controlLayer)

	local mainPlane = PlaneFactory:getInstance():createRole(1)
	mainPlane:pos(display.center)
	layer:add(mainPlane)

	mainPlane:attachVirtualJoy(controlLayer)

	



end

return TestScene