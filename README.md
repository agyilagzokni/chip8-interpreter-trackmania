# CHIP-8 interpreter in Trackmania 2020 using Openplanet

Most of the games work fine, but there are some that are buggy, some aren't playable at all.

## Controls
The CHIP-8 can process 16 different inputs through 0 to 9, A to F.
Natively these are placed like this:

0 | 0 | 0 | 0
-- | -- | -- | --
1 | 2 | 3 | C
4 | 5 | 6 | D
7 | 8 | 9 | E
A | 0 | B | F

In some games these are referred as:
0 | 0 | 0 | 0
-- | -- | -- | --
1 | 2 | 3 | 4
Q | W | E | R
A | S | D | F
Z | X | C | V

And these are mapped to the controller like this:
0 | 0 | 0 | 0
-- | -- | -- | --
X | Y | B | R1
V | U | M | L1
L | D | R | RSB
L2 | A | R2 | LSB

U, L, D, R: D-pad

RSB, LSB: stick buttons

V, M: View and Menu

You can switch between controller and virtual keypad inside the openplanet settings.

## Test ROMs

The test ROMs used are available [here](https://github.com/Timendus/chip8-test-suite#chip-8-splash-screen)

#### Instruction test result:
![](https://cdn.discordapp.com/attachments/915699235020750888/1131620963218358283/instrtest.png)

#### Flag test result:
![](https://cdn.discordapp.com/attachments/915699235020750888/1131620963830730772/carrytest.png)

#### Quirks test result:
![](https://cdn.discordapp.com/attachments/915699235020750888/1131620963545530570/Screenshot_2.png)

The disp.wait is tied to the interpreter not limiting the number of max sprites per second to 60.

Clipping fails, because the pixels rendered outside the viewable area aren't wrapping around correctly.

## Resouces used:
https://johnearnest.github.io/chip8Archive/ - Newer CHIP-8 ROMs

https://github.com/badlogic/chip8/blob/master/roms/ - Other ROMs

https://en.wikipedia.org/wiki/CHIP-8

http://devernay.free.fr/hacks/chip8/C8TECH10.HTM
