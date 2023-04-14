local boxes = {}
local maxBoxes = 10

local enemies = {}
local maxEnemies = 5

local score = 0

local backgroundMusic
local boxCollisionSound

function love.load()
  
    Object = require "library/classic"
    require "player"
    require "box"
    require "enemy"

    math.randomseed(os.time())

    player = Player()
    enemy = Enemy()

    backgroundMusic = love.audio.newSource("95487__timbre__mouse-organ2.wav", "stream")
    backgroundMusic:setLooping(true)
    backgroundMusic:setVolume(0.2)
    backgroundMusic:play()

    boxCollisionSound = love.audio.newSource("202230__deraj__pop-sound.wav", "static")

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

    -- Check for collisions between the player and the enemies
    for _, enemy in ipairs(enemies) do

        if circleCircleCollision({x = player.x, y = player.y, radius = player.radius}, {x = enemy.x, y = enemy.y, radius = enemy.radius}) then
            
            resetGame()

            break

        end

    end

    -- Check for collisions between boxes and enemies
    for i = #boxes, 1, -1 do

        local box = boxes[i]

        if box.isThrown then

            for j = #enemies, 1, -1 do

                local enemy = enemies[j]

                if checkOverlap(box, enemy) then

                    boxCollisionSound:stop()
                    boxCollisionSound:play()

                    -- Remove the box and enemy from their respective tables
                    table.remove(boxes, i)
                    table.remove(enemies, j)

                    score = score + 1

                    break

                end

            end

        end

    end

    -- Check for off screen boxes
    for i = #boxes, 1, -1 do

        local box = boxes[i]

        if box.isThrown and box.isOffScreen then

            table.remove(boxes, i)

        end

    end

    -- Spawn new boxes if there are less than the maximum allowed
    if #boxes < maxBoxes then

        local newBox = Box(boxes, #boxes + 1)
        newBox.isThrown = false

        table.insert(boxes, newBox)

    end

    -- Spawn new enemies if there are less than the maximum allowed
    if #enemies < maxEnemies then

        table.insert(enemies, Enemy())

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

    love.graphics.printf("Score: " .. score, 0, 25, love.graphics.getWidth(), "center")

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

function circleCircleCollision(circle1, circle2)

    local dx = circle1.x - circle2.x
    local dy = circle1.y - circle2.y
    local distance = math.sqrt(dx * dx + dy * dy)

    return distance <= circle1.radius + circle2.radius

end

function resetGame()

    score = 0

    -- Reset the player
    player = Player()

    -- Reset the boxes
    boxes = {}

    for i = 1, maxBoxes do

        table.insert(boxes, Box(boxes, i))

    end

    -- Reset the enemies
    enemies = {}

    for i = 1, maxEnemies do

        table.insert(enemies, Enemy())

    end

end