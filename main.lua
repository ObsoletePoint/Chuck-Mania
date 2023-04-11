function love.load()
  
    Object = require "library/classic"
    require "player"

    player = Player()

end

function love.update(dt)

    player:update(dt)

end

function love.draw()

    player:draw()

end