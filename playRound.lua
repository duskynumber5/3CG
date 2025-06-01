-- guides events of each round
-- triggered by each player confirming their selection

-- take cards

-- flip cards

-- process actions

-- declare winner

-- if tie flip coin

PlayClass = {}

function PlayClass:playRound()
    if game.state == GAME_STATE.BATTLE then
        for _, column in ipairs(columns) do
            for _,card in ipairs(column.cards) do
                card.faceUp = false
                card.grabbable = false
            end
        end
    end

    
end