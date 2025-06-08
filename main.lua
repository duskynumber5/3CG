io.stdout:setvbuf("no")

require "gameStart"
require "card"
require "grabber"
require "player"
require "button"

function love.load()
    game = GameClass:new()
    grabber = GrabberClass:new()
    player = PlayerClass:new()
    computer = ComputerClass:new()

    CardClass:loadCards()

    GameClass:boardSetup()

    PlayerClass:hand()
    playerDeck = PlayerClass:deck()
    PlayerClass:board()

    ComputerClass:hand()
    computerDeck = ComputerClass:deck()
    ComputerClass:board()
end

function love.update()
    GameClass:update()
    grabber:update()
    CardClass:update()
    PlayClass:update()
end

function love.draw()
    GameClass:draw()

    if game.state == GAME_STATE.TITLE then
        GameClass:titleDraw()
    end

    if game.state == GAME_STATE.MENU then
        GameClass:menuDraw()
    end
end

function love.keypressed(key)
    if key == "f" and game.state == GAME_STATE.TITLE then
        game.state = GAME_STATE.PICK_CARDS

        GameClass:deal()
    end

    if key == "r" and game.state == GAME_STATE.WIN then
        love.load()
        game.state = GAME_STATE.PICK_CARDS
        GameClass:deal()
    end

    if key == "m" and game.state == GAME_STATE.WIN then
        love.load()
    end

    if key == "escape" and game.state <= 3 then
        game.prevState = game.state
        game.state = GAME_STATE.MENU
    end
end