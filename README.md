Super Mario Clone — x86 Assembly
Developer: Ali Bazmi
Roll Number: 24i-0623
Course: Computer Organization & Assembly Language
Instructor: Usama Imran
Institution: FAST-NUCES Islamabad

Overview
A console-based Mario-style game built entirely in 32-bit x86 Assembly using MASM and the Irvine32 library. The game features three levels of increasing difficulty, a physics system, enemy AI, power-ups, a boss fight, and persistent score saving — all implemented at the assembly level without any high-level language abstractions.

Table of Contents

Features
System Requirements
Installation
How to Play
Controls
Game Mechanics
Scoring System
File Structure
Known Issues
Technical Notes
Credits


Features

3 handcrafted levels with unique layouts and difficulty scaling
Underground secret level accessible via warp pipe in Level 1
Gravity, jumping, and character physics
Lives system (3 lives) and per-level countdown timers
Coin collection as a level completion condition
Four enemy types with distinct behavior patterns
Power-up system with three upgrades
Mystery blocks, lava pits, and combo mechanics
Background music and sound effects via Windows MCI
High score saving and leaderboard (top 5)


System Requirements
RequirementDetailOperating SystemWindows (32-bit or 64-bit)AssemblerMASM (Microsoft Macro Assembler)LibraryIrvine32.libIDEVisual Studio or MASM32 SDK
Required audio files (.wav):

super_mario.wav
mario_jump.wav
mario_power_up.wav
game_coin.wav
koopa_shell_kick.wav
mario_flagpole.wav
game_over_mario.wav
victory.wav


Installation
Step 1 — Set up MASM and Irvine32
Download the MASM32 SDK from masm32.com and install the Irvine32 library (typically bundled with the Irvine textbook or available as a standalone download).
Step 2 — Prepare the project folder
Place all .wav audio files in the same directory as the source file.
Step 3 — Compile
Using Visual Studio:

Create a new Empty Project
Add Source2.asm to the project
Go to Project → Properties → Linker → Input → Additional Dependencies
Add: irvine32.lib, kernel32.lib, user32.lib, winmm.lib
Build with Ctrl+Shift+B

Using MASM32 command line:
ml /c /coff Source2.asm
link /SUBSYSTEM:CONSOLE Source2.obj irvine32.lib kernel32.lib user32.lib winmm.lib

How to Play
Objective: Collect all coins (O) in each level to unlock the next one. Defeat enemies, avoid hazards, and reach the end of Level 3 to defeat Bowser and rescue Princess Peach.
Win Condition: Complete all 3 levels and defeat Bowser.
Lose Condition: Lose all 3 lives, or let the timer expire.
Main Menu Options:

Start Game
Instructions
View Leaderboard
Exit


Controls
KeyActionWJumpAMove LeftDMove RightSShoot Fireball (Fire Mario) / Enter or Exit Warp PipePPause / ResumeXExit to MenuOToggle Sound

Game Mechanics
Enemies
Goomba (G)

Walks left and right, reverses direction at walls and edges
Defeat by jumping on top
100 points on defeat

Koopa Troopa (K = Green, R = Red)

Jump on it once to turn it into a shell (S)
Touch the shell to kick it — it travels right and defeats enemies in its path
Touch the moving shell again to remove it
150 points on defeat, 200 per enemy the shell kills

Flying Enemy (F)

Not affected by gravity, bobs up and down
Defeat by jumping on it
150 points on defeat

Bowser Boss (B) — Level 3 only

2x2 character sprite, 3 health points
Fires horizontal projectiles (red ~)
Defeat by jumping on him 3 times or hitting with 3 fireballs
100 points per hit, 500 on defeat


Power-Ups
Super Mushroom (M)

Turns Mario into Super Mario (cyan color)
Required before collecting the Fire Flower
100 points

Fire Flower (W)

Requires Super Mario state
Enables fireball shooting with the S key (max 2 on screen)
Fireballs travel horizontally and defeat enemies on contact
200 points

Turbo Star (*)

Doubles movement speed for 8 seconds
Timer display turns blue while active
0 points (effect-based pickup)


Special Mechanics
Mystery Blocks (?)

Hit from below to activate
Block converts to a platform, spawns a coin above
50 points on activation

Warp Pipe (P) — Level 1 only

Stand on top of the pipe and press S to enter the underground level
Exit at the far right (X = 110) to return to the surface at X = 80

Lava Pits (L) — Level 3 only

Animated lava; touching it causes instant death
A warning message displays at the start of Level 3

Invincibility Frames

2 seconds of invincibility after taking damage
Mario flashes red/white during this period

Combo System

Kill 3 enemies consecutively without dying
Reward: +20 seconds added to the level timer


Timer System
LevelTime LimitLevel 1120 secondsLevel 2100 secondsLevel 390 seconds
Timer color coding: green (30+ seconds), yellow (10–30 seconds), red flashing (under 10 seconds).

Scoring System
ActionPointsCollect Coin (O)10Activate Mystery Block (?)50Collect Super Mushroom100Defeat Goomba100Defeat Koopa / Flying Enemy150Collect Fire Flower200Shell kills enemy200Hit Bowser100Defeat Bowser500Fireball hits Bowser fire25Kick shell again (remove)50Time bonus (end of level)10 x seconds remaining

File Structure
SuperMario/
|
|-- Source2.asm              # Main game source (x86 Assembly)
|-- scores.txt               # Auto-generated high scores file
|
|-- super_mario.wav
|-- mario_jump.wav
|-- mario_power_up.wav
|-- game_coin.wav
|-- koopa_shell_kick.wav
|-- mario_flagpole.wav
|-- game_over_mario.wav
|-- victory.wav
|
|-- README.md
scores.txt format:
Name: Ali | Score: 1500 | Level: 3
Name: John | Score: 1200 | Level: 2

Known Issues
Audio not playing
Ensure all .wav files are in the same folder as the executable. Files must be in PCM WAV format; MP3 files renamed to .wav will not work.
Screen flicker
Run the game in fullscreen mode (Alt+Enter in Command Prompt) for the best display experience.
Platform collision gaps
Occasional minor gaps in platform collision are intentional for smoother movement feel.
No camera scrolling
The game uses a static 120-column screen. The entire level is visible at once by design.

Technical Notes

Language: x86 Assembly (32-bit)
Assembler: MASM
Library: Irvine32 (I/O, color, timing, cursor control)
Audio: Windows MCI via winmm.lib
Collision: Character-grid system using DL (X) and DH (Y) registers with ±1 tolerance
Memory: All data stored statically in the .data section; no dynamic allocation
Entity limits: Up to 10–20 enemies, coins, and platforms per level (static arrays)

Key procedures:

main — Main game loop
LoadLevelData — Parses level maps and spawns entities
DrawPlayer — Renders Mario with power-up color states
UpdateEnemies — Enemy movement and collision AI
CheckPlatformCollision — Jump and landing logic
SaveToFile — Writes score data to scores.txt


Credits

Irvine32 Library by Kip Irvine
Audio assets sourced from OpenGameArt.org (converted to PCM WAV)
Gameplay inspired by Nintendo's Super Mario Bros.

This project was developed for educational purposes as a university assignment. You are free to study and modify the code.
