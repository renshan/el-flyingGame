
local Player = class("Player", function()
    return display.newSprite("#flying1.png")
end)

local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)
function Player:ctor()

    self:addAnimationCache()

    local body = cc.PhysicsBody:createBox(self:getContentSize(), MATERIAL_DEFAULT)
    body:setRotationEnable(false)

    body:setCategoryBitmask(0x0111)
    body:setContactTestBitmask(0x1111)
    body:setCollisionBitmask(0x1001)

    self:setTag(PLAYER_TAG)
    self:setPhysicsBody(body)
    self:getPhysicsBody():setGravityEnable(false) 
end


function Player:createProgress()
    self.blood = 100
    local progressbg = display.newSprite("image/progress1.png")
    self.fill = display.newProgressTimer("image/progress2.png", display.PROGRESS_TIMER_BAR)

    self.fill:setMidpoint(cc.p(0, 0.5))
    self.fill:setBarChangeRate(cc.p(1.0, 0))
    self.fill:setPosition(progressbg:getContentSize().width/2, progressbg:getContentSize().height/2)
    progressbg:addChild(self.fill)
    self.fill:setPercentage(self.blood)

    progressbg:setAnchorPoint(cc.p(0, 1))
    self:getParent():addChild(progressbg)
    progressbg:setPosition(cc.p(display.left, display.top))
end

function Player:setProPercentage(Percentage)
    self.fill:setPercentage(Percentage)
end

function Player:addAnimationCache()
    local animationNames = {"flying", "drop", "die"}
    local animationFrameNum = {4, 3, 4}

    for i = 1, #animationNames do
        local frames = display.newFrames( animationNames[i] .. "%d.png", 1, animationFrameNum[i])
        local animation = display.newAnimation(frames, 0.5 / 8)
        animation:setDelayPerUnit(0.1)
        display.setAnimationCache(animationNames[i], animation)
    end

end

function Player:hit()
    local hit = display.newSprite()
    hit:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
    self:addChild(hit)
    local frames = display.newFrames("attack%d.png", 1, 6)
    local animation = display.newAnimation(frames, 0.3 / 6)
    local animate = cc.Animate:create(animation)

    local sequence = transition.sequence({
        animate,
        cc.CallFunc:create(function()
            hit:removeSelf()
        end)
    })

    hit:runAction(sequence)
    hit:setScale(0.6)
    
end

function Player:flying()
    transition.stopTarget(self)
    transition.playAnimationForever(self, display.getAnimationCache("flying"))
end

function Player:drop()
    transition.stopTarget(self)
    transition.playAnimationForever(self, display.getAnimationCache("drop"))
end

function Player:die()
    transition.stopTarget(self)
    transition.playAnimationOnce(self, display.getAnimationCache("die"))
end

return Player