
local Bird = class("Bird", function()
    return display.newSprite("#bird1.png")
end)

local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)

function Bird:ctor(x, y)

    local birdBody = cc.PhysicsBody:createCircle(self:getContentSize().width / 2,
        MATERIAL_DEFAULT)
    birdBody:setRotationEnable(false)

    birdBody:setCategoryBitmask(0x0010)
    birdBody:setContactTestBitmask(0x0010)
    birdBody:setCollisionBitmask(0x1000)
    self:setTag(BIRD_TAG)

    self:setPhysicsBody(birdBody)
    self:getPhysicsBody():setGravityEnable(false)  


    self:setPosition(x, y)

    local frames = display.newFrames("bird%d.png", 1, 9)
    local animation = display.newAnimation(frames, 0.5 / 9)
    animation:setDelayPerUnit(0.1)
    local animate = cc.Animate:create(animation)

    self:runAction(cc.RepeatForever:create(animate))
end

return Bird

