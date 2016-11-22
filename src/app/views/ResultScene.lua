local ResultScene = class("ResultScene", cc.load("mvc").ViewBase)

ResultScene.RESOURCE_FILENAME = "Layer/GameOver.csb"

local TAG_BG = 101

function ResultScene:onCreate(  )
	-- body
	local root = self:getResourceNode()
	local Retry = root:getChildByName("Retry")
	Retry:onTouch(function ( event )
		if event.name == "ended" then
			__G__MenuCancelSound()
			local scene = root:getParent()
			if scene and scene.onRetry then 
				scene:onRetry()
			end		
		end
	end, false, true)

	local exit = root:getChildByName("Exit")
	exit:onTouch(function ( event )
		if event.name == "ended" then
			__G__MenuCancelSound()
			local scene = root:getParent()
			if scene and scene.onGameExit then 
				scene:onGameExit()
			end		
		end
	end,  false, true)

	local rankLb = root:getChildByName("Rank")
	rankLb:setString(tostring(GameData:getInstance():getRank()))

	local scoreLb = root:getChildByName("Score")
	scoreLb:setString(tostring(GameData:getInstance():getScore()))

	local bg = __G__createBg( "Layer/BackGround.csb" )
	self:addChild(bg, -1,TAG_BG)

end

function ResultScene:onRetry(  )
	local callback = function ()
		__G__actDelay(self, function()
				self:getApp():enterLoading("GameScene" )
		end, 0.2)
	end

	--重置游戏数据
	GameData:getInstance():reset()

	callback()
end

function ResultScene:onGameExit()
	display.exit()
end

function ResultScene:onEnter()
	__G__MainMusic(3)		
end

function ResultScene:onExit()

end



return ResultScene 