
require("config")
require("cocos.init")
require("framework.init")
require("app.layers.BackgroundLayer")
require("app.objects.Player")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
	math.randomseed(os.time()) 
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.Director:getInstance():setContentScaleFactor(640 / CONFIG_SCREEN_HEIGHT)

    display.addSpriteFrames("image/player.plist", "image/player.pvr.ccz")
    audio.preloadMusic("sound/background.mp3") 
    audio.preloadSound("sound/button.wav")
    audio.preloadSound("sound/ground.mp3")
    audio.preloadSound("sound/heart.mp3")
    audio.preloadSound("sound/hit.mp3")

    
    self:enterScene("MainScene")
end

return MyApp
