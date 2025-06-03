-- opponent will draw random cards from their pile each round
-- mana tracker

ComputerClass = {}

function ComputerClass:new()
    local computer = {}
    local metadata = {__index = ComputerClass}
    setmetatable(computer, metadata)

    computer.power = nil
    computer.mana = 1
    computer.extraMana = 0

    computer.score = 0

    return computer
end

function ComputerClass:deck()
    computerDeck = {}

    if computerHand then
        for i = 1, 2 do
            for j=2, 11 do
                local card = CardClass:newCard(0, 0, j, false)
                table.insert(computerDeck, card)
            end
        end
    else 
        return
    end

    CardClass:shuffle(computerDeck)

    return computerDeck
end

function ComputerClass:hand()
    computerHand = {}
end

function ComputerClass:board()
    computerBoard = {}
end

function ComputerClass:draw1()
    if #computerHand <= 7 then
        table.insert(computerHand, computerDeck[1])
        table.remove(computerDeck, 1)
    end
end

function ComputerClass:pickCards()
    for i, card in ipairs(computerHand) do
        if card.COST <= computer.mana then
            ::retry::
            index = math.random(3)
            if #computerColumns[index].cards < 4 then
                table.insert(computerColumns[index].cards, card)
                table.remove(computerHand, i)
                card.position.x = computerColumns[index].x - 13.5
                card.position.y = computerColumns[index].y + (100 * (#computerColumns[index].cards - 1))

                card.column = index

                computerColumns[index].power = computerColumns[index].power + card.POWER
                computer.mana = computer.mana - card.COST
            else
                goto retry
            end
        end
        
        if i == #computerHand then
            endTurn = true
        end
    end

    if computer.mana == 0 then
        endTurn = true
    end
end