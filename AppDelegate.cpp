#include "AppDelegate.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "audio/include/SimpleAudioEngine.h"
#include "cocos2d.h"
#include "scripting/lua-bindings/manual/lua_module_register.h"

#define USE_SDK 0
#ifdef USE_SDK
#include "PluginAdMobLua.hpp"
#include "PluginAdMobLuaHelper.h"

#include "PluginReviewLua.hpp"
#include "PluginReviewLuaHelper.h"
#include "PluginGoogleAnalyticsLua.hpp"
#include "PluginAdColonyLua.hpp"
#include "PluginAdColonyLuaHelper.h"
// #include "PluginGoogleAnalyticsLuaHelper.h"
// #include "PluginVungleLua.hpp"
// #include "PluginVungleLuaHelper.h"
#endif

using namespace CocosDenshion;

USING_NS_CC;
using namespace std;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();

#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
    // NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
    RuntimeEngine::getInstance()->end();
#endif

}

// if you want a different context, modify the value of glContextAttrs
// it will affect all platforms
void AppDelegate::initGLContextAttrs()
{
    // set OpenGL context attributes: red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};

    GLView::setGLContextAttrs(glContextAttrs);
}

// if you want to use the package manager to install more packages, 
// don't modify or remove this function
static int register_all_packages()
{
#ifdef SDKBOX_ENABLED
    register_all_PluginReviewLua(LuaEngine::getInstance()->getLuaStack()->getLuaState());
    register_all_PluginReviewLua_helper(LuaEngine::getInstance()->getLuaStack()->getLuaState());
#endif
    return 0; //flag for packages manager
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // set default FPS
    Director::getInstance()->setAnimationInterval(1.0 / 60.0f);

    // register lua module
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    lua_State* L = engine->getLuaStack()->getLuaState();
    lua_module_register(L);
    
#ifdef USE_SDK
    register_all_PluginAdMobLua(L);
    register_all_PluginAdMobLua_helper(L);
    
    register_all_PluginReviewLua(L);
    register_all_PluginReviewLua_helper(L);

    register_all_PluginGoogleAnalyticsLua(L);

    register_all_PluginAdColonyLua(L);
    register_all_PluginAdColonyLua_helper(L);

    // register_all_PluginVungleLua(LuaEngine::getInstance()->getLuaStack()->getLuaState());
    // register_all_PluginVungleLua_helper(LuaEngine::getInstance()->getLuaStack()->getLuaState());

#endif

    register_all_packages();

    LuaStack* stack = engine->getLuaStack();
    stack->setXXTEAKeyAndSign("2dxLua", strlen("2dxLua"), "XXTEA", strlen("XXTEA"));

    //register custom function
    //LuaStack* stack = engine->getLuaStack();
    //register_custom_function(stack->getLuaState());

    if (engine->executeScriptFile("src/main.lua"))
    {
        return false;
    }

    return true;
}

// This function will be called when the app is inactive. Note, when receiving a phone call it is invoked.
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();

    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();

    auto engine = LuaEngine::getInstance();
    
    engine->executeGlobalFunction("__G__applicationDidEnterBackground");
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();

    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();

    auto engine = LuaEngine::getInstance();
    
    engine->executeGlobalFunction("__G__applicationDidEnterBackground");
}
