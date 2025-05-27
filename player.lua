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
    
    drawTop = CardClass:newCard(drawPile.x - 13.5, drawPile.y, CARD_BACK, false)
    table.insert(playerDeck, drawTop)

    return playerDeck
end

function PlayerClass:hand()

end