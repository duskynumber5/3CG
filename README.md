# 3CG

CMPM 121 Assignment 3\
Name: Maddison Lobo\
Game Title: 3CG -- Frogora’s Box

## IMPLEMENTATION

### PROGRAMMING PATTERNS

A list of the programming patterns used, with a brief description of how you used them and why.

STATE PATTERNS

I use states to control what stage of each round the game is in: picking cards, battling, revealing, and scoring. Also to track card states in order to determine when they get placed and when they are being hovered over or idle. 

SEQUENCING PATTERNS

I used this pattern to iterate over the different decks, hands, and columns to get stats or make changes to certain cards within them. 

OBJECT POOL PATTERNS
I use this to load in the cards with the same base assets and set them all to the same size. 

### FEEDBACK

A list of people who gave you feedback on your code of helped you think through your code architecture in discussion sections, the feedback they gave you, and how you adjusted your code to it.

Kayla Nguyn
Comments: 
Adjustments: 

Killian Peters
Comments: Cards look like they're "glowing" even when they are not grabbable. 
Adjustments: I added a black overlay to cards in the player's hand that are not grabbable. 

Joseph Cortez
Comments: The board was really spread out and there was a lot of dead space.
Adjustments: I made the screen size smaller for now to decrease the dead space. 


### POSTMORTEM

A postmortem on what you did well and what you would do differently if you were to do this project over again 
    (maybe some programming patterns that might have been a better fit?).

write

### ASSETS

A list of all assets (sprites, SFX, fonts, music, shaders, etc.) used in this project.

Card Sprites: Maddison Lobo
Font: 
