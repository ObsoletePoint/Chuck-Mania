local collisionSound

Enemy = Object:extend()

function Enemy:new()

    self.speed = 250
    self.radius = 25

    collisionSound = love.audio.newSource("88451__davidou__boing.wav", "static")

    -- Randomly choose the edge of the screen to spawn the enemy
    local edge = math.random(1, 4)

    if edge == 1 then

        -- Top edge
        self.x = math.random(0, love.graphics.getWidth())
        self.y = 0

    elseif edge == 2 then

        -- Right edge
        self.x = love.graphics.getWidth()
        self.y = math.random(0, love.graphics.getHeight())

    elseif edge == 3 then

        -- Bottom edge
        self.x = math.random(0, love.graphics.getWidth())
        self.y = love.graphics.getHeight()

    else

        -- Left edge
        self.x = 0
        self.y = math.random(0, love.graphics.getHeight())

    end

    -- Set a random initial direction
    self.direction = math.random() * 2 * math.pi

end

function Enemy:update(dt)

    -- Move the enemy
    self.x = self.x + math.cos(self.direction) * self.speed * dt
    self.y = self.y + math.sin(self.direction) * self.speed * dt

    -- Bounce off the screen edges
    local hitWall = false

    if self.x < 0 or self.x > love.graphics.getWidth() then

        self.direction = math.pi - self.direction
        hitWall = true

    end

    if self.y < 0 or self.y > love.graphics.getHeight() then

        self.direction = -self.direction
        hitWall = true

    end

    -- Play collision sound when the enemy hits a wall
    if hitWall then

        collisionSound:stop()
        collisionSound:play()
        
    end

end

function Enemy:draw()
    
    love.graphics.circle("fill", self.x, self.y, self.radius)

end
