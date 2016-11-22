GameData = class("GameData")

local MAX_RANK = 100
local BG_SPEED = 10

local DEFAULT_ROLE = 1
local DEFAULT_LEVEL = 2

function GameData:ctor()
	self:initData()

	--因为到读取大量文件
	--只有进行第一次初始化时候才进行读取配置文件
	self:loadConfig()
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
		dump(self.armyConfig_)
	end
end

function GameData:getArmyConfig( id )
	if not id then return self.armyConfig_ end
	if self.armyConfig_ and self.armyConfig_[id] then 
		return self.armyConfig_[id]
	else
		print("id ~~~", id)
		error("no army config")
	end
end

function GameData:initData()
	self.score_ = 0
	self.rank_ = MAX_RANK
	self.lastRank_ = MAX_RANK
	--游戏背景移动速度
	self.bgSpeed_ = BG_SPEED

	--游戏速度
	self.gameSpeed_ = 1.0
	--角色id
	self.roleId_ = self.roleId_ or DEFAULT_ROLE

	--排行榜数据
	self.rankInfo_ = nil

	--敌人配置
	self.armyConfig_ = self.armyConfig_ or {}

	--关卡数
	self.level_ = self.level_ or DEFAULT_LEVEL

	self:load()
end
--读取和存储游戏数据
function GameData:load()
    local fileUtils = cc.FileUtils:getInstance()
	local writePath = fileUtils:getWritablePath()
	local path = writePath.."score.plist"
    local data = nil
    if io.exists(path) then 
    	data = fileUtils:getValueVectorFromFile(path)
    else
		data = fileUtils:getValueVectorFromFile("score.plist")
	end
	self.rankInfo_ = data
end

--插入分数
function GameData:insertRank( pos,score )
	if pos > 1 and pos < 100 then 
		for i = 100,pos,-1 do
			self.rankInfo_[i] = self.rankInfo_[i-1]
		end
		self.rankInfo_[pos] = score
	end
end

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

--从排行榜中取得分数
function GameData:getRankFromScore( score )
	for i = 100 , 1 ,-1 do
		local hScore = self.rankInfo_[i]
		if score <= hScore then 
			return (i+1) 
		end
	end
	return 1
end

function GameData:save()
	local fileUtils = cc.FileUtils:getInstance()
	local writePath = fileUtils:getWritablePath()
	fileUtils:writeValueVectorToFile( self.rankInfo_, writePath.."score.plist")
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

function GameData:setRank( rank )
	self.rank_ = rank
end

function GameData:getRank()
	return self.rank_
end

function GameData:getLastRank()
	return self.lastRank_ 
end

function GameData:setLastRank( rank )
	self.lastRank_ = rank
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