GameData = class("GameData")

local MAX_RANK = 100
local BG_SPEED = 10

local DEFAULT_ROLE = 1
local DEFAULT_LEVEL = 1

local DEFAULT_WORLD = 1

local DEFAULT_BOMB = 3 --默认炸弹个数
local MAX_BOMB = 6

local MAX_WORLD = 5

local KEY_ALL_SCORE = "ALL_SCORE"

function GameData:ctor()
	self:initData()

	self:load()
	--因为到读取大量文件
	--只有进行第一次初始化时候才进行读取配置文件
	-- self:loadConfig()
end

function GameData:loadConfig()
	for i = 1, MAX_LEVEL do
		local fileName = string.format("config/army%02d.plist",i)
		if gameio.isExist(fileName) then 
			local armyConfig = gameio.getVectorPlistFromFile(fileName)
			if armyConfig then 
				table.insert(self.armyConfig_, armyConfig)
			end
		else
			--一定是从1开始的,所以如果到这里代表没了那个文件
			break
		end
	end

	if DEBUG == 2 then 
		print("armyConfig==============")
		-- dump(self.armyConfig_)
	end
end

function GameData:getArmyConfig(world, id )
	local fileName = string.format("config/level%02d/army%02d.plist",world, id)
	if gameio.isExist(fileName) then
		local armyConfig = gameio.getVectorPlistFromFile(fileName)
		return armyConfig
	else
		error("not File"..fileName)
	end
end

function GameData:initData()
	--游戏背景移动速度
	self.bgSpeed_ = BG_SPEED

	--游戏速度
	self.gameSpeed_ = 1.0
	--角色id
	self.roleId_ = self.roleId_ or DEFAULT_ROLE

	--炸弹个数
	self.bombNum_ = DEFAULT_BOMB

	--敌人配置
	self.armyConfig_ = self.armyConfig_ or {}

	--关卡数
	self.level_ = DEFAULT_LEVEL

	--世界数目
	self.worldNum_ = self.worldNum_ or DEFAULT_WORLD

	--全局的主角
	self.role_ = nil

	--游戏一次运行时候的分数
	self.score_ = 0
	--游戏获得的总分数
	self.allScore_ = self.allScore_ or 0

	self.gameTime_ = os.time()

	self.armyKill_ = 0
end
--读取和存储游戏数据
function GameData:load()
    --获得总的分数
    local allScore = userDefault.getIntegerForKey(KEY_ALL_SCORE, 0)
    self:setAllScore(allScore) 
end

function GameData:save()
	local fileUtils = cc.FileUtils:getInstance()
	local writePath = fileUtils:getWritablePath()
	userDefault.setIntegerForKey(KEY_ALL_SCORE, self:getAllScore() )
end

--------------level----------------
function GameData:resetLevel()
	self.level_ = 1
end

function GameData:getLevel()
	return self.level_
end

function GameData:addLevel( num )
	self.level_ = self.level_ + 1
end

function GameData:getMaxLevel()
	return MAX_LEVEL
end

----------------WORLD-----------------
function GameData:resetWorld()
	self.worldNum_ = DEFAULT_WORLD
end

function GameData:getWorld()
	return self.worldNum_
end

function GameData:addWorld(num)
	self.worldNum_ = self.worldNum_ + 1
end

function GameData:getMaxWorld()
	return MAX_WORLD
end

----------------bomb---------------------------
function GameData:setBomb(num)
	self.bombNum_ = num
end

function GameData:getBomb()
	return self.bombNum_
end

function GameData:addBomb(num)
	local finalBomb = self.bombNum_ + num
	self.bombNum_ = finalBomb > MAX_BOMB and MAX_BOMB or finalBomb
end

function GameData:minBomb(num)
	local finalBomb = self.bombNum_ - num
	self.bombNum_ = finalBomb >= 0 and finalBomb or 0
end

----------------bomb---------------------------

----------------Game Time --------------------
function GameData:addGameTime(time)
	self.gameTime_  = self.gameTime_ + time
end

function GameData:getGameTime()
	local time = os.time()
	return time - self.gameTime_
end

function GameData:resetGameTime()
	self.gameTime_ = os.time()
end
----------------Game Time END --------------------

function GameData:resetKillNum()
	self.armyKill_ = 0
end

function GameData:addKillNum(num)
	if not num then num = 1 end
	self.armyKill_ = self.armyKill_ + num 
end

function GameData:getKillNum()
	return self.armyKill_
end


function GameData:reset()
	self:initData()
end

function GameData:setRoleId( id_ )
	self.roleId_ = id_
end

function GameData:getRoleId()
	return self.roleId_
end

function GameData:setRole( role )
	self.role_ = role
end

function GameData:getRole()
	return self.role_
end

function GameData:setGameSpeed(speed_)
	self.gameSpeed_ = speed_
end

function GameData:getGameSpeed()
	return self.gameSpeed_
end

function GameData:setBgSpeed( speed )
	self.bgSpeed_ = speed
end

function GameData:addBgSpeed( speed )
	self.bgSpeed_ = self.bgSpeed_ + speed
end

function GameData:getBgSpeed()
	return self.bgSpeed_
end

function GameData:setScore( score )
	self.score_ = score
end

function GameData:addScore( score )
	self.score_ = self.score_ + score
end

function GameData:getScore()
	return self.score_
end

function GameData:getHighScore()
	local key = "high_score"
	local score = userDefault.getIntegerForKey(key, 0)
	score = score > self:getScore() and score or self:getScore()
	userDefault.setIntegerForKey(key, score)
	return score
end

---------all Score
function GameData:setAllScore( score )
	self.allScore_ = score
end

function GameData:addAllScore( score )
	self.allScore_ = self.allScore_ + score
end

function GameData:getAllScore()
	return self.allScore_
end

-----单例
local gamedata_instance = nil
function GameData:getInstance()
	if not gamedata_instance then 
		gamedata_instance = GameData.new()
	end

	GameData.new = function (  )
		error("GameData Cannot use new operater,Please use getInstance")
	end

	return gamedata_instance
end