module("Effect", package.seeall)

local scheduler = cc.Director:getInstance():getScheduler()
function createGLState(vertFile, fragFile)
	local shader = cc.GLProgram:createWithFilenames(vertFile, fragFile)
	local state = cc.GLProgramState:getOrCreateWithGLProgram(shader)
	return state
end
--变成正常颜色
function colorSprite( obj )
	local state = cc.GLProgramState:getOrCreateWithGLProgramName(cc.shaders.SHADER_NAME_POSITION_TEXTURE_COLOR_NO_MVP)
	obj:setGLProgramState(state)
end

--特效，置灰
function getGreyState()
	local state = createGLState("shaders/P_stand.vert", "shaders/grey.frag")
	return state
end

function greySprite( obj )
	local state = getGreyState()
	state:setUniformFloat("uNumber",tonumber(1))
	obj:setGLProgramState(state)
end

--特效，根据时间置灰
function greyTo(obj, time)
	if not time then time = 1 end
	local schduleFunc = nil
	--每次动作之间的时间间隔
	local DELTA_TIME = 0.1
	local AllTimes = time/DELTA_TIME
	local num = 0
	local perColor = 1/AllTimes
	local function update(dt)
		num = num + 1
		local state = getGreyState()
		state:setUniformFloat("uNumber",tonumber(perColor * num))
		obj:setGLProgramState(state)
		if num >= AllTimes then 
			greySprite(obj)
			scheduler:unscheduleScriptEntry(schduleFunc)
			schduleFunc = nil
		end
	end
	schduleFunc = scheduler:scheduleScriptFunc(update, DELTA_TIME, false  )
end

--变灰之后恢复
function colorTo(obj, time)
	if not time then time = 1 end
	local schduleFunc = nil
	--每次动作之间的时间间隔
	local DELTA_TIME = 0.1
	local AllTimes = time/DELTA_TIME
	local num = 0
	local perColor = 1/AllTimes
	local function update(dt)
		num = num + 1
		local state = getGreyState()
		state:setUniformFloat("uNumber",tonumber(1- perColor* num) )
		obj:setGLProgramState(state)
		if num >= AllTimes then 
			colorSprite(obj)
			scheduler:unscheduleScriptEntry(schduleFunc)
			schduleFunc = nil
		end
	end
	schduleFunc = scheduler:scheduleScriptFunc(update, DELTA_TIME, false  )
end

--HUE
function hueSprite(obj)
	local state = createGLState("shaders/P_stand.vert", "shaders/Hue.frag")
	obj:setGLProgramState(state)
end

--bloom
function bloomSprite(obj)
	local state = createGLState("shaders/P_stand.vert", "shaders/BloomUp.frag")
	obj:setGLProgramState(state)
end

--模糊特效
function blurSprite(obj)
	local state = createGLState("shaders/P_stand.vert", "shaders/Blur.frag")
	obj:setGLProgramState(state)
end

--测试
function testSprite(obj)
	local state = createGLState("shaders/P_stand.vert", "shaders/test.frag")
	obj:setGLProgramState(state)
end


