-- opponent will draw random cards from their pile each round
-- mana tracker

ComputerClass = {}

function ComputerClass:new()
    local computer = {}
    local metadata = {__index = ComputerClass}
    setmetatable(computer, metadata)

    computer.power = nil
    computer.mana = 1

    return computer
end

function ComputerClass:deck()
    computerDeck = {}

    if computerHand then
        drawTop = CardClass:newCard(drawPile.x - 13.5, drawPile.y, 1, false)
        table.insert(computerHand, drawTop)

        for i = 1, 2 do
            for j=2, 11 do
                local card = CardClass:newCard(0, 0, j, true)
                table.insert(computerDeck, card)
            end
        end
    else 
        return
    end

    computerDeck.deckCount = 1

    CardClass:shuffle(computerDeck)

    return computerDeck
end

function ComputerClass:hand()
    computerHand = {}
end

function ComputerClass:draw1()
    if #computerHand <= 7 then
        computerDeck[1].position.x = validPositions[#computerHand].x - 13.5
        computerDeck[1].position.y = validPositions[#computerHand].y
        table.insert(computerHand, computerDeck[1])
        table.remove(computerDeck, 1)
    end
end