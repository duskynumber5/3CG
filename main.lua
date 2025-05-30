require "gameStart"
require "card"
require "grabber"
require "player"
require "button"

function love.load()
    game = GameClass:new()
    grabber = GrabberClass:new()
    player = PlayerClass:new()

    GameClass:boardSetup()

    PlayerClass:hand()
    playerDeck = PlayerClass:deck()
    PlayerClass:board()

    GameClass:deal()
end

function love.update()
    GameClass:update()
    grabber:update()
    CardClass:update()
end

function love.draw()
    GameClass:draw()
end

function love.keypressed(key)
    if key == "r" then
        love.load()
    end

    if key == "escape" then
        love.event.quit()
    end
end