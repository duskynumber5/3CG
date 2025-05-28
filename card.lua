-- manages cards and their assets
require "vector"

CardClass = {}

CARD_STATE = {
    IDLE = 0,
    MOUSE_OVER = 1,
    GRABBED = 2,
}

function CardClass:newCard(x, y, image, grabbable)
    local card = {}
    local metadata = {__index = CardClass}
    setmetatable(card, metadata)

    card.position = Vector(x, y)
    card.size = Vector(70, 90)
    card.image = image

    card.grabbable = grabbable

    card.NAME = nil 
    card.POWER = nil
    card.COST = nil
    card.ACTION_TIME = nil

    return card
end

function CardClass:draw()
    width = 64
    height = 64

    if self.state ~= CARD_STATE.IDLE and self.grabbable == true then
        love.graphics.setColor(0, 0, 0, 0.8) 
        local offset = 18 * (self.state == CARD_STATE.GRABBED and 2 or 1)
        love.graphics.rectangle("fill", self.position.x + offset, (self.position.y - 12) + offset, width + 10, height + 30, 6, 6)
    end

    love.graphics.setColor(1, 1, 1 ,1)

    love.graphics.draw(self.image, self.position.x, self.position.y, 0, 1.5, 1.5)

    love.graphics.print(tostring(self.state), self.position.x + 20, self.position.y - 20)
    love.graphics.print(tostring(self), self.position.x + 20, self.position.y - 30)
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

    if self.state == CARD_STATE.MOUSE_OVER and playerBoard[self] then
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
            end
        end
    end
end
