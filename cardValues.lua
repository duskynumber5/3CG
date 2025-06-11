CardValues = {
    Apollo = {
        type = ON_REVEAL,
        cost = 1,
        power = 2,
        description = "When Revealed:\nGain +1 mana next turn.",
        ability = function()
            if currentCard.position.x > 500 then 
                player.extraMana = player.extraMana + 1
            else
                computer.extraMana = computer.extraMana + 1
            end
        end

    },

    Ares = {
        type = ON_REVEAL,
        cost = 3,
        power = 3,
        description = "When Revealed:\nGain +2 power for each\nenemy card here.",
        ability = function()
            if currentCard.position.x > 500 then
                if #computerColumns[currentCard.column].cards > 0 then
                    for _, card in ipairs(computerColumns[currentCard.column].cards) do
                        currentCard.POWER = currentCard.POWER + 2
                    end
                end
            else
                if #columns[currentCard.column].cards > 0 then
                    for _, card in ipairs(columns[currentCard.column].cards) do
                        currentCard.POWER = currentCard.POWER + 2
                    end
                end
            end
        end
    },

    Demeter = {
        type = ON_REVEAL,
        cost = 1,
        power = 1,
        description = "When Revealed:\nBoth players draw\na card.",
        ability = function()
            PlayerClass:draw1()
            ComputerClass:draw1()
        end
    },

    Hades = {
        type = ON_REVEAL,
        cost = 4,
        power = 4,
        description = "When Revealed:\nGain +2 power for each\ncard in your discard pile.",
        ability = function()
            if currentCard.position.x > 500 then
                for _, card in ipairs(discard) do
                    currentCard.POWER = currentCard.POWER + 2
                end
            else
                for _, card in ipairs(computerDiscardPile) do
                    currentCard.POWER = currentCard.POWER + 2
                end
            end
        end
    },

    Hera = {
        type = ON_REVEAL,
        cost = 2,
        power = 3,
        description = "When Revealed:\nGive cards in your hand\n+1 power.",
        ability = function()
            if currentCard.position.x > 500 then
                for _, card in ipairs(playerHand) do
                    card.POWER = card.POWER + 1
                end
            else
                for _, card in ipairs(computerHand) do
                    card.POWER = card.POWER + 1
                end
            end
        end
    },

    Hercules = {
        type = ON_REVEAL,
        cost = 2,
        power = 3,
        description = "When Revealed:\nDoubles its power if its\nthe strongest card here.",
        ability = function()
            if #columns[currentCard.column].cards == 1 and #computerColumns[currentCard.column].cards == 0 then
                currentCard.POWER = currentCard.POWER * 2
                return
            end
            if #columns[currentCard.column].cards == 0 and #computerColumns[currentCard.column].cards == 1 then
                currentCard.POWER = currentCard.POWER * 2
                return
            end
            
            if #columns[currentCard.column].cards > 1 then
                strongest = true
                for _, card in ipairs(columns[currentCard.column].cards) do
                    if card ~= currentCard and card.POWER >= currentCard.POWER then
                        strongest = false
                    end
                end
            end
            
            if #computerColumns[currentCard.column].cards > 1 then
                for _, card in ipairs(computerColumns[currentCard.column].cards) do
                    if card ~= currentCard and card.POWER >= currentCard.POWER then
                        strongest = false
                    end
                end
            end

            if strongest == true then
                currentCard.POWER = currentCard.POWER * 2
            end
        end
    },

    Icarus = {
        type =  ON_TURN_END,
        cost = 1,
        power = 1,
        description = "End of Turn:\nGains +1 power, but is\ndiscarded when its power\nis greater than 7.",
        ability = function()
            if currentCard.POWER < 7 then
                currentCard.POWER = currentCard.POWER + 1
            else
                currentCard:discard()
                local col = columns[currentCard.column]
                if not col then return end

                for i, card in ipairs(col.cards) do
                    card.position.y = col.y + (110 * (i - 1))
                    card.index = i
                end
                currentStageIndex = currentStageIndex - 1
            end
        end
    },

    Nyx = {
        type = ON_REVEAL,
        cost = 3,
        power = 2,
        description = "When Revealed:\nDiscards your other cards\nhere, add their power\nto this card.",
        ability = function()
            if currentCard.position.x > 500 then
                local col = columns[currentCard.column]
                if not col then return end

                local discardCards = {}

                for _, card in ipairs(col.cards) do
                    if card ~= currentCard then
                        currentCard.POWER = currentCard.POWER + card.POWER
                        table.insert(discardCards, card)
                    end
                end

                for _, card in ipairs(discardCards) do
                    card:discard()
                    if currentStageIndex ~= 1 then
                        currentStageIndex = currentStageIndex
                    end
                end

                currentCard.index = 1
                currentCard.position.y = col.y
            else
                local col = computerColumns[currentCard.column]
                if not col then return end

                local computerDiscardCards = {}

                for _, card in ipairs(col.cards) do
                    if card ~= currentCard then
                        currentCard.POWER = currentCard.POWER + card.POWER
                        table.insert(computerDiscardCards, card)
                    end
                end

                for _, card in ipairs(computerDiscardCards) do
                    card:discard()
                    if currentStageIndex ~= 1 then
                        currentStageIndex = currentStageIndex
                    end
                end

                currentCard.index = 1
                currentCard.position.y = col.y
            end
        end
    },

    Persephone = {
        type = ON_REVEAL,
        cost = 2,
        power = 2,
        description = "When Revealed:\nDiscard the lowest power\ncard in your hand.",
        ability = function()
            if currentCard.position.x > 500 then
                if playerHand[2] then
                    local lowest = playerHand[2]
                    for i = 2, #playerHand do
                        if lowest.POWER > playerHand[i].POWER then
                            lowest = playerHand[i]
                        end
                    end
                    lowest:discard()
                end
            else
                if computerHand[2] then
                    local lowest = computerHand[2]
                    for i = 2, #computerHand do
                        if lowest.POWER > computerHand[i].POWER then
                            lowest = computerHand[i]
                        end
                    end
                    lowest:discard()
                end
            end
        end
    },

    WoodenCow = {
        type = VANILLA,
        cost = 1,
        power = 1,
        description = "ribbi- i mean moo",
        ability = function()
        end
    },

    Zeus = {
        type = ON_REVEAL,
        cost = 4,
        power = 4,
        description = "When Revealed:\nLower the power of each\ncard in your opponent's\nhand by 1.",
        ability = function()
            if currentCard.position.x > 500 then
                for _, card in ipairs(computerHand) do
                    card.POWER = card.POWER - 1
                end
            else
                for _, card in ipairs(playerHand) do
                    card.POWER = card.POWER - 1
                end
            end
        end
    }
}