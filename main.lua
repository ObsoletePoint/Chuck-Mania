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
            player.holdingBox.isThrown = true

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

    -- Check for collisions between boxes and enemies
    for i = #boxes, 1, -1 do

        local box = boxes[i]

        if box.isThrown then

            for j = #enemies, 1, -1 do

                local enemy = enemies[j]

                if checkOverlap(box, enemy) then

                    -- Remove the box and enemy from their respective tables
                    table.remove(boxes, i)
                    table.remove(enemies, j)

                    break

                end

            end

        end
        
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

function checkOverlap(a, b)

    if a.width and b.width then

        -- Both are rectangles
        return a.x < b.x + b.width and
               a.x + a.width > b.x and
               a.y < b.y + b.height and
               a.y + a.height > b.y

    elseif a.width and b.radius then

        -- a is a rectangle (box), b is a circle (enemy)
        return circleRectangleCollision(b, a)

    end

end