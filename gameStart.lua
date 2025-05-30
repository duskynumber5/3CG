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
    columns = {}

    local w = IMAGE_W + 5
    local h = IMAGE_H + 32

    -- player hand
    local x = 1000 / 3.3
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
    local x = 1000 / 2.8
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
    local y = 30

    for i = 1, 3, 1 do
        table.insert(columns, {
                x = x,
                y = y,
                w = w,
                h = h,
                cards = {},
                power = 0
            })
        x = x + (110)
    end

    -- draw pile
    local x = (1000 / 3.3) + 110
    local y = 900 - ((IMAGE_H)*3.7 + (110 - IMAGE_H)*3.7)
    drawPile = {
        x = x, 
        y = y, 
        w = w, 
        h = h
    }
    mouseWasDown = false

    -- discard pile
    local x = (1000 / 3.3) + 220
    local y = 900 - ((IMAGE_H)*3.7 + (110 - IMAGE_H)*3.7)
    discardPile = {
        x = x, 
        y = y, 
        w = w, 
        h = h
    }

    -- computer card places
    local x = 10
    local y = 30
    for i = 1, 3, 1 do
        table.insert(columns, {
                x = x,
                y = y,
                w = w,
                h = h,
                cards = {},
                power = 0
            })
        x = x + (110)
    end
end

function GameClass:update()
    checkForMouseMoving()

    for i = #playerHand, 1, -1 do
        local card = playerHand[i]

        if card.state == CARD_STATE.MOUSE_OVER and love.mouse.isDown(1) and grabber.heldObject == nil and card.grabbable then
            grabber:grab(card)
        end

        if card.position.x == drawPile.x - 13.5 and card.position.y == drawPile.y and card.state == CARD_STATE.MOUSE_OVER then
            if love.mouse.isDown(1) and not mouseWasDown and #playerDeck > 0 then
                PlayerClass:draw1()
            end
        end
    end
    mouseWasDown = love.mouse.isDown(1)

    for _, card in ipairs(playerBoard) do
        card:checkForMouseOver()
        for i = #playerBoard, 1, -1 do
        local card = playerBoard[i]
            if card.state == CARD_STATE.MOUSE_OVER and love.mouse.isDown(1) and grabber.heldObject == nil and card.grabbable then
                grabber:grab(card)
            end
        end
    end
    for _, column in ipairs(columns) do
        for _, card in ipairs(column.cards) do
            card:checkForMouseOver()
            for i = #column.cards, 1, -1 do
            local card = column.cards[i]
                if card.state == CARD_STATE.MOUSE_OVER and love.mouse.isDown(1) and grabber.heldObject == nil and card.grabbable then
                    grabber:grab(card)
                end
            end
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
    for _, column in ipairs(columns) do
        love.graphics.rectangle("line", column.x, column.y, column.w, column.h, 6 ,6)
        love.graphics.print(tostring(column.power), column.x, column.y - 20)
    end
    for _, column in ipairs(columns) do
        for _, card in ipairs(column.cards) do
            card:draw()
        end
    end
    

    -- draw computer board
    for _, position in ipairs(computerPositions) do
        love.graphics.rectangle("line", position.x, position.y, position.w, position.h, 6 ,6)
    end

    -- draw pile
    love.graphics.rectangle("line", drawPile.x, drawPile.y, drawPile.w, drawPile.h, 6 ,6)
    
    -- discard pile
    love.graphics.rectangle("line", discardPile.x, discardPile.y, discardPile.w, discardPile.h, 6 ,6)

    for _, card in ipairs(playerBoard) do
        card:draw()
    end
    for i, card in ipairs(playerHand) do
        if i == 1 and #playerDeck == 0 then
            goto continue
        end
        card:draw()
        ::continue::
    end

    love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y))

    local debugx = 400
    local debugy = 100
    for i, column in ipairs(columns) do
        for _, card in ipairs(column.cards) do
            love.graphics.print(i .. ": " .. tostring(card), debugx, debugy)
            debugy = debugy + 15
        end
    end

end

function checkForMouseMoving()
    if grabber.currentMousePos == nil then
        return
    end

    for _, card in ipairs(playerHand) do
        card:checkForMouseOver(grabber)
    end
end
