local GameEndScene = class("GameEndScene", cc.load("mvc").ViewBase)

function GameEndScene:onCreate()
	local layer = display.newLayer(display.COLOR_WHITE)
	self:add(layer)
	local str = "Thanks For Your Play."
	local title = display.newTTF("fonts/pen.ttf", 72, str)
	title:setColor(display.COLOR_BLACK)
	title:pos(display.cx, display.cy)
	layer:add(title)

	Helper.floatObject(title)

end

function GameEndScene:onEnter()
	print("onEnter~~~~~")

	__G__actDelay(self, function (  )
		self:getApp():enterLoading("MainMenu")
	end, 5)
end

return GameEndScene