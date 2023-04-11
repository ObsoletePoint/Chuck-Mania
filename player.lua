Player = Object:extend()

function Player:new()

    self.x = 25
    self.y = 25

    self.speed = 100

    self.radius = 25

end

function Player:update(dt)

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

end

function Player:draw()

    love.graphics.circle("line", self.x, self.y, self.radius)

end