require "gameStart"
require "card"
require "grabber"
require "player"

function love.load()
    grabber = GrabberClass:new()
    player = PlayerClass:new()

    GameClass:boardSetup()

    PlayerClass:hand()
    playerDeck = PlayerClass:deck()
    PlayerClass:board()
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