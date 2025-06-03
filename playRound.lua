require "player"
require "computer"

PlayClass = {}

function PlayClass:playRound()
    if game.state == GAME_STATE.BATTLE then
        endTurn = false
        
        for _, column in ipairs(columns) do
            for _, card in ipairs(column.cards) do
                card.faceUp = false
                card.grabbable = false
            end
        end
        
        local tries = 0
        repeat
            ComputerClass:pickCards()
            tries = tries + 1
        until endTurn == true or tries > 10

        for _, column in ipairs(computerColumns) do
            for _, card in ipairs(column.cards) do
                card.faceUp = false
            end
        end

        stagedCards = {}

        for i = 1, 3 do
            local playerCol = columns[i]
            local aiCol = computerColumns[i]

            local playerPower, aiPower = 0, 0

            for _, card in ipairs(playerCol.cards) do
                playerPower = playerPower + card.POWER
            end
            for _, card in ipairs(aiCol.cards) do
                aiPower = aiPower + card.POWER
            end

            local flipFirst = "player"
            if aiPower > playerPower then
                flipFirst = "ai"
            elseif aiPower == playerPower then
                flipFirst = math.random(2) == 1 and "player" or "ai"
            end

            if flipFirst == "player" then
                for _, card in ipairs(playerCol.cards) do
                    table.insert(stagedCards, card)
                end
                for _, card in ipairs(aiCol.cards) do
                    table.insert(stagedCards, card)
                end
            else
                for _, card in ipairs(aiCol.cards) do
                    table.insert(stagedCards, card)
                end
                for _, card in ipairs(playerCol.cards) do
                    table.insert(stagedCards, card)
                end
            end
        end

        game.state = GAME_STATE.REVEALING
        for _, card in ipairs(playerHand) do
            card.grabbable = false
        end
        currentStageIndex = 1
        revealFrameDelay = 30
        revealFrameCounter = 0
    end
end

function PlayClass:update()
    -- reveal cards
    if game.state == GAME_STATE.REVEALING then
        revealFrameCounter = revealFrameCounter + 1

        if currentStageIndex > #stagedCards then
            game.state = GAME_STATE.SCORING
        end

        if revealFrameCounter >= revealFrameDelay and currentStageIndex <= #stagedCards then
            local card = stagedCards[currentStageIndex]
            card.faceUp = true
            if card.ACTION_TIME == ON_REVEAL then
                currentCard = card
                CardValues[card.NAME].ability(currentCard)
            end 
            currentStageIndex = currentStageIndex + 1
            revealFrameCounter = 0
        end
    end

    -- award points
    if game.state == GAME_STATE.SCORING then
        for i = 1, 3, 1 do
            local winner = compare(columns[i], computerColumns[i])
            if winner == "player" then
                player.score = player.score + (columns[i].power - computerColumns[i].power)
            end

            if winner == "computer" then
                computer.score = computer.score + (computerColumns[i].power - columns[i].power)
            end

            if winner == "tie" then
                local random = math.random(2)
                if random == 1 then
                    computer.score = computer.score + computerColumns[i].power
                else
                    player.score = player.score + columns[i].power
                end
            end
        end

        currentStageIndex = 1
        revealFrameCounter = 0
        game.state = GAME_STATE.PICK_CARDS

        for _, card in ipairs(playerHand) do
            if card ~= playerHand[1] then
                card.grabbable = true
            end
        end

        game.round = game.round + 1
        -- mana update
        if player.mana == 0 then
            player.mana = game.round
        else
            player.mana = player.mana + game.round
        end

        if player.extraMana then
            player.mana = player.mana + player.extraMana
        end

        if computer.mana == 0 then
            computer.mana = game.round
        else
            computer.mana = computer.mana + game.round
        end

        if computer.extraMana then
            computer.mana = computer.mana + computer.extraMana
        end

        PlayerClass:draw1()
        ComputerClass:draw1()
        player.extraMana = 0
    end
end

function compare(playerCol, computerCol)
    if playerCol.power > computerCol.power then
        return "player"
    end

    if playerCol.power < computerCol.power then
        return "computer"
    end

    if playerCol.power == computerCol.power then
        return "tie"
    end
end