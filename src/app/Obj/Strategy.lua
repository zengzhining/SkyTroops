--策略，用在敌人AI
local Strategy = class("Strategy")

local AI_TIME = 0.5

local AI_WIDTH = 50

function Strategy:ctor( id_ )
	self.id_ = id_

	self:initData()
end

function Strategy:getAiId(  )
	return self.id_
end

function Strategy:initData(  )
	self.hasUseAi_ = false

	self.aiTime_ = 0

	self.aiTimeLimit_ = AI_TIME

	self.aiWidth_ = AI_WIDTH
end

-----------AI WIDTH----------------
function Strategy:setAiWidth(width)
	self.aiWidth_ = width
end

function Strategy:getAiWidth()
	return self.aiWidth_
end

function Strategy:useAi(  )
	self.hasUseAi_ = true
end

--是否使用了Ai
function Strategy:hasUseAi(  )
	return self.hasUseAi_
end

-----------------Ai Time---------
function Strategy:addAiTime(dt)
	self.aiTime_ = self.aiTime_+ dt
end

function Strategy:getAiTime()
	return self.aiTime_
end

function Strategy:setAiTimeLimit( time )
	self.aiTimeLimit_ = time
end

function Strategy:resetAiTime()
	self.aiTime_ = 0
end

function Strategy:canAi()
		--3s 才能使用一个ai
	if self.id_ >= 4 and self.id_ <= 5 then
		return self.aiTime_ >= self.aiTimeLimit_
	end
end

return Strategy