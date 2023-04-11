local boxes = {}
local maxBoxes = 10


function love.load()
  
    Object = require "library/classic"
    require "player"
    require "box"

    math.randomseed(os.time())

    player = Player()

    for i = 1, maxBoxes do

        table.insert(boxes, Box())

    end

end

function love.update(dt)

    player:update(dt)

    for i, box in ipairs(boxes) do

        box:update(dt)

    end

end

function love.draw()

    player:draw()

    for i, box in ipairs(boxes) do

        box:draw()

    end

end

function addBox()

    if #boxes < maxBoxes then

        table.insert(boxes, Box())

    end

end