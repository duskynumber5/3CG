require "card"

PlayerClass = {}

function PlayerClass:new()
    local player = {}
    local metadata = {__index = PlayerClass}
    setmetatable(player, metadata)

    player.power = nil
    player.mana = 1
    player.extraMana = 0

    player.score = 0

    return player
end

function PlayerClass:deck()
    playerDeck = {}

    if playerHand then
        drawTop = CardClass:newCard(drawPile.x - 13.5, drawPile.y, 1, false)
        table.insert(playerHand, drawTop)

        local pool = {}
        for j = 2, 12 do
            table.insert(pool, j)
            table.insert(pool, j)
        end

        CardClass:shuffle(pool)

        for i = 1, 20 do
            local cardID = pool[i]
            local card = CardClass:newCard(0, 0, cardID, true)
            table.insert(playerDeck, card)
        end
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
    if #playerHand <= 7 and #playerDeck > 0 then
        playerDeck[1].position.x = validPositions[#playerHand].x - 13.5
        playerDeck[1].position.y = validPositions[#playerHand].y
        table.insert(playerHand, playerDeck[1])
        table.remove(playerDeck, 1)
    end
end