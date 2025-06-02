-- guides events of each round
-- triggered by each player confirming their selection

-- take cards

-- flip cards

-- process actions

-- declare winner

-- if tie flip coin

require "player"
require "computer"

PlayClass = {}

function PlayClass:playRound()
    if game.state == GAME_STATE.BATTLE then
        for _, column in ipairs(columns) do
            for _,card in ipairs(column.cards) do
                card.faceUp = false
                card.grabbable = false
            end
        end

        game.state = GAME_STATE.REVEALING
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