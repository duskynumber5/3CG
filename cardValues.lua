CardValues = {
    Apollo = {
        type = ON_REVEAL,
        cost = 1,
        power = 2,
        description = "When Revealed:\n\nGain +1 mana next turn.",
        ability = function()
            player.mana = player.mana + 1
        end

    },

    Ares = {
        type = ON_REVEAL,
        cost = 3,
        power = 3,
        description = "When Revealed:\n\nGain +2 power for each\nenemy card here.",
        ability = function()
            for _, card in ipairs(opponentColunmns[currentCard.column].cards) do
                currentCard.power = currentCard.power + card.power
            end
        end
    },

    Demeter = {
        type = ON_REVEAL,
        cost = 1,
        power = 1,
        description = "When Revealed:\n\nBoth players draw\na card.",
        ability = function()
            PlayerClass:draw1()
            ComputerClass:draw1()
        end
    },

    Hades = {
        type = ON_REVEAL,
        cost = 4,
        power = 1,
        description = "When Revealed:\n\nGain +2 power for each\ncard in your discard pile.",
        ability = function()
            for _, card in ipairs(discardPile) do
                currentCard.power = currentCard.power + 1
            end
        end
    },

    Hera = {
        type = ON_REVEAL,
        cost = 2,
        power = 3,
        description = "When Revealed:\n\nGive cards in your hand\n+1 power.",
        ability = function()
            for _, card in ipairs(playerHand) do
                card.power = card.power + 1
            end
        end
    },

    Hercules = {
        type = ON_REVEAL,
        cost = 2,
        power = 3,
        description = "When Revealed:\n\nDoubles its power if its\nthe strongest card here.",
        ability = function()
            local strongest = true
            for _, card in ipairs(columns[currentCard.column].cards) do
                if currentCard.power <= card.power then
                    strongest = false
                end
            end

            if strongest == true then
                currentCard.power = currentCard.power * 2
            end
        end
    },

    Icarus = {
        type =  ON_TURN_END,
        cost = 1,
        power = 1,
        description = "End of Turn:\n\nGains +1 power, but is\ndiscarded when its power\nis greater than 7.",
        ability = function()
            if currentCard.power < 7 then
                currentCard.power = currentCard.power + 1
            else
                currentCard:discard()
            end
        end
    },

    Nyx = {
        type = ON_REVEAL,
        cost = 3,
        power = 2,
        description = "When Revealed:\n\nDiscards your other cards\nhere, add their power\nto this card.",
        ability = function()
            for _, card in ipairs(columns[currentCard.column].cards) do
                if card ~= currentCard then
                    card:discard()
                    currentCard.power = currentCard.power + card.power
                end
            end
        end
    },

    Persephone = {
        type = ON_REVEAL,
        cost = 2,
        power = 2,
        description = "When Revealed:\n\nDiscard the lowest power\ncard in your hand.",
        ability = function()
            local losest = playerHand[1]
            for _, card in ipairs(playerHand) do
                if lowest.power > card.power then
                    lowest = card
                end
            end

            lowest:discard()
        end
    },

    WoodenCow = {
        type = VANILLA,
        cost = 1,
        power = 1,
        description = "ribbi- i mean moo",
        ability = nil
    },
}