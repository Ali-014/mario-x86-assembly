.386
.model flat, stdcall
.stack 4096


INCLUDE Irvine32.inc
INCLUDE macros.inc
INCLUDELIB winmm.lib

PlaySoundA PROTO, pszSound:PTR BYTE, hmod:DWORD, fdwSound:DWORD
mciSendStringA PROTO, lpstrCommand:PTR BYTE, lpstrReturnString:PTR BYTE, uReturnLength:DWORD, hwndCallback:DWORD

.data

; ===========================
; LEVEL MAPS (29 lines x 120 chars each)
; ===========================
level1 BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                     __      _          ",13,10
       BYTE "       _( )                                                                                        _(  )___ ( )_        ",13,10
       BYTE "       (_ _ )_                                                                                    (_   _   _  _ )       ",13,10
       BYTE "                                                                                                    (_)(_)(_)           ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                   R   O                                                                ",13,10
       BYTE "                                            #############                                                               ",13,10
       BYTE "                                                                O               O                                       ",13,10
       BYTE "                                                              ########         #####                                    ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                     F                                  ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                           O                            ",13,10
       BYTE "                                                                                      #########                         ",13,10
       BYTE "                          ###  #?##                                                                                     ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                  M                O   W                                              #########         ",13,10
       BYTE "                              #######             #######                                                               ",13,10
       BYTE "                  OO                                                           G                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                           R   O                                               %%                       ",13,10
       BYTE "                                        ################                                 ##########                     ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "           PPPP                                                                                                         ",13,10
       BYTE "           PPPP           PP   G      *                        K                                                        ",13,10
       BYTE "           PPPP           PP                                                                                            ",13,10
       BYTE "---------------------    -----------------------------------------------------------------------------------------------",13,10,0

level2 BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                             O                                          ",13,10
       BYTE "                                                                           #####                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                       *                                                ",13,10
       BYTE "                                                                    #######                                             ",13,10
       BYTE "       OO             G                             OO                                                                  ",13,10
       BYTE "      #######                                       #######                                                             ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                           ##                                           ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                 ############################                                                                           ",13,10
       BYTE "                                                                       ####                                             ",13,10
       BYTE "                                                                                        PPP                             ",13,10
       BYTE "                                                                 PPP                    PPP                             ",13,10
       BYTE "                    O   O                      G                 PPP                    PPP G                           ",13,10
       BYTE "-----------------------------------------------------------------------                ---------------------------------",13,10,0

level3 BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                  F                                                                                     ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                OOO                     ",13,10
       BYTE "                                                                                         ###LLL#######                  ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                   OO           ######                                  ",13,10
       BYTE "                                                            ##############                                              ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                        O                                                                               ",13,10
       BYTE "                                  #############     #####                                                               ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                    OOO                                                                                                 ",13,10
       BYTE "              #############                                                                                             ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "       O       G                                                                                                        ",13,10
       BYTE "    #######                                                                                                             ",13,10
       BYTE "                                  ###########                              #######                                      ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                                                     OOOOO                                                              ",13,10
       BYTE "                                                  ############                                                          ",13,10
       BYTE "                                                                                                                        ",13,10
       BYTE "                              P                                                                                         ",13,10
       BYTE "                              P                                                                                         ",13,10
       BYTE "                              P        P   *                                 B                    G                     ",13,10
       BYTE "--------------------------------LLLLLLL---------------------------------------------------------------------------------",13,10,0



; Boundaries
MIN_X BYTE 1
MAX_X BYTE 118
GROUND_Y BYTE 27

; Player End Check
PlayerEndCheck BYTE 0
EndX_POS BYTE 118
ENDY_POS BYTE 27

; Game state
currentLevel BYTE 1
maxLevels BYTE 3
score DWORD 0
coinsCollected DWORD 0

; Player properties
xPos BYTE 10
yPos BYTE 27
inAir BYTE 0
jumpHeight BYTE 0
maxJumpHeight BYTE 6

; Player lives and invincibility
playerLives BYTE 3
isInvincible BYTE 0
invincibilityTimer DWORD 0
invincibilityMaxTime DWORD 2000

; Movement speeds
groundSpeed BYTE 1
airSpeed BYTE 1

; Smooth movement variables
moveStepsRemaining BYTE 0
moveDirection BYTE 0


; Speed Racer Mario feature
boostedGroundSpeed BYTE 2
boostedAirSpeed BYTE 2
turboActive BYTE 0
turboTimer DWORD 0
turboMaxTime DWORD 8000
turboGroundSpeed BYTE 4
turboAirSpeed BYTE 2


; Directional collision detection
prevYPos BYTE ?
collisionFromAbove BYTE 0
collisionFromBelow BYTE 0
collisionFromLeft BYTE 0
collisionFromRight BYTE 0


; Platform data
numPlatforms BYTE 0
platform1x BYTE 15 DUP(?)
platform1y BYTE 15 DUP(?)
platformWidths BYTE 15 DUP(?)


; Pit data
pitDeathMsg BYTE "YOU FELL IN A PIT! -1 LIFE",0


; Coin data
numCoins BYTE 0
coinX BYTE 20 DUP(?)
coinY BYTE 20 DUP(?)
coinCollected BYTE 20 DUP(?)
coinValue DWORD 10

;coins 
numMysteryBlocks BYTE 0
mysteryBlockX BYTE 15 DUP(?)
mysteryBlockY BYTE 15 DUP(?)
mysteryBlockActivated BYTE 15 DUP(?)  ; 0=has coin, 1=empty
mysteryBlockValue DWORD 50 
mysteryBlockMsg BYTE   "                 MYSTERY BLOCK ACTIVATED! COIN APPEARS!            ",0


; Turbo Star data
numTurboStars BYTE 0
turboStarX BYTE 5 DUP(?)
turboStarY BYTE 5 DUP(?)
turboStarCollected BYTE 5 DUP(?)


; GOOMBA ENEMY SYSTEM
numEnemies BYTE 0
enemyX BYTE 10 DUP(?)
enemyY BYTE 10 DUP(?)
enemyAlive BYTE 10 DUP(?)
enemyDirection BYTE 10 DUP(?)
enemySpeed BYTE 1
enemyValue DWORD 100

; KOOPA SHELL SYSTEM
movingShellActive BYTE 0       ; 0 means shell is not moving 1 means moving
movingShellX BYTE ?            ; X position of moving shell
movingShellY BYTE ?            ; Y position of moving shell  
movingShellSpeed BYTE 1    
shellCreatedMsg BYTE   "                KOOPA SHELL CREATED! TOUCH AGAIN TO REMOVE         ",0
shellRemovedMsg BYTE   "                   SHELL REMOVED! +50 BONUS POINTS                 ",0


; KOOPA ENEMY DATA
koopaSpeed BYTE 1              
numKoopas BYTE 0
koopaX BYTE 10 DUP(?)
koopaY BYTE 10 DUP(?)
koopaAlive BYTE 10 DUP(?)      ; 0 = dead, 1 = alive 
koopaDirection BYTE 10 DUP(?)  ; 0 = left, 1 = right 
koopaType BYTE 10 DUP(?)       ; 0 = green K, 1 = red R
koopaValue DWORD 150


; FLYING ENEMY SYSTEM (PARAGOOMBAS)
numFlyingEnemies BYTE 0
flyingEnemyX BYTE 10 DUP(?)
flyingEnemyY BYTE 10 DUP(?)
flyingEnemyAlive BYTE 10 DUP(?)
flyingEnemyDirection BYTE 10 DUP(?)    ; 0 = left, 1 = right
flyingEnemySpeed BYTE 1
flyingEnemyValue DWORD 150              ; Worth more than regular Goombas

; Vertical movement for flying enemies 
flyingEnemyBaseY BYTE 10 DUP(?)         ; Original Y position
flyingEnemyBobOffset BYTE 10 DUP(?)     ; Current bob offset (0-3)
flyingEnemyBobDirection BYTE 10 DUP(?)  ; 0=up, 1=down

; Flying enemy messages
flyingEnemyDefeatedMsg BYTE "               FLYING ENEMY DEFEATED!  +150 POINTS!                ",0


; FIRE MARIO SYSTEM
isSuperMario BYTE 0              ; 0 = small, 1 = super it is needed to become Fire Mario
isFireMario BYTE 0               ; 0 = normal, 1 = fire mario

superMarioInvincible BYTE 0      ; 0 = normal super mario, 1 = can destroy 1 enemy by touch
superMarioHitMsg BYTE "                SUPER MARIO CRUSHES ENEMY!  +150 POINTS!                ",0
superMarioPowerLostMsg BYTE "            SUPER MARIO POWER LOST!  BACK TO NORMAL MARIO          ",0

; Super Mushroom data required to become Super Mario first
numMushrooms BYTE 0
mushroomX BYTE 5 DUP(?)
mushroomY BYTE 5 DUP(?)
mushroomCollected BYTE 5 DUP(?)

; Fire Flower power up data
numFireFlowers BYTE 0
fireFlowerX BYTE 5 DUP(?)
fireFlowerY BYTE 5 DUP(?)
fireFlowerCollected BYTE 5 DUP(?)

; Fireball data 
MAX_FIREBALLS EQU 2
numActiveFireballs BYTE 0
fireballX BYTE 2 DUP(?)
fireballY BYTE 2 DUP(?)
fireballActive BYTE 2 DUP(?)     ; 0 = inactive, 1 = active
fireballDirection BYTE 2 DUP(?)  ; 0 = left, 1 = right
fireballSpeed BYTE 2             ; How fast fireballs move


; Fire Mario messages
superMushroomMsg BYTE  "                 SUPER MUSHROOM!  YOU ARE NOW SUPER MARIO!         ",0
fireFlowerMsg BYTE     "               FIRE FLOWER!  PRESS S TO SHOOT FIREBALLS!           ",0
fireballKillMsg BYTE   "                  FIREBALL HIT! +100 POINTS!                       ",0
maxFireballsMsg BYTE   "                        MAX 2 FIREBALLS!                           ",0
needSuperMarioMsg BYTE "                      NEED SUPER MARIO FIRST!                      ",0


; BOWSER BOSS SYSTEM
; Bowser state
bowserActive BYTE 0             ; 0 = not active, 1 = active
bowserAlive BYTE 0              ; 0 = dead, 1 = alive
bowserHealth BYTE 3             ; Takes 3 hits to defeat
bowserMaxHealth BYTE 3

; Bowser position top-left corner of 2x2 sprite
bowserX BYTE 100                ; X position
bowserY BYTE 26                 ; Y position (on ground 1 for 2x2)
bowserDirection BYTE 0          ; 0 = left, 1 = right
bowserSpeed BYTE 1

; Bowser movement boundaries
bowserMinX BYTE 70              ; Left boundary
bowserMaxX BYTE 115             ; Right boundary

; Bowser fire breath system
bowserFireActive BYTE 0         ; 0 = no fire, 1 = fire active
bowserFireX BYTE 0              ; Fire breath X position
bowserFireY BYTE 0              ; Fire breath Y position
bowserFireSpeed BYTE 2          ; Speed of fire breath
bowserFireTimer DWORD 0         ; Timer for fire breath
bowserFireInterval DWORD 3000   ; Fire every 3 seconds (3000ms in terms of code)

; Bowser hit animation
bowserHitTimer DWORD 0          ; Timer for hit flash effect
bowserHitFlashing BYTE 0        ; Is bowser flashing from hit? 

; Bowser defeat animation
bowserDefeated BYTE 0           ; 1=bowser is defeated, show animation
bowserDefeatTimer DWORD 0       ; Timer for defeat animation

; Bowser collision values
bowserPointValue DWORD 500      ; Points for defeating Bowser
bowserHitValue DWORD 100        ; Points per hit

; Bowser messages
bowserAppearMsg BYTE "BOWSER APPEARS!  DEFEAT HIM TO SAVE THE PRINCESS!", 0
bowserHitMsg BYTE      "                     BOWSER HIT!                                   ",0
bowserHealthMsg BYTE   "                     HITS LEFT!                                    ",0
bowserDefeatedMsg BYTE "                 BOWSER DEFEATED! +500 POINTS!                     ",0
bowserFireMsg BYTE     "                 BOWSER BREATHES FIRE!                             ",0
fireballCollideMsg BYTE"                   FIREBALLS COLLIDE!                              ",0
bowserRoarMsg BYTE     "                       ROOOAR!                                     ",0

enemyComboCount BYTE 0         ; Counter for kills without dying
comboBonusTime DWORD 20        ; Seconds to add
comboMsg BYTE "COMBO! 3 KILLS! +20 SECONDS!", 0

;pipes
numPipes BYTE 0
pipeX BYTE 10 DUP(?)        ; X position of each pipe
pipeY BYTE 10 DUP(?)        ; Y position of pipe bottom
pipeHeight BYTE 10 DUP(?)   ; Height of each pipe


; File handling
tempBuffer BYTE 4096 DUP(0)
BUFFER_SIZE EQU 4096
existingSize DWORD 0
numberBuffer BYTE 20 DUP(0)
playerName BYTE 30 DUP(0)
fileHandle DWORD ?
scorefile BYTE "scores.txt",0


; Input
inputChar BYTE ?


; Parsing temporary variables
platformStartX BYTE ?
inPlatform BYTE ?

; Display strings
strScore BYTE "Score: ",0
strCoins BYTE " | Coins: ",0
strLevel BYTE " | Level: ",0
strLives BYTE " | Lives: ",0
strTurbo BYTE " | TURBO: ",0
strInactive BYTE "OFF",0
nameLabel BYTE "Name: ",0
scoreLabel BYTE " | Score: ",0
levelLabel BYTE " | Level: ",0
newline BYTE 13,10,0
defaultName BYTE "Unknown",0
inputNamePrompt BYTE "Enter your name: ",0
checkforsavetofile BYTE 0

; Level messages
levelCompleteMsg BYTE "LEVEL ",0
levelCompleteMsg2 BYTE" COMPLETE!",0
pressKeyMsg BYTE      "          Press ANY KEY to continue... ",0
gameOver BYTE         "GAME OVER!",0
gameComplete BYTE     "                   ALL LEVELS COMPLETE! YOU WIN!                  ",0
featureMsg BYTE       "                 SPEED RACER MARIO - 25% Faster Movement!         ",0
turboMsg BYTE         "                  TURBO STAR COLLECTED! 2x SPEED FOR 8 SECONDS!   ",0
enemyDefeatedMsg BYTE "                          GOOMBA DEFEATED! +100 POINTS!           ",0
playerHitMsg BYTE     "                          YOU GOT HIT! INVINCIBLE FOR 2 SECONDS!  ",0
gameOverLivesMsg BYTE "NO LIVES LEFT!",0


; Menu strings
welcomeTitle1 BYTE "  _____ _    _ _____  ______ _____    __  __          _____  _____ ____  ", 0
welcomeTitle2 BYTE " / ____| |  | |  __ \|  ____|  __ \  |  \/  |   /\   |  __ \|_   _/ __ \ ", 0
welcomeTitle3 BYTE "| (___ | |  | | |__) | |__  | |__) | | \  / |  /  \  | |__) | | || |  | |", 0
welcomeTitle4 BYTE " \___ \| |  | |  ___/|  __| |  _  /  | |\/| | / /\ \ |  _  /  | || |  | |", 0
welcomeTitle5 BYTE " ____) | |__| | |    | |____| | \ \  | |  | |/ ____ \| | \ \ _| || |__| |", 0
welcomeTitle6 BYTE "|_____/ \____/|_|    |______|_|  \_\ |_|  |_/_/    \_\_|  \_\_____\____/ ", 0

; Flagpole data
flagpoleX BYTE 60           ; Center of screen column
flagpoleY BYTE 8            ; Top of pole
flagpoleHeight BYTE 15      ; Height of pole
flagCurrentY BYTE ?         ; Current flag position

; Firework data
numFireworks BYTE 5         ; Number of firework bursts
fireworkX BYTE 5 DUP(?)     ; X positions
fireworkY BYTE 5 DUP(?)     ; Y positions
fireworkStage BYTE 5 DUP(?) ; Animation stage (0-4)
fireworkActive BYTE 5 DUP(?)

; Victory messages
victoryMsg1 BYTE "  _     _______      ________ _        _____ ____  __  __ _____  _      ______ _______ ______ _ ", 0
victoryMsg2 BYTE " | |   | ____\ \    / /  ____| |      / ____/ __ \|  \/  |  __ \| |    |  ____|__   __|  ____| |", 0
victoryMsg3 BYTE " | |   | |__  \ \  / /| |__  | |     | |   | |  | | \  / | |__) | |    | |__     | |  | |__  | |", 0
victoryMsg4 BYTE " | |   |  __|  \ \/ / |  __| | |     | |   | |  | | |\/| |  ___/| |    |  __|    | |  |  __| | |", 0
victoryMsg5 BYTE " | |___| |____  \  /  | |____| |____ | |___| |__| | |  | | |    | |____| |____   | |  | |____|_|", 0
victoryMsg6 BYTE " |_____|______|  \/   |______|______| \_____\____/|_|  |_|_|    |______|______|  |_|  |______(_)", 0

victoryStatsMsg BYTE "AMAZING PERFORMANCE!", 0
continueVictoryMsg BYTE "Press ANY KEY to continue to next level...", 0

 
; Leaderboard data structures
MAX_LEADERBOARD_ENTRIES EQU 50         ; Store up to 50 scores
leaderboardNames BYTE 50 * 30 DUP(0)   ; 50 names, 30 chars each
leaderboardScores DWORD 50 DUP(0)      ; 50 scores
leaderboardLevels BYTE 50 DUP(0)       ; 50 levels completed
leaderboardCount DWORD 0               ; Current number of entries

; Display strings
leaderboardTitle BYTE "          HIGH SCORES", 0
leaderboardHeader BYTE "RANK  NAME                     SCORE    LEVEL", 0
leaderboardSeparator BYTE "-------------------------------------------", 0
noScoresMsg BYTE "No high scores yet! Be the first!", 0
backToMenuMsg BYTE "Press ANY KEY to return to menu...", 0


menuTitle BYTE "          MAIN MENU", 0
menuOption1 BYTE "    1. Start Game", 0
menuOption2 BYTE "    2. Instructions", 0
menuOption4 BYTE "    3. View Leaderboard", 0
menuOption3 BYTE "    4. Exit", 0
menuPrompt BYTE "    Select option (1-4): ", 0

shellKickMsg BYTE     "                    SHELL KICKED! WATCH IT GO!                    ",0
shellKillMsg BYTE     "             SHELL ELIMINATED GOOMBA! +200 POINTS!                ",0
shellReachedEdgeMsg BYTE"                    SHELL DISAPPEARED AT EDGE!                  ",0


instructTitle BYTE "          HOW TO PLAY", 0
instruct1 BYTE "  CONTROLS:", 0
instruct2 BYTE "    W - Jump", 0
instruct3 BYTE "    A - Move Left", 0
instruct4 BYTE "    D - Move Right", 0
instruct5 BYTE "    X - Exit Game", 0
instruct7 BYTE "  OBJECTIVE:", 0
instruct8 BYTE "    - Collect all coins (O) to complete level", 0
instruct9 BYTE "    - Jump on platforms (#) to reach coins", 0
instruct10 BYTE "    - Defeat Goombas (G) by jumping on them!", 0
instruct11 BYTE "    - Avoid hitting Goombas from the side!", 0
instruct12 BYTE "    - Collect blue stars (*) for turbo speed!", 0
instructBack BYTE "    Press ANY KEY to return to menu...", 0


; TIMER SYSTEM
levelTimer DWORD 0              ; Current timer value (in seconds)
levelTimerMax DWORD 0           ; Maximum time for current level
timerCounter DWORD 0            ; Counter for timing (milliseconds)
timerUpdateInterval DWORD 1000  ; Update every 1000ms (1 second)

; Timer values for each level in seconds
level1Time DWORD 120            ; Level 1: 120 seconds (2 minutes)
level2Time DWORD 100            ; Level 2: 100 seconds
level3Time DWORD 90             ; Level 3: 90 seconds (harder = less time)

; Timer display strings
strTime BYTE " | TIME: ",0
timerExpiredMsg BYTE "TIME'S UP!  GAME OVER! ",0
timerWarningMsg BYTE "HURRY UP! TIME IS RUNNING OUT!",0


; END SCREEN SYSTEM
; Princess Rescued ASCII Art (Victory Ending)
princessTitle1 BYTE "  _____  _____  _____ _   _  _____ ______  _____ _____   ", 0
princessTitle2 BYTE " |  __ \|  __ \|_   _| \ | |/ ____|  ____|/ ____/ ____|  ", 0
princessTitle3 BYTE " | |__) | |__) | | | |  \| | |    | |__  | (___| (___    ", 0
princessTitle4 BYTE " |  ___/|  _  /  | | | .  ` | |    |  __|  \___ \\___ \   ", 0
princessTitle5 BYTE " | |    | | \ \ _| |_| |\  | |____| |____ ____) |___) |  ", 0
princessTitle6 BYTE " |_|    |_|  \_\_____|_| \_|\_____|______|_____/_____/   ", 0

princessTitle7 BYTE "  _____  ______  _____ _____ _    _ ______ _____  _ ", 0
princessTitle8 BYTE " |  __ \|  ____|/ ____/ ____| |  | |  ____|  __ \| |", 0
princessTitle9 BYTE " | |__) | |__  | (___| |    | |  | | |__  | |  | | |", 0
princessTitle10 BYTE " |  _  /|  __|  \___ \ |    | |  | |  __| | |  | | |", 0
princessTitle11 BYTE " | | \ \| |____ ____) | |___| |__| | |____| |__| |_|", 0
princessTitle12 BYTE " |_|  \_\______|_____/ \_____\____/|______|_____/(_)", 0

; Try Again ASCII Art (Game Over Ending)
tryAgainTitle1 BYTE "  _______ _______     __     ___   _____          _____ _   _ ", 0
tryAgainTitle2 BYTE " |__   __|  __ \ \   / /    / _ \ / ____|   /\   |_   _| \ | |", 0
tryAgainTitle3 BYTE "    | |  | |__) \ \_/ /    | |_| | |  __   /  \    | | |  \| |", 0
tryAgainTitle4 BYTE "    | |  |  _  / \   /     |  _  | | |_ | / /\ \   | | | . ` |", 0
tryAgainTitle5 BYTE "    | |  | | \ \  | |      | | | | |__| |/ ____ \ _| |_| |\  |", 0
tryAgainTitle6 BYTE "    |_|  |_|  \_\ |_|      |_| |_|\_____/_/    \_\_____|_| \_|", 0

; End screen messages
princessMsg1 BYTE "CONGRATULATIONS, HERO!", 0
princessMsg2 BYTE "You have saved Princess Peach from Bowser!", 0
princessMsg3 BYTE "The Mushroom Kingdom is forever grateful!", 0

tryAgainMsg1 BYTE "GAME OVER", 0
tryAgainMsg2 BYTE "Bowser still holds the Princess captive.. .", 0
tryAgainMsg3 BYTE "The Mushroom Kingdom needs you to try again!", 0

; Final stats messages
finalScoreMsg BYTE "FINAL SCORE: ", 0
finalLevelMsg BYTE "LEVELS COMPLETED: ", 0
finalCoinsMsg BYTE "TOTAL COINS: ", 0
totalCoinsCollected DWORD 0

; End screen messages
playAgainPrompt BYTE "Press R to RESTART or X to EXIT", 0
thankYouMsg BYTE "Thank you for playing SUPER MARIO!", 0

; Princess sprite 
princessSprite1 BYTE "    @@@    ", 0
princessSprite2 BYTE "   @   @   ", 0
princessSprite3 BYTE "  @ o o @  ", 0
princessSprite4 BYTE "  @  ^  @  ", 0
princessSprite5 BYTE "  @ \_/ @  ", 0
princessSprite6 BYTE "   @@@@@   ", 0
princessSprite7 BYTE "  /|   |\  ", 0
princessSprite8 BYTE " / |   | \ ", 0
princessSprite9 BYTE "/__|   |__\", 0

; Mario sprite 
marioSprite1 BYTE "   ###   ", 0
marioSprite2 BYTE "  #####  ", 0
marioSprite3 BYTE "  @ o o  ", 0
marioSprite4 BYTE "  @  >   ", 0
marioSprite5 BYTE "  @####  ", 0
marioSprite6 BYTE "   ####  ", 0
marioSprite7 BYTE "  / || \ ", 0
marioSprite8 BYTE " /  ||  \", 0
marioSprite9 BYTE "/__/  \__\", 0

; Heart animation
heartSprite1 BYTE " <3 ", 0
heartSprite2 BYTE "<3<3", 0
heartSprite3 BYTE " <3 ", 0


; LAVA PIT SYSTEM 
numLavaPits BYTE 0
lavaPitX BYTE 10 DUP(?)         ; Starting X position of each lava pit
lavaPitY BYTE 10 DUP(?)         ; Y position (usually ground level)
lavaPitWidth BYTE 10 DUP(?)     ; Width of each lava pit

; Lava animation
lavaAnimFrame BYTE 0            ; Current animation frame (0-3)
lavaAnimTimer DWORD 0           ; Timer for animation
lavaAnimInterval DWORD 200      ; Animate every 200ms

; Lava messages
lavaDeathMsg BYTE "YOU FELL INTO LAVA!  -1 LIFE", 0
lavaWarningMsg BYTE "WATCH OUT FOR THE LAVA!", 0

; Lava characters for animation
lavaChar1 BYTE '~'              ; Frame 1
lavaChar2 BYTE '^'              ; Frame 2
lavaChar3 BYTE '~'              ; Frame 3
lavaChar4 BYTE '*'              ; Frame 4


; Game end state
gameEndState BYTE 0     ; 0 = Try Again, 1 = Princess Rescued


; SOUNDS EFFECT
; Game Paused state 
gamePaused BYTE 0      ; 0 = not paused, 1 = paused

; SoundEffects 
marioJumpSound Byte "mario_jump.wav",0
marioPowerUp Byte "mario_power_up.wav",0
coinSound Byte "game_coin.wav",0
koopaShellSound BYTE "koopa_shell_kick.wav",0
marioflagpoleSound Byte "mario_flagpole.wav",0
gameoverSound Byte "game_over_mario.wav",0
gameVictorySound Byte "victory.wav", 0

fireballSound Byte "fireball.wav",0
backgroundMusic Byte "super_mario.wav",0

mciOpen BYTE "open super_mario.wav type mpegvideo alias bgmusic", 0
mciPlay BYTE "play bgmusic repeat", 0
mciStop BYTE "stop bgmusic", 0  
mciClose BYTE "close bgmusic", 0
testMciOpen BYTE "open super_mario.wav type waveaudio alias bgmusic", 0
fileNotFoundMsg BYTE "MUSIC FILE NOT FOUND!", 0
musicLoadedMsg BYTE "Music loaded successfully!", 0

; Sound flags
SOUND_PLAY EQU 20001h          
soundEnabled DWORD 1

; Breakable brick data
numBricks BYTE 0
brickX BYTE 20 DUP(?)
brickY BYTE 20 DUP(?)
brickActive BYTE 20 DUP(?) ; 1 = Active (Solid), 0 = Broken (Empty)
brickPoints DWORD 50


; UNDERGROUND LEVEL MAP (29x120)
levelUnderground BYTE "                                                                                                                        ",13,10
                 BYTE "                                                                                                                        ",13,10
                 BYTE "   P                                                                                                                    ",13,10
                 BYTE "   P                                                                                                                    ",13,10
                 BYTE "   P                                                                                                                    ",13,10
                 BYTE "                                                                                                                        ",13,10
                 BYTE "                                                                                                                        ",13,10
                 BYTE "         OOO                                                                                                            ",13,10
                 BYTE "        #####                                                                                                           ",13,10
                 BYTE "                                                                                                                        ",13,10
                 BYTE "                                      OOO                                                                               ",13,10
                 BYTE "                                     #####                                                                              ",13,10
                 BYTE "                   G                                          G                                                         ",13,10
                 BYTE "                #######                                    #######                                                      ",13,10
                 BYTE "                                                                                                                        ",13,10
                 BYTE "                                                                                                                        ",13,10
                 BYTE "                                                                                                   O                    ",13,10
                 BYTE "                                                                                                 #####                  ",13,10
                 BYTE "                                                                                                                        ",13,10
                 BYTE "                                                                                                                        ",13,10
                 BYTE "                                            O  O                                                                    P   ",13,10
                 BYTE "                                           #######                                                                  P   ",13,10
                 BYTE "                                                                                                                    P   ",13,10
                 BYTE "                                                                                                                    P   ",13,10
                 BYTE "                                                                                                                    P   ",13,10
                 BYTE "                                                                                                                    P   ",13,10
                 BYTE "                                                                                                                    P   ",13,10
                 BYTE "                                                                                                                    P   ",13,10
                 BYTE "########################################################################################################################",13,10,0


; UNDERGROUND STATE VARIABLES
isUnderground BYTE 0           ; 0 = Surface, 1 = Underground
warpPipeX_L1 BYTE 12           ; The X coordinate of the pipe in Level 1 to enter
warpReturnX_L1 BYTE 80         ; Where you land when you exit the underground
undergroundColor DWORD 0       ; Background color helper


.code


main PROC
    call WelcomeScreen
    call MainMenu
    call inputname
    call InitSpeedRacerMode

    cmp inputChar, '4'
    je exitGame

    cmp inputChar, '1'
    jne main
    
    ; Reset game state
    mov currentLevel, 1
    mov score, 0
    mov coinsCollected, 0
    mov playerLives, 3

startLevel:
    ; Load background music
    call PlayBackgroundMusicSound

       mov isUnderground, 0
    ; Reset player position
    mov xPos, 10
    mov yPos, 27
    mov inAir, 0
    mov turboActive, 0
    mov turboTimer, 0
    mov isInvincible, 0
    mov invincibilityTimer, 0
    mov numEnemies, 0
    mov numFlyingEnemies, 0 
    mov numPipes, 0 
    mov numKoopas, 0
    mov numMushrooms, 0             
    mov numFireFlowers, 0           
    mov numActiveFireballs, 0       
    mov fireballActive[0], 0        
    mov fireballActive[1], 0 
    mov bowserActive, 0             
    mov bowserAlive, 0              
    mov bowserFireActive, 0         
    mov bowserFireTimer, 0          
    mov bowserHealth, 3             
    mov bowserDefeated, 0   
    mov numLavaPits, 0              
    mov lavaAnimFrame, 0            
    mov lavaAnimTimer, 0 

    mov enemyComboCount, 0


    ; Parse level map
    call LoadLevelData
    call InitLevelTimer   
    
    call Clrscr
    call FillBackground
    call DrawLevel
    call DrawTurboStars
    call RedrawEnemies
    call RedrawFlyingEnemies
    call RedrawPipes  
    call DrawMushrooms              
    call DrawFireFlowers
    call DrawPlayer
    
    ; Show Bowser appearance message on level 3
    cmp currentLevel, 3
    jne skipBowserAppearMsg
    cmp bowserActive, 1
    jne skipBowserAppearMsg

    cmp currentLevel, 3
    jne skipLavaWarning
    
    push eax
    push edx
    mov eax, yellow + (red * 16)
    call SetTextColor
    mov dl, 30
    mov dh, 2
    call Gotoxy
    mov edx, OFFSET lavaWarningMsg
    call WriteString
    
    mov eax, 1500
    call Delay
    
    ; Clear message
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, 30
    mov dh, 2
    call Gotoxy
    mov ecx, 30
clearLavaMsg:
    mov al, ' '
    call WriteChar
    loop clearLavaMsg
    
    pop edx
    pop eax

skipLavaWarning:
    
    push eax
    push edx
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dl, 10
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET bowserAppearMsg
    call WriteString
    
    mov eax, 2000
    call Delay
    pop edx
    pop eax

skipBowserAppearMsg:

gameLoop:
    ; Store previous position for direction detection

    cmp gamePaused, 1
    je l1

    mov al, yPos
    mov prevYPos, al
    
    call DrawHUD
    call RedrawPlatforms
    call RedrawBricks
    call RedrawCoins
    call DrawTurboStars
    call DrawMushrooms              
    call DrawFireFlowers
    call RedrawPipes 
    call RedrawEnemies
    call RedrawKoopas  
    call RedrawMysteryBlocks 
    call RedrawFlyingEnemies
    call RedrawFireballs  
    call DrawBowser                 
    call DrawBowserFire   
    call DrawLavaPits  
    call DrawPlayer
    
    mov eax, 50
    call Delay
    
    call UpdateTimer               
    call UpdateTurboTimer
    call UpdateEnemies
    call UpdateKoopas
    call UpdateMovingShell  
    call UpdateFlyingEnemies  
    call UpdateFireballs 
    call UpdateBowser               
    call UpdateBowserFire           
    call CheckFireballCollisions   
    call UpdateLavaAnimation  
    call UpdateInvincibilityTimer

    l1:
    call ReadKey
    jz noInput
    
    mov inputChar, al

    cmp inputChar, "p"
    je togglePause
    cmp inputChar, "P"
    je togglePause
    jmp checkOtherKeys      
    
    togglePause:
    call pauseGame
    cmp gamePaused, 1
    je nomovements
    jmp noInput   
    
    checkOtherKeys:

    cmp inputChar, "x"
    je exitGame
    cmp inputChar, "X"
    je exitGame
    cmp inputChar, "w"
    je jumpAction
    cmp inputChar, "W"
    je jumpAction
    cmp inputChar, "a"
    je moveLeft
    cmp inputChar, "A"
    je moveLeft
    cmp inputChar, "d"
    je moveRight
    cmp inputChar, "D"
    je moveRight
    cmp inputChar, "s"              
    je handleSKey                
    cmp inputChar, "S"              
    je handleSKey    
    cmp inputChar, "O"
    je SoundCheck
    cmp inputChar, " "              
    je shootFireball 

noInput:
    call CheckEnemyCollision
    call CheckKoopaCollision
    call CheckMysteryBlockCollision
    call CheckFlyingEnemyCollision
    call CheckMushroomCollection    
    call CheckFireFlowerCollection
    call CheckBowserCollision      
    call CheckBowserFireCollision  
    call CheckLavaCollision
    call CheckPitCollision
    call CheckUndergroundExit

    ; Check if player is dead
    cmp playerLives, 0
    jle playerDied
    

    ; Check if timer Expired 
    call CheckTimerExpired
    cmp al, 1
    je timerGameOver

    
    mov eax, coinsCollected
    movzx ebx, numCoins
    cmp eax, ebx
    jge levelCompleted

    jmp applyPhysics


    ; Label for timer game over 

    timerGameOver:
    mov gameEndState, 0
    
    call SaveToFile
    
    call ShowTryAgainScreen
    
    call CheckPlayAgain
    cmp al, 1
    je restartGameFromTimer
    
    mov checkforsavetofile, 1  
    jmp exitGame

    ; Resetting everything for the new game 
    restartGameFromTimer:
    mov currentLevel, 1
    mov score, 0
    mov coinsCollected, 0
    mov totalCoinsCollected, 0
    mov playerLives, 3
    mov isSuperMario, 0
    mov isFireMario, 0
    jmp startLevel

soundcheck:
    call toggleSound
    jmp gameloop

handleSKey:
    call CheckWarpPipe      
    
    ; Check if we just switched to underground
    cmp isUnderground, 1    
    je applyPhysics         

    jmp shootFireball  

levelCompleted:
    call checkPlayerEndofLevel
    cmp PlayerEndCheck, 1
    jne applyPhysics

    mov eax, coinsCollected
    add totalCoinsCollected, eax

    call CalculateTimeBonus   
    call VictoryCelebration
    
    ; Increment level
    mov al, currentLevel
    inc al
    mov currentLevel, al
    
    ; Check if all levels complete
    cmp al, maxLevels
    jg allLevelsComplete
    
    ; Reset for next level
    mov coinsCollected, 0
    mov PlayerEndCheck, 0
    jmp startLevel


allLevelsComplete:
    ; Set game end state to VICTORY
    mov gameEndState, 1
    
    call PlayGameVictorySound
    ; Save score to file
    call SaveToFile
    
    ; Show Princess Rescued ending
    call ShowPrincessRescuedScreen
    
    ; Check if player wants to play again
    call CheckPlayAgain
    cmp al, 1
    je restartGame
    
    mov checkforsavetofile, 1
    jmp exitGame


shootFireball:
    ; Check if Fire Mario
    cmp isFireMario, 0
    je cannotShoot
    
    ; Check if we already have 2 fireballs
    movzx eax, numActiveFireballs
    cmp eax, MAX_FIREBALLS
    jge maxFireballsReached
    
    ; Find an inactive fireball slot
    mov esi, 0
findFireballSlot:
    cmp esi, MAX_FIREBALLS
    jge cannotShoot
    
    cmp fireballActive[esi], 0
    je createFireball
    
    inc esi
    jmp findFireballSlot

createFireball:
    ; Create fireball at player position same Y straight line
    mov al, xPos
    mov fireballX[esi], al
    mov al, yPos
    mov fireballY[esi], al
    mov fireballActive[esi], 1
    
    ; Set direction based on player's last movement
    mov al, moveDirection
    mov fireballDirection[esi], al
    
    ; Offset fireball based on direction
    cmp al, 0
    je fireballGoLeft
    
    ; Going right
    mov al, fireballX[esi]
    add al, 2
    mov fireballX[esi], al
    jmp fireballCreated

fireballGoLeft:
    mov al, fireballX[esi]
    sub al, 2
    mov fireballX[esi], al

fireballCreated:
    inc numActiveFireballs
    jmp applyPhysics

maxFireballsReached:
    push eax
    push edx
    mov eax, yellow + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET maxFireballsMsg
    call WriteString
    pop edx
    pop eax
    jmp applyPhysics

cannotShoot:
    jmp applyPhysics

restartGame:
    ; Reset everything for a new game
    mov currentLevel, 1
    mov score, 0
    mov coinsCollected, 0
    mov totalCoinsCollected, 0
    mov playerLives, 3
    mov isSuperMario, 0
    mov isFireMario, 0
    jmp startLevel

jumpAction:
    cmp inAir, 1
    je applyPhysics
    
    call PlayJumpSound
    mov inAir, 1
    mov jumpHeight, 0
    jmp applyPhysics

moveLeft:
    call UpdatePlayer
    
    cmp inAir, 1
    je moveLeftAir_Smooth
    movzx eax, groundSpeed
    jmp setupLeftMove
    
moveLeftAir_Smooth:
    movzx eax, airSpeed
    
setupLeftMove:
    mov moveStepsRemaining, al
    mov moveDirection, 0
    
leftStepLoop:
    cmp moveStepsRemaining, 0
    je afterMoveLeft
    
    mov al, xPos
    cmp al, MIN_X
    jle afterMoveLeft

    ; Prepare collision check
    push edx
    mov dl, xPos
    dec dl                  
    mov dh, yPos
    
    ;  Check Pipes
    call IsPipeAtPosition
    cmp al, 1
    je hitObstacleLeft     
    
    ;  Check Bricks
    call IsBrickAtPosition  
    cmp al, 1
    jne noBrickLeft         
    
    call TryBreakBrick
    cmp al, 1              
    je brickBrokenLeft
    
    jmp hitObstacleLeft       
    
noBrickLeft:
    pop edx                
    dec xPos
    jmp leftContinue

hitObstacleLeft:
    pop edx                
    jmp afterMoveLeft      

brickBrokenLeft:
    pop edx                
    dec xPos               
    
leftContinue:
    call CheckCoinCollection
    call CheckTurboStarCollection
    call CheckKoopaCollision
    call CheckEnemyCollision
    call CheckMysteryBlockCollision
    
    dec moveStepsRemaining
    jmp leftStepLoop
    
afterMoveLeft:
    call CheckStillOnSurface
    call DrawPlayer
    jmp applyPhysics

moveRight:
    call UpdatePlayer
    
    cmp inAir, 1
    je moveRightAir_Smooth
    movzx eax, groundSpeed
    jmp setupRightMove
    
moveRightAir_Smooth:
    movzx eax, airSpeed
    
setupRightMove:
    mov moveStepsRemaining, al
    mov moveDirection, 1
    
rightStepLoop:
    cmp moveStepsRemaining, 0
    je afterMoveRight
    
    mov al, xPos
    cmp al, MAX_X
    jge afterMoveRight

    ; Prepare collision check
    push edx
    mov dl, xPos
    inc dl             
    mov dh, yPos
    
    ; Check Pipes
    call IsPipeAtPosition
    cmp al, 1
    je hitObstacleRight     
    
    ; Check Bricks
    call IsBrickAtPosition
    cmp al, 1
    jne noBrickRight
    
    call TryBreakBrick
    cmp al, 1
    je brickBrokenRight
    
    jmp hitObstacleRight    
    
noBrickRight:
    pop edx             
    inc xPos
    jmp rightContinue

hitObstacleRight:
    pop edx               
    jmp afterMoveRight      

brickBrokenRight:
    pop edx                
    inc xPos

rightContinue:
    call CheckCoinCollection
    call CheckTurboStarCollection
    call CheckKoopaCollision
    call CheckEnemyCollision
    call CheckMysteryBlockCollision
    
    dec moveStepsRemaining
    jmp rightStepLoop
    
afterMoveRight:
    call CheckStillOnSurface
    call DrawPlayer
    jmp applyPhysics


applyPhysics:
    cmp inAir, 1
    jne gameLoop
    
    call UpdatePlayer
    
    mov al, jumpHeight
    cmp al, maxJumpHeight
    jge startFalling

    push edx
    mov dl, xPos
    mov dh, yPos
    dec dh                 
    
    ;  Check Pipe Above
    call IsPipeAtPosition
    cmp al, 1
    je hitHead
    
    ;  Check Brick Above
    call IsBrickAtPosition
    cmp al, 1
    je hitHead

    ; Check Platform (#) Above 
    call IsPlatformAtPosition
    cmp al, 1
    je hitHead
    
    pop edx
    
    mov al, yPos
    cmp al, 1
    jle startFalling
    
    dec yPos
    inc jumpHeight
    jmp checkLanding

hitHead:
    pop edx             
    jmp startFalling    

startFalling:
    mov al, yPos
    cmp al, GROUND_Y
    jge stoppedFalling
    
    inc yPos

checkLanding:
    mov al, yPos
    cmp al, GROUND_Y
    jge landedOnGround
    
    call CheckPlatformCollision
    cmp al, 1
    je landedOnPlatform

    ; Check Collision landing
    push edx
    mov dl, xPos
    mov dh, yPos
    inc dh                      ;

    ; Check Brick Below
    push edx                    
    call IsBrickAtPosition
    pop edx                     
    cmp al, 1
    je landedOnBrickFromPhysics

    call IsPipeAtPosition
    pop edx                     
    cmp al, 1
    je hitPipeBelow
    
    call DrawPlayer
    jmp gameLoop

landedOnBrickFromPhysics:
    pop edx                     
    mov inAir, 0
    mov jumpHeight, 0
    call DrawPlayer
    jmp gameLoop

hitPipeBelow:                  
    push edx
    mov dl, xPos
    call GetPipeTopY           
    pop edx
    mov yPos, al
    dec yPos                   
    mov inAir, 0
    mov jumpHeight, 0
    call DrawPlayer
    jmp gameLoop

landedOnGround:
    mov al, GROUND_Y
    mov yPos, al
    mov inAir, 0
    mov jumpHeight, 0
    call DrawPlayer
    jmp gameLoop

landedOnPlatform:
    mov al, bl
    dec al
    mov yPos, al
    mov inAir, 0
    mov jumpHeight, 0
    call DrawPlayer
    jmp gameLoop

stoppedFalling:
    mov al, GROUND_Y
    mov yPos, al
    mov inAir, 0
    mov jumpHeight, 0
    call DrawPlayer
    jmp gameLoop

playerDied:
    mov gameEndState, 0
    
    call SaveToFile
    
    call ShowTryAgainScreen
    
    call CheckPlayAgain
    cmp al, 1
    je restartGameFromDeath
    
    mov checkforsavetofile, 1  
    jmp exitGame

restartGameFromDeath:
    mov currentLevel, 1
    mov score, 0
    mov coinsCollected, 0
    mov totalCoinsCollected, 0
    mov playerLives, 3
    mov isSuperMario, 0
    mov isFireMario, 0
    jmp startLevel

nomovements:
    jmp gameLoop

exitGame:
    cmp checkforsavetofile, 1
    je skipSaveToFile
    call SaveToFile

    skipSaveToFile:

    call Clrscr
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dl, 45
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET gameOver
    call WriteString
    
    mov dl, 40
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET strScore
    call WriteString
    mov eax, score
    call WriteDec
    
    mov eax, 3000
    call Delay
    exit
main ENDP


toggleSound Proc
    pusha

    cmp SoundEnabled, 1
    je offsound 
    mov SoundEnabled, 1
    call PlayBackGroundMusicSound
    jmp SoundDone 

    offsound:
    mov SoundEnabled, 0
    call StopBackGroundMusic

    SoundDone:
        popa
        ret
toggleSound Endp


pauseGame PROC
    pusha
   
    cmp gamePaused, 1
    je resumeGame

    mov gamePaused, 1
    
    push eax
    push edx
    mov eax, yellow + (blue * 16)
    call SetTextColor
    mov dl, 35
    mov dh, 14
    call Gotoxy
    mwrite "PAUSE", 0

    mov dl, 98
    mov dh, 0
    call Gotoxy
    mwrite "PRESS X FOR EXIT", 0

    mov dl, 98
    mov dh, 1
    call Gotoxy
    mwrite "PRESS P FOR RESUME", 0

    pop edx
    pop eax
    
    jmp pauseDone         

resumeGame:

    mov gamePaused, 0
    
    push eax
    push edx
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, 35
    mov dh, 14
    call Gotoxy
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar

    mov dl, 98
    mov dh, 0
    call Gotoxy
    mwrite "                ", 0

    mov dl, 98
    mov dh, 1
    call Gotoxy
    mwrite "                  ", 0

    pop edx
    pop eax

pauseDone:
    popa                    
    ret
pauseGame ENDP


UpdateCombo PROC
    pusha

    ; Increment combo counter
    inc enemyComboCount
    
    cmp enemyComboCount, 3
    jl comboUpdateDone

    
    ; Reset counter
    mov enemyComboCount, 0

    mov eax, levelTimer
    add eax, 20
    mov levelTimer, eax

    call PlayMarioPowerUpSound

    push eax
    push edx
    mov eax, lightMagenta + (lightBlue * 16)
    call SetTextColor
    mov dl, 40
    mov dh, 1 ; Top center
    call Gotoxy
    mov edx, OFFSET comboMsg
    call WriteString
    
    ; Short delay to let player see it
    mov eax, 500
    call Delay
    
    ; Clear Message
    mov dl, 40
    mov dh, 1
    call Gotoxy
    mov ecx, 30
    clearComboMsg:
        mov al, ' '
        call WriteChar
        loop clearComboMsg
    pop edx
    pop eax

comboUpdateDone:
    popa
    ret
UpdateCombo ENDP

; Checks End of the Level
checkPlayerEndofLevel PROC
    pusha
    mov al, xPos
    cmp al, EndX_POS
    jl notAtFlagpole
    mov al, yPos
    cmp al, EndY_POS
    jg notAtFlagpole
    ; Player reached flagpole top
    mov PlayerEndCheck, 1

    notAtFlagpole:
    popa 
    ret
checkPlayerEndofLevel ENDP


LoadLevelData PROC
    pusha
    mov numPlatforms, 0
    mov numCoins, 0
    mov numTurboStars, 0
    mov numEnemies, 0
    mov inPlatform, 0
    mov numPipes, 0  
    mov numKoopas, 0
    mov numMysteryBlocks, 0
    mov numFlyingEnemies, 0 
    mov numMushrooms, 0             
    mov numFireFlowers, 0
    mov bowserActive, 0             
    mov bowserAlive, 0              
    mov bowserFireActive, 0         
    mov bowserHealth, 3             
    mov bowserDefeated, 0      
    mov numLavaPits, 0             
    mov lavaAnimFrame, 0           
    mov lavaAnimTimer, 0 
    mov platformStartX, 0
    
    cmp isUnderground, 1
    je parseUnderground

    mov al, currentLevel
    cmp al, 1
    je parseLevel1
    cmp al, 2
    je parseLevel2
    cmp al, 3
    je parseLevel3
    jmp parseDone

parseUnderground:
    mov esi, OFFSET levelUnderground
    jmp startParsing

parseLevel1:
    mov esi, OFFSET level1
    jmp startParsing

parseLevel2:
    mov esi, OFFSET level2
    jmp startParsing

parseLevel3:
    mov esi, OFFSET level3
    jmp startParsing

startParsing:
    mov dh, 0
    mov dl, 0
    
parseLoop:
    mov al, [esi]
    
    cmp al, 0
    je finishParsing
    cmp al, 13
    je handleNewline
    cmp al, 10
    je handleLinefeed
    cmp al, 'O'
    je foundCoin
    cmp al, '#'
    je foundPlatformChar
    cmp al, '*'
    je foundTurboStar
    cmp al, 'G'
    je foundGoomba
    cmp al, 'P'             
    je foundPipe 
    cmp al, 'K'             
    je foundGreenKoopa      
    cmp al, 'R'               
    je foundRedKoopa 
    cmp al, '?'             
    je foundMysteryBlock
    cmp al, 'F'
    je foundFlyingEnemy
    cmp al, 'M'             
    je foundMushroom        
    cmp al, 'W'             
    je foundFireFlower 
    cmp al, 'B'                     
    je foundBowser 
    cmp al, 'L'                     
    je foundLava 
    cmp al, '%'             
    je foundBrick
    cmp al, ' '
    je foundSpace
    jmp checkEndPlatform

foundBrick:
    push eax
    movzx eax, numBricks
    cmp eax, 20             
    jge skipBrick
    
    mov brickX[eax], dl
    mov brickY[eax], dh
    mov brickActive[eax], 1 
    inc numBricks
    
skipBrick:
    pop eax
    jmp nextCharacter

foundLava:
    cmp currentLevel, 3
    jne skipLavaSpawn
    call FindOrCreateLavaPit
    
skipLavaSpawn:
    jmp nextCharacter

foundBowser:
    ; Only spawn Bowser on level 3
    cmp currentLevel, 3
    jne skipBowserSpawn
    
    mov bowserX, dl
    mov al, dh
    dec al                          
    mov bowserY, al
    mov bowserActive, 1
    mov bowserAlive, 1
    mov bowserHealth, 3
    mov bowserDirection, 0
    mov bowserFireActive, 0
    mov bowserFireTimer, 0
    mov bowserHitFlashing, 0
    mov bowserDefeated, 0
    
skipBowserSpawn:
    jmp nextCharacter

foundMushroom:
    push eax
    movzx eax, numMushrooms
    cmp eax, 5
    jge skipMushroom
    
    mov mushroomX[eax], dl
    mov mushroomY[eax], dh
    mov mushroomCollected[eax], 0
    inc numMushrooms
    
skipMushroom:
    pop eax
    jmp nextCharacter

foundFireFlower:
    push eax
    movzx eax, numFireFlowers
    cmp eax, 5
    jge skipFireFlower
    
    mov fireFlowerX[eax], dl
    mov fireFlowerY[eax], dh
    mov fireFlowerCollected[eax], 0
    inc numFireFlowers
    
skipFireFlower:
    pop eax
    jmp nextCharacter

foundFlyingEnemy:
    push eax
    movzx eax, numFlyingEnemies
    cmp eax, 10
    jge skipFlyingEnemy
    
    mov flyingEnemyX[eax], dl
    mov flyingEnemyY[eax], dh
    mov flyingEnemyBaseY[eax], dh       ; Store original Y for bobbing
    mov flyingEnemyAlive[eax], 1
    mov flyingEnemyDirection[eax], 1    ; Start moving right
    mov flyingEnemyBobOffset[eax], 0
    mov flyingEnemyBobDirection[eax], 1 ; Start bobbing down
    inc numFlyingEnemies
    
skipFlyingEnemy:
    pop eax
    jmp nextCharacter

foundCoin:
    push eax
    movzx eax, numCoins
    cmp eax, 20
    jge skipCoin
    
    mov coinX[eax], dl
    mov coinY[eax], dh
    mov coinCollected[eax], 0
    inc numCoins
    
skipCoin:
    pop eax
    jmp nextCharacter

foundPlatformChar:
    cmp inPlatform, 0
    jne continueCurrentPlatform
    
    mov platformStartX, dl
    mov inPlatform, 1
    jmp nextCharacter

continueCurrentPlatform:
    jmp nextCharacter

foundTurboStar:
    push eax
    movzx eax, numTurboStars
    cmp eax, 5
    jge skipStar
    
    mov turboStarX[eax], dl
    mov turboStarY[eax], dh
    mov turboStarCollected[eax], 0
    inc numTurboStars
    
skipStar:
    pop eax
    jmp nextCharacter

foundGreenKoopa:
    push eax
    movzx eax, numKoopas
    cmp eax, 10
    jge skipGreenKoopa
    
    mov koopaX[eax], dl
    mov koopaY[eax], dh
    mov koopaAlive[eax], 1      ; Alive
    mov koopaDirection[eax], 1  ; Start moving right
    mov koopaType[eax], 0       ; Green type K
    inc numKoopas
    
skipGreenKoopa:
    pop eax
    jmp nextCharacter

foundRedKoopa:
    push eax
    movzx eax, numKoopas
    cmp eax, 10
    jge skipRedKoopa
    
    mov koopaX[eax], dl
    mov koopaY[eax], dh
    mov koopaAlive[eax], 1      ; Alive
    mov koopaDirection[eax], 1  ; Start moving right
    mov koopaType[eax], 1       ; Red type R
    inc numKoopas
    
skipRedKoopa:
    pop eax
    jmp nextCharacter

foundGoomba:
    push eax
    movzx eax, numEnemies
    cmp eax, 10
    jge skipGoomba
    
    mov enemyX[eax], dl
    mov enemyY[eax], dh
    mov enemyAlive[eax], 1
    mov enemyDirection[eax], 1
    inc numEnemies
    
skipGoomba:
    pop eax
    jmp nextCharacter

foundMysteryBlock:
    push eax
    movzx eax, numMysteryBlocks
    cmp eax, 15
    jge skipMysteryBlock
    
    mov mysteryBlockX[eax], dl
    mov mysteryBlockY[eax], dh
    mov mysteryBlockActivated[eax], 0    ; Has coin inside
    inc numMysteryBlocks
    
skipMysteryBlock:
    pop eax
    jmp nextCharacter

foundPipe:
push eax
push ebx
    
; Check if this pipe already exists or is a continuation
call FindOrCreatePipe
    
pop ebx
pop eax
jmp nextCharacter


foundSpace:
    jmp checkEndPlatform

checkEndPlatform:
    cmp inPlatform, 0
    je nextCharacter
    
    call SaveCurrentPlatform
    mov inPlatform, 0
    jmp nextCharacter

handleNewline:
    cmp inPlatform, 0
    je skipSavePlatformNL
    call SaveCurrentPlatform
    mov inPlatform, 0

skipSavePlatformNL:
    inc esi
    inc dh
    mov dl, 0
    jmp parseLoop

handleLinefeed:
    inc esi
    jmp parseLoop

nextCharacter:
    inc esi
    inc dl
    jmp parseLoop

finishParsing:
    cmp inPlatform, 0
    je parseDone
    call SaveCurrentPlatform

parseDone:
    push eax
    push edx
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 29
    call Gotoxy
    movzx eax, numPipes
    call WriteDec
    mov al, ' '
    call WriteChar
    mov al, 'P'
    call WriteChar
    mov al, 'I'
    call WriteChar
    mov al, 'P'
    call WriteChar
    mov al, 'E'
    call WriteChar
    mov al, 'S'
    call WriteChar
    pop edx
    pop eax

    popa
    ret
LoadLevelData ENDP

SaveCurrentPlatform PROC
    push eax
    push ebx
    push ecx
    
    movzx eax, numPlatforms
    cmp eax, 15
    jge platformArrayFull
    
    mov bl, platformStartX
    mov platform1x[eax], bl
    mov platform1y[eax], dh
    
    mov cl, dl
    sub cl, platformStartX
    mov platformWidths[eax], cl
    
    inc numPlatforms

platformArrayFull:
    pop ecx
    pop ebx
    pop eax
    ret
SaveCurrentPlatform ENDP

FindOrCreatePipe PROC
    push eax
    push ebx
    push ecx
    push esi
    
    mov esi, 0
    
checkExistingPipe:
    movzx eax, numPipes
    cmp esi, eax
    jge createNewPipe
    
    mov al, pipeX[esi]
    cmp al, dl
    je updateExistingPipe
    
    inc esi
    jmp checkExistingPipe

updateExistingPipe:
    mov al, pipeY[esi]      
    mov bl, dh              
    
    cmp bl, al
    jge checkBottomUpdate   
    mov pipeY[esi], bl      
    
checkBottomUpdate:
    mov al, pipeY[esi]
    add al, pipeHeight[esi]
    dec al                  
    
    cmp dh, al
    jle recalculateHeight   
        
recalculateHeight:
    ;Recalculate height properly
    mov bl, pipeY[esi]     
    mov al, dh              
    add al, 1               
    
    ; Find actual bottom most Y
    push esi
    mov esi, 0
    mov cl, dh              ; Track lowest Y found
    
findBottomLoop:
    movzx eax, numPipes
    cmp esi, eax
    jge bottomFound
    
    ; Check if this pipe is at same X
    mov al, pipeX[esi]
    cmp al, dl
    jne nextBottomCheck
    
    ; Update bottom-most Y
    mov al, pipeY[esi]
    add al, pipeHeight[esi]
    dec al
    cmp al, cl
    jle nextBottomCheck
    mov cl, al           
    
nextBottomCheck:
    inc esi
    jmp findBottomLoop
    
bottomFound:
    pop esi
    
    ; Calculate final height
    mov al, cl              
    sub al, pipeY[esi]      ; Height = Bottom Top
    inc al                  ; +1 for inclusive
    mov pipeHeight[esi], al
    
    jmp pipeUpdateDone

createNewPipe:
    ; Create new pipe
    movzx eax, numPipes
    cmp eax, 10
    jge pipeArrayFull
    
    mov pipeX[eax], dl      
    mov pipeY[eax], dh      ; Y position (current segment)
    mov pipeHeight[eax], 1  ; Initial height = 1
    inc numPipes

pipeArrayFull:
pipeUpdateDone:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
FindOrCreatePipe ENDP


; Tracks continuous lava sections
FindOrCreateLavaPit PROC
    push eax
    push ebx
    push ecx
    push esi
    
    ; Check if we can add to an existing lava pit
    mov esi, 0
    
checkExistingLava:
    movzx eax, numLavaPits
    cmp esi, eax
    jge createNewLava
    
    ; Check if this lava is adjacent to existing pit
    mov al, lavaPitX[esi]
    add al, lavaPitWidth[esi]
    cmp al, dl                     
    jne nextLavaCheck
    
    ; Check same Y row
    mov al, lavaPitY[esi]
    cmp al, dh
    jne nextLavaCheck
    
    ; Extend existing lava pit
    inc lavaPitWidth[esi]
    jmp lavaUpdateDone

nextLavaCheck:
    inc esi
    jmp checkExistingLava

createNewLava:
    ; Create new lava pit
    movzx eax, numLavaPits
    cmp eax, 10
    jge lavaArrayFull
    
    mov lavaPitX[eax], dl           ; X position
    mov lavaPitY[eax], dh           ; Y position
    mov lavaPitWidth[eax], 1        ; Initial width = 1
    inc numLavaPits

lavaArrayFull:
lavaUpdateDone:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
FindOrCreateLavaPit ENDP

RedrawBricks PROC
    pusha
    mov esi, 0
    
redrawBrickLoop:
    movzx eax, numBricks
    cmp esi, eax
    jge redrawBricksDone
    
    cmp brickActive[esi], 0
    je skipRedrawBrick
    
    ; Draw Brick (Brown background if possible, or Red/Yellow)
    mov eax, yellow + (red * 16) 
    call SetTextColor
    
    mov dl, brickX[esi]
    mov dh, brickY[esi]
    call Gotoxy
    mov al, '%'      ; Appearance of the brick
    call WriteChar

skipRedrawBrick:
    inc esi
    jmp redrawBrickLoop

redrawBricksDone:
    popa
    ret
RedrawBricks ENDP

; Returns al=1 if active brick exists at dl,dh. Returns al=0 otherwise.
IsBrickAtPosition PROC
    push ecx
    push esi
    
    mov esi, 0
    
checkBrickLoop:
    movzx eax, numBricks
    cmp esi, eax
    jge noBrickFound
    
    cmp brickActive[esi], 0
    je nextBrickCheck
    
    mov al, brickX[esi]
    cmp dl, al
    jne nextBrickCheck
    
    mov al, brickY[esi]
    cmp dh, al
    jne nextBrickCheck
    
    ; Found Active Brick
    pop esi
    pop ecx
    mov al, 1
    ret

nextBrickCheck:
    inc esi
    jmp checkBrickLoop

noBrickFound:
    pop esi
    pop ecx
    mov al, 0
    ret
IsBrickAtPosition ENDP

TryBreakBrick PROC
    push ecx
    push esi
    push ebx
    
    ; 1. Check if we are Super Mario
    cmp isSuperMario, 1
    je canBreak
    cmp isFireMario, 1      ; Fire mario is also Super
    je canBreak
    
    ; Normal Mario cannot break
    mov al, 0
    jmp tryBreakDone

canBreak:
    mov esi, 0
    
findBrickToBreak:
    movzx eax, numBricks
    cmp esi, eax
    jge brickBreakFail
    
    cmp brickActive[esi], 0
    je nextBreakCheck
    
    ; Check Coords
    mov al, brickX[esi]
    cmp dl, al
    jne nextBreakCheck
    
    mov al, brickY[esi]
    cmp dh, al
    jne nextBreakCheck
    
    ; BREAK IT
    mov brickActive[esi], 0
    
    ; Play Sound
    call PlayMarioPowerUpSound
    
    ; Add Score
    push eax
    mov eax, score
    add eax, brickPoints
    mov score, eax
    pop eax
    
    ; Visual effect 
    push eax
    push edx
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    call Gotoxy
    mov al, ' '
    call WriteChar
    pop edx
    pop eax
    
    mov al, 1 ; Return Success
    jmp tryBreakDone

nextBreakCheck:
    inc esi
    jmp findBrickToBreak

brickBreakFail:
    mov al, 0

tryBreakDone:
    pop ebx
    pop esi
    pop ecx
    ret
TryBreakBrick ENDP

DrawLevel PROC
    pusha
    cmp isUnderground, 1
    je drawUndergroundMap

    mov al, currentLevel
    cmp al, 1
    je drawLevel1
    cmp al, 2
    je drawLevel2
    cmp al, 3
    je drawLevel3
    jmp drawDone

drawUndergroundMap:
    mov esi, OFFSET levelUnderground
    jmp drawMap

drawLevel1:
    mov esi, OFFSET level1
    jmp drawMap

drawLevel2:
    mov esi, OFFSET level2
    jmp drawMap

drawLevel3:
    mov esi, OFFSET level3
    jmp drawMap

drawMap:
    cmp isUnderground, 1
    je setMapBlack
    mov eax, white + (lightBlue * 16)
    jmp applyMapColor
setMapBlack:
    mov eax, white + (black * 16) ; or blue bricks
applyMapColor:
    call SetTextColor
    mov dh,0
    
drawLineLoop:
    mov dl, 0
    call Gotoxy
    
drawCharLoop:
    mov al, [esi]
    cmp al, 0
    je drawDone
    cmp al, 13
    je nextLine
    cmp al, 10
    je skipLF
    call WriteChar
    inc esi
    jmp drawCharLoop
    
skipLF:
    inc esi
    jmp drawCharLoop
    
nextLine:
    inc esi
    inc dh
    jmp drawLineLoop

drawDone:
    popa
    ret
DrawLevel ENDP


; DRAW LAVA PITS WITH ANIMATION
DrawLavaPits PROC
    pusha

    cmp currentLevel, 3
    jne drawLavaDone
    
    mov esi, 0
    
drawLavaLoop:
    movzx eax, numLavaPits
    cmp esi, eax
    jge drawLavaDone
    
    ; Set lava color (orange or red on dark red background)
    mov eax, yellow + (red * 16)
    call SetTextColor
    
    ; Get lava position
    mov dl, lavaPitX[esi]
    mov dh, lavaPitY[esi]
    call Gotoxy
    
    ; Draw each character of the lava pit with animation
    movzx ecx, lavaPitWidth[esi]
    
drawLavaChars:
    push ecx
    
    ; Get animated character based on frame and position
    mov al, lavaAnimFrame
    add al, cl                      ; Add position for wave effect
    and al, 3                       ; Keep in range 0-3
    
    cmp al, 0
    je useLavaChar1
    cmp al, 1
    je useLavaChar2
    cmp al, 2
    je useLavaChar3
    jmp useLavaChar4

useLavaChar1:
    mov al, '~'
    jmp writeLavaChar

useLavaChar2:
    mov al, '^'
    jmp writeLavaChar

useLavaChar3:
    mov al, '~'
    jmp writeLavaChar

useLavaChar4:
    mov al, '*'

writeLavaChar:
    call WriteChar
    
    pop ecx
    loop drawLavaChars
    
    inc esi
    jmp drawLavaLoop

drawLavaDone:
    popa
    ret
DrawLavaPits ENDP


; UPDATE LAVA ANIMATION
UpdateLavaAnimation PROC
    pusha
    
    ; Only animate on level 3
    cmp currentLevel, 3
    jne updateLavaAnimDone
    
    ; Update timer
    mov eax, lavaAnimTimer
    add eax, 50                     ; Game loop is 50ms
    mov lavaAnimTimer, eax
    
    ; Check if time to animate
    cmp eax, lavaAnimInterval
    jl updateLavaAnimDone
    
    ; Reset timer
    mov lavaAnimTimer, 0
    
    ; Advance animation frame
    mov al, lavaAnimFrame
    inc al
    and al, 3                       
    mov lavaAnimFrame, al

updateLavaAnimDone:
    popa
    ret
UpdateLavaAnimation ENDP


; Instant death when touching lava!  
CheckLavaCollision PROC
    pusha
    
    ; Only check on level 3
    cmp currentLevel, 3
    jne noLavaCollision
    
    ; Skip if invincible
    cmp isInvincible, 1
    je noLavaCollision
    
    mov esi, 0
    
lavaCollisionLoop:
    movzx eax, numLavaPits
    cmp esi, eax
    jge noLavaCollision
    
    ; Get lava pit bounds
    mov bl, lavaPitX[esi]           
    mov bh, lavaPitY[esi]           
    

    ; Check if player Y is at or above lava
    mov al, yPos
    mov cl, bh
    dec cl                          
    cmp al, cl
    jl nextLavaCollision            ; Player is above lava area
    cmp al, bh
    jg nextLavaCollision            ; Player is below lava, just a check but never actually happens
    
    ; Check X collision
    mov al, xPos
    
    ; Left boundary check
    cmp al, bl
    jl nextLavaCollision
    
    ; Right boundary check
    mov cl, bl
    add cl, lavaPitWidth[esi]
    cmp al, cl
    jge nextLavaCollision
    
    ; Player touched lava
    call PlayerLavaDeath
    jmp noLavaCollision

nextLavaCollision:
    inc esi
    jmp lavaCollisionLoop

noLavaCollision:
    popa
    ret
CheckLavaCollision ENDP


; PLAYER LAVA DEATH
PlayerLavaDeath PROC
    pusha
    
    call PlayGameOverSound
    ; Decrease life
    dec playerLives
    mov enemyComboCount, 0
    ; Reset coins for this level
    mov coinsCollected, 0
    
    ; Show death animation player sinks into lava
    call LavaDeathAnimation
    
    ; Show death message
    push eax
    push edx
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dl, 25
    mov dh, 2
    call Gotoxy
    mov edx, OFFSET lavaDeathMsg
    call WriteString
    pop edx
    pop eax
    
    ; Brief pause
    mov eax, 1500
    call Delay
    
    ; Check if game over
    cmp playerLives, 0
    jle lavaGameOver
    
    ; Reset player position for respawn
    mov xPos, 10
    mov yPos, 27
    mov inAir, 0
    mov turboActive, 0
    mov turboTimer, 0
    mov isInvincible, 1           
    mov eax, invincibilityMaxTime
    mov invincibilityTimer, eax
    
    ; Reload level
    call LoadLevelData
    call Clrscr
    call FillBackground
    call DrawLevel
    call DrawTurboStars
    call RedrawEnemies
    call RedrawFlyingEnemies
    call RedrawPipes
    call DrawMushrooms
    call DrawFireFlowers
    call DrawLavaPits
    call DrawBowser
    call DrawPlayer
    
    jmp lavaDeathDone

lavaGameOver:
    ; Will be handled by main game loop (playerLives = 0)

lavaDeathDone:
    popa
    ret
PlayerLavaDeath ENDP


; Lava Death Animation
LavaDeathAnimation PROC
    pusha
    
    ; Frame 1: Player flashes
    mov eax, lightRed + (yellow * 16)
    call SetTextColor
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, 'X'
    call WriteChar
    
    mov eax, 150
    call Delay
    
    ; Frame 2: Player turns orange
    mov eax, yellow + (red * 16)
    call SetTextColor
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, 'X'
    call WriteChar
    
    mov eax, 150
    call Delay
    
    ; Frame 1: Player sinks (draw at lava level)
    mov eax, lightRed + (red * 16)
    call SetTextColor
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, '~'
    call WriteChar
    
    mov eax, 150
    call Delay
    
    ; Frame 4: Player disappears into lava
    mov eax, yellow + (red * 16)
    call SetTextColor
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, '^'
    call WriteChar
    
    mov eax, 150
    call Delay
    
    ; Frame 5: Just lava remains
    mov eax, yellow + (red * 16)
    call SetTextColor
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, '~'
    call WriteChar
    
    mov eax, 300
    call Delay
    
    popa
    ret
LavaDeathAnimation ENDP


; Check if Position is Lava
IsLavaAtPosition PROC
    push ebx
    push ecx
    push esi
    
    ; Only check on level 3
    cmp currentLevel, 3
    jne notLavaPos
    
    mov esi, 0
    
checkLavaPos:
    movzx eax, numLavaPits
    cmp esi, eax
    jge notLavaPos
    
    ; Check Y first
    mov al, lavaPitY[esi]
    cmp dh, al
    jne nextLavaPos
    
    ; Check X range
    mov al, lavaPitX[esi]
    cmp dl, al
    jl nextLavaPos
    
    mov bl, al
    add bl, lavaPitWidth[esi]
    cmp dl, bl
    jge nextLavaPos
    
    ; Position is lava! 
    mov al, 1
    jmp lavaPosDone

nextLavaPos:
    inc esi
    jmp checkLavaPos

notLavaPos:
    mov al, 0

lavaPosDone:
    pop esi
    pop ecx
    pop ebx
    ret
IsLavaAtPosition ENDP


; Check enemy lava collision
CheckEnemyLavaCollision PROC
    pusha
    
    ; Only on level 3
    cmp currentLevel, 3
    jne enemyLavaCheckDone
    
    mov esi, 0
    
enemyLavaLoop:
    movzx eax, numEnemies
    cmp esi, eax
    jge enemyLavaCheckDone
    
    cmp enemyAlive[esi], 0
    je nextEnemyLava
    
    ; Check if enemy is on lava
    push edx
    mov dl, enemyX[esi]
    mov dh, enemyY[esi]
    call IsLavaAtPosition
    pop edx
    
    cmp al, 1
    jne nextEnemyLava
    
    ; Enemy fell into lava! Kill it
    mov enemyAlive[esi], 0
    
    push esi
    call EraseEnemy
    pop esi

nextEnemyLava:
    inc esi
    jmp enemyLavaLoop

enemyLavaCheckDone:
    popa
    ret
CheckEnemyLavaCollision ENDP


; ENEMY SYSTEM

; Looks like:  B O
;              W S
DrawBowser PROC
    pusha
    
    ; Check if Bowser is active and alive
    cmp bowserActive, 0
    je drawBowserDone
    
    cmp bowserAlive, 0
    je drawBowserDone
    
    ; Check if flashing from hit
    cmp bowserHitFlashing, 1
    jne normalBowserColor
    
    ; Flashing effect 
    mov eax, bowserHitTimer
    shr eax, 6                      ; flash speed also increases by increasing this 
    and eax, 1
    cmp eax, 0
    je whiteBowserColor
    
normalBowserColor:
    mov eax, yellow + (red * 16)
    jmp setBowserColorDone

whiteBowserColor:
    mov eax, white + (lightRed * 16)

setBowserColorDone:
    call SetTextColor
    
    ; Draw top-left: B
    mov dl, bowserX
    mov dh, bowserY
    call Gotoxy
    mov al, 'B'
    call WriteChar
    
    ; Draw top-right: O
    inc dl
    call Gotoxy
    mov al, 'O'
    call WriteChar
    
    ; Draw bottom-left: W
    mov dl, bowserX
    inc dh
    call Gotoxy
    mov al, 'W'
    call WriteChar
    
    ; Draw bottom-right: S
    inc dl
    call Gotoxy
    mov al, 'S'
    call WriteChar
    
    ; Draw health bar above Bowser
    call DrawBowserHealthBar

drawBowserDone:
    popa
    ret
DrawBowser ENDP


; DRAW BOWSER HEALTH BAR
DrawBowserHealthBar PROC
    pusha
    
    ; Position health bar above Bowser
    mov dl, bowserX
    mov dh, bowserY
    cmp dh, 1
    jle skipHealthBar              
    dec dh
    call Gotoxy
    
    mov eax, lightRed + (black * 16)
    call SetTextColor
    
    ; Draw hearts based on health
    movzx ecx, bowserHealth
    cmp ecx, 0
    je skipHealthBar
    cmp ecx, 3
    jg skipHealthBar                
    
drawHealthLoop:
    mov al, 3                       
    call WriteChar
    loop drawHealthLoop

skipHealthBar:
    popa
    ret
DrawBowserHealthBar ENDP


; Erase Bowser
EraseBowser PROC
    pusha
    
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    
    ; Erase top-left
    mov dl, bowserX
    mov dh, bowserY
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    ; Erase top-right
    inc dl
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    ; Erase bottom-left
    mov dl, bowserX
    inc dh
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    ; Erase bottom-right
    inc dl
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    ; Erase health bar area
    mov dl, bowserX
    mov dh, bowserY
    cmp dh, 1
    jle skipEraseHealth
    dec dh
    call Gotoxy
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar

skipEraseHealth:
    popa
    ret
EraseBowser ENDP


; Movement and Fire Timer
UpdateBowser PROC
    pusha
    
    ; Check if Bowser is active
    cmp bowserActive, 0
    je updateBowserDone
    
    ; Check if Bowser is alive
    cmp bowserAlive, 0
    je checkBowserDefeatAnim
    
    ; Update hit flashing timer
    cmp bowserHitFlashing, 1
    jne noFlashUpdate
    
    mov eax, bowserHitTimer
    cmp eax, 0
    jle endFlashing
    sub eax, 50
    mov bowserHitTimer, eax
    jmp noFlashUpdate

endFlashing:
    mov bowserHitFlashing, 0
    mov bowserHitTimer, 0

noFlashUpdate:
    ; Erase Bowser at current position
    call EraseBowser
    
    ; Move Bowser based on direction
    mov al, bowserDirection
    cmp al, 0
    je moveBowserLeftDir
    jmp moveBowserRightDir

moveBowserLeftDir:
    mov al, bowserX
    cmp al, bowserMinX
    jle reverseBowserDir
    dec bowserX
    jmp afterBowserMove

moveBowserRightDir:
    mov al, bowserX
    add al, 2                      
    cmp al, bowserMaxX
    jge reverseBowserDir
    inc bowserX
    jmp afterBowserMove

reverseBowserDir:
    mov al, bowserDirection
    xor al, 1
    mov bowserDirection, al

afterBowserMove:
    ; Update fire breath timer
    mov eax, bowserFireTimer
    add eax, 50                    
    mov bowserFireTimer, eax
    
    ; Check if time to breathe fire
    cmp eax, bowserFireInterval
    jl skipBowserFireBreath
    
    ; Reset timer and fire! 
    mov bowserFireTimer, 0
    call BowserBreatheFire

skipBowserFireBreath:
    ; Draw Bowser at new position
    call DrawBowser
    jmp updateBowserDone

checkBowserDefeatAnim:
    ; Check if showing defeat animation
    cmp bowserDefeated, 1
    jne updateBowserDone
    
    call BowserDefeatAnimation

updateBowserDone:
    popa
    ret
UpdateBowser ENDP


; Bowser Breathe Fire
BowserBreatheFire PROC
    pusha
    
    cmp bowserFireActive, 1
    je breatheFireDone
    
    mov bowserFireActive, 1
    
    ; Fire starts at Bowser's left side
    mov al, bowserX
    dec al
    cmp al, MIN_X
    jle breatheFireDone             
    mov bowserFireX, al
    
    ; Same Y as Bowser top
    mov al, bowserY
    inc al
    mov bowserFireY, al

breatheFireDone:
    popa
    ret
BowserBreatheFire ENDP


; Update Bowser Fire
UpdateBowserFire PROC
    pusha
    
    cmp bowserFireActive, 0
    je updateBowserFireDone
    
    ; Erase fire at current position
    call EraseBowserFire
    
    ; Move fire left (towards player)
    mov al, bowserFireX
    cmp al, MIN_X
    jle deactivateBowserFireNow
    
    sub al, bowserFireSpeed
    cmp al, MIN_X
    jle deactivateBowserFireNow
    
    mov bowserFireX, al
    
    ; Check collision with pipes
    push edx
    mov dl, bowserFireX
    mov dh, bowserFireY
    call IsPipeAtPosition
    pop edx
    cmp al, 1
    je deactivateBowserFireNow
    
    ; Check collision with platforms
    push edx
    mov dl, bowserFireX
    mov dh, bowserFireY
    call IsPlatformAtPosition
    pop edx
    cmp al, 1
    je deactivateBowserFireNow
    
    ; Draw fire at new position
    call DrawBowserFire
    jmp updateBowserFireDone

deactivateBowserFireNow:
    mov bowserFireActive, 0

updateBowserFireDone:
    popa
    ret
UpdateBowserFire ENDP


; Draw Bowser Fire
DrawBowserFire PROC
    pusha
    
    cmp bowserFireActive, 0
    je drawBowserFireDone
    
    mov eax, lightRed + (yellow * 16)
    call SetTextColor
    
    mov dl, bowserFireX
    mov dh, bowserFireY
    call Gotoxy
    mov al, '~'
    call WriteChar
    
    ; Draw trailing fire
    inc dl
    cmp dl, MAX_X
    jge drawBowserFireDone
    call Gotoxy
    mov al, '~'
    call WriteChar
    
    inc dl
    cmp dl, MAX_X
    jge drawBowserFireDone
    call Gotoxy
    mov al, '*'
    call WriteChar

drawBowserFireDone:
    popa
    ret
DrawBowserFire ENDP


; Erase Bowser Fire
EraseBowserFire PROC
    pusha
    
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    
    mov dl, bowserFireX
    mov dh, bowserFireY
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    inc dl
    cmp dl, MAX_X
    jge eraseBowserFireDone
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    inc dl
    cmp dl, MAX_X
    jge eraseBowserFireDone
    call Gotoxy
    mov al, ' '
    call WriteChar

eraseBowserFireDone:
    popa
    ret
EraseBowserFire ENDP


; Check bowser collision with player
CheckBowserCollision PROC
    pusha
    
    cmp bowserActive, 0
    je noBowserCollision
    
    cmp bowserAlive, 0
    je noBowserCollision
    
    cmp isInvincible, 1
    je noBowserCollision
    
    ; Bowser is 2x2: (X,Y), (X+1,Y), (X,Y+1), (X+1,Y+1)
    mov bl, bowserX
    mov bh, bowserY
    
    ; Check X collision
    mov al, xPos
    
    ; Left boundary
    mov cl, bl
    dec cl
    cmp al, cl
    jl noBowserCollision
    
    ; Right boundary
    mov cl, bl
    add cl, 2
    cmp al, cl
    jg noBowserCollision
    
    ; Check Y collision
    mov al, yPos
    
    ; Top boundary
    mov cl, bh
    dec cl
    cmp al, cl
    jl noBowserCollision
    
    ; Bottom boundary
    mov cl, bh
    add cl, 2
    cmp al, cl
    jg noBowserCollision
    
    ; Check if player is jumping on top
    cmp inAir, 1
    jne playerHitByBowserNow
    
    ; Check if player is above Bowser
    mov al, yPos
    cmp al, bh
    jge playerHitByBowserNow
    
    ; Player jumped on Bowser! 
    call DamageBowser
    
    ; Make player bounce
    mov inAir, 1
    mov jumpHeight, 2
    jmp noBowserCollision

playerHitByBowserNow:
    ; Player takes damage
    call PlayGameOverSound
    dec playerLives
    
    mov isInvincible, 1
    mov eax, invincibilityMaxTime
    mov invincibilityTimer, eax
    
    ; Push player away
    mov al, xPos
    cmp al, bowserX
    jl pushPlayerLeftBowser
    
    ; Push right
    add al, 5
    cmp al, MAX_X
    jg noBowserCollision
    mov xPos, al
    jmp noBowserCollision

pushPlayerLeftBowser:
    sub al, 5
    cmp al, MIN_X
    jl noBowserCollision
    mov xPos, al

noBowserCollision:
    popa
    ret
CheckBowserCollision ENDP


; CHECK BOWSER FIRE COLLISION WITH PLAYER
CheckBowserFireCollision PROC
    pusha
    
    cmp bowserFireActive, 0
    je noBowserFireColl
    
    cmp isInvincible, 1
    je noBowserFireColl
    
    ; Check X collision (fire is 3 chars wide)
    mov al, xPos
    mov bl, bowserFireX
    
    cmp al, bl
    jl checkFireRightSide
    
    mov cl, bl
    add cl, 3
    cmp al, cl
    jg noBowserFireColl
    jmp checkFireYColl

checkFireRightSide:
    mov cl, al
    add cl, 1
    cmp cl, bl
    jl noBowserFireColl

checkFireYColl:
    mov al, yPos
    cmp al, bowserFireY
    jne noBowserFireColl
    
    ; PLAYER HIT BY FIRE!
    call PlayGameOverSound
    dec playerLives
    
    mov bowserFireActive, 0
    call EraseBowserFire
    
    mov isInvincible, 1
    mov eax, invincibilityMaxTime
    mov invincibilityTimer, eax

noBowserFireColl:
    popa
    ret
CheckBowserFireCollision ENDP


; damage bowser
DamageBowser PROC
    pusha
    
    ; Decrease health
    cmp bowserHealth, 0
    je damageBowserDone
    
    call PlayEnemyDeadSound
    dec bowserHealth
    
    ; Start hit flashing
    mov bowserHitFlashing, 1
    mov bowserHitTimer, 500
    
    ; Add points
    mov eax, score
    add eax, bowserHitValue
    mov score, eax
    
    ; Show hit message
    push eax
    push edx
    mov eax, yellow + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET bowserHitMsg
    call WriteString
    movzx eax, bowserHealth
    call WriteDec
    mov edx, OFFSET bowserHealthMsg
    call WriteString
    pop edx
    pop eax
    
    ; Check if defeated
    cmp bowserHealth, 0
    jle bowserIsDefeated
    jmp damageBowserDone

bowserIsDefeated:
    mov bowserAlive, 0
    mov bowserDefeated, 1
    mov bowserDefeatTimer, 0
    
    call EraseBowser
    call PlayEnemyDeadSound
    ; Deactivate fire
    mov bowserFireActive, 0
    call EraseBowserFire
    
    ; Add big bonus
    mov eax, score
    add eax, bowserPointValue
    mov score, eax
    
    ; Show victory message
    push eax
    push edx
    mov eax, lightGreen + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET bowserDefeatedMsg
    call WriteString
    pop edx
    pop eax

damageBowserDone:
    popa
    ret
DamageBowser ENDP


; bowser defeat animation
BowserDefeatAnimation PROC
    pusha
    
    mov eax, bowserDefeatTimer
    add eax, 50
    mov bowserDefeatTimer, eax
    
    cmp eax, 200
    jl defeatPhase1Show
    cmp eax, 400
    jl defeatPhase2Show
    cmp eax, 600
    jl defeatPhase3Show
    
    ; Animation done
    mov bowserDefeated, 0
    mov bowserActive, 0
    jmp defeatAnimDone

defeatPhase1Show:
    mov eax, yellow + (red * 16)
    call SetTextColor
    mov dl, bowserX
    mov dh, bowserY
    call Gotoxy
    mov al, '*'
    call WriteChar
    call WriteChar
    jmp defeatAnimDone

defeatPhase2Show:
    mov eax, lightRed + (yellow * 16)
    call SetTextColor
    mov dl, bowserX
    mov dh, bowserY
    call Gotoxy
    mov al, '#'
    call WriteChar
    mov al, '#'
    call WriteChar
    inc dh
    mov dl, bowserX
    call Gotoxy
    mov al, '#'
    call WriteChar
    mov al, '#'
    call WriteChar
    jmp defeatAnimDone

defeatPhase3Show:
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, bowserX
    mov dh, bowserY
    call Gotoxy
    mov al, ' '
    call WriteChar
    call WriteChar
    inc dh
    mov dl, bowserX
    call Gotoxy
    mov al, ' '
    call WriteChar
    call WriteChar

defeatAnimDone:
    popa
    ret
BowserDefeatAnimation ENDP


; check fireball collisions
; mario's fireball vs bowser and vs bowser's fire

CheckFireballCollisions PROC
    pusha
    
    ; Skip if Bowser not active
    cmp bowserActive, 0
    je fireballCollisionsDone
    
    mov esi, 0
    
checkFireballLoop:
    cmp esi, MAX_FIREBALLS
    jge fireballCollisionsDone
    
    cmp fireballActive[esi], 0
    je nextFireballCheck
    
    ; Check vs Bowser (if alive)
    cmp bowserAlive, 1
    jne checkVsBowserFire
    
    ; Get fireball position
    mov al, fireballX[esi]
    mov bl, bowserX
    
    ; X check (Bowser is 2 wide)
    cmp al, bl
    jl checkBowserRight
    mov cl, bl
    add cl, 2
    cmp al, cl
    jg checkVsBowserFire
    jmp checkBowserYHit

checkBowserRight:
    mov cl, al
    add cl, 1
    cmp cl, bl
    jl checkVsBowserFire

checkBowserYHit:
    ; Y check (Bowser is 2 tall)
    mov al, fireballY[esi]
    mov bl, bowserY
    cmp al, bl
    jl checkVsBowserFire
    mov cl, bl
    add cl, 2
    cmp al, cl
    jge checkVsBowserFire
    
    ; FIREBALL HIT BOWSER!
    mov fireballActive[esi], 0
    cmp numActiveFireballs, 0
    je skipDecActive1
    dec numActiveFireballs
skipDecActive1:
    
    push esi
    call EraseFireball
    pop esi
    
    call DamageBowser
    jmp nextFireballCheck

checkVsBowserFire:
    ; Check vs Bowser's fire breath
    cmp bowserFireActive, 0
    je nextFireballCheck
    
    ; X proximity check
    mov al, fireballX[esi]
    mov bl, bowserFireX
    
    ; Calculate distance
    cmp al, bl
    jge calcDistPos
    
    ; al < bl
    mov cl, bl
    sub cl, al
    jmp checkDistVal

calcDistPos:
    mov cl, al
    sub cl, bl

checkDistVal:
    cmp cl, 4
    ja nextFireballCheck
    
    ; Y check
    mov al, fireballY[esi]
    cmp al, bowserFireY
    jne nextFireballCheck
    
    ; FIREBALLS COLLIDE!
    ; Deactivate Mario's fireball
    mov fireballActive[esi], 0
    cmp numActiveFireballs, 0
    je skipDecActive2
    dec numActiveFireballs
skipDecActive2:
    
    push esi
    call EraseFireball
    pop esi
    
    ; Deactivate Bowser's fire
    mov bowserFireActive, 0
    call EraseBowserFire
    
    ; Show collision message
    push eax
    push edx
    mov eax, yellow + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET fireballCollideMsg
    call WriteString
    pop edx
    pop eax
    
    ; Small bonus
    mov eax, score
    add eax, 25
    mov score, eax
    
    jmp fireballCollisionsDone

nextFireballCheck:
    inc esi
    jmp checkFireballLoop

fireballCollisionsDone:
    popa
    ret
CheckFireballCollisions ENDP



UpdateEnemies PROC
    pusha
    mov esi, 0
    
updateEnemyLoop:
    movzx eax, numEnemies
    cmp esi, eax
    jge updateDone
    
    cmp enemyAlive[esi], 0
    je nextEnemyUpdate
    
    ; Erase enemy at current position
    push esi
    call EraseEnemy
    pop esi
    
    ; Keep enemy on ground!
    call ApplyEnemyGravity
    
    ; Move enemy based on direction
    mov al, enemyDirection[esi]
    cmp al, 0
    je moveEnemyLeft
    jmp moveEnemyRight

moveEnemyLeft:
    mov al, enemyX[esi]
    cmp al, MIN_X
    jle reverseEnemyDirection
    
    ; Check for wall or edge collision
    push esi
    call CheckEnemyLeftCollision
    pop esi
    cmp al, 1
    je reverseEnemyDirection
    
    ; Move left
    mov al, enemySpeed
    sub enemyX[esi], al
    jmp afterEnemyMove

moveEnemyRight:
    mov al, enemyX[esi]
    cmp al, MAX_X
    jge reverseEnemyDirection
    
    ; Check for wall or edge collision
    push esi
    call CheckEnemyRightCollision
    pop esi
    cmp al, 1
    je reverseEnemyDirection
    
    ; Move right
    mov al, enemySpeed
    add enemyX[esi], al
    jmp afterEnemyMove

reverseEnemyDirection:
    ; Reverse direction
    mov al, enemyDirection[esi]
    xor al, 1
    mov enemyDirection[esi], al

afterEnemyMove:
    ; Draw enemy at new position
    push esi
    call DrawEnemy
    pop esi

nextEnemyUpdate:
    inc esi
    jmp updateEnemyLoop

updateDone:
    popa
    ret
UpdateEnemies ENDP

ApplyEnemyGravity PROC
    push eax
    push ebx
    push ecx
    push edx
    
    ; Check if enemy is on ground
    mov al, enemyY[esi]
    cmp al, GROUND_Y
    je enemyOnGround
    
    ; Check if enemy is on platform
    mov dl, enemyX[esi]
    mov dh, enemyY[esi]
    inc dh  ; Check position below enemy
    
    call IsPlatformAtPosition
    cmp al, 1
    je enemyOnPlatform
    
    ; move down to ground/platform
    call FindGroundBelow
    jmp gravityDone

enemyOnGround:
    ; Enemy is already on ground
    jmp gravityDone

enemyOnPlatform:
    ; Enemy is on platform - stay there
    jmp gravityDone

gravityDone:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
ApplyEnemyGravity ENDP

FindGroundBelow PROC
    push eax
    push ebx
    push ecx
    push edx
    
    mov dl, enemyX[esi] 
    mov dh, enemyY[esi]  
    
searchGroundLoop:
    ; Check if reached the ground
    cmp dh, GROUND_Y
    jge foundGround
    
    ; Check if there iss a platform at this position
    inc dh
    call IsPlatformAtPosition
    cmp al, 1
    je foundPlatform
    
    jmp searchGroundLoop

foundPlatform:
    ; Place enemy on top of platform
    dec dh
    mov enemyY[esi], dh
    jmp findGroundDone

foundGround:
    ; Place enemy on ground
    mov al, GROUND_Y
    mov enemyY[esi], al
    
findGroundDone:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
FindGroundBelow ENDP


CheckEnemyLeftCollision PROC
    push ebx
    push ecx
    push edx
    push esi
    
    ; Get enemy next position moving left
    mov dl, enemyX[esi]
    dec dl                      ; Position to the left
    mov dh, enemyY[esi]
    
    ; Check 1: Is there a wall
    call IsPlatformAtPosition
    cmp al, 1
    je shouldReverse_Left       
    
    ; check for pipe collision
    call IsPipeAtPosition
    cmp al, 1
    je shouldReverse_Left       
    
    ; Check 2: Is there ground
    inc dh                      ; Check one position below
    call IsPlatformAtPosition
    cmp al, 1
    je continueLeft             
    
    ; Check 3: Are we at ground level
    mov al, enemyY[esi]
    cmp al, GROUND_Y
    je continueLeft           
    
    ; No platform below and not on ground = edge detected
    jmp shouldReverse_Left

continueLeft:
    mov al, 0                   ; Don't reverse safe to move
    jmp checkLeftDone

shouldReverse_Left:
    mov al, 1                   ; Reverse direction

checkLeftDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
CheckEnemyLeftCollision ENDP


CheckEnemyRightCollision PROC
    push ebx
    push ecx
    push edx
    push esi
    
    ; Get enemy next position
    mov dl, enemyX[esi]
    inc dl                      ; Position to the right
    mov dh, enemyY[esi]
    
    ; Check 1: Is there a wall
    call IsPlatformAtPosition
    cmp al, 1
    je shouldReverse_Right      

    call IsPipeAtPosition
    cmp al, 1
    je shouldReverse_Right 
    
    ; Check 2: Is there ground
    inc dh                    
    call IsPlatformAtPosition
    cmp al, 1
    je continueRight            
    
    ; Check 3: Are we at ground level
    mov al, enemyY[esi]
    cmp al, GROUND_Y
    je continueRight            

    ; No platform below and not on ground this means edge detected
    jmp shouldReverse_Right

continueRight:
    mov al, 0                   
    jmp checkRightDone

shouldReverse_Right:
    mov al, 1                   

checkRightDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
CheckEnemyRightCollision ENDP


DrawEnemy PROC
    pusha
    
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, enemyX[esi]
    mov dh, enemyY[esi]
    call Gotoxy
    mov al, 'G'
    call WriteChar
    
    popa
    ret
DrawEnemy ENDP

EraseEnemy PROC
    pusha
    
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, enemyX[esi]
    mov dh, enemyY[esi]
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    popa
    ret
EraseEnemy ENDP


; mario style enemy collision
; if mario is jumping/falling + hits enemy = enemy dies
; if mario is on ground + hits enemy = player takes damage
CheckEnemyCollision PROC
    pusha
    mov esi, 0
    
enemyCollisionLoop:
    movzx eax, numEnemies
    cmp esi, eax
    jge noEnemyCollision
    
    cmp enemyAlive[esi], 0
    je nextEnemyCollision
    
    cmp isInvincible, 1
    je nextEnemyCollision
    
    mov bl, enemyX[esi]
    mov bh, enemyY[esi]
    
    ; Check X collision range (1 pixel)
    mov al, xPos
    mov cl, bl
    sub cl, 1
    cmp al, cl
    jl nextEnemyCollision
    
    mov cl, bl
    add cl, 1
    cmp al, cl
    jg nextEnemyCollision
    
    ; Check Y collision range (1 pixel)
    mov al, yPos
    mov cl, bh
    sub cl, 1
    cmp al, cl
    jl nextEnemyCollision
    
    mov cl, bh
    add cl, 1
    cmp al, cl
    jg nextEnemyCollision
    
    cmp isSuperMario, 1
    jne checkNormalCollision
    cmp superMarioInvincible, 1
    je superMarioDestroyEnemy
    
checkNormalCollision:
    ; Check if Mario is in the air
    cmp inAir, 1
    je marioIsJumping
    
    ; Mario is on ground
    jmp playerGotHit

marioIsJumping:
    ; Mario is in air  enemy dies! 
    jmp playerJumpedOnEnemy

superMarioDestroyEnemy:
    mov enemyAlive[esi], 0
    call PlayEnemyDeadSound
    call UpdateCombo
    
    ; Erase enemy
    push esi
    call EraseEnemy
    pop esi
    
    ; Add bonus points (more than normal jump kill)
    push eax
    mov eax, score
    add eax, 150                        ; Bonus for super power
    mov score, eax
    pop eax
    

    mov isSuperMario, 0
    mov superMarioInvincible, 0
    
    ; Show super mario crush message
    push eax
    push edx
    mov eax, lightCyan + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET superMarioHitMsg
    call WriteString
    
    mov eax, 500
    call Delay
    
    ; Show power lost message
    mov eax, yellow + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET superMarioPowerLostMsg
    call WriteString
    pop edx
    pop eax
    
    jmp noEnemyCollision

playerJumpedOnEnemy:
    mov enemyAlive[esi], 0
    call PlayEnemyDeadSound 
    call UpdateCombo

    ; Erase enemy
    push esi
    call EraseEnemy
    pop esi
    
    ; Add points
    push eax
    mov eax, score
    add eax, enemyValue
    mov score, eax
    pop eax
    
    ; Make Mario bounce 
    mov inAir, 1
    mov jumpHeight, 3
    
    ; Show victory message
    push eax
    push edx
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET enemyDefeatedMsg
    call WriteString
    pop edx
    pop eax
    
    jmp noEnemyCollision

playerGotHit:
    cmp isSuperMario, 1
    je superMarioTakesHit
    
    ; Normal Mario takes damage
    call PlayGameOverSound
    dec playerLives
    mov enemyComboCount, 0
    
    ; Activate invincibility
    mov isInvincible, 1
    mov eax, invincibilityMaxTime
    mov invincibilityTimer, eax
    
    jmp showHitMessage

superMarioTakesHit:
    call PlayGameOverSound
    mov isSuperMario, 0
    mov superMarioInvincible, 0
    mov enemyComboCount, 0
    
    ; Activate invincibility
    mov isInvincible, 1
    mov eax, invincibilityMaxTime
    mov invincibilityTimer, eax

showHitMessage:
    ; Show hit message
    push eax
    push edx
    mov eax, lightRed + (lightblue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET playerHitMsg
    call WriteString
    pop edx
    pop eax
    
    cmp playerLives, 0
    jle noEnemyCollision
    
    ; Push player away from enemy
    mov al, enemyDirection[esi]
    cmp al, 0
    je pushPlayerRight
    
    ; Push left
    mov al, xPos
    sub al, 3
    cmp al, MIN_X
    jl noEnemyCollision
    mov xPos, al
    jmp noEnemyCollision

pushPlayerRight:
    ; Push right
    mov al, xPos
    add al, 3
    cmp al, MAX_X
    jg noEnemyCollision
    mov xPos, al

nextEnemyCollision:
    inc esi
    jmp enemyCollisionLoop

noEnemyCollision:
    popa
    ret
CheckEnemyCollision ENDP

UpdateInvincibilityTimer PROC
    pusha
    
    cmp isInvincible, 0
    je notInvincible
    
    mov eax, invincibilityTimer
    cmp eax, 50
    jl deactivateInvincibility
    
    sub eax, 50
    mov invincibilityTimer, eax
    jmp notInvincible
    
deactivateInvincibility:
    mov isInvincible, 0
    mov invincibilityTimer, 0

notInvincible:
    popa
    ret
UpdateInvincibilityTimer ENDP

RedrawEnemies PROC
    pusha
    mov esi, 0
    
redrawEnemyLoop:
    movzx eax, numEnemies
    cmp esi, eax
    jge redrawEnemiesDone
    
    cmp enemyAlive[esi], 0
    je skipRedrawEnemy
    
    call DrawEnemy

skipRedrawEnemy:
    inc esi
    jmp redrawEnemyLoop

redrawEnemiesDone:
    popa
    ret
RedrawEnemies ENDP


; koopa system (identical to goomba behavior)
UpdateKoopas PROC
    pusha
    mov esi, 0

updateKoopaLoop:
    movzx eax, numKoopas
    cmp esi, eax
    jge updateKoopasDone
    
    cmp koopaAlive[esi], 0
    je nextKoopaUpdate
    
    cmp koopaAlive[esi], 2      ; Is it a shell
    je nextKoopaUpdate          ; Skip movement for shells
    
    ; Only update walking koopas (state = 1)
    ; Erase koopa at current position
    push esi
    call EraseKoopa
    pop esi
    
    ; Apply gravity (same as before)
    call ApplyKoopaGravity
    
    ; Move koopa based on direction (same as before)
    mov al, koopaDirection[esi]
    cmp al, 0
    je moveKoopaLeft
    jmp moveKoopaRight


moveKoopaLeft:
    mov al, koopaX[esi]
    cmp al, MIN_X
    jle reverseKoopaDirection
    
    ; Check for wall or edge collision (same as Goomba)
    push esi
    call CheckKoopaLeftCollision
    pop esi
    cmp al, 1
    je reverseKoopaDirection
    
    ; Move left
    mov al, koopaSpeed
    sub koopaX[esi], al
    jmp afterKoopaMove

moveKoopaRight:
    mov al, koopaX[esi]
    cmp al, MAX_X
    jge reverseKoopaDirection
    
    ; Check for wall or edge collision (same as Goomba)
    push esi
    call CheckKoopaRightCollision
    pop esi
    cmp al, 1
    je reverseKoopaDirection
    
    ; Move right
    mov al, koopaSpeed
    add koopaX[esi], al
    jmp afterKoopaMove

reverseKoopaDirection:
    ; Reverse direction (same as Goomba)
    mov al, koopaDirection[esi]
    xor al, 1
    mov koopaDirection[esi], al

afterKoopaMove:
    ; Draw koopa at new position
    push esi
    call DrawKoopa
    pop esi

nextKoopaUpdate:
    inc esi
    jmp updateKoopaLoop

updateKoopasDone:
    popa
    ret
UpdateKoopas ENDP

UpdateMovingShell PROC
    pusha
    
    ; Check if moving shell is active
    cmp movingShellActive, 0
    je noMovingShell
    
    ; Erase shell at current position
    call EraseMovingShell
    
    ; Move shell to the right
    mov al, movingShellSpeed
    add movingShellX, al
    
    ; Check if shell reached screen edge
    mov al, movingShellX
    cmp al, MAX_X
    jge removeMovingShell
    
    ; CHECK GOOMBA COLLISIONS!
    call CheckMovingShellVsGoombas
    
    ; Draw shell at new position
    call DrawMovingShell
    jmp noMovingShell

removeMovingShell:
    ; Shell reached edge - remove it
    call EraseMovingShell
    mov movingShellActive, 0
    
    ; Show removal message
    push eax
    push edx
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET shellReachedEdgeMsg
    call WriteString
    pop edx
    pop eax

noMovingShell:
    popa
    ret
UpdateMovingShell ENDP

CheckMovingShellVsGoombas PROC
    pusha
    mov esi, 0
    
shellVsGoombaLoop:
    movzx eax, numEnemies
    cmp esi, eax
    jge shellVsGoombaDone
    
    ; Check if Goomba is alive
    cmp enemyAlive[esi], 0
    je nextShellVsGoomba
    
    ; Check collision bounds
    mov bl, movingShellX        ; Shell X
    mov bh, movingShellY        ; Shell Y
    mov cl, enemyX[esi]         ; Goomba X
    mov ch, enemyY[esi]         ; Goomba Y
    
    ; X collision check (?1 pixel)
    mov al, bl
    sub al, 1
    cmp cl, al
    jl nextShellVsGoomba
    add al, 2
    cmp cl, al
    jg nextShellVsGoomba
    
    ; Y collision check
    cmp bh, ch
    jne nextShellVsGoomba
    
    ; shell hit goomba!
    mov enemyAlive[esi], 0      ; Kill Goomba
    call PlayEnemyDeadSound 
    call UpdateCombo 

    ; Erase Goomba
    push esi
    call EraseEnemy
    pop esi
    
    ; Add big score bonus
    push eax
    mov eax, score
    add eax, 200                ; Big bonus for shell kill
    mov score, eax
    pop eax
    
    ; Show kill message
    push eax
    push edx
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET shellKillMsg
    call WriteString
    pop edx
    pop eax

nextShellVsGoomba:
    inc esi
    jmp shellVsGoombaLoop

shellVsGoombaDone:
    popa
    ret
CheckMovingShellVsGoombas ENDP

DrawMovingShell PROC
    pusha
    
    mov eax, lightMagenta + (black * 16)  ; Different color for moving shell
    call SetTextColor
    mov dl, movingShellX
    mov dh, movingShellY
    call Gotoxy
    mov al, 'S'
    call WriteChar
    
    popa
    ret
DrawMovingShell ENDP

EraseMovingShell PROC
    pusha
    
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, movingShellX
    mov dh, movingShellY
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    popa
    ret
EraseMovingShell ENDP


; identical to applyenemygravity
ApplyKoopaGravity PROC
    push eax
    push ebx
    push ecx
    push edx
    
    ; Check if koopa is on ground
    mov al, koopaY[esi]
    cmp al, GROUND_Y
    je koopaOnGround
    
    ; Check if koopa is on platform
    mov dl, koopaX[esi]
    mov dh, koopaY[esi]
    inc dh  ; Check position below koopa
    
    call IsPlatformAtPosition
    cmp al, 1
    je koopaOnPlatform
    
    ; Koopa is falling move down to ground/platform
    call FindKoopaGroundBelow
    jmp koopaGravityDone

koopaOnGround:
koopaOnPlatform:
    jmp koopaGravityDone

koopaGravityDone:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
ApplyKoopaGravity ENDP

; identical to findgroundbelow
FindKoopaGroundBelow PROC
    push eax
    push ebx
    push ecx
    push edx
    
    mov dl, koopaX[esi]  ; Koopa X position
    mov dh, koopaY[esi]  ; Current Y position
    
searchKoopaGroundLoop:
    cmp dh, GROUND_Y
    jge foundKoopaGround
    
    inc dh
    call IsPlatformAtPosition
    cmp al, 1
    je foundKoopaPlatform
    
    jmp searchKoopaGroundLoop

foundKoopaPlatform:
    dec dh
    mov koopaY[esi], dh
    jmp findKoopaGroundDone

foundKoopaGround:
    mov al, GROUND_Y
    mov koopaY[esi], al
    
findKoopaGroundDone:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
FindKoopaGroundBelow ENDP

; identical to checkenemyleftcollision
CheckKoopaLeftCollision PROC
    push ebx
    push ecx
    push edx
    push esi
    
    mov dl, koopaX[esi]
    dec dl
    mov dh, koopaY[esi]
    
    call IsPlatformAtPosition
    cmp al, 1
    je shouldReverseKoopa_Left
    
    call IsPipeAtPosition
    cmp al, 1
    je shouldReverseKoopa_Left
    
    inc dh
    call IsPlatformAtPosition
    cmp al, 1
    je continueKoopaLeft
    
    mov al, koopaY[esi]
    cmp al, GROUND_Y
    je continueKoopaLeft
    
    jmp shouldReverseKoopa_Left

continueKoopaLeft:
    mov al, 0
    jmp checkKoopaLeftDone

shouldReverseKoopa_Left:
    mov al, 1

checkKoopaLeftDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
CheckKoopaLeftCollision ENDP

; IDENTICAL to CheckEnemyRightCollision
CheckKoopaRightCollision PROC
    push ebx
    push ecx
    push edx
    push esi
    
    mov dl, koopaX[esi]
    inc dl
    mov dh, koopaY[esi]
    
    call IsPlatformAtPosition
    cmp al, 1
    je shouldReverseKoopa_Right

    call IsPipeAtPosition
    cmp al, 1
    je shouldReverseKoopa_Right
    
    inc dh
    call IsPlatformAtPosition
    cmp al, 1
    je continueKoopaRight
    
    mov al, koopaY[esi]
    cmp al, GROUND_Y
    je continueKoopaRight
    
    jmp shouldReverseKoopa_Right

continueKoopaRight:
    mov al, 0
    jmp checkKoopaRightDone

shouldReverseKoopa_Right:
    mov al, 1

checkKoopaRightDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
CheckKoopaRightCollision ENDP

DrawKoopa PROC
    pusha
    
    ; Check koopa state first
    mov al, koopaAlive[esi]
    cmp al, 2                   ; Is it a shell
    je drawAsShell
    
    ; Draw walking koopa K or R
    mov al, koopaType[esi]
    cmp al, 1
    je drawRedKoopa
    
    ; Draw green koopa K
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dl, koopaX[esi]
    mov dh, koopaY[esi]
    call Gotoxy
    mov al, 'K'
    call WriteChar
    jmp drawKoopaDone

drawRedKoopa:
    ; Draw red koopa R
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dl, koopaX[esi]
    mov dh, koopaY[esi]
    call Gotoxy
    mov al, 'R'
    call WriteChar
    jmp drawKoopaDone

drawAsShell:
    ; Draw shell S
    call DrawKoopaShell

drawKoopaDone:
    popa
    ret
DrawKoopa ENDP


EraseKoopa PROC
    pusha
    
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, koopaX[esi]
    mov dh, koopaY[esi]
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    popa
    ret
EraseKoopa ENDP


CheckKoopaCollision PROC
    pusha
    mov esi, 0
    
koopaCollisionLoop:
    movzx eax, numKoopas
    cmp esi, eax
    jge noKoopaCollision
    
    cmp koopaAlive[esi], 0
    je nextKoopaCollision
    
    cmp isInvincible, 1
    je nextKoopaCollision
    
    mov bl, koopaX[esi]
    mov bh, koopaY[esi]
    
    ; X collision check
    mov al, xPos
    mov cl, bl
    sub cl, 1
    cmp al, cl
    jl nextKoopaCollision
    add cl, 2
    cmp al, cl
    jg nextKoopaCollision
    
    ; Y collision check
    mov al, yPos
    mov cl, bh
    sub cl, 1
    cmp al, cl
    jl nextKoopaCollision
    add cl, 2
    cmp al, cl
    jg nextKoopaCollision
    
    ; 
    cmp isSuperMario, 1
    jne checkNormalKoopaCollision
    cmp superMarioInvincible, 1
    je superMarioDestroyKoopa
    
checkNormalKoopaCollision:
    ; KOOPA 3-STAGE LOGIC
    mov al, koopaAlive[esi]
    cmp al, 1                   ; Walking koopa
    je handleWalkingKoopa
    cmp al, 2                   ; Static Shell S
    je handleStaticShell
    jmp nextKoopaCollision

handleWalkingKoopa:
    ; Stage 1: Walking K/R  Static Shell S
    cmp inAir, 1
    je convertToShell           ; Convert to shell
    jmp playerHitByKoopa        ; Player takes damage

convertToShell:
    mov koopaAlive[esi], 2      ; 2 = Static Shell state
    call PlayEnemyDeadSound 

    ; Erase walking koopa
    push esi
    call EraseKoopa
    pop esi
    
    ; Draw shell at same position
    push esi
    call DrawKoopaShell
    pop esi
    
    ; Add points for converting to shell
    push eax
    mov eax, score
    add eax, koopaValue
    mov score, eax
    pop eax
    
    ; Make Mario bounce
    mov inAir, 1
    mov jumpHeight, 3
    
    ; Show shell conversion message
    push eax
    push edx
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET shellCreatedMsg
    call WriteString
    pop edx
    pop eax
    
    jmp noKoopaCollision

superMarioDestroyKoopa:
    mov koopaAlive[esi], 0
    call PlayEnemyDeadSound
    call UpdateCombo
    
    ; Erase koopa
    push esi
    call EraseKoopa
    pop esi
    
    ; Add bonus points more than normal jump kill
    push eax
    mov eax, score
    add eax, 200                    ; Koopas worth more
    mov score, eax
    pop eax
    
    
    mov isSuperMario, 0
    mov superMarioInvincible, 0
    
    ; Show super mario crush message
    push eax
    push edx
    mov eax, lightCyan + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET superMarioHitMsg
    call WriteString
    
    mov eax, 500
    call Delay
    
    ; Show power lost message
    mov eax, yellow + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET superMarioPowerLostMsg
    call WriteString
    pop edx
    pop eax
    
    jmp noKoopaCollision

handleStaticShell:
    ; Remove static shell from koopa array
    mov koopaAlive[esi], 0      ; Remove from koopa system
    
    ; Erase static shell
    push esi
    call EraseKoopa
    pop esi
    
    call PlayShellKickSound
    mov movingShellActive, 1    ; Activate moving shell
    mov al, koopaX[esi]
    mov movingShellX, al        ; Set shell X position
    mov al, koopaY[esi]  
    mov movingShellY, al        ; Set shell Y position
    
    ; Add points for kicking shell
    push eax
    mov eax, score
    add eax, 25                 ; Bonus for kicking
    mov score, eax
    pop eax
    
    ; Show shell kick message
    push eax
    push edx
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET shellKickMsg
    call WriteString
    pop edx
    pop eax
    
    jmp noKoopaCollision

playerHitByKoopa:
    cmp isSuperMario, 1
    je superMarioTakesKoopaHit
    
    ; Normal Mario takes damage same as before
    call PlayGameOverSound
    dec playerLives
    mov isInvincible, 1
    mov eax, invincibilityMaxTime
    mov invincibilityTimer, eax
    
    ; Push player away
    mov al, koopaDirection[esi]
    cmp al, 0
    je pushPlayerRightFromKoopa
    
    mov al, xPos
    sub al, 3
    cmp al, MIN_X
    jl noKoopaCollision
    mov xPos, al
    jmp noKoopaCollision

superMarioTakesKoopaHit:
    call PlayGameOverSound
    mov isSuperMario, 0
    mov superMarioInvincible, 0
    mov enemyComboCount, 0
    
    ; Activate invincibility
    mov isInvincible, 1
    mov eax, invincibilityMaxTime
    mov invincibilityTimer, eax
    
    ; Push player away
    mov al, koopaDirection[esi]
    cmp al, 0
    je pushPlayerRightFromKoopa
    
    mov al, xPos
    sub al, 3
    cmp al, MIN_X
    jl noKoopaCollision
    mov xPos, al
    jmp noKoopaCollision

pushPlayerRightFromKoopa:
    mov al, xPos
    add al, 3
    cmp al, MAX_X
    jg noKoopaCollision
    mov xPos, al

nextKoopaCollision:
    inc esi
    jmp koopaCollisionLoop

noKoopaCollision:
    popa
    ret
CheckKoopaCollision ENDP


RedrawKoopas PROC
    pusha
    mov esi, 0
    
redrawKoopaLoop:
    movzx eax, numKoopas
    cmp esi, eax
    jge redrawKoopasDone
    
    cmp koopaAlive[esi], 0
    je skipRedrawKoopa
    
    call DrawKoopa

skipRedrawKoopa:
    inc esi
    jmp redrawKoopaLoop

redrawKoopasDone:
    popa
    ret
RedrawKoopas ENDP

DrawKoopaShell PROC
    pusha
    
    ; Draw static shell S
    mov eax, cyan + (black * 16)
    call SetTextColor
    mov dl, koopaX[esi]
    mov dh, koopaY[esi]
    call Gotoxy
    mov al, 'S'              
    call WriteChar
    
    popa
    ret
DrawKoopaShell ENDP


; draw flying enemy
DrawFlyingEnemy PROC
    pusha
    
    mov eax, lightMagenta + (lightBlue * 16)   ; Purple/magenta color for flying enemies
    call SetTextColor
    mov dl, flyingEnemyX[esi]
    mov dh, flyingEnemyY[esi]
    call Gotoxy
    mov al, 'F'                                
    call WriteChar
    
    popa
    ret
DrawFlyingEnemy ENDP


; erase flying enemy
EraseFlyingEnemy PROC
    pusha
    
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, flyingEnemyX[esi]
    mov dh, flyingEnemyY[esi]
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    popa
    ret
EraseFlyingEnemy ENDP

; update flying enemies no gravity applied! 
UpdateFlyingEnemies PROC
    pusha
    mov esi, 0
    
updateFlyingLoop:
    movzx eax, numFlyingEnemies
    cmp esi, eax
    jge updateFlyingDone
    
    cmp flyingEnemyAlive[esi], 0
    je nextFlyingUpdate
    
    ; Erase flying enemy at current position
    push esi
    call EraseFlyingEnemy
    pop esi
    
    ; But we add a bobbing effect for visual appeal
    call ApplyFlyingEnemyBob
    
    ; Move flying enemy based on direction
    mov al, flyingEnemyDirection[esi]
    cmp al, 0
    je moveFlyingLeft
    jmp moveFlyingRight

moveFlyingLeft:
    mov al, flyingEnemyX[esi]
    cmp al, MIN_X
    jle reverseFlyingDirection
    
    ; Check for pipe collision
    push esi
    call CheckFlyingLeftCollision
    pop esi
    cmp al, 1
    je reverseFlyingDirection
    
    ; Move left
    mov al, flyingEnemySpeed
    sub flyingEnemyX[esi], al
    jmp afterFlyingMove

moveFlyingRight:
    mov al, flyingEnemyX[esi]
    cmp al, MAX_X
    jge reverseFlyingDirection
    
    ; Check for pipe collision
    push esi
    call CheckFlyingRightCollision
    pop esi
    cmp al, 1
    je reverseFlyingDirection
    
    ; Move right
    mov al, flyingEnemySpeed
    add flyingEnemyX[esi], al
    jmp afterFlyingMove

reverseFlyingDirection:
    ; Reverse direction
    mov al, flyingEnemyDirection[esi]
    xor al, 1
    mov flyingEnemyDirection[esi], al

afterFlyingMove:
    ; Draw flying enemy at new position
    push esi
    call DrawFlyingEnemy
    pop esi

nextFlyingUpdate:
    inc esi
    jmp updateFlyingLoop

updateFlyingDone:
    popa
    ret
UpdateFlyingEnemies ENDP


; Making flying enemies move up and down slightly
ApplyFlyingEnemyBob PROC
    push eax
    push ebx
    
    ; Get current bob direction
    mov al, flyingEnemyBobDirection[esi]
    cmp al, 0
    je bobUp
    
bobDown:
    ; Moving down
    mov al, flyingEnemyBobOffset[esi]
    inc al
    cmp al, 2                           ; Max bob distance = 2
    jge reverseBobDirection
    mov flyingEnemyBobOffset[esi], al
    jmp applyBobOffset

bobUp:
    ; Moving up
    mov al, flyingEnemyBobOffset[esi]
    cmp al, 0
    je reverseBobDirection
    dec al
    mov flyingEnemyBobOffset[esi], al
    jmp applyBobOffset

reverseBobDirection:
    mov al, flyingEnemyBobDirection[esi]
    xor al, 1
    mov flyingEnemyBobDirection[esi], al

applyBobOffset:
    ; Calculate Y position = baseY + bobOffset
    mov al, flyingEnemyBaseY[esi]
    add al, flyingEnemyBobOffset[esi]
    mov flyingEnemyY[esi], al
    
    pop ebx
    pop eax
    ret
ApplyFlyingEnemyBob ENDP


; check flying enemy left collision
CheckFlyingLeftCollision PROC
    push ebx
    push ecx
    push edx
    push esi
    
    ; Get flying enemy next position (moving left)
    mov dl, flyingEnemyX[esi]
    dec dl                              ; Position to the left
    mov dh, flyingEnemyY[esi]
    
    ; Check for pipe collision only
    call IsPipeAtPosition
    cmp al, 1
    je shouldReverseFlyingLeft
    
    ; No obstacle - safe to move
    mov al, 0
    jmp checkFlyingLeftDone

shouldReverseFlyingLeft:
    mov al, 1

checkFlyingLeftDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
CheckFlyingLeftCollision ENDP


; check flying enemy right collision
CheckFlyingRightCollision PROC
    push ebx
    push ecx
    push edx
    push esi
    
    ; Get flying enemy next position (moving right)
    mov dl, flyingEnemyX[esi]
    inc dl                              ; Position to the right
    mov dh, flyingEnemyY[esi]
    
    ; Check for pipe collision only
    call IsPipeAtPosition
    cmp al, 1
    je shouldReverseFlyingRight
    
    ; No obstacle - safe to move
    mov al, 0
    jmp checkFlyingRightDone

shouldReverseFlyingRight:
    mov al, 1

checkFlyingRightDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
CheckFlyingRightCollision ENDP


; check flying enemy collision with player
CheckFlyingEnemyCollision PROC
    pusha
    mov esi, 0
    
flyingCollisionLoop:
    movzx eax, numFlyingEnemies
    cmp esi, eax
    jge noFlyingCollision
    
    cmp flyingEnemyAlive[esi], 0
    je nextFlyingCollision
    
    cmp isInvincible, 1
    je nextFlyingCollision
    
    mov bl, flyingEnemyX[esi]
    mov bh, flyingEnemyY[esi]
    
    ; Check X collision range (?1 pixel)
    mov al, xPos
    mov cl, bl
    sub cl, 1
    cmp al, cl
    jl nextFlyingCollision
    
    mov cl, bl
    add cl, 1
    cmp al, cl
    jg nextFlyingCollision
    
    ; Check Y collision range (?1 pixel)
    mov al, yPos
    mov cl, bh
    sub cl, 1
    cmp al, cl
    jl nextFlyingCollision
    
    mov cl, bh
    add cl, 1
    cmp al, cl
    jg nextFlyingCollision
    
  
    cmp isSuperMario, 1
    jne checkNormalFlyingCollision
    cmp superMarioInvincible, 1
    je superMarioDestroyFlyingEnemy
    
checkNormalFlyingCollision:

    ; Check if Mario is above the flying enemy (jumping on it)
    mov al, yPos
    cmp al, bh                          ; Is Mario's Y less than enemy Y
    jl playerJumpedOnFlying             ; Mario is above kill enemy! 
    
    ; Check if Mario was falling (in air and moving down)
    cmp inAir, 1
    jne playerHitByFlying               ; Not in air = hit by enemy
    
    ; Check if Mario came from above
    mov al, prevYPos
    cmp al, bh
    jl playerJumpedOnFlying             ; Was above before = jumped on
    
    ; Mario hit from side
    jmp playerHitByFlying

superMarioDestroyFlyingEnemy:
    mov flyingEnemyAlive[esi], 0
    call PlayEnemyDeadSound
    call UpdateCombo
    
    ; Erase flying enemy
    push esi
    call EraseFlyingEnemy
    pop esi
    
    ; Add bonus points
    push eax
    mov eax, score
    add eax, 200                        ; Flying enemies worth more
    mov score, eax
    pop eax
    
   
    mov isSuperMario, 0
    mov superMarioInvincible, 0
    
    ; Show super mario crush message
    push eax
    push edx
    mov eax, lightCyan + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET superMarioHitMsg
    call WriteString
    
    mov eax, 500
    call Delay
    
    ; Show power lost message
    mov eax, yellow + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET superMarioPowerLostMsg
    call WriteString
    pop edx
    pop eax
    
    jmp noFlyingCollision

playerJumpedOnFlying:
    ; Mario killed the flying enemy!  
    mov flyingEnemyAlive[esi], 0
    call PlayEnemyDeadSound 

    call UpdateCombo
    ; Erase flying enemy
    push esi
    call EraseFlyingEnemy
    pop esi
    
    ; Add points flying enemies worth more
    push eax
    mov eax, score
    add eax, flyingEnemyValue
    mov score, eax
    pop eax
    
    ; Make Mario bounce
    mov inAir, 1
    mov jumpHeight, 3
    
    ; Show victory message
    push eax
    push edx
    mov eax, lightGreen + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET flyingEnemyDefeatedMsg
    call WriteString
    pop edx
    pop eax
    
    jmp noFlyingCollision

playerHitByFlying:
    cmp isSuperMario, 1
    je superMarioTakesFlyingHit
    
    ; Player takes damage
    call PlayGameOverSound
    dec playerLives
    
    ; Activate invincibility
    mov isInvincible, 1
    mov eax, invincibilityMaxTime
    mov invincibilityTimer, eax
    
    ; Show hit message
    push eax
    push edx
    mov eax, lightRed + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET playerHitMsg
    call WriteString
    pop edx
    pop eax
    
    cmp playerLives, 0
    jle noFlyingCollision
    
    ; Push player away from flying enemy
    mov al, flyingEnemyDirection[esi]
    cmp al, 0
    je pushPlayerRightFromFlying
    
    ; Push left
    mov al, xPos
    sub al, 3
    cmp al, MIN_X
    jl noFlyingCollision
    mov xPos, al
    jmp noFlyingCollision


superMarioTakesFlyingHit:
    call PlayGameOverSound
    mov isSuperMario, 0
    mov superMarioInvincible, 0
    mov enemyComboCount, 0
    
    ; Activate invincibility
    mov isInvincible, 1
    mov eax, invincibilityMaxTime
    mov invincibilityTimer, eax
    
    ; Push player away
    mov al, flyingEnemyDirection[esi]
    cmp al, 0
    je pushPlayerRightFromFlying
    
    mov al, xPos
    sub al, 3
    cmp al, MIN_X
    jl noFlyingCollision
    mov xPos, al
    jmp noFlyingCollision

pushPlayerRightFromFlying:
    ; Push right
    mov al, xPos
    add al, 3
    cmp al, MAX_X
    jg noFlyingCollision
    mov xPos, al

nextFlyingCollision:
    inc esi
    jmp flyingCollisionLoop

noFlyingCollision:
    popa
    ret
CheckFlyingEnemyCollision ENDP


; redraw all flying enemies
RedrawFlyingEnemies PROC
    pusha
    mov esi, 0
    
redrawFlyingLoop:
    movzx eax, numFlyingEnemies
    cmp esi, eax
    jge redrawFlyingDone
    
    cmp flyingEnemyAlive[esi], 0
    je skipRedrawFlying
    
    call DrawFlyingEnemy

skipRedrawFlying:
    inc esi
    jmp redrawFlyingLoop

redrawFlyingDone:
    popa
    ret
RedrawFlyingEnemies ENDP

; check if player is on flying enemy cell
IsPlayerOnFlyingEnemyCell PROC
    push ecx
    push esi
    push ebx
    
    mov ecx, 0
    mov esi, 0
    
checkFlyingCell:
    cmp flyingEnemyAlive[esi], 0
    je nextFlyingCell
    
    mov al, yPos
    mov bl, flyingEnemyY[esi]
    cmp al, bl
    jne nextFlyingCell
    
    mov al, xPos
    mov bl, flyingEnemyX[esi]
    cmp al, bl
    jne nextFlyingCell
    
    mov al, 1
    pop ebx
    pop esi
    pop ecx
    ret

nextFlyingCell:
    inc esi
    inc ecx
    movzx eax, numFlyingEnemies
    cmp ecx, eax
    jl checkFlyingCell
    
    mov al, 0
    pop ebx
    pop esi
    pop ecx
    ret
IsPlayerOnFlyingEnemyCell ENDP


; coin & star collection
CheckCoinCollection PROC
    pusha
    mov esi, 0
    
coinCheckLoop:
    cmp coinCollected[esi], 1
    je nextCoin_Check
    
    mov collisionFromAbove, 0
    mov collisionFromBelow, 0
    mov collisionFromLeft, 0
    mov collisionFromRight, 0
    
    mov bl, coinX[esi]
    mov bh, coinY[esi]
    
    mov al, xPos
    mov cl, bl
    sub cl, 2
    cmp al, cl
    jl nextCoin_Check
    
    mov cl, bl
    add cl, 2
    cmp al, cl
    jg nextCoin_Check
    
    mov al, yPos
    mov cl, bh
    sub cl, 2
    cmp al, cl
    jl nextCoin_Check
    
    mov cl, bh
    add cl, 2
    cmp al, cl
    jg nextCoin_Check
    
    call DetermineCollisionDirection
    
    mov al, xPos
    mov cl, bl
    cmp al, cl
    je checkVerticalCollision
    
    mov al, yPos
    mov cl, bh
    sub al, cl
    cmp al, 1
    jbe collectCoin_Dir
    jmp nextCoin_Check

checkVerticalCollision:
    mov al, yPos
    mov cl, bh
    sub al, cl
    cmp al, 2
    jbe collectCoin_Dir
    jmp nextCoin_Check

collectCoin_Dir:
    mov coinCollected[esi], 1
    
    mov al, yPos
    mov cl, bh
    cmp al, cl
    jl setCoinFromAbove
    jg setCoinFromBelow
    jmp setCoinFromSide

setCoinFromAbove:
    mov collisionFromAbove, 1
    jmp eraseCoin_Dir

setCoinFromBelow:
    mov collisionFromBelow, 1
    jmp eraseCoin_Dir

setCoinFromSide:
    mov al, xPos
    mov cl, bl
    cmp al, cl
    jl setCoinFromLeft
    mov collisionFromRight, 1
    jmp eraseCoin_Dir

setCoinFromLeft:
    mov collisionFromLeft, 1

eraseCoin_Dir:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    mov dl, coinX[esi]
    mov dh, coinY[esi]
    
    call IsPlatformAtPosition
    cmp al, 1
    je skipCoinErase_Dir
    
    call PlayCoinSound
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    call Gotoxy
    mov al, ' '
    call WriteChar
    jmp afterCoinErase_Dir

skipCoinErase_Dir:
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    call Gotoxy
    mov al, '#'
    call WriteChar

afterCoinErase_Dir:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    
    push eax
    mov eax, score
    add eax, coinValue
    mov score, eax
    pop eax
    
    inc coinsCollected
    jmp coinCollectionDone

nextCoin_Check:
    inc esi
    movzx eax, numCoins
    cmp esi, eax
    jl coinCheckLoop

coinCollectionDone:
    popa
    ret
CheckCoinCollection ENDP

IsPlatformAtPosition PROC
    push ecx
    push esi
    push ebx
    push edx
    
    mov ecx, 0
    mov esi, 0
    
checkPlatPos:
    mov al, dh
    mov bl, platform1y[esi]
    cmp al, bl
    jne nextPlatPos
    
    mov al, dl
    mov bl, platform1x[esi]
    cmp al, bl
    jl nextPlatPos
    
    mov bl, platform1x[esi]
    add bl, platformWidths[esi]
    cmp al, bl
    jge nextPlatPos
    
    pop edx
    pop ebx
    pop esi
    pop ecx
    mov al, 1
    ret

nextPlatPos:
    inc esi
    inc ecx
    movzx eax, numPlatforms
    cmp ecx, eax
    jl checkPlatPos
    
    pop edx
    pop ebx
    pop esi
    pop ecx
    mov al, 0
    ret
IsPlatformAtPosition ENDP


IsPipeAtPosition PROC
    push ecx
    push esi
    push ebx
    
    mov ecx, 0
    mov esi, 0
    
checkPipePos:
    movzx eax, numPipes
    cmp ecx, eax
    jge noPipeAtPosition
    
    ; Check X position
    mov al, pipeX[esi]
    cmp dl, al
    jne nextPipe
    
    ;  More precise Y position check
    mov al, pipeY[esi]      ; Top of pipe
    cmp dh, al
    jl nextPipe             ; Above pipe
    
    mov bl, pipeY[esi]
    add bl, pipeHeight[esi] ; Calculate bottom
    dec bl                  ; Adjust for inclusive range
    cmp dh, bl
    jg nextPipe             ; Below pipe
    
    ; Position is inside pipe
    mov al, 1
    jmp pipeCheckDone

nextPipe:
    inc esi
    inc ecx
    jmp checkPipePos
    
noPipeAtPosition:
    mov al, 0

pipeCheckDone:
    pop ebx
    pop esi
    pop ecx
    ret
IsPipeAtPosition ENDP


; get pipe top y position
GetPipeTopY PROC
    push ecx
    push esi
    push ebx
    push edx
    
    mov esi, 0
    mov al, GROUND_Y        ; Default to ground
    
findPipeTopLoop:
    movzx eax, numPipes
    cmp esi, eax
    jge pipeTopFound
    
    ; Check if X matches
    mov bl, pipeX[esi]
    cmp dl, bl
    jne nextPipeTop
    
    ;  Return the actual pipe top Y
    mov al, pipeY[esi]      ; Get pipe top Y
    jmp pipeTopFound

nextPipeTop:
    inc esi
    jmp findPipeTopLoop
    
pipeTopFound:
    pop edx
    pop ebx
    pop esi
    pop ecx
    ret
GetPipeTopY ENDP

CheckStillOnSurface PROC
    cmp inAir, 1
    je stillOnSomething
    
    mov al, yPos
    cmp al, GROUND_Y
    je stillOnSomething
    
    call CheckPlatformCollision
    cmp al, 1
    je stillOnSomething
    
    push edx
    mov dl, xPos
    mov dh, yPos
    inc dh          
    call IsBrickAtPosition
    pop edx
    cmp al, 1
    je stillOnSomething
    
    ; If none of the above, start falling
    mov inAir, 1
    mov al, maxJumpHeight
    mov jumpHeight, al
    
stillOnSomething:
    ret
CheckStillOnSurface ENDP

CheckPlatformCollision PROC
    push ecx
    push esi
    
    mov ecx, 0
    mov esi, 0
    
checkLoop:
    mov al, yPos
    mov bl, platform1y[esi]
    dec bl
    
    cmp al, bl
    jl notThisPlatform
    
    inc bl
    cmp al, bl
    jg notThisPlatform
    
    mov al, xPos
    mov bl, platform1x[esi]
    cmp al, bl
    jl notThisPlatform
    
    mov bl, platform1x[esi]
    add bl, platformWidths[esi]
    cmp al, bl
    jge notThisPlatform
    
    mov bl, platform1y[esi]
    mov al, 1
    pop esi
    pop ecx
    ret

notThisPlatform:
    inc esi
    inc ecx
    movzx eax, numPlatforms
    cmp ecx, eax
    jl checkLoop
    
    mov al, 0
    pop esi
    pop ecx
    ret
CheckPlatformCollision ENDP

DrawPlayer PROC
    pusha
    
    cmp isSuperMario, 1
    jne checkNormalInvincibility
    cmp superMarioInvincible, 1
    je superMarioInvincibleColor
    
checkNormalInvincibility:
    cmp isInvincible, 1
    jne checkFireMarioColor
    
    mov eax, invincibilityTimer
    shr eax, 7                      ; Divide by 128 for flicker speed
    and eax, 1                      ; Check if even or odd
    cmp eax, 0
    je showInvincibleFlash          ; Even frame = show red flash
    jmp checkFireMarioColor         ; Odd frame = show normal color

showInvincibleFlash:
    mov eax, white + (lightRed * 16)    ; White on red background
    jmp drawPlayerChar

superMarioInvincibleColor:
    mov eax, yellow + (lightMagenta * 16)    ; gold/rainbow effect
    jmp drawPlayerChar

checkFireMarioColor:
    ; Check if Fire Mario (white on red)
    cmp isFireMario, 1
    je fireColor
    
    ; Check if Super Mario (cyan)
    cmp isSuperMario, 1
    je superColor
    
    ; Normal Mario (green)
    mov eax, lightGreen + (black * 16)
    jmp drawPlayerChar

superColor:
    mov eax, lightCyan + (black * 16)
    jmp drawPlayerChar

fireColor:
    mov eax, white + (red * 16)

drawPlayerChar:
    call SetTextColor
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, "X"
    call WriteChar
    
    popa
    ret
DrawPlayer ENDP


UpdatePlayer PROC
    pusha
    
    call IsPlayerOnPlatformCell
    cmp al, 1
    je skipErase
    
    call IsPlayerOnCoinCell
    cmp al, 1
    je skipErase
    
    call IsPlayerOnTurboStarCell
    cmp al, 1
    je skipErase
    

    call IsPlayerOnEnemyCell
    cmp al, 1
    je skipErase

    call IsPlayerOnFlyingEnemyCell      
    cmp al, 1                           
    je skipErase  
    
    call IsPlayerOnPipeCell    
    cmp al, 1                  
    je skipErase                

    cmp isUnderground,1 
    jne bluecolor

    blackcolor:
    mov eax, white + (Black * 16)
    call SetTextColor
    mov dl, xPos
    mov dh, yPos
    call Gotoxy  
    mov al, " "
    call WriteChar
    jmp skipErase

    bluecolor:
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, " "
    call WriteChar

skipErase:
    popa
    ret
UpdatePlayer ENDP

IsPlayerOnPlatformCell PROC
    push ecx
    push esi
    push ebx
    
    mov ecx, 0
    mov esi, 0
    
checkPlatformCell:
    mov al, yPos
    mov bl, platform1y[esi]
    cmp al, bl
    jne nextPlatformCell
    
    mov al, xPos
    mov bl, platform1x[esi]
    cmp al, bl
    jl nextPlatformCell
    
    mov bl, platform1x[esi]
    add bl, platformWidths[esi]
    cmp al, bl
    jge nextPlatformCell
    
    mov al, 1
    pop ebx
    pop esi
    pop ecx
    ret

nextPlatformCell:
    inc esi
    inc ecx
    movzx eax, numPlatforms
    cmp ecx, eax
    jl checkPlatformCell
    
    mov al, 0
    pop ebx
    pop esi
    pop ecx
    ret
IsPlayerOnPlatformCell ENDP

IsPlayerOnCoinCell PROC
    push ecx
    push esi
    push ebx
    
    mov ecx, 0
    mov esi, 0
    
checkCoinCell:
    cmp coinCollected[esi], 1
    je nextCoinCell
    
    mov al, yPos
    mov bl, coinY[esi]
    cmp al, bl
    jne nextCoinCell
    
    mov al, xPos
    mov bl, coinX[esi]
    cmp al, bl
    jne nextCoinCell
    
    mov al, 1
    pop ebx
    pop esi
    pop ecx
    ret

nextCoinCell:
    inc esi
    inc ecx
    movzx eax, numCoins
    cmp ecx, eax
    jl checkCoinCell
    
    mov al, 0
    pop ebx
    pop esi
    pop ecx
    ret
IsPlayerOnCoinCell ENDP

IsPlayerOnTurboStarCell PROC
    push ecx
    push esi
    push ebx
    
    mov ecx, 0
    mov esi, 0
    
checkStarCell:
    cmp turboStarCollected[esi], 1
    je nextStarCell
    
    mov al, yPos
    mov bl, turboStarY[esi]
    cmp al, bl
    jne nextStarCell
    
    mov al, xPos
    mov bl, turboStarX[esi]
    cmp al, bl
    jne nextStarCell
    
    mov al, 1
    pop ebx
    pop esi
    pop ecx
    ret

nextStarCell:
    inc esi
    inc ecx
    movzx eax, numTurboStars
    cmp ecx, eax
    jl checkStarCell
    
    mov al, 0
    pop ebx
    pop esi
    pop ecx
    ret
IsPlayerOnTurboStarCell ENDP

IsPlayerOnEnemyCell PROC
    push ecx
    push esi
    push ebx
    
    mov ecx, 0
    mov esi, 0
    
checkEnemyCell:
    cmp enemyAlive[esi], 0
    je nextEnemyCell
    
    mov al, yPos
    mov bl, enemyY[esi]
    cmp al, bl
    jne nextEnemyCell
    
    mov al, xPos
    mov bl, enemyX[esi]
    cmp al, bl
    jne nextEnemyCell
    
    mov al, 1
    pop ebx
    pop esi
    pop ecx
    ret

nextEnemyCell:
    inc esi
    inc ecx
    movzx eax, numEnemies
    cmp ecx, eax
    jl checkEnemyCell
    
    mov al, 0
    pop ebx
    pop esi
    pop ecx
    ret
IsPlayerOnEnemyCell ENDP


;  check if player is on pipe cell
IsPlayerOnPipeCell PROC
    push ecx
    push esi
    push ebx
    
    mov ecx, 0
    mov esi, 0
    
checkPipeCell:
    movzx eax, numPipes
    cmp esi, eax
    jge noPipeCell
    
    ; Check if player position matches pipe
    mov al, yPos
    mov bl, pipeY[esi]
    cmp al, bl
    jl nextPipeCell
    
    mov bl, pipeY[esi]
    add bl, pipeHeight[esi]
    dec bl
    cmp al, bl
    jg nextPipeCell
    
    mov al, xPos
    mov bl, pipeX[esi]
    cmp al, bl
    jne nextPipeCell
    
    ; Player is on pipe cell
    mov al, 1
    pop ebx
    pop esi
    pop ecx
    ret

nextPipeCell:
    inc esi
    inc ecx
    jmp checkPipeCell
    
noPipeCell:
    mov al, 0
    pop ebx
    pop esi
    pop ecx
    ret
IsPlayerOnPipeCell ENDP


CheckPitCollision PROC
    pusha
    ; Check if player is on ground level
    mov al, yPos
    cmp al, GROUND_Y
    jne noPitCollision      ; Not on ground no pit check
    
    ; Check if position below player (ground) is a space
    mov al, currentLevel
    cmp al, 1
    je checkLevel1Pit
    cmp al, 2  
    je checkLevel2Pit
    cmp al, 3
    je checkLevel3Pit
    jmp noPitCollision

checkLevel1Pit:
    mov esi, OFFSET level1
    jmp findGroundLine

checkLevel2Pit:
    mov esi, OFFSET level2
    jmp findGroundLine

checkLevel3Pit:
    mov esi, OFFSET level3
    
findGroundLine:
    ; Skip to last line (ground line)
    mov ecx, 28             ; Skip 28 lines to reach ground
skipLines:
    cmp ecx, 0
    je checkGroundChar
    
skipToNextLine:
    mov al, [esi]
    inc esi
    cmp al, 10              ; Line feed
    je lineSkipped
    cmp al, 0
    je noPitCollision
    jmp skipToNextLine
    
lineSkipped:
    dec ecx
    jmp skipLines

checkGroundChar:
    ; Now at ground line, check character at player's X position
    movzx eax, xPos
    add esi, eax            ; Move to player's X position
    mov al, [esi]           ; Get character at ground position
    
    cmp al, ' '             ; Is it a space (pit)
    je playerFellInPit
    jmp noPitCollision

playerFellInPit:
    ; Player fell in pit!
    call PlayerPitDeath
    
noPitCollision:
    popa
    ret
CheckPitCollision ENDP


; handle player pit death
PlayerPitDeath PROC
    pusha
    
    call PlayGameOverSound
    ; Decrease life
    dec playerLives
    mov enemyComboCount, 0
    mov coinsCollected, 0
    ; Show death message
    push eax
    push edx
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dl, 30
    mov dh, 2
    call Gotoxy
    mov edx, OFFSET pitDeathMsg
    call WriteString
    pop edx
    pop eax
    
    ; Brief pause to show message
    mov eax, 1500
    call Delay
    
    ; Check if game over
    cmp playerLives, 0
    jle pitGameOver
    
    ; Reset level (like startLevel but without decrementing lives)
    mov xPos, 10
    mov yPos, 27
    mov inAir, 0
    mov turboActive, 0
    mov turboTimer, 0
    mov isInvincible, 0
    mov invincibilityTimer, 0
    
    ; Reload level  
    call LoadLevelData
    call Clrscr
    call DrawLevel
    call DrawTurboStars
    call RedrawEnemies
    call DrawPlayer
    
    jmp pitDeathDone

pitGameOver:
    ; Will be handled by main game loop
    
pitDeathDone:
    popa
    ret
PlayerPitDeath ENDP


; draw mushrooms
DrawMushrooms PROC
    pusha
    mov esi, 0
    
drawMushroomLoop:
    movzx eax, numMushrooms
    cmp esi, eax
    jge drawMushroomsDone
    
    cmp mushroomCollected[esi], 1
    je skipDrawMushroom
    
    mov eax, lightRed + (lightBlue * 16)
    call SetTextColor
    mov dl, mushroomX[esi]
    mov dh, mushroomY[esi]
    call Gotoxy
    mov al, 'M'
    call WriteChar

skipDrawMushroom:
    inc esi
    jmp drawMushroomLoop

drawMushroomsDone:
    popa
    ret
DrawMushrooms ENDP

; draw fire flowers
DrawFireFlowers PROC
    pusha
    mov esi, 0
    
drawFireFlowerLoop:
    movzx eax, numFireFlowers
    cmp esi, eax
    jge drawFireFlowersDone
    
    cmp fireFlowerCollected[esi], 1
    je skipDrawFireFlower
    
    mov eax, yellow + (red * 16)
    call SetTextColor
    mov dl, fireFlowerX[esi]
    mov dh, fireFlowerY[esi]
    call Gotoxy
    mov al, 'W'
    call WriteChar

skipDrawFireFlower:
    inc esi
    jmp drawFireFlowerLoop

drawFireFlowersDone:
    popa
    ret
DrawFireFlowers ENDP


; check mushroom collection (become super mario)

CheckMushroomCollection PROC
    pusha
    mov esi, 0
    
mushroomCheckLoop:
    movzx eax, numMushrooms
    cmp esi, eax
    jge mushroomCheckDone
    
    cmp mushroomCollected[esi], 1
    je nextMushroomCheck
    
    ; Check X collision
    mov al, xPos
    mov bl, mushroomX[esi]
    cmp al, bl
    jl checkMushroomRight
    sub al, bl
    cmp al, 2
    ja nextMushroomCheck
    jmp checkMushroomY

checkMushroomRight:
    sub bl, al
    cmp bl, 2
    ja nextMushroomCheck

checkMushroomY:
    mov al, yPos
    mov bl, mushroomY[esi]
    cmp al, bl
    jne nextMushroomCheck
    
    ; COLLECTED MUSHROOM!  
    mov mushroomCollected[esi], 1
    call PlayMarioPowerUpSound
    mov isSuperMario, 1
    mov superMarioInvincible, 1          
    
    ; Erase mushroom
    push eax
    push edx
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, mushroomX[esi]
    mov dh, mushroomY[esi]
    call Gotoxy
    mov al, ' '
    call WriteChar
    pop edx
    pop eax
    
    ; Add points
    push eax
    mov eax, score
    add eax, 100
    mov score, eax
    pop eax
    
    ; Show message
    push eax
    push edx
    mov eax, lightGreen + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET superMushroomMsg
    call WriteString
    pop edx
    pop eax
    
    jmp mushroomCheckDone

nextMushroomCheck:
    inc esi
    jmp mushroomCheckLoop

mushroomCheckDone:
    popa
    ret
CheckMushroomCollection ENDP

; check fire flower collection (become fire mario)
CheckFireFlowerCollection PROC
    pusha
    mov esi, 0
    
fireFlowerCheckLoop:
    movzx eax, numFireFlowers
    cmp esi, eax
    jge fireFlowerCheckDone
    
    cmp fireFlowerCollected[esi], 1
    je nextFireFlowerCheck
    
    ; Check X collision
    mov al, xPos
    mov bl, fireFlowerX[esi]
    cmp al, bl
    jl checkFlowerRight
    sub al, bl
    cmp al, 2
    ja nextFireFlowerCheck
    jmp checkFlowerY

checkFlowerRight:
    sub bl, al
    cmp bl, 2
    ja nextFireFlowerCheck

checkFlowerY:
    mov al, yPos
    mov bl, fireFlowerY[esi]
    cmp al, bl
    jne nextFireFlowerCheck
    
    ; Check if already Super Mario
    cmp isSuperMario, 0
    je needSuperMarioFirst
    
    ; COLLECTED FIRE FLOWER!
    mov fireFlowerCollected[esi], 1
    mov isFireMario, 1
    
    ; Erase fire flower
    push eax
    push edx
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, fireFlowerX[esi]
    mov dh, fireFlowerY[esi]
    call Gotoxy
    mov al, ' '
    call WriteChar
    pop edx
    pop eax
    
    ; Add points
    push eax
    mov eax, score
    add eax, 200
    mov score, eax
    pop eax
    
    ; Show message
    push eax
    push edx
    mov eax, lightRed + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET fireFlowerMsg
    call WriteString
    pop edx
    pop eax
    
    jmp fireFlowerCheckDone

needSuperMarioFirst:
    push eax
    push edx
    mov eax, yellow + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET needSuperMarioMsg
    call WriteString
    pop edx
    pop eax

nextFireFlowerCheck:
    inc esi
    jmp fireFlowerCheckLoop

fireFlowerCheckDone:
    popa
    ret
CheckFireFlowerCollection ENDP

; update fireballs straight path 
UpdateFireballs PROC
    pusha
    mov esi, 0
    
updateFireballLoop:
    cmp esi, MAX_FIREBALLS
    jge updateFireballsDone
    
    cmp fireballActive[esi], 0
    je nextFireballUpdate
    
    ; Erase fireball at current position
    push esi
    call EraseFireball
    pop esi
    
    ; Move fireball horizontally (STRAIGHT LINE)
    mov al, fireballDirection[esi]
    cmp al, 0
    je moveFireballLeft

moveFireballRight:
    mov al, fireballX[esi]
    add al, fireballSpeed
    cmp al, MAX_X
    jge deactivateFireball
    mov fireballX[esi], al
    jmp checkFireballCollisions1

moveFireballLeft:
    mov al, fireballX[esi]
    sub al, fireballSpeed
    cmp al, MIN_X
    jle deactivateFireball
    mov fireballX[esi], al
    jmp checkFireballCollisions1

deactivateFireball:
    mov fireballActive[esi], 0
    dec numActiveFireballs
    jmp nextFireballUpdate

checkFireballCollisions1:
    ; Check collision with pipes
    push esi
    mov dl, fireballX[esi]
    mov dh, fireballY[esi]
    call IsPipeAtPosition
    pop esi
    cmp al, 1
    je deactivateFireball
    
    ; Check collision with platforms
    push esi
    mov dl, fireballX[esi]
    mov dh, fireballY[esi]
    call IsPlatformAtPosition
    pop esi
    cmp al, 1
    je deactivateFireball
    
    ; Check collision with enemies
    push esi
    call CheckFireballVsEnemies
    pop esi
    
    ; Check collision with flying enemies
    push esi
    call CheckFireballVsFlyingEnemies
    pop esi
    
    ; Check collision with koopas
    push esi
    call CheckFireballVsKoopas
    pop esi
    
    ; Check if fireball is still active
    cmp fireballActive[esi], 0
    je nextFireballUpdate
    
    ; Draw fireball at new position
    push esi
    call DrawFireball
    pop esi

nextFireballUpdate:
    inc esi
    jmp updateFireballLoop

updateFireballsDone:
    popa
    ret
UpdateFireballs ENDP


; draw fireball
DrawFireball PROC
    pusha
    
    mov eax, lightRed + (yellow * 16)
    call SetTextColor
    mov dl, fireballX[esi]
    mov dh, fireballY[esi]
    call Gotoxy
    mov al, 'o'
    call WriteChar
    
    popa
    ret
DrawFireball ENDP

; erase fireball
EraseFireball PROC
    pusha
    
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, fireballX[esi]
    mov dh, fireballY[esi]
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    popa
    ret
EraseFireball ENDP


; redraw all fireballs
RedrawFireballs PROC
    pusha
    mov esi, 0
    
redrawFireballLoop:
    cmp esi, MAX_FIREBALLS
    jge redrawFireballsDone
    
    cmp fireballActive[esi], 0
    je skipRedrawFireball
    
    call DrawFireball

skipRedrawFireball:
    inc esi
    jmp redrawFireballLoop

redrawFireballsDone:
    popa
    ret
RedrawFireballs ENDP


; check fireball vs goombas instant kill
CheckFireballVsEnemies PROC
    pusha
    
    mov edi, 0
    
fireballVsEnemyLoop:
    movzx eax, numEnemies
    cmp edi, eax
    jge fireballVsEnemyDone
    
    cmp enemyAlive[edi], 0
    je nextFireballEnemy
    
    ; Check X collision
    mov al, fireballX[esi]
    mov bl, enemyX[edi]
    cmp al, bl
    jl checkFBEnemyLeft
    sub al, bl
    cmp al, 2
    ja nextFireballEnemy
    jmp checkFBEnemyY

checkFBEnemyLeft:
    sub bl, al
    cmp bl, 2
    ja nextFireballEnemy

checkFBEnemyY:
    mov al, fireballY[esi]
    mov bl, enemyY[edi]
    cmp al, bl
    jne nextFireballEnemy
    
    ; FIREBALL HIT GOOMBA!
    mov enemyAlive[edi], 0
    call PlayEnemyDeadSound
    call UpdateCombo 

    push esi
    mov esi, edi
    call EraseEnemy
    pop esi
    
    mov fireballActive[esi], 0
    dec numActiveFireballs
    
    push eax
    mov eax, score
    add eax, 100
    mov score, eax
    pop eax
    
    push eax
    push edx
    mov eax, lightGreen + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET fireballKillMsg
    call WriteString
    pop edx
    pop eax
    
    jmp fireballVsEnemyDone

nextFireballEnemy:
    inc edi
    jmp fireballVsEnemyLoop

fireballVsEnemyDone:
    popa
    ret
CheckFireballVsEnemies ENDP


; check fireball vs flying enemies
CheckFireballVsFlyingEnemies PROC
    pusha
    
    mov edi, 0
    
fireballVsFlyingLoop:
    movzx eax, numFlyingEnemies
    cmp edi, eax
    jge fireballVsFlyingDone
    
    cmp flyingEnemyAlive[edi], 0
    je nextFireballFlying
    
    ; Check X collision
    mov al, fireballX[esi]
    mov bl, flyingEnemyX[edi]
    cmp al, bl
    jl checkFBFlyingLeft
    sub al, bl
    cmp al, 2
    ja nextFireballFlying
    jmp checkFBFlyingY

checkFBFlyingLeft:
    sub bl, al
    cmp bl, 2
    ja nextFireballFlying

checkFBFlyingY:
    mov al, fireballY[esi]
    mov bl, flyingEnemyY[edi]
    cmp al, bl
    jl checkFBFlyingYBelow
    sub al, bl
    cmp al, 1
    ja nextFireballFlying
    jmp fireballHitFlying

checkFBFlyingYBelow:
    sub bl, al
    cmp bl, 1
    ja nextFireballFlying

fireballHitFlying:
    mov flyingEnemyAlive[edi], 0
    call UpdateCombo  

    push esi
    mov esi, edi
    call EraseFlyingEnemy
    pop esi
    
    mov fireballActive[esi], 0
    dec numActiveFireballs
    
    push eax
    mov eax, score
    add eax, 150
    mov score, eax
    pop eax
    
    push eax
    push edx
    mov eax, lightGreen + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET fireballKillMsg
    call WriteString
    pop edx
    pop eax
    
    jmp fireballVsFlyingDone

nextFireballFlying:
    inc edi
    jmp fireballVsFlyingLoop

fireballVsFlyingDone:
    popa
    ret
CheckFireballVsFlyingEnemies ENDP

; check fireball vs koopas (two-hit system)
CheckFireballVsKoopas PROC
    pusha
    
    mov edi, 0
    
fireballVsKoopaLoop:
    movzx eax, numKoopas
    cmp edi, eax
    jge fireballVsKoopaDone
    
    cmp koopaAlive[edi], 0
    je nextFireballKoopa
    
    ; Check X collision
    mov al, fireballX[esi]
    mov bl, koopaX[edi]
    cmp al, bl
    jl checkFBKoopaLeft
    sub al, bl
    cmp al, 2
    ja nextFireballKoopa
    jmp checkFBKoopaY

checkFBKoopaLeft:
    sub bl, al
    cmp bl, 2
    ja nextFireballKoopa

checkFBKoopaY:
    mov al, fireballY[esi]
    mov bl, koopaY[edi]
    cmp al, bl
    jne nextFireballKoopa
    
    ; FIREBALL HIT KOOPA! 
    mov al, koopaAlive[edi]
    cmp al, 1
    je fbHitWalkingKoopa
    cmp al, 2
    je fbHitStaticShell
    jmp nextFireballKoopa

fbHitWalkingKoopa:
    ; First hit: Convert to shell
    mov koopaAlive[edi], 2
    
    call UpdateCombo 
    push esi
    mov esi, edi
    call EraseKoopa
    call DrawKoopaShell
    pop esi
    
    mov fireballActive[esi], 0
    dec numActiveFireballs
    
    push eax
    mov eax, score
    add eax, 100
    mov score, eax
    pop eax
    
    push eax
    push edx
    mov eax, yellow + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET shellCreatedMsg
    call WriteString
    pop edx
    pop eax
    
    jmp fireballVsKoopaDone

fbHitStaticShell:
    call PlayShellKickSound 
    mov koopaAlive[edi], 0
    
    push esi
    mov esi, edi
    call EraseKoopa
    pop esi
    
    mov movingShellActive, 1
    mov al, koopaX[edi]
    mov movingShellX, al
    mov al, koopaY[edi]
    mov movingShellY, al
    
    mov fireballActive[esi], 0
    dec numActiveFireballs
    
    push eax
    mov eax, score
    add eax, 50
    mov score, eax
    pop eax
    
    push eax
    push edx
    mov eax, lightCyan + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET shellKickMsg
    call WriteString
    pop edx
    pop eax
    
    jmp fireballVsKoopaDone

nextFireballKoopa:
    inc edi
    jmp fireballVsKoopaLoop

fireballVsKoopaDone:
    popa
    ret
CheckFireballVsKoopas ENDP

; ui & menu procedures
WelcomeScreen PROC
    call Clrscr
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    
    mov dl, 20
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET welcomeTitle1
    call WriteString
    mov dl, 20
    mov dh, 11
    call Gotoxy
    mov edx, OFFSET welcomeTitle2
    call WriteString
    mov dl, 20
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET welcomeTitle3
    call WriteString
    mov dl, 20
    mov dh, 13
    call Gotoxy
    mov edx, OFFSET welcomeTitle4
    call WriteString
    mov dl, 20
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET welcomeTitle5
    call WriteString
    mov dl, 20
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET welcomeTitle6
    call WriteString
    
    mov dl, 20
    mov dh, 18
    mwrite "24i-0623 ALI BAZMI", 0
    call Crlf
    call WaitMsg
    ret
WelcomeScreen ENDP
    
MainMenu PROC
    mov inputChar, 0
    
menuLoop:
    call Clrscr
    mov eax, Yellow + (black * 16)
    call SetTextColor
    
    mov dl, 30
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET menuTitle
    call WriteString
    mov dl, 30
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET menuOption1
    call WriteString
    mov dl, 30
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET menuOption2
    call WriteString
    mov dl, 30
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET menuOption4
    call WriteString
    mov dl, 30
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET menuOption3      
    call WriteString
    mov dl, 30
    mov dh, 11
    call Gotoxy
    mov edx, OFFSET menuPrompt      
    call WriteString

    mov eax, 200
    call Delay

    call ReadKey
    mov inputChar, al
    
    cmp inputChar, '1'
    je menuDone
    cmp inputChar, '2'
    je showInstructions    
    cmp inputChar, '3'
    je showLeaderboard     
    cmp inputChar, '4'
    je menuDone
    jmp menuLoop

    showLeaderboard:
    call LoadLeaderboard
    call DisplayLeaderboard
    jmp menuLoop

menuDone:
    ret
            
showInstructions:
    call Clrscr
    mov eax, Yellow + (black * 16)
    call SetTextColor
    
    mov dl, 20
    mov dh, 3
    call Gotoxy
    mov edx, OFFSET instructTitle
    call WriteString
    
    mov dl, 10
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET instruct1
    call WriteString
    mov dl, 10
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET instruct2
    call WriteString
    mov dl, 10
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET instruct3
    call WriteString
    mov dl, 10
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET instruct4
    call WriteString
    mov dl, 10
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET instruct5
    call WriteString
    
    mov dl, 10
    mov dh, 11
    call Gotoxy
    mov edx, OFFSET instruct7
    call WriteString
    mov dl, 10
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET instruct8
    call WriteString
    mov dl, 10
    mov dh, 13
    call Gotoxy
    mov edx, OFFSET instruct9
    call WriteString
    mov dl, 10
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET instruct10
    call WriteString
    mov dl, 10
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET instruct11
    call WriteString
    mov dl, 10
    mov dh, 16
    call Gotoxy
    mov edx, OFFSET instruct12
    call WriteString
    
    mov dl, 10
    mov dh, 27
    call Gotoxy
    mov edx, OFFSET instructBack
    call WriteString
    
    call WaitMsg
    jmp menuLoop
MainMenu ENDP

inputname PROC
    call Clrscr

    mov edi, OFFSET playerName
    mov ecx, 30
    mov al, 0
    rep stosb

    mov edx, OFFSET inputNamePrompt
    call WriteString

    mov edx, OFFSET playerName
    mov ecx, 29
    call ReadString
    
    mov edi, OFFSET playerName
    add edi, eax
    mov BYTE PTR [edi], 0
    
    ret
inputname ENDP

InitSpeedRacerMode PROC
    pusha
    
    mov al, boostedGroundSpeed
    mov groundSpeed, al
    mov al, boostedAirSpeed
    mov airSpeed, al
    
    call Clrscr
    mov eax, lightBlue + (black * 16)
    call SetTextColor
    
    mov dl, 30
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET featureMsg
    call WriteString
    
    mov eax, 2000
    call Delay
    
    popa
    ret
InitSpeedRacerMode ENDP

CheckTurboStarCollection PROC
    pusha
    mov esi, 0
    
starCheckLoop:
    cmp turboStarCollected[esi], 1
    je nextStar_Check
    
    mov collisionFromAbove, 0
    mov collisionFromBelow, 0
    mov collisionFromLeft, 0
    mov collisionFromRight, 0
    
    mov bl, turboStarX[esi]
    mov bh, turboStarY[esi]
    
    mov al, xPos
    mov cl, bl
    sub cl, 2
    cmp al, cl
    jl nextStar_Check
    
    mov cl, bl
    add cl, 2
    cmp al, cl
    jg nextStar_Check
    
    mov al, yPos
    mov cl, bh
    sub cl, 2
    cmp al, cl
    jl nextStar_Check
    
    mov cl, bh
    add cl, 2
    cmp al, cl
    jg nextStar_Check
    
    call DetermineCollisionDirection
    
    mov al, xPos
    mov cl, bl
    cmp al, cl
    je checkVerticalStarCollision
    
    mov al, yPos
    mov cl, bh
    sub al, cl
    cmp al, 1
    jbe collectStar_Dir
    jmp nextStar_Check

checkVerticalStarCollision:
    mov al, yPos
    mov cl, bh
    sub al, cl
    cmp al, 2
    jbe collectStar_Dir
    jmp nextStar_Check

collectStar_Dir:
    mov turboStarCollected[esi], 1
    
    mov al, yPos
    mov cl, bh
    cmp al, cl
    jl setStarFromAbove
    jg setStarFromBelow
    jmp setStarFromSide

setStarFromAbove:
    mov collisionFromAbove, 1
    jmp eraseStar_Dir

setStarFromBelow:
    mov collisionFromBelow, 1
    jmp eraseStar_Dir

setStarFromSide:
    mov al, xPos
    mov cl, bl
    cmp al, cl
    jl setStarFromLeft
    mov collisionFromRight, 1
    jmp eraseStar_Dir

setStarFromLeft:
    mov collisionFromLeft, 1

eraseStar_Dir:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    mov dl, turboStarX[esi]
    mov dh, turboStarY[esi]
    
    call IsPlatformAtPosition
    cmp al, 1
    je skipStarErase_Dir
    
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    call Gotoxy
    mov al, ' '
    call WriteChar
    jmp afterStarErase_Dir

skipStarErase_Dir:
    mov eax, white + (black * 16)
    call SetTextColor
    call Gotoxy
    mov al, '#'
    call WriteChar

afterStarErase_Dir:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    
    mov turboActive, 1
    push eax
    mov eax, turboMaxTime
    mov turboTimer, eax
    pop eax
    
    push eax
    mov al, turboGroundSpeed
    mov groundSpeed, al
    mov al, turboAirSpeed
    mov airSpeed, al
    pop eax
    
    push eax
    push edx
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET turboMsg
    call WriteString
    pop edx
    pop eax
    
    jmp starCollectionDone

nextStar_Check:
    inc esi
    movzx eax, numTurboStars
    cmp esi, eax
    jl starCheckLoop

starCollectionDone:
    popa
    ret
CheckTurboStarCollection ENDP

DetermineCollisionDirection PROC
    push eax
    push ebx
    
    mov al, yPos
    mov bl, prevYPos
    cmp al, bl
    jl movingUp
    jg movingDown
    jmp checkHorizontal

movingUp:
    mov collisionFromBelow, 1
    jmp directionDone

movingDown:
    mov collisionFromAbove, 1
    jmp directionDone

checkHorizontal:
    
directionDone:
    pop ebx
    pop eax
    ret
DetermineCollisionDirection ENDP

UpdateTurboTimer PROC
    pusha
    
    cmp turboActive, 0
    je turboNotActive
    
    mov eax, turboTimer
    cmp eax, 50
    jl deactivateTurbo
    
    sub eax, 50
    mov turboTimer, eax
    jmp turboNotActive
    
deactivateTurbo:
    mov turboActive, 0
    mov turboTimer, 0
    
    mov al, boostedGroundSpeed
    mov groundSpeed, al
    mov al, boostedAirSpeed
    mov airSpeed, al

turboNotActive:
    popa
    ret
UpdateTurboTimer ENDP

DrawTurboStars PROC
    pusha
    mov ecx, 0
    mov esi, 0
    
drawTurboLoop:
    cmp turboStarCollected[esi], 1
    je skipTurboStar
    
    mov eax, lightBlue + (black * 16)
    call SetTextColor
    mov dl, turboStarX[esi]
    mov dh, turboStarY[esi]
    call Gotoxy
    mov al, '*'
    call WriteChar

skipTurboStar:
    inc esi
    inc ecx
    movzx eax, numTurboStars
    cmp ecx, eax
    jl drawTurboLoop
    
    popa
    ret
DrawTurboStars ENDP


; redraw procedures
RedrawPlatforms PROC
    pusha
    
    mov ecx, 0
    mov esi, 0
    
redrawPlatformLoop:
    mov dl, platform1x[esi]
    mov dh, platform1y[esi]
    
    mov eax, yellow + (lightBlue * 16)
    call SetTextColor
    
    push ecx
    movzx ecx, platformWidths[esi]
    mov bl, 0
    
drawPlatformChars:
    push edx
    add dl, bl
    call Gotoxy
    mov al, '#'
    call WriteChar
    pop edx
    inc bl
    cmp bl, cl
    jl drawPlatformChars
    
    pop ecx
    inc esi
    inc ecx
    movzx eax, numPlatforms
    cmp ecx, eax
    jl redrawPlatformLoop
    
    popa
    ret
RedrawPlatforms ENDP

RedrawCoins PROC
    pusha
    mov ecx, 0
    mov esi, 0
    
redrawCoinLoop:
    cmp coinCollected[esi], 1
    je skipRedrawCoin
    
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, coinX[esi]
    mov dh, coinY[esi]
    call Gotoxy
    mov al, 'O'
    call WriteChar

skipRedrawCoin:
    inc esi
    inc ecx
    movzx eax, numCoins
    cmp ecx, eax
    jl redrawCoinLoop
    
    popa
    ret
RedrawCoins ENDP

CheckMysteryBlockCollision PROC
    pusha
    mov esi, 0
    
mysteryBlockLoop:
    movzx eax, numMysteryBlocks
    cmp esi, eax
    jge noMysteryBlockCollision
    
    ; Check if block is already activated
    cmp mysteryBlockActivated[esi], 1
    je nextMysteryBlock
    
    mov bl, mysteryBlockX[esi]
    mov bh, mysteryBlockY[esi]
    
    ; Check collision bounds (?1 pixel)
    mov al, xPos
    mov cl, bl
    sub cl, 1
    cmp al, cl
    jl nextMysteryBlock
    add cl, 2
    cmp al, cl
    jg nextMysteryBlock
    
    ; Y collision check
    mov al, yPos
    mov cl, bh
    sub cl, 1
    cmp al, cl
    jl nextMysteryBlock
    add cl, 2
    cmp al, cl
    jg nextMysteryBlock
    
    ; ?? MYSTERY BLOCK HIT!
    call ActivateMysteryBlock
    jmp noMysteryBlockCollision

nextMysteryBlock:
    inc esi
    jmp mysteryBlockLoop

noMysteryBlockCollision:
    popa
    ret
CheckMysteryBlockCollision ENDP

ActivateMysteryBlock PROC
    pusha
    
    ; Mark block as activated
    mov mysteryBlockActivated[esi], 1
    
    ; Erase old ? block
    push esi
    call EraseMysteryBlock
    pop esi
    
    ; Draw new # platform
    push esi
    call DrawActivatedBlock
    pop esi
    

    call CreateMysteryBlockCoin    ; ESI still contains mystery block index
    
    ; Add bonus points
    push eax
    mov eax, score
    add eax, mysteryBlockValue
    mov score, eax
    pop eax
    
    ; Show activation message
    push eax
    push edx
    mov eax, Yellow + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET mysteryBlockMsg
    call WriteString
    pop edx
    pop eax
    
    popa
    ret
ActivateMysteryBlock ENDP

CreateMysteryBlockCoin PROC
    pusha
    
    ; get coordinates directly from mystery block data
    mov dl, mysteryBlockX[esi]  ; Get block X position
    mov dh, mysteryBlockY[esi]  ; Get block Y position  
    dec dh                      ; Move one position above block
    
    ; Find empty slot in coin array
    push esi                    ; Save mystery block index
    mov esi, 0
    
findEmptyCoinSlot:
    movzx eax, numCoins
    cmp esi, eax
    jge addNewCoin
    
    ; Check if this slot is collected
    cmp coinCollected[esi], 1
    je useThisSlot
    
    inc esi
    cmp esi, 20
    jl findEmptyCoinSlot
    jmp createCoinDone  ; Array full
    
useThisSlot:
    ; Reuse this slot
    mov coinX[esi], dl          ; DL = X position
    mov coinY[esi], dh          ; DH = Y position  
    mov coinCollected[esi], 0
    jmp drawNewCoin

addNewCoin:
    ; Add to end of array
    movzx eax, numCoins
    cmp eax, 20
    jge createCoinDone
    
    mov coinX[eax], dl          ; DL = X position
    mov coinY[eax], dh          ; DH = Y position
    mov coinCollected[eax], 0
    inc numCoins
    mov esi, eax                ; Set ESI to new coin index for drawing

drawNewCoin:
    ; Draw the new coin immediately
    push eax
    push edx
    mov eax, yellow + (black * 16)
    call SetTextColor
    call Gotoxy                 
    mov al, 'O'
    call WriteChar
    pop edx
    pop eax

createCoinDone:
    pop esi                     ; Restore mystery block index
    popa
    ret
CreateMysteryBlockCoin ENDP

DrawMysteryBlock PROC
    pusha
    
    ; Check if block is activated
    mov al, mysteryBlockActivated[esi]
    cmp al, 1
    je drawActivatedBlock
    
    ; Draw active mystery block (yellow ?)
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, mysteryBlockX[esi]
    mov dh, mysteryBlockY[esi]
    call Gotoxy
    mov al, '?'
    call WriteChar
    jmp drawMysteryDone

drawActivatedBlock:
    ; Draw empty block (white #)
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, mysteryBlockX[esi]
    mov dh, mysteryBlockY[esi]
    call Gotoxy
    mov al, '#'
    call WriteChar

drawMysteryDone:
    popa
    ret
DrawMysteryBlock ENDP

DrawActivatedBlock PROC
    pusha
    
    ; Draw platform block
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, mysteryBlockX[esi]
    mov dh, mysteryBlockY[esi]
    call Gotoxy
    mov al, '#'
    call WriteChar
    
    popa
    ret
DrawActivatedBlock ENDP

RedrawMysteryBlocks PROC
    pusha
    mov esi, 0
    
redrawMysteryLoop:
    movzx eax, numMysteryBlocks
    cmp esi, eax
    jge redrawMysteryDone
    
    call DrawMysteryBlock

    inc esi
    jmp redrawMysteryLoop

redrawMysteryDone:
    popa
    ret
RedrawMysteryBlocks ENDP

EraseMysteryBlock PROC
    pusha
    
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    mov dl, mysteryBlockX[esi]
    mov dh, mysteryBlockY[esi]
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    popa
    ret
EraseMysteryBlock ENDP

RedrawPipes PROC
    pusha
    
    mov ecx, 0
    mov esi, 0
    
redrawPipeLoop:
    movzx eax, numPipes
    cmp esi, eax
    jge redrawPipesDone
    
    ; Set pipe color (green)
    mov eax, lightGreen + (lightblue * 16)
    call SetTextColor
    
    ; Draw pipe from top to bottom
    mov dl, pipeX[esi]
    mov dh, pipeY[esi]      ; Start at top
    
    push ecx
    movzx ecx, pipeHeight[esi]
    
drawPipeSegments:
    call Gotoxy
    mov al, 'P'
    call WriteChar
    inc dh                  ; Move down one row
    loop drawPipeSegments
    
    pop ecx
    inc esi
    inc ecx
    jmp redrawPipeLoop
    
redrawPipesDone:
    popa
    ret
RedrawPipes ENDP

; file handling procedures
SaveToFile PROC
    pusha
    
    mov edx, OFFSET scorefile
    call OpenInputFile
    mov ebx, eax
    
    mov edi, OFFSET tempBuffer
    mov ecx, BUFFER_SIZE
    mov al, 0
    rep stosb
    
    mov existingSize, 0
    
    cmp ebx, INVALID_HANDLE_VALUE
    je createNewFile
    
    mov eax, ebx
    mov edx, OFFSET tempBuffer
    mov ecx, BUFFER_SIZE - 200
    call ReadFromFile
    mov existingSize, eax
    
    mov eax, ebx
    call CloseFile

createNewFile:
    mov edx, OFFSET scorefile
    call CreateOutputFile
    cmp eax, INVALID_HANDLE_VALUE
    je error_exit
    mov fileHandle, eax
    
    cmp existingSize, 0
    je writeNewEntry
    
    mov eax, fileHandle
    mov edx, OFFSET tempBuffer
    mov ecx, existingSize
    call WriteToFile

writeNewEntry:
    mov eax, fileHandle
    mov edx, OFFSET nameLabel
    mov ecx, 6
    call WriteToFile
    
    mov edx, OFFSET playerName
    call CalculateStringLength
    cmp ecx, 0
    je writeDefaultName
    
    mov eax, fileHandle
    mov edx, OFFSET playerName
    call WriteToFile
    jmp afterName

writeDefaultName:
    mov eax, fileHandle
    mov edx, OFFSET defaultName
    mov ecx, 7
    call WriteToFile

afterName:
    mov eax, fileHandle
    mov edx, OFFSET scoreLabel
    mov ecx, 10
    call WriteToFile
    
    mov eax, score
    call NumberToString
    mov eax, fileHandle
    mov edx, OFFSET numberBuffer
    call CalculateStringLength
    call WriteToFile
    
    mov eax, fileHandle
    mov edx, OFFSET levelLabel
    mov ecx, 10
    call WriteToFile
    
    cmp currentLevel, 3
    jle l1
    mov currentLevel, 3
    l1:
    movzx eax, currentLevel
    call NumberToString
    mov eax, fileHandle
    mov edx, OFFSET numberBuffer
    call CalculateStringLength
    call WriteToFile
    
    mov eax, fileHandle
    mov edx, OFFSET newline
    mov ecx, 2
    call WriteToFile
    
    mov eax, fileHandle
    call CloseFile

error_exit:
    popa
    ret
SaveToFile ENDP

CalculateStringLength PROC
    push eax
    push esi
    
    mov esi, edx
    mov ecx, 0
    
lengthLoop:
    mov al, [esi + ecx]
    cmp al, 0
    je lengthDone
    cmp al, 13
    je lengthDone
    cmp al, 10
    je lengthDone
    cmp al, ' '
    je checkIfReallyEnd
    inc ecx
    cmp ecx, 50
    jl lengthLoop
    jmp lengthDone

checkIfReallyEnd:
    push ecx
    mov eax, ecx
    
checkRestLoop:
    inc eax
    mov bl, [esi + eax]
    cmp bl, 0
    je reallyEnd
    cmp bl, ' '
    je checkRestLoop
    cmp eax, 30
    jl checkRestLoop
    
reallyEnd:
    pop ecx

lengthDone:
    pop esi
    pop eax
    ret
CalculateStringLength ENDP

NumberToString PROC
    pusha
    
    mov edi, OFFSET numberBuffer
    mov ecx, 20
    mov al, 0
    rep stosb
    
    popa
    pusha
    
    mov edi, OFFSET numberBuffer
    mov ebx, 10
    mov esi, 0
    
    cmp eax, 0
    jne convertLoop
    mov BYTE PTR [edi], '0'
    jmp convertDone
    
convertLoop:
    cmp eax, 0
    je reverseDigits
    
    mov edx, 0
    div ebx
    add dl, '0'
    push edx
    inc esi
    jmp convertLoop
    
reverseDigits:
    mov ecx, 0
    
storeLoop:
    cmp ecx, esi
    je convertDone
    pop edx
    mov [edi + ecx], dl
    inc ecx
    jmp storeLoop
    
convertDone:
    popa
    ret
NumberToString ENDP

;  savetoleaderboard proper append
SaveToLeaderboard PROC
    pusha
    
    ; Step 1: Read existing file content
    mov edx, OFFSET scorefile
    call OpenInputFile
    mov ebx, eax
    
    ; Clear temp buffer
    mov edi, OFFSET tempBuffer
    mov ecx, BUFFER_SIZE
    mov al, 0
    rep stosb
    
    mov existingSize, 0
    
    ; If file doesn't exist, skip reading
    cmp ebx, INVALID_HANDLE_VALUE
    je writeNewScore
    
    ; Read existing data
    mov eax, ebx
    mov edx, OFFSET tempBuffer
    mov ecx, BUFFER_SIZE - 200  ; Leave space for new entry
    call ReadFromFile
    mov existingSize, eax
    
    mov eax, ebx
    call CloseFile

writeNewScore:
    ; Step 2: Move to end of existing data
    mov edi, OFFSET tempBuffer
    add edi, existingSize
    
    ; Step 3: Manually format new entry at the end

    mov al, 'N'
    stosb
    mov al, 'a'
    stosb
    mov al, 'm'
    stosb
    mov al, 'e'
    stosb
    mov al, ':'
    stosb
    mov al, ' '
    stosb
    
    ; Add player name
    mov esi, OFFSET playerName
    call AppendPlayerName
    
    mov al, ' '
    stosb
    mov al, '|'
    stosb
    mov al, ' '
    stosb
    mov al, 'S'
    stosb
    mov al, 'c'
    stosb
    mov al, 'o'
    stosb
    mov al, 'r'
    stosb
    mov al, 'e'
    stosb
    mov al, ':'
    stosb
    mov al, ' '
    stosb
    
    ; Add score
    mov eax, score
    call AppendScore

    mov al, ' '
    stosb
    mov al, '|'
    stosb
    mov al, ' '
    stosb
    mov al, 'L'
    stosb
    mov al, 'e'
    stosb
    mov al, 'v'
    stosb
    mov al, 'e'
    stosb
    mov al, 'l'
    stosb
    mov al, ':'
    stosb
    mov al, ' '
    stosb
    
    ; Add level
    movzx eax, currentLevel
    cmp eax, 3
    jle validLevel
    mov eax, 3
validLevel:
    add al, '0'
    stosb
    

    mov al, 13
    stosb
    mov al, 10
    stosb
    
    ; Step 4: Calculate total size
    mov eax, edi
    sub eax, OFFSET tempBuffer
    
    ; Step 5: Write entire buffer back to file
    mov edx, OFFSET scorefile
    call CreateOutputFile
    cmp eax, INVALID_HANDLE_VALUE
    je saveError
    
    mov fileHandle, eax
    
    mov eax, fileHandle
    mov edx, OFFSET tempBuffer
    mov ecx, edi
    sub ecx, OFFSET tempBuffer  ; Calculate actual length
    call WriteToFile
    
    mov eax, fileHandle
    call CloseFile

saveError:
    popa
    ret
SaveToLeaderboard ENDP

; Appends player name 
AppendPlayerName PROC
    push eax
    push esi
    
appendNameLoop:
    mov al, [esi]
    cmp al, 0
    je appendNameDone
    cmp al, 13
    je appendNameDone
    cmp al, 10
    je appendNameDone
    stosb
    inc esi
    jmp appendNameLoop

appendNameDone:
    pop esi
    pop eax
    ret
AppendPlayerName ENDP

; append score as string

AppendScore PROC
    push eax
    push ebx
    push ecx
    push edx
    
    mov ebx, 10
    mov ecx, 0
    
    ; Handle zero case
    cmp eax, 0
    jne convertScoreLoop
    mov al, '0'
    stosb
    jmp scoreConvertDone
    
convertScoreLoop:
    cmp eax, 0
    je reverseScoreDigits
    
    mov edx, 0
    div ebx
    add dl, '0'
    push edx
    inc ecx
    jmp convertScoreLoop
    
reverseScoreDigits:
    cmp ecx, 0
    je scoreConvertDone
    pop eax
    stosb
    dec ecx
    jmp reverseScoreDigits
    
scoreConvertDone:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
AppendScore ENDP

;===============================================
; SIMPLIFIED: LoadLeaderboard PROCEDURE  
;===============================================
LoadLeaderboard PROC
    pusha
    
    ; Reset leaderboard data
    mov leaderboardCount, 0
    
    ; Clear arrays
    mov edi, OFFSET leaderboardNames
    mov ecx, 1500  ; 50 * 30
    mov al, 0
    rep stosb
    
    mov edi, OFFSET leaderboardScores
    mov ecx, 50
    mov eax, 0
    rep stosd
    
    ; Open leaderboard file using  Irvine32 function
    mov edx, OFFSET scorefile
    call OpenInputFile       ;  function name
    cmp eax, INVALID_HANDLE_VALUE
    je loadError
    
    mov fileHandle, eax
    
    ; Read entire file
    mov eax, fileHandle
    mov edx, OFFSET tempBuffer
    mov ecx, 3000           
    call ReadFromFile
    mov existingSize, eax
    
    mov eax, fileHandle
    call CloseFile
    
    ; Parse file contents (simplified)
    call ParseLeaderboardDataSimple

loadError:
    popa
    ret
LoadLeaderboard ENDP


; simplified: parse leaderboard data
ParseLeaderboardDataSimple PROC
    pusha
    
    mov esi, OFFSET tempBuffer
    mov edi, 0  ; Current entry index
    
simpleParseLoop:
    ; Check if we've processed all data
    mov eax, esi
    sub eax, OFFSET tempBuffer
    cmp eax, existingSize
    jge simpleParseDone
    
    ; Check for end of data
    cmp BYTE PTR [esi], 0
    je simpleParseDone
    
    ; Check for maximum entries
    cmp edi, 49
    jge simpleParseDone
    
    ; Look for "Name: " pattern
    call FindNamePattern
    cmp al, 1
    jne skipToNextLineSimple
    
    ; Parse name
    call ParseNameSimple
    
    ; Look for "Score: " pattern  
    call FindScorePattern
    cmp al, 1
    jne skipToNextLineSimple
    
    ; Parse score
    call ParseScoreSimple
    
    ; Look for "Level: " pattern
    call FindLevelPattern
    cmp al, 1
    jne incrementEntrySimple
    
    ; Parse level
    call ParseLevelSimple

incrementEntrySimple:
    inc edi
    inc leaderboardCount
    
    ; Skip to next line
    call SkipToNextLineSimple
    jmp simpleParseLoop

skipToNextLineSimple:
    call SkipToNextLineSimple
    jmp simpleParseLoop

simpleParseDone:
    ; Sort leaderboard by score (descending)
    call SortLeaderboardSimple
    
    popa
    ret
ParseLeaderboardDataSimple ENDP

; find name pattern
FindNamePattern PROC
    push ebx
    push ecx
    push edx
    
    ; Look for "Name: " in current line
findNameLoop:
    mov al, [esi]
    cmp al, 0
    je namePatternNotFound
    cmp al, 13
    je namePatternNotFound
    cmp al, 10
    je namePatternNotFound
    
    ; Check for "Name: " pattern
    mov eax, [esi]
    cmp eax, 'emaN'  ; "Name" in little-endian
    je checkNameColon
    
    inc esi
    jmp findNameLoop

checkNameColon:
    cmp BYTE PTR [esi+4], ':'
    jne continueNameSearch
    cmp BYTE PTR [esi+5], ' '
    jne continueNameSearch
    
    ; Found "Name: " pattern
    add esi, 6  ; Skip "Name: "
    mov al, 1
    jmp namePatternDone

continueNameSearch:
    inc esi
    jmp findNameLoop

namePatternNotFound:
    mov al, 0

namePatternDone:
    pop edx
    pop ecx
    pop ebx
    ret
FindNamePattern ENDP

; find score pattern
FindScorePattern PROC
    push ebx
    push ecx
    push edx
    
    ; Look for "Score: " in current line
findScoreLoop:
    mov al, [esi]
    cmp al, 0
    je scorePatternNotFound
    cmp al, 13
    je scorePatternNotFound
    cmp al, 10
    je scorePatternNotFound
    
    ; Check for "Score: " pattern
    mov eax, [esi]
    cmp eax, 'rocS'  ; "Scor" in little-endian
    je checkScoreColon
    
    inc esi
    jmp findScoreLoop

checkScoreColon:
    cmp BYTE PTR [esi+5], ':'
    jne continueScoreSearch
    cmp BYTE PTR [esi+6], ' '
    jne continueScoreSearch
    
    ; Found "Score: " pattern  
    add esi, 7  ; Skip "Score: "
    mov al, 1
    jmp scorePatternDone

continueScoreSearch:
    inc esi
    jmp findScoreLoop

scorePatternNotFound:
    mov al, 0

scorePatternDone:
    pop edx
    pop ecx
    pop ebx
    ret
FindScorePattern ENDP

; find level pattern
FindLevelPattern PROC
    push ebx
    push ecx
    push edx
    
    ; Look for "Level: " in current line
findLevelLoop:
    mov al, [esi]
    cmp al, 0
    je levelPatternNotFound
    cmp al, 13
    je levelPatternNotFound
    cmp al, 10
    je levelPatternNotFound
    
    ; Check for "Level: " pattern
    mov eax, [esi]
    cmp eax, 'eveL'  ; "Leve" in little-endian
    je checkLevelColon
    
    inc esi
    jmp findLevelLoop

checkLevelColon:
    cmp BYTE PTR [esi+4], 'l'
    jne continueLevelSearch
    cmp BYTE PTR [esi+5], ':'
    jne continueLevelSearch
    cmp BYTE PTR [esi+6], ' '
    jne continueLevelSearch
    
    ; Found "Level: " pattern
    add esi, 7  ; Skip "Level: "
    mov al, 1
    jmp levelPatternDone

continueLevelSearch:
    inc esi
    jmp findLevelLoop

levelPatternNotFound:
    mov al, 0

levelPatternDone:
    pop edx
    pop ecx
    pop ebx
    ret
FindLevelPattern ENDP

; Parse Name
ParseNameSimple PROC
    push eax
    push ebx
    push ecx
    push edx
    
    ; Calculate destination address
    mov eax, edi
    mov ebx, 30
    mul ebx
    add eax, OFFSET leaderboardNames
    mov edx, eax  ; EDX = destination
    
    mov ecx, 0
nameParseSimpleLoop:
    mov al, [esi]
    cmp al, '|'
    je nameParseSimpleEnd
    cmp al, 13
    je nameParseSimpleEnd
    cmp al, 10
    je nameParseSimpleEnd
    cmp al, 0
    je nameParseSimpleEnd
    cmp al, ' '
    je checkNameEnd
    cmp ecx, 28
    jge nameParseSimpleEnd
    
    mov [edx], al
    inc esi
    inc edx
    inc ecx
    jmp nameParseSimpleLoop

checkNameEnd:
    ; Check if next char is "|" (end of name)
    cmp BYTE PTR [esi+1], '|'
    je nameParseSimpleEnd
    ; Otherwise include the space
    mov [edx], al
    inc esi
    inc edx
    inc ecx
    jmp nameParseSimpleLoop

nameParseSimpleEnd:
    mov BYTE PTR [edx], 0  ; Null terminate
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
ParseNameSimple ENDP

; Parse Score
ParseScoreSimple PROC
    push eax
    push ebx
    push ecx
    push edx
    
    mov eax, 0  ; Accumulator
    mov ebx, 10 ; Base 10
    
scoreParseSimpleLoop:
    mov cl, [esi]
    cmp cl, '0'
    jb scoreParseSimpleEnd
    cmp cl, '9'
    ja scoreParseSimpleEnd
    
    ; Convert digit and add to accumulator
    sub cl, '0'
    mul ebx
    movzx edx, cl
    add eax, edx
    inc esi
    jmp scoreParseSimpleLoop

scoreParseSimpleEnd:
    ; Store score
    mov ebx, edi
    mov leaderboardScores[ebx*4], eax
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
ParseScoreSimple ENDP


; simplified: parse level
ParseLevelSimple PROC
    push eax
    push ebx
    
    mov al, [esi]
    cmp al, '0'
    jb levelParseSimpleEnd
    cmp al, '9'
    ja levelParseSimpleEnd
    
    sub al, '0'
    mov leaderboardLevels[edi], al
    inc esi

levelParseSimpleEnd:
    pop ebx
    pop eax
    ret
ParseLevelSimple ENDP

; skip to next line
SkipToNextLineSimple PROC
    push eax

skipLineSimpleLoop:
    mov al, [esi]
    cmp al, 0
    je skipLineSimpleDone
    inc esi
    cmp al, 10  ; Line feed
    je skipLineSimpleDone
    jmp skipLineSimpleLoop

skipLineSimpleDone:
    pop eax
    ret
SkipToNextLineSimple ENDP

; Sort Leaderboard (Bubble Sort)
SortLeaderboardSimple PROC
    pusha
    
    mov ecx, leaderboardCount
    cmp ecx, 2
    jl sortSimpleDone
    
    dec ecx
    
outerSimpleLoop:
    push ecx
    mov esi, 0
    mov edi, ecx
    
innerSimpleLoop:
    ; Compare scores[esi] with scores[esi+1]
    mov eax, leaderboardScores[esi*4]
    mov ebx, leaderboardScores[esi*4+4]
    cmp eax, ebx
    jge noSimpleSwap
    
    ; Swap needed
    call SwapLeaderboardEntriesSimple

noSimpleSwap:
    inc esi
    dec edi
    jnz innerSimpleLoop
    
    pop ecx
    loop outerSimpleLoop

sortSimpleDone:
    popa
    ret
SortLeaderboardSimple ENDP

; Swap Leaderboard Entries
SwapLeaderboardEntriesSimple PROC
    pusha
    
    ; Swap scores
    mov eax, leaderboardScores[esi*4]
    mov ebx, leaderboardScores[esi*4+4]
    mov leaderboardScores[esi*4], ebx
    mov leaderboardScores[esi*4+4], eax
    
    ; Swap levels
    mov al, leaderboardLevels[esi]
    mov bl, leaderboardLevels[esi+1]
    mov leaderboardLevels[esi], bl
    mov leaderboardLevels[esi+1], al
    
    ; Swap names (30 bytes each)
    mov ecx, 30
    push esi
    
    ; Calculate addresses
    mov eax, esi
    mov ebx, 30
    mul ebx
    add eax, OFFSET leaderboardNames
    mov edi, eax
    
    mov eax, esi
    inc eax
    mul ebx
    add eax, OFFSET leaderboardNames
    mov esi, eax
    
swapNameSimpleLoop:
    mov al, [edi]
    mov bl, [esi]
    mov [edi], bl
    mov [esi], al
    inc edi
    inc esi
    loop swapNameSimpleLoop
    
    pop esi
    popa
    ret
SwapLeaderboardEntriesSimple ENDP

; Display leaderboard
DisplayLeaderboard PROC
    pusha
    
    call Clrscr
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    ; Title
    mov dl, 25
    mov dh, 3
    call Gotoxy
    mov edx, OFFSET leaderboardTitle
    call WriteString
    
    ; Header
    mov dl, 10
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET leaderboardHeader
    call WriteString
    
    ; Separator
    mov dl, 10
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET leaderboardSeparator
    call WriteString
    
    ; Check if we have scores
    cmp leaderboardCount, 0
    je noScores
    
    ; Display top 5 entries
    mov esi, 0
    mov dh, 8
    
displayLoop:
    cmp esi, 5
    jge displayDone
    mov eax, leaderboardCount
    cmp esi, eax
    jge displayDone
    
    call DisplayLeaderboardEntry
    
    inc esi
    inc dh
    jmp displayLoop

displayDone:
    jmp showBackMessage

noScores:
    mov dl, 20
    mov dh, 10
    call Gotoxy
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov edx, OFFSET noScoresMsg
    call WriteString

showBackMessage:
    mov dl, 25
    mov dh, 20
    call Gotoxy
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov edx, OFFSET backToMenuMsg
    call WriteString
    
    call ReadChar
    
    popa
    ret
DisplayLeaderboard ENDP

; Display single leaderboard entry

DisplayLeaderboardEntry PROC
    pusha

    mov eax, lightGreen + (black * 16)
    call SetTextColor
    
    mov eax, esi          ; Copy index to EAX
    add al, 6             ; Row = 6 + index
    mov bl, al            ; SAVE row in BL for reuse
    
    mov dh, bl            ; Restore row
    mov dl, 10            ; X position = 10
    call Gotoxy
    
    mov eax, esi
    inc eax               ; Rank = Index + 1
    call WriteDec
    
    mov al, '.'           ; Print "."
    call WriteChar
    mov al, ' '           ; Print spacing
    call WriteChar

    mov dh, bl            ; ?? RESTORE row again
    mov dl, 15            ; X position = 15
    call Gotoxy
    
    mov eax, esi          ; Get index
    push ebx              ; Save BL
    mov ebx, 30           ; Name size = 30 bytes
    mul ebx               ; Offset = index ? 30
    add eax, OFFSET leaderboardNames
    mov edx, eax
    call WriteString
    pop ebx               ; Restore BL
    
    mov dh, bl            ; RESTORE row again
    mov dl, 42            ; X position = 35
    call Gotoxy
    
    mov eax, leaderboardScores[esi*4]  ; Get score (DWORD)
    call WriteDec

    mov dh, bl            ; ?? RESTORE row again
    mov dl, 50            ; X position = 45
    call Gotoxy
    
    movzx eax, leaderboardLevels[esi]  ; Get level (BYTE)
    call WriteDec
    
    popa
    ret
DisplayLeaderboardEntry ENDP

VictoryCelebration PROC
    pusha
    
    ; Clear screen with dark background
    call Clrscr
    
    ; Display ASCII art title
    call DisplayVictoryTitle
    
    ; Initialize fireworks
    call InitializeFireworks
    
    ; Draw static flagpole
    call DrawFlagpole
    
    ; Animate flag going up
    call AnimateFlag
    
    ; Trigger fireworks
    call AnimateFireworks
    
    ; Display stats
    call DisplayVictoryStats
    
    ; Wait for user
    mov dl, 30
    mov dh, 26
    call Gotoxy
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov edx, OFFSET continueVictoryMsg
    call WriteString
    
    call ReadChar
    
    popa
    ret
VictoryCelebration ENDP

DisplayVictoryTitle PROC
    pusha
    
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    
    ; Line 1
    mov dl, 5
    mov dh, 2
    call Gotoxy
    mov edx, OFFSET victoryMsg1
    call WriteString
    
    ; Line 2
    mov dl, 5
    mov dh, 3
    call Gotoxy
    mov edx, OFFSET victoryMsg2
    call WriteString
    
    ; Line 3
    mov dl, 5
    mov dh, 4
    call Gotoxy
    mov edx, OFFSET victoryMsg3
    call WriteString
    
    ; Line 4
    mov dl, 5
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET victoryMsg4
    call WriteString
    
    ; Line 5
    mov dl, 5
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET victoryMsg5
    call WriteString
    
    ; Line 6
    mov dl, 5
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET victoryMsg6
    call WriteString
    
    popa
    ret
DisplayVictoryTitle ENDP

DrawFlagpole PROC
    pusha
    
    call PlayflagpoleSound
    mov eax, white + (black * 16)
    call SetTextColor
    
    ; Draw vertical pole
    movzx ecx, flagpoleHeight
    movzx edx, flagpoleY
    mov dh, dl
    
drawPoleLoop:
    mov dl, flagpoleX
    call Gotoxy
    mov al, '|'
    call WriteChar
    inc dh
    loop drawPoleLoop
    
    ; Draw base
    mov dl, flagpoleX
    sub dl, 2
    call Gotoxy
    mov al, '='
    call WriteChar
    inc dl
    call Gotoxy
    call WriteChar
    inc dl
    call Gotoxy
    call WriteChar
    inc dl
    call Gotoxy
    call WriteChar
    inc dl
    call Gotoxy
    call WriteChar
    
    popa
    ret
DrawFlagpole ENDP

; Animate flag moving up
AnimateFlag PROC
    pusha
    
    ; Start flag at bottom
    mov al, flagpoleY
    add al, flagpoleHeight
    dec al
    mov flagCurrentY, al
    
animateFlagLoop:
    ; Erase old flag
    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, flagpoleX
    add dl, 1
    mov dh, flagCurrentY
    call Gotoxy
    mov al, ' '
    call WriteChar
    call Gotoxy
    call WriteChar
    
    ; Move flag up
    dec flagCurrentY
    
    ; Check if reached top
    mov al, flagCurrentY
    mov bl, flagpoleY
    cmp al, bl
    jl flagReachedTop
    
    ; Draw flag at new position
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dl, flagpoleX
    add dl, 1
    mov dh, flagCurrentY
    call Gotoxy
    mov al, '>'
    call WriteChar
    inc dl
    call Gotoxy
    mov al, '>'
    call WriteChar
    
    ; Delay
    mov eax, 150
    call Delay
    
    jmp animateFlagLoop

flagReachedTop:
    ; Draw final flag at top
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dl, flagpoleX
    add dl, 1
    mov dh, flagpoleY
    call Gotoxy
    mov al, '>'
    call WriteChar
    inc dl
    call Gotoxy
    mov al, '>'
    call WriteChar
    
    popa
    ret
AnimateFlag ENDP

; initialize fireworks

InitializeFireworks PROC
    pusha
    
    ; Set firework positions 
    mov fireworkX[0], 20
    mov fireworkY[0], 12
    
    mov fireworkX[1], 100
    mov fireworkY[1], 10
    
    mov fireworkX[2], 40
    mov fireworkY[2], 15
    
    mov fireworkX[3], 80
    mov fireworkY[3], 13
    
    mov fireworkX[4], 60
    mov fireworkY[4], 18
    
    ; Initialize stages
    mov esi, 0
initFireworkLoop:
    mov fireworkStage[esi], 0
    mov fireworkActive[esi], 1
    inc esi
    cmp esi, 5
    jl initFireworkLoop
    
    popa
    ret
InitializeFireworks ENDP

; animate all fireworks
AnimateFireworks PROC
    pusha
    
    mov ecx, 15  ; Total animation frames
    
animateFireworksLoop:
    push ecx
    
    ; Update each firework
    mov esi, 0
updateFireworkLoop:
    cmp fireworkActive[esi], 0
    je skipFirework
    
    call DrawSingleFirework
    
skipFirework:
    inc esi
    cmp esi, 5
    jl updateFireworkLoop
    
    ; Delay between frames
    mov eax, 200
    call Delay
    
    ; Advance stages
    mov esi, 0
advanceStageLoop:
    mov al, fireworkStage[esi]
    inc al
    cmp al, 5
    jl storeStage
    mov fireworkActive[esi], 0
    mov al, 0
storeStage:
    mov fireworkStage[esi], al
    inc esi
    cmp esi, 5
    jl advanceStageLoop
    
    pop ecx
    loop animateFireworksLoop
    
    popa
    ret
AnimateFireworks ENDP

; draw single firework
DrawSingleFirework PROC
    pusha
    
    mov al, fireworkStage[esi]
    
    cmp al, 0
    je drawStage0
    cmp al, 1
    je drawStage1
    cmp al, 2
    je drawStage2
    cmp al, 3
    je drawStage3
    cmp al, 4
    je drawStage4
    jmp fireworkDrawDone

drawStage0:
    ; Small burst
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, fireworkX[esi]
    mov dh, fireworkY[esi]
    call Gotoxy
    mov al, '*'
    call WriteChar
    jmp fireworkDrawDone

drawStage1:
    ; Medium burst
    mov eax, lightRed + (black * 16)
    call SetTextColor
    
    ; Center
    mov dl, fireworkX[esi]
    mov dh, fireworkY[esi]
    call Gotoxy
    mov al, '*'
    call WriteChar
    
    ; Cross pattern
    dec dl
    call Gotoxy
    call WriteChar
    add dl, 2
    call Gotoxy
    call WriteChar
    dec dl
    dec dh
    call Gotoxy
    call WriteChar
    add dh, 2
    call Gotoxy
    call WriteChar
    jmp fireworkDrawDone

drawStage2:
    ; Large burst
    mov eax, lightMagenta + (black * 16)
    call SetTextColor
    
    mov dl, fireworkX[esi]
    mov dh, fireworkY[esi]
    
    ; Draw larger pattern
    sub dl, 2
    sub dh, 1
    call Gotoxy
    mov al, '*'
    call WriteChar
    add dl, 1
    call Gotoxy
    call WriteChar
    add dl, 1
    call Gotoxy
    call WriteChar
    add dl, 1
    call Gotoxy
    call WriteChar
    add dl, 1
    call Gotoxy
    call WriteChar
    
    mov dl, fireworkX[esi]
    mov dh, fireworkY[esi]
    sub dl, 2
    call Gotoxy
    call WriteChar
    add dl, 4
    call Gotoxy
    call WriteChar
    
    mov dl, fireworkX[esi]
    mov dh, fireworkY[esi]
    sub dl, 2
    inc dh
    call Gotoxy
    call WriteChar
    add dl, 1
    call Gotoxy
    call WriteChar
    add dl, 1
    call Gotoxy
    call WriteChar
    add dl, 1
    call Gotoxy
    call WriteChar
    add dl, 1
    call Gotoxy
    call WriteChar
    jmp fireworkDrawDone

drawStage3:
    ; Fading
    mov eax, cyan + (black * 16)
    call SetTextColor
    
    mov dl, fireworkX[esi]
    mov dh, fireworkY[esi]
    sub dl, 1
    sub dh, 1
    call Gotoxy
    mov al, '.'
    call WriteChar
    add dl, 2
    call Gotoxy
    call WriteChar
    sub dl, 1
    add dh, 2
    call Gotoxy
    call WriteChar
    jmp fireworkDrawDone

drawStage4:
    ; Clear firework
    mov eax, black + (black * 16)
    call SetTextColor
    
    mov dl, fireworkX[esi]
    mov dh, fireworkY[esi]
    sub dl, 2
    sub dh, 1
    
    mov ecx, 3
clearFireworkLoop:
    push ecx
    mov ecx, 5
    push edx
clearRowLoop:
    call Gotoxy
    mov al, ' '
    call WriteChar
    inc dl
    loop clearRowLoop
    pop edx
    inc dh
    sub dl, 5
    pop ecx
    loop clearFireworkLoop

fireworkDrawDone:
    popa
    ret
DrawSingleFirework ENDP

; Display victory stats
DisplayVictoryStats PROC
    pusha
    
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    
    ; Display congratulations message
    mov dl, 35
    mov dh, 22
    call Gotoxy
    mov edx, OFFSET victoryStatsMsg
    call WriteString
    
    ; Display score
    mov dl, 45
    mov dh, 24
    call Gotoxy
    mov edx, OFFSET strScore
    call WriteString
    mov eax, score
    call WriteDec
    
    popa
    ret
DisplayVictoryStats ENDP

FillBackground PROC
    pusha
    
    cmp isUnderground, 1
    je setBlackBack
    
    mov eax, white + (lightBlue * 16)
    call SetTextColor
    jmp fillDone

setBlackBack:
    ; Underground Black
    mov eax, white + (black * 16)
    call SetTextColor

fillDone:
    mov dh, 0    
    popa
    ret
FillBackground ENDP

; initialize timer for current level
InitLevelTimer PROC
    pusha
    
    ; Reset timer counter
    mov timerCounter, 0
    
    ; Set timer based on current level
    mov al, currentLevel
    cmp al, 1
    je setLevel1Timer
    cmp al, 2
    je setLevel2Timer
    cmp al, 3
    je setLevel3Timer
    
    ; Default timer
    mov eax, 120
    jmp setTimerValue

setLevel1Timer:
    mov eax, level1Time
    jmp setTimerValue

setLevel2Timer:
    mov eax, level2Time
    jmp setTimerValue

setLevel3Timer:
    mov eax, level3Time

setTimerValue:
    mov levelTimer, eax
    mov levelTimerMax, eax
    
    popa
    ret
InitLevelTimer ENDP

; update timer called every game loop iteration
UpdateTimer PROC
    pusha
    
    ; Add elapsed time 50ms per game loop iteration
    mov eax, timerCounter
    add eax, 50                     ; Game loop delay is 50ms
    mov timerCounter, eax
    
    ; Check if 1 second has passed
    cmp eax, timerUpdateInterval
    jl timerUpdateDone
    
    ; Reset counter
    mov timerCounter, 0
    
    ; Decrement timer
    mov eax, levelTimer
    cmp eax, 0
    je timerUpdateDone              ; Already at zero
    
    dec eax
    mov levelTimer, eax
    
    ; Check for warning (10 seconds left)
    cmp eax, 10
    jg noTimerWarning
    cmp eax, 0
    je timerUpdateDone
    
    ; Show warning message (flashing)
    push eax
    push edx
    
    ; Only show on even seconds for flash effect
    and eax, 1
    cmp eax, 0
    jne skipWarningDisplay
    
    mov eax, lightRed + (lightBlue * 16)
    call SetTextColor
    mov dl, 80
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET timerWarningMsg
    call WriteString
    jmp warningDisplayDone

skipWarningDisplay:
    ; Clear warning area
    mov eax, lightBlue + (lightBlue * 16)
    call SetTextColor
    mov dl, 80
    mov dh, 0
    call Gotoxy
    mov ecx, 30
clearWarningLoop:
    mov al, ' '
    call WriteChar
    loop clearWarningLoop

warningDisplayDone:
    pop edx
    pop eax

noTimerWarning:
timerUpdateDone:
    popa
    ret
UpdateTimer ENDP

; check if timer has expired
CheckTimerExpired PROC
    mov eax, levelTimer
    cmp eax, 0
    je timerHasExpired
    
    mov al, 0                       ; Not expired
    ret

timerHasExpired:
    mov al, 1                       ; Expired! 
    ret
CheckTimerExpired ENDP

; handle timer expiration game over

HandleTimerExpired PROC
    pusha
    
    call Clrscr
    
    ; Display "TIME'S UP" message
    mov eax, lightRed + (black * 16)
    call SetTextColor
    
    mov dl, 35
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET timerExpiredMsg
    call WriteString
    
    ; Display final score
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    mov dl, 40
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET strScore
    call WriteString
    mov eax, score
    call WriteDec
    
    ; Display level reached
    mov dl, 40
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET strLevel
    call WriteString
    movzx eax, currentLevel
    call WriteDec
    
    ; Prompt to continue
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dl, 30
    mov dh, 18
    call Gotoxy
    mov edx, OFFSET pressKeyMsg
    call WriteString
    
    call ReadChar
    
    popa
    ret
HandleTimerExpired ENDP

DrawHUD PROC
    pusha
    
    cmp turboActive, 1
    je turboHUD
    
    mov eax, lightCyan + (lightBlue * 16)
    jmp drawHUDContent
    
turboHUD:
    mov eax, lightBlue + (lightBlue * 16)
    
drawHUDContent:
    call SetTextColor
    mov dl, 0
    mov dh, 0
    call Gotoxy
    
    mov edx, OFFSET strScore
    call WriteString
    mov eax, score
    call WriteDec
    
    mov edx, OFFSET strCoins
    call WriteString
    mov eax, coinsCollected
    call WriteDec
    mov al, '/'
    call WriteChar
    movzx eax, numCoins
    call WriteDec
    
    mov edx, OFFSET strLevel
    call WriteString
    movzx eax, currentLevel
    call WriteDec
    mov al, '/'
    call WriteChar
    movzx eax, maxLevels
    call WriteDec
    
    mov edx, OFFSET strLives
    call WriteString
    
    cmp playerLives, 1
    jle showLowLives
    mov eax, lightGreen + (lightBlue * 16)
    jmp displayLives

showLowLives:
    mov eax, lightRed + (lightBlue * 16)

displayLives:
    call SetTextColor
    movzx eax, playerLives
    call WriteDec
   
    mov edx, OFFSET strTime
    
    ; Set timer color based on time remaining
    mov eax, levelTimer
    cmp eax, 10
    jle timerCritical
    cmp eax, 30
    jle timerWarning_HUD
    
    ; Normal timer color (green)
    mov eax, lightGreen + (lightBlue * 16)
    jmp displayTimerValue

timerWarning_HUD:
    ; Warning timer color (yellow)
    mov eax, yellow + (lightBlue * 16)
    jmp displayTimerValue

timerCritical:
    ; Critical timer color (red, flashing)
    mov eax, levelTimer
    and eax, 1
    cmp eax, 0
    je timerFlashRed
    mov eax, yellow + (lightBlue * 16)
    jmp displayTimerValue

timerFlashRed:
    mov eax, lightRed + (lightBlue * 16)

displayTimerValue:
    call SetTextColor
    
    ; Display "TIME: "
    mov eax, lightCyan + (lightBlue * 16)
    call SetTextColor
    mov edx, OFFSET strTime
    call WriteString
    
    ; Display timer value with color
    mov eax, levelTimer
    cmp eax, 10
    jle timerColorRed
    cmp eax, 30
    jle timerColorYellow
    
    mov eax, lightGreen + (lightBlue * 16)
    jmp showTimerNumber

timerColorYellow:
    mov eax, yellow + (lightBlue * 16)
    jmp showTimerNumber

timerColorRed:
    mov eax, lightRed + (lightBlue * 16)

showTimerNumber:
    call SetTextColor
    mov eax, levelTimer
    call WriteDec
    mov al, 's'
    call WriteChar
    
    ; Show turbo status
    cmp turboActive, 1
    jne normalTurboDisplay
    
    mov eax, lightCyan + (lightBlue * 16)
    call SetTextColor
    mov edx, OFFSET strTurbo
    call WriteString
    
    mov eax, yellow + (lightBlue * 16)
    call SetTextColor
    mov eax, turboTimer
    mov ebx, 1000
    mov edx, 0
    div ebx
    call WriteDec
    mov al, 's'
    call WriteChar
    jmp hudDone

normalTurboDisplay:
    mov eax, lightCyan + (lightBlue * 16)
    call SetTextColor
    mov edx, OFFSET strTurbo
    call WriteString
    mov eax, gray + (lightBlue * 16)
    call SetTextColor
    mov edx, OFFSET strInactive
    call WriteString
    
    ; Show invincibility status
    cmp isInvincible, 1
    jne hudDone
    
    mov eax, yellow + (lightBlue * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov al, '['
    call WriteChar
    mov al, 'I'
    call WriteChar
    mov al, 'N'
    call WriteChar
    mov al, 'V'
    call WriteChar
    mov al, ']'
    call WriteChar

hudDone:
    popa
    ret
DrawHUD ENDP


; calculate time bonus add in victorycelebration or before it
CalculateTimeBonus PROC
    pusha
    
    ; Give 10 points per second remaining
    mov eax, levelTimer
    mov ebx, 10
    mul ebx                         ; EAX = seconds * 10
    
    ; Add to score
    add score, eax
    
    popa
    ret
CalculateTimeBonus ENDP

; show princess rescued screen (victory)
ShowPrincessRescuedScreen PROC
    pusha
    
    call Clrscr
    
    ; Draw starry background
    call DrawStarryBackground
    
    ; Display "PRINCESS RESCUED" title
    mov eax, lightMagenta + (black * 16)
    call SetTextColor
    
    mov dl, 10
    mov dh, 2
    call Gotoxy
    mov edx, OFFSET princessTitle1
    call WriteString
    
    mov dl, 10
    mov dh, 3
    call Gotoxy
    mov edx, OFFSET princessTitle2
    call WriteString
    
    mov dl, 10
    mov dh, 4
    call Gotoxy
    mov edx, OFFSET princessTitle3
    call WriteString
    
    mov dl, 10
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET princessTitle4
    call WriteString
    
    mov dl, 10
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET princessTitle5
    call WriteString
    
    mov dl, 10
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET princessTitle6
    call WriteString
    
    ; Display "RESCUED!" part
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    
    mov dl, 10
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET princessTitle7
    call WriteString
    
    mov dl, 10
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET princessTitle8
    call WriteString
    
    mov dl, 10
    mov dh, 11
    call Gotoxy
    mov edx, OFFSET princessTitle9
    call WriteString
    
    mov dl, 10
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET princessTitle10
    call WriteString
    
    mov dl, 10
    mov dh, 13
    call Gotoxy
    mov edx, OFFSET princessTitle11
    call WriteString
    
    mov dl, 10
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET princessTitle12
    call WriteString
    
    ; Draw Mario sprite (left side)
    call DrawMarioSprite
    
    ; Draw Princess sprite (right side)
    call DrawPrincessSprite
    
    ; Animate hearts between them
    call AnimateHearts
    
    ; Display congratulations messages
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    mov dl, 30
    mov dh, 17
    call Gotoxy
    mov edx, OFFSET princessMsg1
    call WriteString
    
    mov eax, white + (black * 16)
    call SetTextColor
    
    mov dl, 20
    mov dh, 19
    call Gotoxy
    mov edx, OFFSET princessMsg2
    call WriteString
    
    mov dl, 20
    mov dh, 20
    call Gotoxy
    mov edx, OFFSET princessMsg3
    call WriteString
    
    ; Display final stats
    call DisplayFinalStats
    
    ; Display thank you message
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dl, 25
    mov dh, 26
    call Gotoxy
    mov edx, OFFSET thankYouMsg
    call WriteString
    
    ; Display play again prompt
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 22
    mov dh, 28
    call Gotoxy
    mov edx, OFFSET playAgainPrompt
    call WriteString
    
    popa
    ret
ShowPrincessRescuedScreen ENDP

; show try again screen (game over)
ShowTryAgainScreen PROC
    pusha
    
    call Clrscr
    
    ; Display "TRY AGAIN" title with red color
    mov eax, lightRed + (black * 16)
    call SetTextColor
    
    mov dl, 10
    mov dh, 4
    call Gotoxy
    mov edx, OFFSET tryAgainTitle1
    call WriteString
    
    mov dl, 10
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET tryAgainTitle2
    call WriteString
    
    mov dl, 10
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET tryAgainTitle3
    call WriteString
    
    mov dl, 10
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET tryAgainTitle4
    call WriteString
    
    mov dl, 10
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET tryAgainTitle5
    call WriteString
    
    mov dl, 10
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET tryAgainTitle6
    call WriteString
    
    ; Draw sad Mario
    call DrawSadMarioSprite
    
    ; Display game over messages
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    mov dl, 35
    mov dh, 13
    call Gotoxy
    mov edx, OFFSET tryAgainMsg1
    call WriteString
    
    mov eax, white + (black * 16)
    call SetTextColor
    
    mov dl, 18
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET tryAgainMsg2
    call WriteString
    
    mov dl, 15
    mov dh, 16
    call Gotoxy
    mov edx, OFFSET tryAgainMsg3
    call WriteString
    
    ; Display final stats
    call DisplayFinalStats
    
    ; Display play again prompt
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dl, 22
    mov dh, 26
    call Gotoxy
    mov edx, OFFSET playAgainPrompt
    call WriteString
    
    popa
    ret
ShowTryAgainScreen ENDP

; draw starry background
DrawStarryBackground PROC
    pusha
    
    mov eax, white + (black * 16)
    call SetTextColor
    
    ; Draw random stars
    mov ecx, 30
    
drawStarLoop:
    push ecx
    
    ; Random X position
    mov eax, 80
    call RandomRange
    mov dl, al
    
    ; Random Y position
    mov eax, 29
    call RandomRange
    mov dh, al
    
    call Gotoxy
    
    ; Random star type
    mov eax, 3
    call RandomRange
    cmp al, 0
    je drawDot
    cmp al, 1
    je drawPlus
    jmp drawAsterisk

drawDot:
    mov al, '.'
    jmp writeStarChar

drawPlus:
    mov al, '+'
    jmp writeStarChar

drawAsterisk:
    mov al, '*'

writeStarChar:
    call WriteChar
    
    pop ecx
    loop drawStarLoop
    
    popa
    ret
DrawStarryBackground ENDP

; draw mario sprite (victory)
DrawMarioSprite PROC
    pusha
    
    mov eax, lightRed + (black * 16)
    call SetTextColor
    
    mov dl, 25
    mov dh, 17
    
    ; Draw Mario line by line
    call Gotoxy
    mov edx, OFFSET marioSprite1
    call WriteString
    
    inc dh
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET marioSprite2
    call WriteString
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    inc dh
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET marioSprite3
    call WriteString
    
    inc dh
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET marioSprite4
    call WriteString
    
    mov eax, lightRed + (black * 16)
    call SetTextColor
    
    inc dh
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET marioSprite5
    call WriteString
    
    mov eax, lightBlue + (black * 16)
    call SetTextColor
    
    inc dh
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET marioSprite6
    call WriteString
    
    inc dh
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET marioSprite7
    call WriteString
    
    inc dh
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET marioSprite8
    call WriteString
    
    inc dh
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET marioSprite9
    call WriteString
    
    popa
    ret
DrawMarioSprite ENDP

; draw princess sprite
DrawPrincessSprite PROC
    pusha
    
    mov eax, lightMagenta + (black * 16)
    call SetTextColor
    
    mov dl, 50
    mov dh, 17
    
    ; Draw Princess line by line
    call Gotoxy
    mov edx, OFFSET princessSprite1
    call WriteString
    
    inc dh
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET princessSprite2
    call WriteString
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    inc dh
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET princessSprite3
    call WriteString
    
    inc dh
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET princessSprite4
    call WriteString
    
    inc dh
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET princessSprite5
    call WriteString
    
    mov eax, lightMagenta + (black * 16)
    call SetTextColor
    
    inc dh
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET princessSprite6
    call WriteString
    
    inc dh
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET princessSprite7
    call WriteString
    
    inc dh
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET princessSprite8
    call WriteString
    
    inc dh
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET princessSprite9
    call WriteString
    
    popa
    ret
DrawPrincessSprite ENDP

; draw sad mario sprite (game over)
DrawSadMarioSprite PROC
    pusha
    
    ; Draw a simple sad Mario
    mov eax, lightRed + (black * 16)
    call SetTextColor
    
    mov dl, 35
    mov dh, 18
    call Gotoxy
    mov edx, OFFSET marioSprite1
    call WriteString
    
    inc dh
    mov dl, 35
    call Gotoxy
    mov edx, OFFSET marioSprite2
    call WriteString
    
    ; Sad face (different color)
    mov eax, gray + (black * 16)
    call SetTextColor
    
    inc dh
    mov dl, 35
    call Gotoxy
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, '@'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, 'x'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, 'x'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    
    inc dh
    mov dl, 35
    call Gotoxy
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, '@'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, '>'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    
    inc dh
    mov dl, 35
    call Gotoxy
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, '@'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, '/'
    call WriteChar
    mov al, '_'
    call WriteChar
    mov al, '\'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    
    popa
    ret
DrawSadMarioSprite ENDP

; animate hearts between mario and princess
AnimateHearts PROC
    pusha
    
    mov ecx, 5      ; Number of heart animations
    
heartAnimLoop:
    push ecx
    ; Draw hearts
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dl, 38
    mov dh, 19
    call Gotoxy
    mov edx, OFFSET heartSprite1
    call WriteString
    mov dl, 42
    mov dh, 18
    call Gotoxy
    mov edx, OFFSET heartSprite2
    call WriteString
    mov dl, 40
    mov dh, 20
    call Gotoxy
    mov edx, OFFSET heartSprite3
    call WriteString
    mov eax, 300
    call Delay
    ; Erase hearts
    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, 38
    mov dh, 19
    call Gotoxy
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar
    mov dl, 42
    mov dh, 18
    call Gotoxy
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar
    mov dl, 40
    mov dh, 20
    call Gotoxy
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar
    mov eax, 200
    call Delay
    pop ecx
    dec ecx
    cmp ecx, 0
    jne heartAnimLoop
    
    ; Draw final hearts
    mov eax, lightRed + (black * 16)
    call SetTextColor
    
    mov dl, 38
    mov dh, 19
    call Gotoxy
    mov edx, OFFSET heartSprite1
    call WriteString
    
    mov dl, 42
    mov dh, 18
    call Gotoxy
    mov edx, OFFSET heartSprite2
    call WriteString
    
    mov dl, 40
    mov dh, 20
    call Gotoxy
    mov edx, OFFSET heartSprite3
    call WriteString
    
    popa
    ret
AnimateHearts ENDP

; display final stats
DisplayFinalStats PROC
    pusha
    
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    
    ; Final Score
    mov dl, 30
    mov dh, 22
    call Gotoxy
    mov edx, OFFSET finalScoreMsg
    call WriteString
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov eax, score
    call WriteDec
    
    ; Levels Completed
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    
    mov dl, 28
    mov dh, 23
    call Gotoxy
    mov edx, OFFSET finalLevelMsg
    call WriteString
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    ; Calculate levels completed
    movzx eax, currentLevel
    cmp gameEndState, 1
    jne displayCurrentLevel
    ; If victory, show max levels
    movzx eax, maxLevels
    jmp writeLevelCount

displayCurrentLevel:
    dec eax                 ; Show previous level if game over
    cmp eax, 0
    jge writeLevelCount
    mov eax, 0

writeLevelCount:
    call WriteDec
    mov al, '/'
    call WriteChar
    movzx eax, maxLevels
    call WriteDec
    
    ; Total Coins
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    
    mov dl, 32
    mov dh, 24
    call Gotoxy
    mov edx, OFFSET finalCoinsMsg
    call WriteString
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov eax, totalCoinsCollected
    add eax, coinsCollected     ; Add current level coins
    call WriteDec
    
    popa
    ret
DisplayFinalStats ENDP


CheckPlayAgain PROC
    push ebx
    push ecx
    push edx
    
waitForInput:
    call ReadChar
    
    cmp al, 'r'
    je wantRestart
    cmp al, 'R'
    je wantRestart
    cmp al, 'x'
    je wantExit
    cmp al, 'X'
    je wantExit
    
    jmp waitForInput

wantRestart:
    mov al, 1
    jmp checkPlayAgainDone

wantExit:
    mov al, 0

checkPlayAgainDone:
    pop edx
    pop ecx
    pop ebx
    ret
CheckPlayAgain ENDP

PlayCoinSound PROC
    pusha
    cmp soundEnabled, 0
    je playCoinDone
    INVOKE PlaySoundA, OFFSET coinSound, NULL, SOUND_PLAY
playCoinDone:
    popa
    ret
PlayCoinSound ENDP

PlayMarioPowerUpSound PROC
    pusha
    cmp soundEnabled, 0
    je playMarioPowerUpDone
    INVOKE PlaySoundA, OFFSET marioPowerUp, NULL, SOUND_PLAY
playMarioPowerUpDone:
    popa
    ret
PlayMarioPowerUpSound ENDP

PlayJumpSound PROC
    pusha
    cmp soundEnabled, 0
    je playJumpDone
    INVOKE PlaySoundA, OFFSET MarioJumpSound, NULL, SOUND_PLAY
playJumpDone:
    popa
    ret
PlayJumpSound ENDP


PlayEnemyDeadSound PROC
    pusha
    cmp soundEnabled, 0
    je playEnemyDeadDone
    INVOKE PlaySoundA, OFFSET koopaShellSound, NULL, SOUND_PLAY
playEnemyDeadDone:
    popa
    ret
PlayEnemyDeadSound ENDP


PlayGameOverSound PROC
    pusha
    cmp soundEnabled, 0
    je playGameOverDone
    INVOKE PlaySoundA, OFFSET gameoverSound, NULL, SOUND_PLAY
playGameOverDone:
    popa
    ret
PlayGameOverSound ENDP


PlayShellKickSound PROC
    pusha
    cmp soundEnabled, 0
    je playKoopaShellDone
    INVOKE PlaySoundA, OFFSET koopaShellSound, NULL, SOUND_PLAY  ; 
playKoopaShellDone:
    popa
    ret
PlayShellKickSound ENDP

PlayGameVictorySound PROC
    pusha
    cmp soundEnabled, 0
    je playGameVictoryDone
    INVOKE PlaySoundA, OFFSET gameVictorySound, NULL, SOUND_PLAY
playGameVictoryDone:
    popa
    ret
PlayGameVictorySound ENDP

PlayFlagpoleSound PROC
    pusha
    cmp soundEnabled, 0
    je playFlagpoleDone
    INVOKE PlaySoundA, OFFSET MarioflagpoleSound, NULL, SOUND_PLAY
playFlagpoleDone:
    popa
    ret
PlayFlagpoleSound ENDP

PlayBackgroundMusicSound PROC
    pusha
    cmp soundEnabled, 0
    je HandleSoundOff   
    INVOKE mciSendStringA, OFFSET mciClose, NULL, 0, NULL
    
    INVOKE mciSendStringA, OFFSET mciOpen, NULL, 0, NULL
    
    push eax
    cmp eax, 0
    jne showFileError
    
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 29
    call Gotoxy
    mov edx, OFFSET musicLoadedMsg
    call WriteString
       
    mov eax, 50
    call Delay
    INVOKE mciSendStringA, OFFSET mciPlay, NULL, 0, NULL
    jmp debugDone

showFileError:
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 29
    call Gotoxy
    mov edx, OFFSET fileNotFoundMsg
    call WriteString

debugDone:
    pop eax             
    mov eax, 2000
    call Delay
    jmp playBGMusicDone

HandleSoundOff:
    call StopBackgroundMusic

playBGMusicDone:
    popa                
    ret
PlayBackgroundMusicSound ENDP

StopBackgroundMusic PROC
    pusha
    
    INVOKE mciSendStringA, OFFSET mciStop, NULL, 0, NULL
    INVOKE mciSendStringA, OFFSET mciClose, NULL, 0, NULL
    
    popa
    ret
StopBackgroundMusic ENDP

CheckWarpPipe PROC
    pusha
    
    ; 1. Can only warp from Level 1
    cmp currentLevel, 1
    jne warpCheckDone
    
    ; 2. Can't warp if already underground
    cmp isUnderground, 1
    je warpCheckDone
    
    ; 3. Check X Coordinate (Player must be ON the pipe)
    ; Our pipe is at warpPipeX_L1 (35). Player width is small.
    mov al, xPos
    cmp al, warpPipeX_L1
    jl warpCheckDone
    
    mov bl, warpPipeX_L1
    add bl, 4           ; Pipe width tolerance
    cmp al, bl
    jg warpCheckDone
    
    ; 4. Check Y Coordinate (Must be standing on top of pipe)

    mov al, yPos
    cmp al, 26
    jg warpCheckDone    ; Too low (on ground)
    cmp al, 15
    jl warpCheckDone    ; Too high (jumping over)
    
    ; WARP TRIGGERED 
    call PlayFlagpoleSound ; Or a dedicated Warp sound if you have one
    
    ; Set state
    mov isUnderground, 1
    
    ; Set position for Underground (Top Left, dropping in)
    mov xPos, 4
    mov yPos, 4
    mov inAir, 1        ; Make them fall in
    
    ; Reload Level Data , This loads the underground map now
    call LoadLevelData
    call InitLevelTimer ; Reset timer or keep it Usually timer keeps running.
    
    ; Redraw Screen
    call Clrscr
    call FillBackground
    call DrawLevel
    call DrawPlayer
    
warpCheckDone:
    popa
    ret
CheckWarpPipe ENDP

CheckUndergroundExit PROC
    pusha
    
    cmp isUnderground, 1
    jne exitCheckDone
    
    mov al, xPos
    cmp al, 110         
    jl exitCheckDone
    
    mov isUnderground, 0
    
    ; Set position ahead
    mov al, warpReturnX_L1
    mov xPos, al
    mov yPos, 20
    mov inAir, 1
    
    call LoadLevelData 
    
    call Clrscr
    call FillBackground
    call DrawLevel
    call RedrawEnemies     
    call RedrawCoins        
    call DrawPlayer
    
exitCheckDone:
    popa
    ret
CheckUndergroundExit ENDP

END main