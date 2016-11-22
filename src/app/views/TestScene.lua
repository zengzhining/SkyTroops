local TestScene = class("TestScene", cc.load("mvc").ViewBase)

function TestScene:ctor()
	local layer = display.newLayer()
	layer:onAccelerate(function(x,y,z,timeStap)
		print("x,y,z,timeStap~~~~~~~~",x, y, z, timeStap)
	end)

	--test keycode
	layer:onKeypad(function( event )
		
	end)

	layer:onTouch(function ( event )
		-- local emitter1 = cc.ParticleSystemQuad:create("Particles/LavaFlow.plist")
		-- if event.name == "began" then
		-- 	return true
		-- end
		-- Helper.showClickParticle(layer, cc.p(event.x, event.y))
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
	local spTbl = {}
	local texture = display.loadImage("png/RedPlane.png")
	local size = texture:getContentSize()
	local perWidth = size.width / 50
	local perHeight = size.height /50
	for i = 1, 50 do
		for j = 1, 50 do
			local rect = cc.rect(perWidth * (i-1),perHeight * (j-1) ,perWidth,perHeight)
			local sp = cc.Sprite:createWithTexture(texture, rect)
			sp:setAnchorPoint(cc.p(0,0))
			sp:pos(display.cx + perWidth * (i-1), display.cy - perHeight * (j-1) )
			layer:add(sp)
			table.insert(spTbl, sp)
		end
	end

	for i,plane in pairs (spTbl) do
		local spawnAct = cc.Spawn:create( cc.MoveBy:create(0.2, cc.p(math.random(-200,200), math.random(-200, 200) )),
			cc.RotateBy:create(0.2, math.random( 1,180 ))
		 )
		local act = cc.Sequence:create(cc.DelayTime:create(i*0.001), spawnAct, cc.Hide:create())
		plane:runAction(act)
	end

	-- local function step(dt )
	-- 	-- body
	-- 	width = width + 2
	-- 	sp:setTextureRect(cc.rect(0,0,width,200))
		
	-- end


	-- layer:add(sp)

	-- layer:onUpdate(step)

end

return TestScene