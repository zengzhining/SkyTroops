module("Helper", package.seeall)

--上下漂移浮动
function floatObject( obj, time )
	if not time then 
		time = 1.0
	end
	local a = CCRepeatForever:create(cc.Sequence:create(
		cc.EaseIn:create( cc.MoveBy:create(time, cc.p( 0, 4 )), 1.5),
		cc.EaseOut:create( cc.MoveBy:create(time, cc.p( 0, 4 )), 1.5),
		cc.EaseIn:create( cc.MoveBy:create(time, cc.p( 0, -4 )), 1.5),
		cc.EaseOut:create( cc.MoveBy:create(time, cc.p( 0, -4 )), 1.5)
		))
	obj:runAction(a)
end

--淡入淡出
function fadeObj( obj, time )
	if not time then 
		time = 1.0
	end

	local seq = cc.Sequence:create(
		cc.EaseOut:create( cc.FadeOut:create(time), 1.5 ),
		cc.EaseIn:create( cc.FadeIn:create(time), 1.5 )
		)
	obj:runAction(cc.RepeatForever:create(seq))
end

function showParticle( layer, point, fileName )
	local emitter = particle.createParticle( fileName)
	emitter:pos(point)
	layer:add(emitter,999)
	return emitter
end
--显示一个粒子特效
function showClickParticle( layer, point )
	showParticle(layer, point, "Particles/LavaFlow.plist")
end

--显示一个切换特效
function showChangeParticle(layer, point)
	showParticle(layer, point, "Particles/change.plist")
end

--显示一个炸弹特效
function showBoomParticle(layer)
	-- for i = 1, 6 do
		local point = cc.p( display.width * 0.5, display.cy )
		local emitter = showParticle(layer, point, "Particles/dead/sudder.plist")
		-- local dir = i > 4 and 1 or -1
		-- local moveUp = cc.EaseIn:create(cc.MoveBy:create(0.3, cc.p(0, dir * display.height * 1.5) ) , 1.5)
		-- local act = cc.Sequence:create(cc.DelayTime:create(1)  ,cc.RemoveSelf:create(true) )
		-- emitter:runAction(act)
	-- end
end

--boss死亡时候的特效
function showBossDeadParticle(layer)
	local path = "Particles/dead/star.plist"
	for i = 1, 3 do 
		local point = cc.p( display.width/4 * i, display.cy )
		local emitter = showParticle(layer, point,path )
		emitter:stopSystem()
		__G__actDelay(layer, function (  )
			emitter:resetSystem()
			local act = cc.Sequence:create( cc.DelayTime:create(1), cc.RemoveSelf:create(true) )
			emitter:runAction(act)
		end, i*0.1)
	end

	for i = 1,2 do
		local point = cc.p( display.width/3 * i, display.cy * 1.5 )
		local emitter = showParticle(layer, point, path)
		-- emitter:stopSystem()
		local act = cc.Sequence:create( cc.DelayTime:create(1), cc.RemoveSelf:create(true) )
		emitter:runAction(act)
	end

	for i = 1,2 do
		local point = cc.p( display.width/3 * i, display.cy * 0.5 )
		local emitter = showParticle(layer, point, path)
		-- emitter:stopSystem()
		local act = cc.Sequence:create( cc.DelayTime:create(1), cc.RemoveSelf:create(true) )
		emitter:runAction(act)

	end
end

--发送一个post
function postMessageAndGetJson( url,data, successCallback )
	local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    xhr:open("POST", url)

    local function onReadyStateChanged()
    	
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            local response   = xhr.response
            print("response~~~~~~~", response)
            local output = json.decode(response,1)

            if successCallback then
	    		successCallback( output )
	    	end
            
        else
            print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
        end
        xhr:unregisterScriptHandler()
    end

    xhr:registerScriptHandler(onReadyStateChanged)
    xhr:send(data)
end

--单纯发送数据
function postMessage(url,data)
	local xhr = cc.XMLHttpRequest:new()
    xhr:open("POST", url)
    xhr:send(data)
end

--单纯获得数据
function getJson(url, callback)
	return postMessageAndGetJson( url,nil,callback )
end


