
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"
require "pure.init"
require "app.Obj.PlaneFactory"

local function main()
	
	if device.platform == "android" or device.platform == "ios" then
		CC_NEED_SDK = true
	end

   --初始化SDK
   SDKManager:getInstance()

   --设置默认音效大小
   audio.setSoundsVolume(DEFAULT_SOUND_VOL)
   audio.setMusicVolume(DEFAULT_MUSIC_VOL)

   require("app.MyApp"):create():run()
end

function __G__applicationDidEnterBackground()
  print("__G__applicationDidEnterBackground~~~~~~")
end

function __G__applicationWillEnterForeground()
  print("__G__applicationWillEnterForeground~~~~~~~")
  local scene = display.getRunningScene()
  if scene and scene.onAppEnterForeground then 
     scene.onAppEnterForeground()
  end
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
