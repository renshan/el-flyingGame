
local Airship = class("Airship", function()
    return display.newSprite("#airship.png")
end)

local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)

function Airship:ctor(x, y)

	local airshipSize = self:getContentSize()

    local airshipBody = cc.PhysicsBody:createCircle(airshipSize.width / 2,
        MATERIAL_DEFAULT)

    airshipBody:setCategoryBitmask(0x0100)
    airshipBody:setContactTestBitmask(0x0100)
    airshipBody:setCollisionBitmask(0x1000)
    self:setTag(AIRSHIP_TAG)

    self:setPhysicsBody(airshipBody)
    self:getPhysicsBody():setGravityEnable(false)    

    self:setPosition(x, y)

    local move1 = cc.MoveBy:create(3, cc.p(0, airshipSize.height / 2))
    local move2 = cc.MoveBy:create(3, cc.p(0, -airshipSize.height / 2))
    local SequenceAction = cc.Sequence:create( move1, move2 )
    transition.execute(self, cc.RepeatForever:create( SequenceAction ))

end

return Airship