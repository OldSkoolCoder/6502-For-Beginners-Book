*=$0000
// Jump to start of program
jmp Start

.const MazeWidth = 7
.const MazeHeight = 7

.const DIRECTION_Left = 0         // West = 1
.const DIRECTION_Down = 1         // South = 2
.const DIRECTION_Right = 2        // East = 4
.const DIRECTION_Up = 3           // North = 8


*=$0003
// Variable Storage Area

*=$0039
MazeArray:
// XXXXXXX
// X X   X
// X   X X
// X XX  X
// XX   XX
// X  X  X
// XXXXXXX
.byte $80,$80,$80,$80,$80,$80,$80
* = * + 9
.byte $80,$40,$80,$00,$00,$00,$80
* = * + 9
.byte $80,$00,$00,$00,$80,$00,$80
* = * + 9
.byte $80,$00,$80,$80,$00,$00,$80
* = * + 9
.byte $80,$80,$00,$00,$00,$80,$80
* = * + 9
.byte $80,$00,$00,$80,$00,$00,$80
* = * + 9
.byte $80,$80,$80,$80,$80,$80,$80

*=$1000
// Start of the Code
Start:
