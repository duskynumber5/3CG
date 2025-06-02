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
            for _, card in ipairs(computerColumns[currentCard.column].cards) do
                currentCard.POWER = currentCard.POWER + card.POWER
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
                currentCard.POWER = currentCard.POWER + 1
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
                card.POWER = card.POWER + 1
            end
        end
    },

    Hercules = {
        type = ON_REVEAL,
        cost = 2,
        power = 1,
        description = "When Revealed:\n\nDoubles its power if its\nthe strongest card here.",
        ability = function()
            local strongest = true
            for _, card in ipairs(columns[currentCard.column].cards) do
                if currentCard.POWER <= card.POWER then
                    strongest = true
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
        description = "End of Turn:\n\nGains +1 power, but is\ndiscarded when its power\nis greater than 7.",
        ability = function()
            if currentCard.POWER < 7 then
                currentCard.POWER = currentCard.POWER + 1
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
            end

            currentCard.index = 1
            currentCard.position.y = col.y
        end
    },

    Persephone = {
        type = ON_REVEAL,
        cost = 2,
        power = 2,
        description = "When Revealed:\n\nDiscard the lowest power\ncard in your hand.",
        ability = function()
            local lowest = playerHand[2]
            for i = 2, #playerHand do
                if lowest.POWER > playerHand[i].POWER then
                    lowest = playerHand[i]
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
        ability = function()
        end
    },
}