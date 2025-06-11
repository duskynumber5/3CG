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
        local drawTop = CardClass:newCard(computerDrawPile.x - 13.5, computerDrawPile.y, 1, false)
        table.insert(computerHand, drawTop)

        local pool = {}
        for j = 2, 12 do
            table.insert(pool, j)
            table.insert(pool, j)
        end

        CardClass:shuffle(pool)

        for i = 1, 20 do
            local cardID = pool[i]
            local card = CardClass:newCard(0, 0, cardID, false)
            card.faceUp = false
            card.owner = "computer"
            table.insert(computerDeck, card)
        end
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
        computerDeck[1].position.x = computerPositions[#computerHand].x - 13.5
        computerDeck[1].position.y = computerPositions[#computerHand].y
        table.insert(computerHand, computerDeck[1])
        table.remove(computerDeck, 1)
    end
end

function ComputerClass:pickCards()
    for i, card in ipairs(computerHand) do
        if card.COST <= computer.mana and i ~= 1 then
            ::retry::
            index = math.random(3)
            if #computerColumns[index].cards < 4 then
                table.insert(computerColumns[index].cards, card)
                table.remove(computerHand, i)
                card.position.x = computerColumns[index].x - 13.5
                card.position.y = computerColumns[index].y + (110 * (#computerColumns[index].cards - 1))

                card.column = index
                card.state = CARD_STATE.IDLE

                computer.mana = computer.mana - card.COST

                card.faceUp = false
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

    for i, card in ipairs(computerHand) do
        if i ~= 1 then
            card.position.x = computerPositions[i - 1].x - 13.5
            card.position.y = computerPositions[i - 1].y
        end
    end
end