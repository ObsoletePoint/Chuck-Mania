local boxes = {}
local maxBoxes = 10

local enemies = {}
local maxEnemies = 5

function love.load()
  
    Object = require "library/classic"
    require "player"
    require "box"
    require "enemy"

    math.randomseed(os.time())

    player = Player()
    enemy = Enemy()

    -- Mouse Click setup
    love.mousepressed = function(x, y, button)

        if button == 1 and player.holdingBox ~= nil then

            local dx = x - player.x
            local dy = y - player.y
            local magnitude = math.sqrt(dx * dx + dy * dy)
            local normalizedDx = dx / magnitude
            local normalizedDy = dy / magnitude

            player.holdingBox.velocityX = 500 * normalizedDx
            player.holdingBox.velocityY = 500 * normalizedDy

            table.insert(boxes, player.holdingBox)

            player.holdingBox = nil

        end

    end

    -- Boxes
    for i = 1, maxBoxes do

        table.insert(boxes, Box(boxes, i))

    end

    -- Enemies
    for i = 1, maxEnemies do

        table.insert(enemies, Enemy())

    end

end

function love.update(dt)

    player:update(dt, boxes)

    for i, box in ipairs(boxes) do

        box:update(dt)

    end

    for i, enemy in ipairs(enemies) do

        enemy:update(dt)

    end

end

function love.draw()

    player:draw()

    for i, box in ipairs(boxes) do

        box:draw()

    end

    for i, enemy in ipairs(enemies) do

        enemy:draw()
        
    end

end

function addBox()

    if #boxes < maxBoxes then

        table.insert(boxes, Box())

    end

end

function checkOverlap(box1, box2)

    return box1.x < box2.x + box2.width and
           box1.x + box1.width > box2.x and
           box1.y < box2.y + box2.height and
           box1.y + box1.height > box2.y

end