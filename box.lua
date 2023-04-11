Box = Object:extend()

function Box:new()

    self.width = 40
    self.height = 40

    self.x = math.random(0, love.graphics.getWidth() - self.width)
    self.y = math.random(0, love.graphics.getHeight() - self.height)


end

function Box:update(dt)

end

function Box:draw()

    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

end