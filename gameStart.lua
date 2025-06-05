require "card"
require "player"
require "computer"
require "button"
require "playRound"

GameClass = {}

love.window.setMode(1000, 700)

brown = {0.70, 0.63, 0.34, 0}
love.graphics.setBackgroundColor(brown)

love.window.setTitle("Frogora’s Box")
math.randomseed(os.time())

SPRITE_SHEET = love.graphics.newImage("sprites/frogCards.png")

IMAGE_W = 64
IMAGE_H = 64

GAME_STATE = {
    PICK_CARDS = 0,
    BATTLE = 1,
    REVEALING = 2,
    SCORING = 3,
    MENU = 4,
    WIN = 5,
}

function GameClass:new()
    local game = {}
    local metadata = {__index = GameClass}
    setmetatable(game, metadata)

    game.state = nil
    game.round = 1

    return game
end

function GameClass:boardSetup()
    validPositions = {}
    computerPositions = {}
    columns = {}
    computerColumns = {}
    discard = {}
    computerDiscardPile = {}
    stagedCards = {}

    game.state = GAME_STATE.PICK_CARDS

    local w = IMAGE_W + 5
    local h = IMAGE_H + 32

    -- player hand
    local x = 1000 / 2.84
    local y = 700 / 1.5
    for i = 1, 3, 1 do
        table.insert(validPositions, {
            x = x,
            y = y,
            w = w,
            h = h
        })
        x = x + (110)
    end
    local x = 1000 / 3.38
    local y = 700 / 1.2
    for i = 1, 4, 1 do
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
    local x = (1000 / 3.2) + 110
    local y = 700 - ((IMAGE_H)*3.2 + (110 - IMAGE_H)*3.2)
    drawPile = {
        x = x, 
        y = y, 
        w = w, 
        h = h
    }
    mouseWasDown = false

    -- discard pile
    local x = (1000 / 3.5) + 220
    local y = 700 - ((IMAGE_H)*3.2 + (110 - IMAGE_H)*3.2)
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
        table.insert(computerColumns, {
                x = x,
                y = y,
                w = w,
                h = h,
                cards = {},
                power = 0
            })
        x = x + (110)
    end

    endTurnButton = button("end turn", battle, nil, 120, 40)
end

function GameClass:update()
    checkForMouseMoving()

    -- win state
    if player.score >= 25 or computer.score >= 25 then
        game.state = GAME_STATE.WIN
    end

    for i = #playerHand, 1, -1 do
        local card = playerHand[i]

        if card.state == CARD_STATE.MOUSE_OVER and love.mouse.isDown(1) and grabber.heldObject == nil and card.grabbable then
            grabber:grab(card)
        end
    end

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
    for i = 1, 4, 1 do
        playerDeck[1].position.x = validPositions[#playerHand].x - 13.5
        playerDeck[1].position.y = validPositions[#playerHand].y
        table.insert(playerHand, playerDeck[1])
        table.remove(playerDeck, 1)
    end
    for i = 1, 4, 1 do
        table.insert(computerHand, computerDeck[1])
        table.remove(computerDeck, 1)
    end
end

function GameClass:draw()
    love.graphics.setNewFont(30)

    love.graphics.print("Round: " .. tostring(game.round), 0 + (2.6 * 30), 650)

    --scores
    local scoresX = (1000 / 2.23)
    love.graphics.print("Scores", scoresX, 10)
    love.graphics.print(tostring(player.score), scoresX + 90, 50)
    love.graphics.print(tostring(computer.score), scoresX - 10, 50)

    -- stats
    love.graphics.print("Mana: " .. tostring(player.mana), 1000 - (7 * 30), 650)

    love.graphics.setNewFont(12)

    -- draw button
    if game.state == GAME_STATE.PICK_CARDS then
        endTurnButton:draw((1000 / 2.29), 700 / 2.5, 35, 20)
    end

    love.graphics.setColor(white)

    -- draw player board
    for _, position in ipairs(validPositions) do
        love.graphics.rectangle("line", position.x, position.y, position.w, position.h, 6 ,6)
    end
    for _, column in ipairs(columns) do
        love.graphics.rectangle("line", column.x, column.y, column.w, column.h, 6 ,6)
        love.graphics.print(tostring(column.power), column.x, column.y - 20)
    end
    
    -- draw computer board
    for _, column in ipairs(computerColumns) do
        love.graphics.rectangle("line", column.x, column.y, column.w, column.h, 6 ,6)
        love.graphics.print(tostring(column.power), column.x, column.y - 20)
    end
    
    for _, col in ipairs(columns) do
        for _, card in ipairs(col.cards) do
            if card ~= grabber.heldObject then
                card:draw()
            end
        end
    end
    if grabber.heldObject then
        grabber.heldObject:draw()
    end

    for _, col in ipairs(computerColumns) do
        for _, card in ipairs(col.cards) do
            card:draw()
        end
    end

    -- draw pile
    love.graphics.rectangle("line", drawPile.x, drawPile.y, drawPile.w, drawPile.h, 6 ,6)
    
    -- discard pile
    love.graphics.rectangle("line", discardPile.x, discardPile.y, discardPile.w, discardPile.h, 6 ,6)

    
    for _, card in ipairs(discard) do
        card:draw()
    end

    for i, card in ipairs(playerHand) do
        if i == 1 and #playerDeck == 0 then
            goto continue
        end
        card:draw()
        ::continue::
    end

    -- win screen
    if game.state == GAME_STATE.WIN then

        for _, card in ipairs(playerHand) do
            card.grabbable = nil
        end
        
        love.graphics.setColor(black)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
        love.graphics.setColor(white)
        love.graphics.setFont(love.graphics.newFont(40))
    
        if player.score > computer.score then
            local win = "YOU WIN!"
            local reset = "Press R to Restart"

            local textWidth = love.graphics.getFont():getWidth(win)
            local textHeight = love.graphics.getFont():getHeight()

            local screenWidth = love.graphics.getWidth()
            local screenHeight = love.graphics.getHeight()
        
            love.graphics.print(win, (screenWidth - textWidth) / 2, screenHeight / 2 - textHeight)
            love.graphics.print(reset, (screenWidth - love.graphics.getFont():getWidth(reset)) / 2, screenHeight / 2 + 20)
        else 
            local win = "YOU LOSE!"
            local reset = "Press R to Restart"
            
            local textWidth = love.graphics.getFont():getWidth(win)
            local textHeight = love.graphics.getFont():getHeight()

            local screenWidth = love.graphics.getWidth()
            local screenHeight = love.graphics.getHeight()
        
            love.graphics.print(win, (screenWidth - textWidth) / 2, screenHeight / 2 - textHeight)
            love.graphics.print(reset, (screenWidth - love.graphics.getFont():getWidth(reset)) / 2, screenHeight / 2 + 20)
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

function battle()
    game.state = GAME_STATE.BATTLE

    PlayClass:playRound()
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        endTurnButton:checkPressed(x, y)
    end
end