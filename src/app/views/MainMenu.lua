local MainMenu = class("MainMenu", cc.load("mvc").ViewBase)

MainMenu.RESOURCE_FILENAME = "Layer/MainMenu.csb"
function MainMenu:onCreate()
	self:enableNodeEvents()
	-- body
	local root = self:getResourceNode()
	
	local startBtn = root:getChildByName("Start")
	startBtn:hide()
	startBtn:onClick(function ( sender )
		local size = startBtn:getSize()
		Helper.showClickParticle(startBtn, cc.p(size.width * 0.5, size.height * 0.5))
		__G__actDelay(self,function (  )
			
			self:getApp():enterLoading("SelectScene", "FULLAD")
		end, 1)
	end)

	local bg = root:getChildByName("bg")
	bg:setOpacity(0)

	

end

function MainMenu:onEnter()
	__G__MainMusic(2)
	local root = self:getResourceNode()
	local bg = root:getChildByName("bg")
	bg:runAction(cc.FadeIn:create(1))

	local startBtn = root:getChildByName("Start")
	startBtn:runAction(cc.Sequence:create( cc.Hide:create(), cc.DelayTime:create(0.5), cc.Show:create() ))
	Helper.floatObject(startBtn)
	-- startBtn:posByX(display.width)
	-- startBtn:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.MoveBy:create(0.5,cc.p( -display.width,0 ))))
end

function MainMenu:onExit(  )
	self:unUpdate()
end

return MainMenu