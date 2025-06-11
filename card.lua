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
        "WoodenCow",
        "Zeus"
    }


    for j=1, 12 do
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
    transparentBlack = {0, 0, 0, 0.5}
    white = {1, 1, 1 ,1}

    if game.state == GAME_STATE.PICK_CARDS then
        if self.state ~= CARD_STATE.IDLE and self.grabbable == true and self.faceUp == true and grabber.heldObject == nil then
            love.graphics.setColor(black) 
            local offset = 18 * (self.state == CARD_STATE.GRABBED and 2 or 1)
            love.graphics.rectangle("fill", self.position.x + offset, (self.position.y - 12) + offset, width + 10, height + 30, 6, 6)
        end

        if self.state == CARD_STATE.MOUSE_OVER and self.faceUp == true and grabber.heldObject == nil and playerHand[1] ~= self then
            love.graphics.setColor(black) 
            love.graphics.rectangle("fill", 500 - 162.5, 200, 325, 300, 6, 6)
            love.graphics.rectangle("fill", 500 - 162.5, 200, 325, 300, 6, 6)

            love.graphics.setNewFont("assets/Greek_Classics.otf", 45)
            love.graphics.setColor(white) 
            love.graphics.print(self.NAME, 500 - 162.5 + 10, 210)
            love.graphics.setNewFont("assets/Greek_Classics.otf", 30)
            love.graphics.print("Cost: " .. self.COST, 500 - 162.5 + 10, 260)
            love.graphics.print("Power: " .. self.POWER, 500 - 162.5 + 10, 290)
            love.graphics.print(self.DESCRIPTION, 500 - 162.5 + 10, 340)
        end
    end

    love.graphics.setColor(white)
    love.graphics.setNewFont("assets/Greek_Classics.otf", 20)

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

    if self.grabbable == false and playerHand[1] ~= self and self.position.y > 550 then
        love.graphics.setColor(transparentBlack)
        love.graphics.rectangle("fill", self.position.x + 15, self.position.y + 1, self.size.x - 5, self.size.y + 5, 6, 6)
        love.graphics.setColor(white)
    end

    if self.column ~= nil and self.state ~= CARD_STATE.GRABBED then
        love.graphics.rectangle("line", self.position.x + 13.5, self.position.y, 69, 96, 6 ,6)
    end
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
        local col = columns[self.column]
        for i, card in ipairs(col.cards) do
            if card == self then
                table.remove(col.cards, i)
                table.insert(discard, card)

                for j, card in ipairs(col.cards) do
                    card.position.y = col.y + 100 * (j - 1)
                    card.index = j
                end

                self.position.x = discardPile.x - 13.5
                self.position.y = discardPile.y

                break
            end
        end
    end

    if self.column and computerColumns[self.column] then
        local col = computerColumns[self.column]
        for i, card in ipairs(col.cards) do
            if card == self then
                table.remove(col.cards, i)
                table.insert(computerDiscardPile, card)

                for j, card in ipairs(col.cards) do
                    card.position.y = col.y + 100 * (j - 1)
                    card.index = j
                end

                self.position.x = computerDiscardPile.x - 13.5
                self.position.y = computerDiscardPile.y

                break
            end
        end
    end

    for i, card in ipairs(playerHand) do
        if card == self then
            table.remove(playerHand, i)
            table.insert(discard, card)

            self.position.x = discardPile.x - 13.5
            self.position.y = discardPile.y

            for j = i, #playerHand do
                playerHand[j].position.x = validPositions[j - 1].x - 13.5
                playerHand[j].position.y = validPositions[j - 1].y
            end

            break
        end
    end

    for i, card in ipairs(computerHand) do
        if card == self then
            table.remove(computerHand, i)
            table.insert(computerDiscardPile, card)

            self.position.x = computerDiscardPile.x - 13.5
            self.position.y = computerDiscardPile.y

            for j = i, #computerHand do
                computerHand[j].position.x = computerPositions[j].x - 13.5
                computerHand[j].position.y = computerPositions[j].y
            end

            break
        end
    end

    for i, card in ipairs(stagedCards) do
        if card == self then
            table.remove(stagedCards, i)
        end
    end
    
    self.state = CARD_STATE.IDLE
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
