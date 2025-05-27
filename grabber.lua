GrabberClass = {}

function GrabberClass:new()
    local grabber = {}
    local metadata = {__index = GrabberClass}
    setmetatable(grabber, metadata)

    grabber.currentMousePos = nil

    grabber.grabPos = nil
  
    grabber.heldObject = nil

    return grabber
end

function GrabberClass:update()
    self.currentMousePos = Vector(
        love.mouse.getX(),
        love.mouse.getY()
    )
    
    -- click
    if love.mouse.isDown(1) and self.heldObject then

        self.heldObject.position.x = self.currentMousePos.x - 30
        self.heldObject.position.y = self.currentMousePos.y - 30
    end
    -- release
    if not love.mouse.isDown(1) and self.grabPos ~= nil then
        self:release()
    end
end

function GrabberClass:grab(card)
    self.grabPos = self.currentMousePos
    self.heldObject = card

    self.heldObject.state = CARD_STATE.GRABBED
    
    self.heldObject.start = Vector(
        self.heldObject.position.x,
        self.heldObject.position.y
    )
end

function GrabberClass:release()
    if self.heldObject == nil then 
        return
    end
    
    local isValidReleasePosition = false

    local pos = checkForCardOver()
    if pos then
        isValidReleasePosition = true
        self.heldObject.position.x = pos.x - 13.5
        self.heldObject.position.y = pos.y
    end

    if isValidReleasePosition == false then
        self.heldObject.position = self.heldObject.start
    end

    self.heldObject.state = 0
    
    self.heldObject = nil
    self.grabPos = nil
end

function checkForCardOver()    
    for _, pos in ipairs(validPositions) do
        local mousePos = grabber.currentMousePos
        if mousePos.x > pos.x and mousePos.x < pos.x + 70 and
        mousePos.y > pos.y and mousePos.y < pos.y + 90 then
            
            local occupied = false

            for _, card in ipairs(playerDeck) do
                if card ~= grabber.heldObject and
                   card.position.x == pos.x and
                   card.position.y == pos.y then
                    occupied = true
                    break
                end
            end

            if not occupied then
                return pos
            end
        end
    end
    return nil
end


