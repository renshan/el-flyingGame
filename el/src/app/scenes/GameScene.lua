local Player = require("app.objects.Player")

local GameScene = class("GameScene", function()
    return display.newPhysicsScene("GameScene")
end)

function GameScene:ctor()
    
    self.world = self:getPhysicsWorld()
    self.world:setGravity(cc.p(0, -98))
    --self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)

    self.backgroundLayer = BackgroundLayer.new()
        :addTo(self)

    self.player = Player.new()
    self.player:setPosition(-20, display.height * 2 / 3)
    self:addChild(self.player)
    self:playerFlyToScene()

    self.player:createProgress()

    self:addCollision()
end



function GameScene:playerFlyToScene()

    local function startDrop()
        self.player:getPhysicsBody():setGravityEnable(true)  
        self.player:drop()
        self.backgroundLayer:startGame()

        self.backgroundLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            return self:onTouch(event.name, event.x, event.y)
        end)
        self.backgroundLayer:setTouchEnabled(true)

    end

    local animation = display.getAnimationCache("flying")
    transition.playAnimationForever(self.player, animation)
    
    local sequence = transition.sequence({
        cc.MoveTo:create(4, cc.p(display.cx, display.height * 2 / 3)),
        cc.CallFunc:create(startDrop)
    })
    self.player:runAction(sequence)
end

function GameScene:onTouch(event, x, y)
    if event == "began" then

        self.player:flying()
        self.player:getPhysicsBody():setVelocity(cc.p(0, 98))

        return true

    -- elseif event == "moved" then
    elseif event == "ended" then
        self.player:drop()

    -- else event == "cancelled" then
    end
end


function GameScene:onExit()
end


function GameScene:addCollision()

    local function contactLogic(node)
        if node:getTag() == HEART_TAG then
            local emitter = cc.ParticleSystemQuad:create("particles/stars.plist")
            emitter:setBlendAdditive(false)
            emitter:setPosition(node:getPosition())
            self.backgroundLayer.map:addChild(emitter)
            if self.player.blood < 100 then

                self.player.blood = self.player.blood + 2
                self.player:setProPercentage(self.player.blood)
            end
            audio.playSound("sound/heart.mp3")

            node:removeFromParent()

        elseif node:getTag() == GROUND_TAG then
            self.player:hit()
            self.player.blood = self.player.blood - 20
            self.player:setProPercentage(self.player.blood)
            audio.playSound("sound/ground.mp3")
        elseif node:getTag() == AIRSHIP_TAG then
            self.player:hit()
            self.player.blood = self.player.blood - 10
            self.player:setProPercentage(self.player.blood)
            audio.playSound("sound/hit.mp3")
        elseif node:getTag() == BIRD_TAG then
            self.player:hit()
            self.player.blood = self.player.blood - 5
            self.player:setProPercentage(self.player.blood)
            audio.playSound("sound/hit.mp3")
        end
    end

    local function onContactBegin(contact)
        local a = contact:getShapeA():getBody():getNode()
        local b = contact:getShapeB():getBody():getNode()


        contactLogic(a)
        contactLogic(b)

        return true
    end

    local function onContactSeperate(contact)
        if self.player.blood <= 0 then 
            self.backgroundLayer:unscheduleUpdate()
            self.player:die()

            local over = display.newSprite("image/over.png")
                :pos(display.cx, display.cy)
                :addTo(self)

                cc.Director:getInstance():getEventDispatcher():removeAllEventListeners()
        end
    end
    
    local contactListener = cc.EventListenerPhysicsContact:create()
    contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    contactListener:registerScriptHandler(onContactSeperate, cc.Handler.EVENT_PHYSICS_CONTACT_SEPERATE)
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(contactListener, 1)
end

return GameScene
