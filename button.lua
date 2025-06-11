black = {0, 0, 0 ,0}
white = {1, 1, 1 ,1}

function button(text, funct, paramater, width, height)
    return {
        width = width or 100, 
        height = height or 100,
        funct = funct, 
        paramater = paramater, 
        text = text or "no text", 
        buttonX = 0,
        buttonY = 0, 
        textX = 0,
        textY = 0,
        
        checkPressed = function(self, mouseX, mouseY)
            if mouseX then
                if mouseX >= self.buttonX and mouseX <= self.buttonX + self.width then
                    if mouseY >= self.buttonY and mouseY <= self.buttonY + self.height then
                        if self.paramater then
                            self.funct(self.paramater)
                            return
                        else
                            self.funct()
                            return
                        end
                    end
                end
            else
                self.funct()
                return
            end
        end,

        draw = function(self, buttonX, buttonY, textX, textY)
            self.buttonX = buttonX or self.buttonX
            self.buttonY = buttonY or self.buttonY

            if textX then
                self.textX = textX + self.buttonX
            end

            if textY then
                self.textY = textY + self.buttonY
            end

            love.graphics.setColor(white)

            love.graphics.rectangle("fill", self.buttonX, self.buttonY + 10, self.width, self.height, 6, 6)


            love.graphics.setColor(black)
            love.graphics.setNewFont("assets/Greek_Classics.otf", 30)
            love.graphics.print(self.text, self.textX, self.textY)

            love.graphics.setNewFont("assets/Greek_Classics.otf", 20)
        end
    }
end

return button