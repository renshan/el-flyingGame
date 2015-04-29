
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()

    audio.playMusic("sound/background.mp3", true)

    display.newSprite("image/main.jpg")
        :pos(display.cx, display.cy)
        :addTo(self)
    
    local title = display.newSprite("image/title.png")
        :pos(display.cx / 2 * 3, display.cy)
        :addTo(self)

    local move1 = cc.MoveBy:create(0.5, cc.p(0, 10))
    local move2 = cc.MoveBy:create(0.5, cc.p(0, -10))
    local SequenceAction = cc.Sequence:create( move1, move2 )
    transition.execute(title, cc.RepeatForever:create( SequenceAction ))

    local sequence = transition.sequence({
        cc.MoveTo:create(0.5, cc.p(display.cx, display.cy)),
        cc.FadeOut:create(0.2),
        cc.DelayTime:create(0.5),
        cc.FadeIn:create(0.3),
    })

    cc.ui.UIPushButton.new({ normal = "image/start1.png", pressed = "image/start2.png" })
        :onButtonClicked(function()
            print("start")
            audio.playSound("sound/button.wav")
            app:enterScene("GameScene", nil, "SLIDEINT", 1.0)
        end)
        :pos( display.cx / 2, display.cy )
        :addTo(self)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
