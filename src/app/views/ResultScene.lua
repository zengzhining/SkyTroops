local ResultScene = class("ResultScene", cc.load("mvc").ViewBase)

ResultScene.RESOURCE_FILENAME = "Layer/GameOver.csb"

local TAG_BG = 101
local TAG_UNLOCK = 102

local ROLE_SCORE_TBL = {  
	1000,3000,5000,10000,50000
 }

 local MAX_SCORE = 69000

 local lastAllScore = 0

 local scoreNum = 0

local pauseFlag = false
function ResultScene:onCreate(  )
	__G__LoadRes()
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

	local gameTimeLb = root:getChildByName("time")

	local gameTime = GameData:getInstance():getGameTime()
	local min = math.floor(gameTime/60)
	local sec = gameTime % 60
	local timeStr = string.format("%02d:%02d", min, sec)
	gameTimeLb:setString(timeStr)

	local enemyKillLb = root:getChildByName("killNum")

	local killNum = GameData:getInstance():getKillNum()
	enemyKillLb:setString(killNum)

	local scoreLb = root:getChildByName("Score")
	scoreLb:setString(tostring(GameData:getInstance():getScore()))

	local expBar = root:getChildByName("ExpBar")
	local expNum = root:getChildByName("ExpNum")
	self.expBar_ = expBar
	self.expNum_ = expNum

	pauseFlag = false
	lastAllScore = 0
	--这里更新一下总分数
	lastAllScore = GameData:getInstance():getAllScore()


	scoreNum = lastAllScore
	GameData:getInstance():addAllScore(GameData:getInstance():getScore())
	-- GameData:getInstance():addAllScore(10000)
	GameData:getInstance():setAllScore(0)
	GameData:getInstance():reset()
	
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

function ResultScene:onUnlockClose(  )
	pauseFlag= false
end

function ResultScene:showUnlock(id_)
	if not self:getChildByTag(TAG_UNLOCK) then
		local layer = __G__createUnLockLayer("Layer/UnlockLayer.csb")
		self:add(layer,100,TAG_UNLOCK)

		if id_ <= 6 then
			local plane = PlaneFactory:getInstance():createRole(id_)
			plane:pos(display.cx, display.cy*1.2)
			layer:add(plane)
		end
	end
end

function ResultScene:step( dt )
	if pauseFlag then return end
	--首先算出下个等级需要的分数
	local AllLevelNum = 0
	--找到最近一个等级的分数
	local levelNum = 0

	local unlockId = 0

	for i,num in pairs(ROLE_SCORE_TBL) do
		AllLevelNum = AllLevelNum + num
		if AllLevelNum > lastAllScore then 
			levelNum = num
			unlockId = i+1
			break
		end
	end

	if unlockId == 0 then
		return 
	end
	if unlockId > #ROLE_SCORE_TBL + 1 then
		pauseFlag = true
		return 
	end


	local score = GameData:getInstance():getAllScore()

	if scoreNum >= score then
		scoreNum=score
	else
		scoreNum = scoreNum + 10
	end
	
	local delScore = scoreNum-AllLevelNum+levelNum

	if  scoreNum > MAX_SCORE then
		scoreNum = MAX_SCORE
	end

	local str = string.format("%d/%d", scoreNum, AllLevelNum)
	self.expNum_:setString(str)
	self.expBar_:setPercent(delScore/levelNum * 100)

	if  scoreNum <= MAX_SCORE and scoreNum >= AllLevelNum then 

		lastAllScore = scoreNum

		pauseFlag = true
		self:showUnlock(unlockId)
	end

end

function ResultScene:onEnter()
	__G__MainMusic(3)	
	-- __G__actDelay(self, function (  )
		
	self:onUpdate(handler(self, self.step))
	-- end,2)

end

function ResultScene:onExit()
	self:unUpdate()
end



return ResultScene 