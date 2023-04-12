Player = Object:extend()

function Player:new()

    self.x = 25
    self.y = 25

    self.speed = 250

    self.radius = 25

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

    -- Collision
    for i, box in ipairs(boxes) do

        if circleRectangleCollision({x = self.x, y = self.y, radius = self.radius}, box) then

            self.x = oldX
            self.y = oldY

            break

        end
        
    end

end

function Player:draw()

    love.graphics.circle("line", self.x, self.y, self.radius)

end

function circleRectangleCollision(circle, rect)

    local dx = circle.x - math.max(rect.x, math.min(circle.x, rect.x + rect.width))
    local dy = circle.y - math.max(rect.y, math.min(circle.y, rect.y + rect.height))
    
    return (dx * dx + dy * dy) < (circle.radius * circle.radius)
end
