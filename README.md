# 3CG

CMPM 121 Assignment 3\
Name: Maddison Lobo\
Game Title: 3CG -- Frogora’s Box

## IMPLEMENTATION

### PROGRAMMING PATTERNS

A list of the programming patterns used, with a brief description of how you used them and why.

STATE PATTERNS

I use states to control what stage of each round the game is in: picking cards, battling, revealing, and scoring. Also to track card states in order to determine when they get placed and when they are being hovered over or idle. 

UPDATE METHOD

I used this pattern to iterate over the different decks, hands, and columns to get stats or make changes to certain cards within them. I use htis to regurally check and reasign or update data to refect the actions in the game. 

OBJECT POOL PATTERNS
I use this to load in the cards with the same base assets and set them all to the same size. 

FLYWEIGHT PATTERN
Data is taken from the cardValues.lua file and assigned to any asset that matches the name of the data table. Also a single sprite sheet is used for drawing the cards. 

### FEEDBACK

A list of people who gave you feedback on your code of helped you think through your code architecture in discussion sections, the feedback they gave you, and how you adjusted your code to it.

Kayla Nguyn
Comments: Pointed out my column power wasn't always updating properly and suggested new ways to make sure it consistently updates properly. 
Adjustments: I would clear the value and loop through its cards before scoring to make sure it was accurate to any "on_reveal" actions or to any moved cards. 

Killian Peters
Comments: Cards look like they're "glowing" even when they are not grabbable. 
Adjustments: I added a black overlay to cards in the player's hand that are not grabbable. 

Joseph Cortez
Comments: The board was really spread out and there was a lot of dead space.
Adjustments: I made the screen size smaller for now to decrease the dead space. 


### POSTMORTEM

A postmortem on what you did well and what you would do differently if you were to do this project over again 
    (maybe some programming patterns that might have been a better fit?).

Improving from the solitaire project, I was able to use a spritesheet for my assets as well as add some delay or "show" to the game play so it feels less one note. Ideally for the final version I can add animation or more are to improve this even more. I implemented a button element that was missing from my solitare game as well. 

I think once I got my card abilities working they functioned well and I was happy with their implementation. I still have some bits of hard coding and redundent loops that I can clean up but they don't impead things too bad. Overall my implementation is decently strong and has some good qualities but in regards to simplicity and overall flow I think there is still room for imporvement. 

Design wise I think I could rework my layout to make a little more sense for the player and gameplay. Also possibly making the computer's hand visible as well would make it easier for players to stratagize certain cards.

### ASSETS

A list of all assets (sprites, SFX, fonts, music, shaders, etc.) used in this project.

Sprites: I made all of the art
Font: N/A
Music: N/A
SFX: N/A