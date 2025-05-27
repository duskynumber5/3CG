-- player stats & deck

-- player deck

-- player hand

PlayerClass = {}

function PlayerClass:new()
    local player = {}
    local metadata = {__index = PlayerClass}
    setmetatable(player, metadata)

    player.power = nil
    player.mana = nil

    return player
end

function PlayerClass:deck()
    playerDeck = {}

    for i = 1, 10, 1 do
        local card = CardClass:newCard(validPositions[i].x - 13.5, validPositions[i].y, CARD_BACK, true)
        table.insert(playerDeck, card)
    end

    playerDeck.deckCount = 1

    return playerDeck
end

function PlayerClass:hand()
    playerHand = {}

    drawTop = CardClass:newCard(drawPile.x - 13.5, drawPile.y, CARD_BACK, false)
    table.insert(playerHand, drawTop)
end

function PlayerClass:draw1()
    if #playerHand <= 7 then
        table.insert(playerHand, playerDeck[1])
        table.remove(playerDeck, 1)
    end
end