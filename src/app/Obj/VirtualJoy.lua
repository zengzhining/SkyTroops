local VirtualJoy = class("VirtualJoy", function (  )
	return display.newLayer()
end)

function VirtualJoy:ctor( bgFile, controlFile )
	local bg = display.newSprite(bgFile)
	bg:pos(display.cx, display.cy * 0.2)
	self:add(bg)
	local size = bg:getContentSize()


	local btn = display.newSprite(controlFile)
	btn:pos(size.width*0.5, size.height*0.5)
	btn:setAnchorPoint(cc.p(0.5, 0.5))
	btn.originPos_ = cc.p(size.width*0.5, size.height*0.5)
	bg:add(btn)

	self:initData()

	local radius = size.width * 0.5

	local function getNewPos( pos_, length , originPos)
		local finalPosX = radius * (pos_.x - originPos.x )/length
		local finalPosY = radius * (pos_.y - originPos.y )/length
		local finalPos = cc.p( originPos.x + finalPosX, originPos.y + finalPosY )
		return finalPos
	end

	self:onTouch(function ( event )
		local point = cc.p(event.x, event.y)
		local rect = bg:getBoundingBox()
		local isContain = cc.rectContainsPoint(rect, point)
		local newPos = bg:convertToNodeSpace(point)

		local distance = cc.pGetDistance(newPos, btn.originPos_)
		local isInCircle = distance <= radius
		if event.name == "began" then 
			if isInCircle then
				btn:pos(newPos)
				return true
			end
		end

		if event.name == "moved" then 
			local finalPos = newPos
			if not isInCircle then
				finalPos = getNewPos(newPos, distance,btn.originPos_)
			end
			btn:pos(finalPos)

			local deltaPoint = cc.pSub(finalPos,btn.originPos_)
			local strength = cc.pNormalize(deltaPoint)
			self:setStrength(strength)
		end

		if event.name == "ended" then 
			btn:pos(btn.originPos_)
			self:resetStrength()
		end
	end)
end

function VirtualJoy:initData()
	--控制的力度，分为左右上下，-1 ~ 1
	self.strength_ = cc.p(0,0)
end

function VirtualJoy:getStrength()
	return self.strength_
end

function VirtualJoy:resetStrength()
	self:setStrength(cc.p(0,0))
end

function VirtualJoy:setStrength( strength )
	self.strength_ = strength
end

return VirtualJoy