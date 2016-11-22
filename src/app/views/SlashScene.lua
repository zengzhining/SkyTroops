--开屏的动画
local SlashScene = class("SlashScene", cc.load("mvc").ViewBase)

function SlashScene:onCreate()
	-- body
	local layer = display.newLayer(display.COLOR_WHITE)
	self:add(layer)
	local str = "Pure Studio"
	local title = display.newTTF("Pixel.ttf", 72, str)
	title:setColor(display.COLOR_BLACK)
	title:pos(display.cx, display.cy)
	layer:add(title)
end

function SlashScene:onEnter()
	__G__actDelay(self, function (  )
		self:getApp():enterScene("MainMenu")
	end, 3)
end

function SlashScene:onExit()

end

return SlashScene