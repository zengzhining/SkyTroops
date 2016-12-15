local MainMenu = class("MainMenu", cc.load("mvc").ViewBase)

MainMenu.RESOURCE_FILENAME = "Layer/MainMenu.csb"
function MainMenu:onCreate()
	self:enableNodeEvents()
	-- body
	local root = self:getResourceNode()
	
	local startBtn = root:getChildByName("Start")
	startBtn:onClick(function ( sender )
		self:getApp():enterLoading("SelectScene")
	end)

	local bg = root:getChildByName("Bg")

	

end

function MainMenu:onEnter()
	__G__MainMusic(1)
end

function MainMenu:onExit(  )
	self:unUpdate()
end

return MainMenu