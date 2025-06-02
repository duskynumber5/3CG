-- manages cards and their assets
require "vector"
require "cardValues"

CardClass = {}

CARD_STATE = {
    IDLE = 0,
    MOUSE_OVER = 1,
    GRABBED = 2,
}

function CardClass:loadCards()
    cardWidth = 64
    cardHeight = 64
    quads = {}

    local sheetCols = 6
    local sheetRows = 2

    for row = 0, sheetRows - 1 do
        for col = 0, sheetCols - 1 do
            local quad = love.graphics.newQuad(
                col * cardWidth,
                row * cardHeight,
                cardWidth,
                cardHeight,
                SPRITE_SHEET:getDimensions()
            )
            table.insert(quads, quad)
        end
    end

    cards = {}
    names = {
        "cardBack",
        "Apollo",
        "Ares",
        "Demeter",
        "Hades",
        "Hera",
        "Hercules",
        "Icarus",
        "Nyx",
        "Persephone",
        "WoodenCow"
    }


    for j=1, 11 do
        local card = {
            name = names[j],
            image = quads[j],
        }
        table.insert(cards, card)
    end
end

function CardClass:newCard(x, y, counter, grabbable)
    local card = {}
    local metadata = {__index = CardClass}
    setmetatable(card, metadata)

    card.position = Vector(x, y)
    card.size = Vector(70, 90)
    card.counter = counter
    card.image = nil
    card.faceUp = true

    card.grabbable = grabbable

    card.column = nil
    card.originalColumn = nil
    card.index = nil

    card.NAME = "name"
    card.POWER = 0
    card.COST = 0
    card.DESCRIPTION = "description"
    card.ACTION_TIME = nil

    card:assignValues()

    return card
end

function CardClass:update()
    for _, card in ipairs(playerHand) do
        if card ~= playerHand[1] then
            card.grabbable = card.COST <= player.mana
        end
    end
end

function CardClass:assignValues()
    if self.counter and cards[self.counter] then
        local cardFace = cards[self.counter]
        self.NAME = cardFace.name
        if self.faceUp == true then
            self.image = cardFace.image
        else
            self.image = cards[1].image
        end
    end

    if self.counter and cards[self.counter] then
        local values = CardValues[self.NAME]
        if values then
            self.POWER = values.power
            self.COST = values.cost
            self.DESCRIPTION = values.description
            self.ACTION_TIME = values.type
        end
    end
end

function CardClass:draw()
    width = 64
    height = 64
    black = {0, 0, 0, 0.8}
    white = {1, 1, 1 ,1}

    if self.state ~= CARD_STATE.IDLE and self.grabbable == true and self.faceUp == true and grabber.heldObject == nil then
        love.graphics.setColor(0, 0, 0, 0.8) 
        local offset = 18 * (self.state == CARD_STATE.GRABBED and 2 or 1)
        love.graphics.rectangle("fill", self.position.x + offset, (self.position.y - 12) + offset, width + 10, height + 30, 6, 6)
    end

    if self.state == CARD_STATE.MOUSE_OVER and self.faceUp == true and grabber.heldObject == nil and playerHand[1] ~= self then
        love.graphics.setColor(black) 
        love.graphics.rectangle("fill", 1000 / 3, 120, 325, 300, 6, 6)

        love.graphics.setNewFont(40)
        love.graphics.setColor(white) 
        love.graphics.print(self.NAME, (1000 / 3) + 10, 130)
        love.graphics.setNewFont(20)
        love.graphics.print("Cost: " .. self.COST, (1000 / 3) + 10, 190)
        love.graphics.print("Power: " .. self.POWER, (1000 / 3) + 10, 220)
        love.graphics.print(self.DESCRIPTION, (1000 / 3) + 10, 270)
    end

    love.graphics.setColor(white)
    love.graphics.setNewFont(12)

    if self.counter and cards[self.counter] then
        local cardFace = cards[self.counter]
        self.NAME = cardFace.name
        if self.faceUp == true then
            self.image = cardFace.image
        else
            self.image = cards[1].image
        end
    end

    love.graphics.draw(SPRITE_SHEET, self.image, self.position.x, self.position.y, 0, 1.5, 1.5)

    love.graphics.print(tostring(self.state), self.position.x + 20, self.position.y - 20)
    love.graphics.print(tostring(self.column), self.position.x + 20, self.position.y - 30)
end

function CardClass:checkForMouseOver()
    if self.state == CARD_STATE.GRABBED then
        return
    end

    local mousePos = grabber.currentMousePos
    local isMouseOver =
        mousePos.x > self.position.x and
        mousePos.x < self.position.x + self.size.x and 
        mousePos.y > self.position.y and
        mousePos.y < self.position.y + self.size.y

    self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE

    if self.state == CARD_STATE.MOUSE_OVER and columnContains(self) then
        if grabber.heldObject then
    
            local hasCardOnTop = false
            for _, other in ipairs(playerBoard) do
                if other ~= self and
                   other.position.x == self.position.x and
                   other.position.y > self.position.y and
                   (other.position.y - self.position.y) <= 35 then
                    hasCardOnTop = true
                    break
                end
            end
    
            if not hasCardOnTop then
                grabber.stackCard = self
                return
            end
        end
        grabber.stackCard = nil
    end
end

function CardClass:discard()
    if self.column and columns[self.column] then
        for i, card in ipairs(columns[self.column].cards) do
            if card == self then
                table.remove(columns[self.column].cards, i)
                table.insert(discard, card)
                for i, card in ipairs(stagedCards) do
                    if card == self then
                        table.remove(stagedCards, i)
                        break
                    end
                end
            end
        end
    end

    for i, card in ipairs(playerHand) do
        if card == self then
            table.remove(playerHand, i)
            table.insert(discard, card)

            local index = 2
            for _, pos in ipairs(validPositions) do
                if pos.x == card.position.x + 13.5 and pos.y == card.position.y then
                    for k = index, #playerHand, 1 do
                        playerHand[k].position.x = validPositions[k - 1].x - 13.5
                        playerHand[k].position.y = validPositions[k - 1].y
                    end
                end
                index = index + 1
            end
            break
        end
    end

    self.position.x = discardPile.x - 13.5
    self.position.y = discardPile.y
    self.faceUp = true
    self.grabbable = false
end

-- simple array shuffle :) https://gist.github.com/Uradamus/10323382 
function CardClass:shuffle(deck)
    for i = #deck, 2, -1 do
        local random = math.random(i)
        deck[i], deck[random] = deck[random], deck[i]
    end
    return deck
end

function columnContains(item)
    for _, column in ipairs(columns) do
        for _, card in ipairs(column.cards) do
            if card == item then 
                return true 
            end
        end
    end
    return false
end
