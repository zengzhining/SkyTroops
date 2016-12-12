--策略，用在敌人AI
local Strategy = class("Strategy")

function Strategy:ctor( id_ )
	self.id_ = id_

	self:initData()
end

function Strategy:getAiId(  )
	return self.id_
end

function Strategy:initData(  )
	self.hasUseAi_ = false
end

function Strategy:useAi(  )
	self.hasUseAi_ = true
end

--是否使用了Ai
function Strategy:hasUseAi(  )
	return self.hasUseAi_
end

return Strategy