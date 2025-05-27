-- opponent will draw random cards from their pile each round
-- mana tracker

ComputerClass = {}

function ComputerClass:new()
    local computer = {}
    local metadata = {__index = ComputerClass}
    setmetatable(computer, metadata)

    computer.power = nil
    computer.mana = nil

    return computer
end

function ComputerClass:deck()
    computerDeck = {}

    return computerDeck
end

function ComputerClass:hand()

end