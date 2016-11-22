local MainMenu = class("MainMenu", cc.load("mvc").ViewBase)

MainMenu.RESOURCE_FILENAME = "MainMenu.csb"
function MainMenu:onCreate()
	-- body
	local root = self:getResourceNode()

	self:enableNodeEvents()

	local layer = display.newLayer()

	layer:onTouch(function (event  )
		--记得去除掉触摸
		layer:removeTouch()
		-- self:getApp():enterScene("GameScene")
		__G__MenuClickSound()
		__G__MusicFadeOut(self, 1)
		__G__actDelay(self, function (  )
			self:getApp():enterLoading("SelectScene")
		end, 1)

		--展示一个粒子
		Helper.showClickParticle( layer, cc.p( event.x, event.y ) )
	end, false, false)
	self:add(layer,1)

	local bg = __G__createBg( "Layer/BackGround.csb" )
	bg:setSpeed(-5)
	self:add(bg, -1)
end

function MainMenu:onEnter()
	math.randomseed(os.time())
	local root = self:getResourceNode()

	local hint = root:getChildByName("Hint")
	Helper.fadeObj(hint)
	
	__G__MainMusic(math.random(1,2))
end

function MainMenu:onExit(  )
	self:unUpdate()
end

return MainMenu