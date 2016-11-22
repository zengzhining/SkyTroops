--负责管理SDK层
SDKManager = class("SDKManager")

local DELTA_TIME_VEDIO = 20
local DELTA_TIME_FULL = 20

function SDKManager:ctor(  )
	if not CC_NEED_SDK then return end
	self:initAllSDK()
	self:addEvent()
	self:cacheADS()
	self:initData()
end

function SDKManager:initAllSDK()
	sdkbox.PluginGoogleAnalytics:init()
	--ads
	sdkbox.PluginAdMob:init()
	--review
	sdkbox.PluginReview:init()
	--video
	sdkbox.PluginAdColony:init()
	sdkbox.PluginVungle:init()

end

function SDKManager:addEvent()
	--ads event
	sdkbox.PluginAdMob:setListener(function(args)
        local event = args.event
        dump(args, "admob listener info:")
        if event == "adViewDidReceiveAd" then
	        local name = args.name
        	if name == SDK_BANNER_NAME then
	           SDKManager:getInstance():onBannerLoaded()
	        elseif name == SDK_FULLAD_NAME then 
	        	SDKManager:getInstance():onFULLADLoaded()
	        end
	    elseif event == "adViewWillPresentScreen" then 
	        local name = args.name
	    	if name == SDK_BANNER_NAME then
	           SDKManager:getInstance():onBeforeShowBanner()
	    	elseif name == SDK_FULLAD_NAME then
	           SDKManager:getInstance():onBeforeShowFULLAD()
	    	end
	    elseif event == "adViewDidDismissScreen" then
	        local name = args.name
	    	if name == SDK_BANNER_NAME then
	           SDKManager:getInstance():onBannerDismiss()
	    	elseif name == SDK_FULLAD_NAME then
	           SDKManager:getInstance():onFULLADDismiss()
	    	end
        end
    end)

    -- if AdMobTestDeviceId then
    --     print("the admob test device id is:", AdMobTestDeviceId)
    --     sdkbox.PluginAdMob:setTestDevices(AdMobTestDeviceId)
    -- end

    --review event
    sdkbox.PluginReview:setListener(function(args)
        local event = args.event
        if "onDisplayAlert" == event then
            print("onDisplayAlert")
        elseif "onDeclineToRate" == event then
            print("onDeclineToRate")
        elseif "onRate" == event then
            print("onRate")
        elseif "onRemindLater" == event then
            print("onRemindLater")
        end
    end)

    --vedio event
    sdkbox.PluginAdColony:setListener(function(args)

        if "onAdColonyChange" == args.name then
        local info = args.info  -- sdkbox::AdColonyAdInfo
        local available = args.available -- boolean
                dump(info, "onAdColonyChange:")
		        print("available:", available)
	    elseif "onAdColonyReward" ==  args.name then
	        local info = args.info  -- sdkbox::AdColonyAdInfo
	        local currencyName = args.currencyName -- string
	        local amount = args.amount -- int
	        local success = args.success -- boolean
	                dump(info, "onAdColonyReward:")
	        print("currencyName:", currencyName)
	        print("amount:", amount)
	        print("success:", success)
	    elseif "onAdColonyStarted" ==  args.name then
	        local info = args.info  -- sdkbox::AdColonyAdInfo
            dump(info, "onAdColonyStarted:")
	    elseif "onAdColonyFinished" ==  args.name then
	        local info = args.info  -- sdkbox::AdColonyAdInfo
            dump(info, "onAdColonyFinished:")
	        SDKManager:getInstance():onVedioFinished()
	    end
    end)

	sdkbox.PluginVungle:setListener(function(name, args)
	    if "onVungleCacheAvailable" == name then
	        print("onVungleCacheAvailable")
	    elseif "onVungleStarted" ==  name then
	        print("onVungleStarted")
	    elseif "onVungleFinished" ==  name then
	        print("onVungleFinished")
	    elseif "onVungleAdViewed" ==  name then
	        print("onVungleAdViewed:", args)
	        SDKManager:getInstance():onVedioFinished()

	    elseif "onVungleAdReward" ==  name then
	        print("onVungleAdReward:", args)
	    end
	end)

end

--广告回调事件
function SDKManager:onBannerLoaded()

end

function SDKManager:onFULLADLoaded()

end

function SDKManager:onBeforeShowBanner()

end

function SDKManager:onBeforeShowFULLAD()

end

function SDKManager:onBannerDismiss()

end

function SDKManager:onFULLADDismiss()
	if self.fulladDismissCallback_ then 
		self.fulladDismissCallback_()
	end
end

function SDKManager:onVedioFinished()
	if self.vedioFinishCallback_ then 
		self.vedioFinishCallback_()
	end
end

function SDKManager:initData()
	self.fulladDismissCallback_ = nil
	self.vedioFinishCallback_ = nil
	self.lastPlayVedioTime_ = 0
	self.lastShowFullTime_ = 0
end

function SDKManager:setVedioCallback( callback_ )
	self.vedioFinishCallback_ = callback_
end

function SDKManager:setFULLADCallback( callback_ )
	self.fulladDismissCallback_ = callback_
end

--------------------------------------

--analytics log event
function SDKManager:logEvent( key, value )
	if not CC_NEED_SDK then return end
    sdkbox.PluginGoogleAnalytics:logEvent(key, value, "", 1)
    sdkbox.PluginGoogleAnalytics:dispatchHits()
end

function SDKManager:cacheADS()
	sdkbox.PluginAdMob:cache(SDK_BANNER_NAME)
	sdkbox.PluginAdMob:cache(SDK_FULLAD_NAME)
end

--show ads
function SDKManager:showAds( id_ )
	if not CC_NEED_SDK then return end
	--默认播放全屏
	local adsName = SDK_FULLAD_NAME
	if id_ == 1 then 
		adsName = SDK_BANNER_NAME
	end
	sdkbox.PluginAdMob:show(adsName)
end

function SDKManager:hideAds(id_)
	if not CC_NEED_SDK then return end
	--默认播放全屏
	local adsName = SDK_FULLAD_NAME
	if id_ == 1 then 
		adsName = SDK_BANNER_NAME
	end

	sdkbox.PluginAdMob:hide(adsName)
end

function SDKManager:isAdsAvailable( id_)
	if not CC_NEED_SDK then return false end
	--默认播放全屏
	local adsName = SDK_FULLAD_NAME
	if id_ == 1 then 
		adsName = SDK_BANNER_NAME
	end
	local yes = sdkbox.PluginAdMob:isAvailable(adsName)
	return yes
end

function SDKManager:isBannerAvailable()
	return self:isAdsAvailable(1)
end

function SDKManager:showBanner()
	self:showAds(1)
end

function SDKManager:hideBanner()
	self:hideAds(1)
end

function SDKManager:isFULLADAvailable()
	return self:isAdsAvailable(0)
end

--是否处于可以播放全屏的时间
function SDKManager:isInFullTime()
	if os.time() - self.lastShowFullTime_ >= DELTA_TIME_FULL then 
		return true
	end
	return false
end

function SDKManager:showFULLAD()
	if self:isFULLADAvailable() then
		self:showAds(0)
		self.lastShowFullTime_ = os.time()
	else
		print("FULLAD is not available")
	end
end

function SDKManager:hideFULLAD()
	self:hideAds(0)
end

--是否处于可以播放视频广告的时间
function SDKManager:isInVedioTime()
	if os.time() - self.lastPlayVedioTime_ >= DELTA_TIME_VEDIO then 
		return true
	end
	return false
end

function SDKManager:isCanPlayVedio()
	if not CC_NEED_SDK then return false end
	--一分钟只能播放一次广告
	if self:isInVedioTime() then 
		return true
	end

	local status = sdkbox.PluginAdColony:getStatus(SDK_VEDIO_NAME)
	if status ~= 2 then 
		return true
	end

	if sdkbox.PluginVungle:isCacheAvailable() then 
		return true
	end

	return false
end

function SDKManager:showVideo( callback )
	if not CC_NEED_SDK then return end
	local status = sdkbox.PluginAdColony:getStatus(SDK_VEDIO_NAME)
	print("status~~~~~~", status)
	--没有就播放全屏
	if status >= 2 and status <= 3 then
		self:setVedioCallback( callback )
		sdkbox.PluginAdColony:show(SDK_VEDIO_NAME)
	else
		if sdkbox.PluginVungle:isCacheAvailable() then
			self:setVedioCallback( callback )
			sdkbox.PluginVungle:show("video")
		else
			if self:isFULLADAvailable() then
				self:setFULLADCallback( callback )
				self:showFULLAD()
			else
				callback()
				return 
			end
		end
	end

	self.lastPlayVedioTime_ = os.time()
end

----------review
function SDKManager:showReview()
	if not CC_NEED_SDK then return end
	sdkbox.PluginReview:show(true --[[ force ]])
end

--单例
local sdk_manager_instance = nil
function SDKManager:getInstance()
	if not sdk_manager_instance then 
		sdk_manager_instance = SDKManager.new()
	end

	SDKManager.new = function (  )
		error("SDKManager Cannot use new operater,Please use geiInstance")
	end

	return sdk_manager_instance
end

