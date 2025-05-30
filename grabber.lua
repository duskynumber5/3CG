GrabberClass = {}

function GrabberClass:new()
    local grabber = {}
    local metadata = {__index = GrabberClass}
    setmetatable(grabber, metadata)

    grabber.currentMousePos = nil

    grabber.grabPos = nil
  
    grabber.heldObject = nil

    grabber.stackCard = nil

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
    
    self.heldObject.start = {
        x = self.heldObject.position.x,
        y = self.heldObject.position.y
    }

    for j = #playerHand, 1, -1 do
        if playerHand[j] == card then
            table.remove(playerHand, j)
            table.insert(playerHand, self.heldObject)
            break
        end
    end
    for _, column in ipairs(columns) do
        for j = #column.cards, 1, -1 do
            if column.cards[j] == card then
                table.remove(column.cards, j)
                table.insert(column.cards, self.heldObject)
                break
            end
        end
    end
end

function GrabberClass:release()
    if self.heldObject == nil then 
        return
    end
    
    local isValidReleasePosition = false

    local columnIndex, column = checkForCardOver()
    if column then 
        if self.stackCard then
            goto continue
        end
        ::oops::
        self.stackCard = nil
        isValidReleasePosition = true

        for j = #playerHand, 1, -1 do
            if playerHand[j] == self.heldObject then
                table.remove(playerHand, #playerHand)
                break
            end
        end

        removeCardFromColumn(self.heldObject)

        if self.heldObject.column == columnIndex then
            isValidReleasePosition = false
            goto skip
        end

        table.insert(columns[columnIndex].cards, self.heldObject)
        self.heldObject.index = #columns[columnIndex].cards

        self.heldObject.position.x = column.x - 13.5
        self.heldObject.position.y = column.y

        shiftDeck()
        
        ::continue::
        if self.stackCard and not contains(columns[columnIndex].cards, self.stackCard) then
            goto oops
        end
        self.heldObject.column = columnIndex
        ::skip::
    end

    if self.stackCard and self.stackCard.index == 1 and 
    not contains(columns[self.stackCard.column].cards, self.heldObject) then
        if #columns[self.stackCard.column].cards < 4 then

            isValidReleasePosition = true   

            if contains(playerHand, self.heldObject) then
                table.remove(playerHand, #playerHand)
                shiftDeck()
            end

            if not self.heldObject.column == nil then
                table.remove(columns[self.heldObject.column].cards, self.heldObject.index)
            end

            self.heldObject.column = self.stackCard.column
            table.insert(columns[self.stackCard.column].cards, self.heldObject)

            self.heldObject.position.x = self.stackCard.position.x
            self.heldObject.position.y = self.stackCard.position.y + (100 * (#columns[self.stackCard.column].cards - 1))
        end
    end

    if isValidReleasePosition == false then
        self.heldObject.position.x = self.heldObject.start.x
        self.heldObject.position.y = self.heldObject.start.y
    end

    self.heldObject.state = 0
    self.heldObject.grabbable = true
    
    self.stackCard = nil
    self.heldObject = nil
    self.grabPos = nil
end

function checkForCardOver()    
    for i, column in ipairs(columns) do
        local mousePos = grabber.currentMousePos

        if mousePos.x > column.x and mousePos.x < column.x + 70 and
        mousePos.y > column.y and mousePos.y < column.y + 90 then
            
            local occupied = false

            for _, card in ipairs(playerBoard) do
                if card ~= grabber.heldObject and
                   card.position.x == column.x - 13.5 and
                   card.position.y == column.y then
                    occupied = true
                    break
                end
            end

            if not occupied then
                return i, column
            end
        end
    end
    return nil, nil
end

function contains(table, card)
    for _, v in ipairs(table) do
        if v == card then 
            return true 
        end
    end
    return false
end

function shiftDeck()
    i = 2
    for _, pos in ipairs(validPositions) do
        if pos.x == grabber.heldObject.start.x + 13.5 and pos.y == grabber.heldObject.start.y then
            for k = i, #playerHand, 1 do
                playerHand[k].position.x = validPositions[k - 1].x - 13.5
                playerHand[k].position.y = validPositions[k - 1].y
            end
        end
        i = i + 1
    end
end

function removeCardFromColumn(card)
    if card.column == nil then return end
    local col = columns[card.column]
    for i = #col.cards, 1, -1 do
        if col.cards[i] == card then
            table.remove(col.cards, i)
            return
        end
    end
end