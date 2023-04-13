Player = Object:extend()

function Player:new()

    self.x = 25
    self.y = 25

    self.speed = 250
    self.radius = 25

    self.holdingBox = nil

end

function Player:update(dt, boxes)

    local oldX = self.x
    local oldY = self.y

    if love.keyboard.isDown("w") then

        self.y = self.y - self.speed * dt

    end
    
    if love.keyboard.isDown("s") then

        self.y = self.y + self.speed * dt

    end
    
    if love.keyboard.isDown("d") then

        self.x = self.x + self.speed * dt

    end

    if love.keyboard.isDown("a") then

        self.x = self.x - self.speed * dt

    end

    -- Check for collisions and handle box pickup
    if love.keyboard.isDown("space") and self.holdingBox == nil then
        
        self:pickUpBox(boxes)

    end

    -- Collision
    for i, box in ipairs(boxes) do

        if self.holdingBox ~= box and circleRectangleCollision({x = self.x, y = self.y, radius = self.radius}, box) then
            
            self.x = oldX
            self.y = oldY

            break

        end

    end

    -- Make the box follow the player when it's being held
    if self.holdingBox ~= nil then

        self.holdingBox.x = self.x - self.holdingBox.width / 2
        self.holdingBox.y = self.y - self.holdingBox.height / 2

    end

end

function Player:pickUpBox(boxes)

    for i, box in ipairs(boxes) do

        if circleRectangleCollision({x = self.x, y = self.y, radius = self.radius}, box) then
            
            self.holdingBox = box

            table.remove(boxes, i)
            
            break
        end
    end
end

function Player:draw()

    love.graphics.circle("line", self.x, self.y, self.radius)

    if self.holdingBox ~= nil then

        self.holdingBox:draw()

    end

end

function circleRectangleCollision(circle, rect)

    local dx = circle.x - math.max(rect.x, math.min(circle.x, rect.x + rect.width))
    local dy = circle.y - math.max(rect.y, math.min(circle.y, rect.y + rect.height))
    
    return (dx * dx + dy * dy) < (circle.radius * circle.radius)
end
