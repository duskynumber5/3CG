-- player stats & deck

-- player deck

-- player hand

-- player board

require "card"

PlayerClass = {}

function PlayerClass:new()
    local player = {}
    local metadata = {__index = PlayerClass}
    setmetatable(player, metadata)

    player.power = nil
    player.mana = 1

    player.score = 0

    return player
end

function PlayerClass:deck()
    playerDeck = {}

    if playerHand then
        drawTop = CardClass:newCard(drawPile.x - 13.5, drawPile.y, 1, false)
        table.insert(playerHand, drawTop)

        for i = 1, 2 do
            for j=2, 11 do
                local card = CardClass:newCard(0, 0, j, true)
                table.insert(playerDeck, card)
            end
        end
    else 
        return
    end

    CardClass:shuffle(playerDeck)

    return playerDeck
end

function PlayerClass:hand()
    playerHand = {}
end

function PlayerClass:board()
    playerBoard = {}
end

function PlayerClass:draw1()
    if #playerHand <= 7 then
        playerDeck[1].position.x = validPositions[#playerHand].x - 13.5
        playerDeck[1].position.y = validPositions[#playerHand].y
        table.insert(playerHand, playerDeck[1])
        table.remove(playerDeck, 1)
    end
end