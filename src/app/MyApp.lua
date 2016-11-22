
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    math.randomseed(os.time())
    SDKManager:getInstance()
end

function MyApp:enterLoading( nextSceneName, needAds_ )
	if not needAds_ then needAds_ = false end
	local view = self:enterScene("LoadingScene")
	view:setNextScene(nextSceneName)
	view:setNeedAds(needAds_)
end

return MyApp