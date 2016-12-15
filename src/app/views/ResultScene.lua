local ResultScene = class("ResultScene", cc.load("mvc").ViewBase)

ResultScene.RESOURCE_FILENAME = "Layer/GameOver.csb"

local TAG_BG = 101

local ROLE_SCORE_TBL = {  
	200,500,1000,2000,5000
 }

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

	local scoreLb = root:getChildByName("Score")
	scoreLb:setString(tostring(GameData:getInstance():getScore()))

	local expBar = root:getChildByName("ExpBar")
	local expNum = root:getChildByName("ExpNum")

	--这里更新一下总分数
	local lastAllScore = GameData:getInstance():getAllScore()

	-- GameData:getInstance():addAllScore(GameData:getInstance():getScore())
	GameData:getInstance():addAllScore(GameData:getInstance():getScore())

	local allScore = GameData:getInstance():getAllScore()

	local levelNum = 0
	for i,num in pairs(ROLE_SCORE_TBL) do
		levelNum = levelNum + num
		if levelNum > allScore then 
			break
		end
	end

	local str = string.format("%d/%d", allScore, levelNum)
	expNum:setString(str)
	expBar:setPercent(allScore/levelNum * 100)
	

	GameData:getInstance():save()
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
	__G__MainMusic(1)		
end

function ResultScene:onExit()

end



return ResultScene 