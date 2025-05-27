require "card"
require "player"

GameClass = {}

love.window.setMode(1000, 900)

brown = {0.70, 0.63, 0.34, 0}
love.graphics.setBackgroundColor(brown)

love.window.setTitle("game title!") -- make a title!!!!
math.randomseed(os.time())

CARD_BACK = love.graphics.newImage("sprites/cardBack.png")

IMAGE_W = CARD_BACK:getWidth()
IMAGE_H = CARD_BACK:getHeight()

function GameClass:boardSetup()
    validPositions = {}
    computerPositions = {}

    local w = IMAGE_W + 5
    local h = IMAGE_H + 32

    -- player hand
    local x = 1000 / 6
    local y = 900 / 1.4
    for i = 1, 4, 1 do
        table.insert(validPositions, {
            x = x,
            y = y,
            w = w,
            h = h
        })
        x = x + (110)
    end
    local x = 1000 / 4.5
    local y = 900 / 1.2
    for i = 1, 3, 1 do
        table.insert(validPositions, {
            x = x,
            y = y,
            w = w,
            h = h
        })
        x = x + (110)
    end

    -- player card places
    local x = 1000 - (IMAGE_W*3 + 110)
    local y = 900 - ((IMAGE_H)*4 + (110 - IMAGE_H)*4)

    for i = 1, 3, 1 do
        table.insert(validPositions, {
                x = x,
                y = y,
                w = w,
                h = h
            })
        for i = 4, 1, -1 do
            y = y + 110
            table.insert(validPositions, {
                x = x,
                y = y,
                w = w,
                h = h
            })
        end
        x = x + (110)
        y = 900 - ((IMAGE_H)*4 + (110 - IMAGE_H)*4)
    end

    -- draw pile
    local x = 10
    local y = 900 - ((IMAGE_H) + (110 - IMAGE_H))
    drawPile = {
        x = x, 
        y = y, 
        w = w, 
        h = h
    }

    -- computer card places
    local x = 10
    local y = 10
    for i = 1, 3, 1 do
        table.insert(computerPositions, {
            x = x,
            y = y,
            w = w,
            h = h
        })
        for i = 4, 1, -1 do
            table.insert(computerPositions, {
                x = x,
                y = y,
                w = w,
                h = h
            })
            y = y + 110
        end
        x = x + (110)
        y = 10
    end
end

function GameClass:update()
    checkForMouseMoving()

    for i = #playerDeck, 1, -1 do
        local card = playerDeck[i]

        if card.state == CARD_STATE.MOUSE_OVER and love.mouse.isDown(1) and grabber.heldObject == nil and card.grabbable then
            grabber:grab(card)
        end
    end
end

function GameClass:deal()

end

function GameClass:draw()
    -- draw player board
    for _, position in ipairs(validPositions) do
        love.graphics.rectangle("line", position.x, position.y, position.w, position.h, 6 ,6)
    end

    -- draw computer board
    for _, position in ipairs(computerPositions) do
        love.graphics.rectangle("line", position.x, position.y, position.w, position.h, 6 ,6)
    end

    -- draw pile
    love.graphics.rectangle("line", drawPile.x, drawPile.y, drawPile.w, drawPile.h, 6 ,6)

    for _, card in ipairs(playerDeck) do
        card:draw()
    end

    love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y))

    local debugx = 400
    local debugy = 100
    for _, position in ipairs(validPositions) do
        love.graphics.print(tostring(position.x .. " " .. position.y), debugx, debugy)
        debugy = debugy + 15
    end

end

function checkForMouseMoving()
    if grabber.currentMousePos == nil then
        return
    end

    for _, card in ipairs(cardTable) do
        card:checkForMouseOver(grabber)
    end
    
    for _, card in ipairs(wasteCards) do
        card:checkForMouseOver(grabber)
    end
end

function checkForMouseMoving()
    if grabber.currentMousePos == nil then
        return
    end

    for _, card in ipairs(playerDeck) do
        card:checkForMouseOver(grabber)
    end
end
