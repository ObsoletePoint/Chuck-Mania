Box = Object:extend()

function Box:new(boxes, index)

    self.width = 40
    self.height = 40

    self.velocityX = 0
    self.velocityY = 0

    self.isThrown = false

    repeat

        self.x = math.random(0, love.graphics.getWidth() - self.width)
        self.y = math.random(0, love.graphics.getHeight() - self.height)

    until not self:overlapsWithAny(boxes, index)

end

function Box:update(dt)

    self.x = self.x + self.velocityX * dt
    self.y = self.y + self.velocityY * dt

    -- Set a flag if the box goes off the screen
    self.isOffScreen = self.x + self.width < 0 or self.x > love.graphics.getWidth() or self.y + self.height < 0 or self.y > love.graphics.getHeight()

end

function Box:draw()

    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

end

function Box:overlapsWithAny(boxes, index)

    for i, box in ipairs(boxes) do

        if i < index and checkOverlap(self, box) then

            return true

        end

    end

    return false

end