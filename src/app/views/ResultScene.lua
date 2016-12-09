local ResultScene = class("ResultScene", cc.load("mvc").ViewBase)

ResultScene.RESOURCE_FILENAME = "Layer/GameOver.csb"

local TAG_BG = 101

function ResultScene:onCreate(  )
	-- body
	local root = self:getResourceNode()
	local Retry = root:getChildByName("Restart")
	Retry:onClick(function (  )
			__G__MenuCancelSound()
			local scene = root:getParent()
			if scene and scene.onRetry then 
				scene:onRetry()
			end		
	end)

	local exit = root:getChildByName("Menu")
	exit:onClick(function (  )
		__G__MenuCancelSound()
		local scene = root:getParent()
		if scene and scene.onMenu then 
			scene:onMenu()
		end		
	end)

	local rankLb = root:getChildByName("Rank")
	rankLb:setString(tostring(GameData:getInstance():getRank()))

	local scoreLb = root:getChildByName("Score")
	scoreLb:setString(tostring(GameData:getInstance():getScore()))

end

function ResultScene:onRetry(  )
	local callback = function ()
		__G__actDelay(self, function()
				self:getApp():enterLoading("SelectScene" )
		end, 0.2)
	end

	--重置游戏数据
	GameData:getInstance():reset()

	__G__MenuCancelSound()
	callback()
end

function ResultScene:onMenu()
	__G__MenuCancelSound()
	__G__actDelay(self, function()
			self:getApp():enterLoading("MainMenu")
	end, 0.2)
end

function ResultScene:onEnter()
	__G__MainMusic(3)		
end

function ResultScene:onExit()

end



return ResultScene 