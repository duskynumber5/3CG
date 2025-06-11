require "card"
require "player"
require "computer"
require "button"
require "playRound"

GameClass = {}

love.window.setMode(1000, 700)

green = {0.40, 0.63, 0.34, 0}
lightPurple = {0.40, 0.30, 0.50, 0}
purple = {0.30, 0.20, 0.60, 0}
darkPurple = {0.20, 0.0, 0.20, 0}
red = {0.80, 0.20, 0.20, 0}
grey = {0.40, 0.40, 0.34, 0}
darkGreen = {0, 0.30, 0, 0}
darkRed = {0.40, 0.0, 0.0, 0}
color = {0.40, 0.0, 0.0, 0}

love.graphics.setBackgroundColor(lightPurple)

love.window.setTitle("Frogora’s Box")
math.randomseed(os.time())

SPRITE_SHEET = love.graphics.newImage("assets/frogCards.png")
TITLE_SCREEN = love.graphics.newImage("assets/frogTitle.png")

IMAGE_W = 64
IMAGE_H = 64

GAME_STATE = {
    PICK_CARDS = 0,
    BATTLE = 1,
    REVEALING = 2,
    SCORING = 3,
    MENU = 4,
    WIN = 5,
    TITLE = 6,
}

function GameClass:new()
    local game = {}
    local metadata = {__index = GameClass}
    setmetatable(game, metadata)

    game.prevState = nil
    game.state = GAME_STATE.TITLE
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

    local w = IMAGE_W + 5
    local h = IMAGE_H + 32

    -- player hand
    local x = 500 - 272
    local y = 700 - (96 + 10)
    for i = 1, 7, 1 do
        table.insert(validPositions, {
            x = x,
            y = y,
            w = w,
            h = h
        })
        x = x + (80)
    end

    -- player card places
    local x = 1000 - (IMAGE_W*3 + 47)
    local y = 140

    for i = 1, 3, 1 do
        table.insert(columns, {
                x = x,
                y = y,
                w = w,
                h = h,
                cards = {},
                power = 0
            })
        x = x + (80)
    end

    -- draw pile
    local x = 500 - 79
    local y = 700 - ((IMAGE_H)*3.5)
    drawPile = {
        x = x, 
        y = y, 
        w = w, 
        h = h
    }

    -- computer draw pile
    local x = 500 + 10
    local y = 130
    computerDrawPile = {
        x = x, 
        y = y, 
        w = w, 
        h = h
    }

    -- discard pile
    local x = 500 + 10
    local y = 700 - ((IMAGE_H)*3.5)
    discardPile = {
        x = x, 
        y = y, 
        w = w, 
        h = h
    }

    -- computer discard pile
    local x = 500 - 79
    local y = 130
    computerDiscardPile = {
        x = x, 
        y = y, 
        w = w, 
        h = h
    }

    -- computer hand
    local x = 500 + 207
    local y = 10
    for i = 1, 7, 1 do
        table.insert(computerPositions, {
            x = x,
            y = y,
            w = w,
            h = h
        })
        x = x - (80)
    end

    -- computer card places
    local x = 10
    local y = 140
    for i = 1, 3, 1 do
        table.insert(computerColumns, {
                x = x,
                y = y,
                w = w,
                h = h,
                cards = {},
                power = 0
            })
        x = x + (80)
    end

    endTurnButton = button("end turn", battle, nil, 120, 40)
end

function GameClass:update()
    checkForMouseMoving()

    -- win state
    if player.score >= 25 or computer.score >= 25 then
        game.state = GAME_STATE.WIN
    end

    if game.state == GAME_STATE.PICK_CARDS then
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
end

function GameClass:deal()
    for i = 1, 4, 1 do
        playerDeck[1].position.x = validPositions[#playerHand].x - 13.5
        playerDeck[1].position.y = validPositions[#playerHand].y
        table.insert(playerHand, playerDeck[1])
        table.remove(playerDeck, 1)
    end
    for i = 1, 4, 1 do
        computerDeck[1].position.x = computerPositions[#computerHand].x - 13.5
        computerDeck[1].position.y = computerPositions[#computerHand].y
        table.insert(computerHand, computerDeck[1])
        table.remove(computerDeck, 1)
    end
end

function GameClass:titleDraw()
    love.graphics.draw(TITLE_SCREEN, 0, 0)
end

function GameClass:menuDraw()
    love.graphics.setColor(black) 
    love.graphics.rectangle("fill", 0, 0, 1000, 700, 6, 6)

    resumeButton = button("resume", resume, nil, 200, 50)
    exitButton = button("exit", exit, nil, 200, 50)

    resumeButton:draw(500 - 100, 350, 80, 20)
    exitButton:draw(500 - 100, 450, 85, 20)

    love.graphics.setColor(white) 
    love.graphics.setNewFont("assets/Greek_Classics.otf", 100)

    love.graphics.print("PAUSE", 500 - 100, 200)

end

function GameClass:draw()
    love.graphics.setNewFont("assets/Greek_Classics.otf", 45)

    love.graphics.print("Round: " .. tostring(game.round), (125 / 2) - 22.5, 650)

    --scores
    local scoresX = 500 - 50
    local scoreY = 322.5
    love.graphics.print("Scores", scoresX, scoreY)
    love.graphics.print(tostring(player.score), scoresX + 130, scoreY)
    if computer.score < 10 then
        love.graphics.print(tostring(computer.score), scoresX - (50), scoreY)
    else
        love.graphics.print(tostring(computer.score), scoresX - (50 + 10), scoreY)
    end

    -- stats
    love.graphics.print("Mana: " .. tostring(player.mana), 875 - 45, 650)

    love.graphics.setNewFont("assets/Greek_Classics.otf", 20)

    -- draw button
    if game.state == GAME_STATE.PICK_CARDS then
        endTurnButton:draw(500 - 60, 410, 35, 20)
    end

    love.graphics.setColor(white)

    -- draw hands
    for _, position in ipairs(validPositions) do
        love.graphics.rectangle("line", position.x, position.y, position.w, position.h, 6 ,6)
    end
    for _, position in ipairs(computerPositions) do
        love.graphics.rectangle("line", position.x, position.y, position.w, position.h, 6 ,6)
    end

    -- draw boards
    for _, column in ipairs(columns) do
        love.graphics.rectangle("line", column.x, column.y, column.w, column.h, 6 ,6)
        love.graphics.print(tostring(column.power), column.x, column.y - 20)
    end
    
    for _, column in ipairs(computerColumns) do
        love.graphics.rectangle("line", column.x, column.y, column.w, column.h, 6 ,6)
        love.graphics.print(tostring(column.power), column.x, column.y - 20)
    end

    -- draw piles
    love.graphics.rectangle("line", drawPile.x, drawPile.y, drawPile.w, drawPile.h, 6 ,6)
    love.graphics.rectangle("line", computerDrawPile.x, computerDrawPile.y, computerDrawPile.w, computerDrawPile.h, 6 ,6)
    
    -- discard piles
    love.graphics.rectangle("line", discardPile.x, discardPile.y, discardPile.w, discardPile.h, 6 ,6)
    love.graphics.rectangle("line", computerDiscardPile.x, computerDiscardPile.y, computerDiscardPile.w, computerDiscardPile.h, 6 ,6)

    -- draw cards in discard piles
    for _, card in ipairs(discard) do
        card:draw()
    end
    
    for _, card in ipairs(computerDiscardPile) do
        card:draw()
    end

    -- draw cards in hands
    for i, card in ipairs(computerHand) do
        if i == 1 and #computerDeck == 0 then
            goto continue
        end
        card:draw()
        ::continue::
    end

    for i, card in ipairs(playerHand) do
        if i == 1 and #playerDeck == 0 then
            goto continue
        end
        card:draw()
        ::continue::
    end

    -- draw cards in columns
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

    -- win screen
    if game.state == GAME_STATE.WIN then

        for _, card in ipairs(playerHand) do
            card.grabbable = nil
        end
        
        love.graphics.setColor(black)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setColor(black)
        love.graphics.rectangle("fill", 0, love.graphics.getHeight() / 2 - 200, love.graphics.getWidth(), 350)
    
        love.graphics.setColor(white)
        love.graphics.setNewFont("assets/Greek_Classics.otf", 100)
    
        if player.score > computer.score then
            local win = "YOU WIN!"
            local reset = "Press R to Restart"
            local menu = "Press M for Menu"

            local textWidth = love.graphics.getFont():getWidth(win)
            local textHeight = love.graphics.getFont():getHeight()

            local screenWidth = love.graphics.getWidth()
            local screenHeight = love.graphics.getHeight()
        
            love.graphics.print(win, (screenWidth - textWidth) / 2, screenHeight / 2.6 - textHeight)

            love.graphics.setNewFont("assets/Greek_Classics.otf", 50)

            love.graphics.print(reset, (screenWidth - love.graphics.getFont():getWidth(reset)) / 2, screenHeight / 2.6 + 60)
            love.graphics.print(menu, (screenWidth - love.graphics.getFont():getWidth(menu)) / 2, screenHeight / 2.6 + 150)
        else 
            local win = "YOU LOSE!"
            local reset = "Press R to Restart"
            local menu = "Press M for Menu"
            
            local textWidth = love.graphics.getFont():getWidth(win)
            local textHeight = love.graphics.getFont():getHeight()

            local screenWidth = love.graphics.getWidth()
            local screenHeight = love.graphics.getHeight()

            
            love.graphics.print(win, (screenWidth - textWidth) / 2, screenHeight / 2.6 - textHeight)

            love.graphics.setNewFont("assets/Greek_Classics.otf", 50)

            love.graphics.print(reset, (screenWidth - love.graphics.getFont():getWidth(reset)) / 2, screenHeight / 2.6 + 60)
            love.graphics.print(menu, (screenWidth - love.graphics.getFont():getWidth(menu)) / 2, screenHeight / 2.6 + 150)
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

function resume()
    game.state = game.prevState
end

function exit()
    love.event.quit()
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 and game.state == GAME_STATE.MENU then
        resumeButton:checkPressed(x, y)
        exitButton:checkPressed(x, y)
    end

    if button == 1 and game.state == GAME_STATE.PICK_CARDS then
        endTurnButton:checkPressed(x, y)
    end
end