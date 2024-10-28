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
// Variable Storage Area -------------------------------------------------------------
CurrentXPosition:   .byte $00
CurrentYPosition:   .byte $00
Direction:          .byte $00
EndXPosition:       .byte $00
EndYPosition:       .byte $00
AvailableDoors:     .byte $00,$00,$00,$00
DoorCount:          .byte $00
MazeArrayAddressLo: .byte $00
MazeArrayAddressHi: .byte $00
DoorJumpVector:     .word $0000

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
// Start of the Code ----------------------------------------------------------------
Start:

// Initialisation of Variables Process ----------------------------------------------
    lda #$01
    sta CurrentXPosition    // storing $02
    sta CurrentYPosition    // storing $02

    sta EndXPosition        // storing $02
    lda #$05
    sta EndYPosition        // storing $06

// Determine Available Directions ----------------------------------------------------
MazeSolvingLoop:
    ldy #$00                // Init Y to $00
    tya                     // Save Y into Acc
Loop:
    sta AvailableDoors,y    // storing $00
    iny                     // Increase Y by 1
    cpy #$04                // Compare Y to $04
    bne Loop                // If Y is not equal to $04, loop

    sta DoorCount           // storing $00
    sta Direction           // storing $00

// Maze Cell Byte Data Structure
// 0000 0000
// ││││ │││└─ West   │
// ││││ ││└── South  │_ The Direction to back track
// ││││ │└─── East   │
// ││││ └──── North  │
// │││└──────
// ││└───────
// │└──────── Solution Path
// └───────── Wall

//--------------------------------------------------------------------------
// Look Northwards for a door
    ldy CurrentYPosition        // load the Y Register with 
                                // the current Y Axis position

    ldx CurrentXPosition        // load the X Register with 
                                // the current X Axis position

    dey // Looking northwards means to decrease the row count

    jsr GetMazePositionData     // Get Data in this maze location

// Can We Go North -------------------------------------------------------------------
    bne NoDoorFoundTrySouth     // Is there a door?
    ldy DoorCount               // Yes, load how many doors in Y Register
    lda #DIRECTION_Up           // Load the Direction
    sta AvailableDoors,y        // Store Direction in Available Doors
    inc DoorCount               // Increase our door count

//--------------------------------------------------------------------------
NoDoorFoundTrySouth:
// Look Southwards for a door
    ldy CurrentYPosition        // load the Y Register with 
                                // the current Y Axis position

    ldx CurrentXPosition        // load the X Register with 
                                // the current X Axis position

    iny // Looking southwards means to increase the row count

    jsr GetMazePositionData

// Can We Go South -------------------------------------------------------------------
    bne NoDoorFoundTryEast      // Is there a door?
    ldy DoorCount               // Yes, load how many doors in Y Register
    lda #DIRECTION_Down         // Load the Direction
    sta AvailableDoors,y        // Store Direction in Available Doors
    inc DoorCount               // Increase our door count

//--------------------------------------------------------------------------
NoDoorFoundTryEast:
// Look Eastwards for a door
    ldy CurrentYPosition        // load the Y Register with 
                                // the current Y Axis position

    ldx CurrentXPosition        // load the X Register with 
                                // the current X Axis position

    inx // Looking eastwards means to increase the column count

    jsr GetMazePositionData

// Can We Go East --------------------------------------------------------------------
    bne NoDoorFoundTryWest      // Is there a door?
    ldy DoorCount               // Yes, load how many doors in Y Register
    lda #DIRECTION_Right        // Load the Direction
    sta AvailableDoors,y        // Store Direction in Available Doors
    inc DoorCount               // Increase our door count

//--------------------------------------------------------------------------
NoDoorFoundTryWest:
// Look Westwards for a door
    ldy CurrentYPosition        // load the Y Register with 
                                // the current Y Axis position

    ldx CurrentXPosition        // load the X Register with 
                                // the current X Axis position

    dex // Looking eastwards means to decrease the column count

    jsr GetMazePositionData

// Can We Go West ---------------------------------------------------------------------
    bne NoDoorFound             // Is there a door?
    ldy DoorCount               // Yes, load how many doors in Y Register
    lda #DIRECTION_Left         // Load the Direction
    sta AvailableDoors,y        // Store Direction in Available Doors
    inc DoorCount               // Increase our door count

//--------------------------------------------------------------------------
NoDoorFound:
    lda DoorCount               // Load how many Doors we found
    bne FoundSomeDoors          // Did we have more than Zero

// Look For where we came from -------------------------------------------------------

// Did not Find Any Doors
// Get the information at our current position in the maze
    ldy CurrentYPosition        // load the Y Register with 
                                // the current Y Axis position

    ldx CurrentXPosition        // load the X Register with 
                                // the current X Axis position

    jsr GetMazePositionData
    pha                         // Push the Acc to the Stack for later on

// Remove Solution From The Current Position -----------------------------------------
    and #%10111111              // Reset Solution Path Bit back to Zero
    ldy CurrentYPosition        // load the Y Register with 
                                // the current Y Axis position

    ldx CurrentXPosition        // load the X Register with 
                                // the current X Axis position
    jsr SetMazePositionData

// Set Current Position To Where we Came From ----------------------------------------
    pla                         // Pull back the original information from the stack
    tay                         // Store the value of Acc to Y Register, to use later
    and #pow(2,DIRECTION_Up)    // Mask off the Bit that signifies we went south
    beq WeDidNotComeSouthTryNorth   // We will branch because we had no bit set
    dec CurrentYPosition        // if we came south, then we need to go north
    jmp MazeSolvingLoop         // Go back to the beginning and look for a door

WeDidNotComeSouthTryNorth:
    tya                         // Store the value of Y Register back into Acc
    and #pow(2,DIRECTION_Down)  // Mask off the Bit that signifies we went south
    beq WeDidNotComeNorthTryEast// We will branch because we had no bit set
    inc CurrentYPosition        // if we came north, then we need to go south
    jmp MazeSolvingLoop         // Go back to the beginning and look for a door

WeDidNotComeNorthTryEast:
    tya                         // Store the value of Y Register back into Acc
    and #pow(2,DIRECTION_Right) // Mask off the Bit that signifies we went south
    beq WeDidNotComeNorthTryWest// We will branch because we had no bit set
    inc CurrentXPosition        // if we came west, then we need to go east
    jmp MazeSolvingLoop         // Go back to the beginning and look for a door

WeDidNotComeNorthTryWest:
    tya                         // Store the value of Y Register back into Acc
    dec CurrentXPosition        // if we came east, then we need to go west
    jmp MazeSolvingLoop         // Go back to the beginning and look for a door

FoundSomeDoors:
    lda AvailableDoors          // Load the First Door Found
    asl                         // x 2
    tax                         // transfer into X Register
    lda FoundDoorJumpMatrix,x   // Load Lo Byte of jump Table
    sta DoorJumpVector          // Store in lo byte of jump vector
    lda FoundDoorJumpMatrix+1,x // Load Hi Byte of jump Table
    sta DoorJumpVector+1        // Store in Hi byte of jump vector
    jmp (DoorJumpVector)        // Do The Jump

TrySouthDoor:
    inc CurrentYPosition        // Increase the current Maze Row Position
    //        %0000 1000
    lda #pow(2,DIRECTION_Up)    // Set the Direction Back, if blocked.
    jmp SetTheSolutionBit       // Go to the setting of the solution bit of the maze cell

TryNorthDoor:
    dec CurrentYPosition        // Decrease the current Maze Row Position
    //        %0000 0010
    lda #pow(2,DIRECTION_Down)  // Set the Direction Back, if blocked.
    jmp SetTheSolutionBit       // Go to the setting of the solution bit of the maze cell

TryEastDoor:
    inc CurrentXPosition        // Increase the current Maze Column Position
    //        %0000 0001
    lda #pow(2,DIRECTION_Left)  // Set the Direction Back, if blocked.
    jmp SetTheSolutionBit       // Go to the setting of the solution bit of the maze cell

TryWestDoor:
    dec CurrentXPosition        // Decrease the current Maze Column Position
    //        %0000 0100
    lda #pow(2,DIRECTION_Right) // Set the Direction Back, if blocked.

SetTheSolutionBit:
// Add current location to the Solution Path -----------------------------------------
    ora #%01000000              // Set the Solution Bit in the cell Data

    ldy CurrentYPosition        // load the Y Register with 
                                // the current Y Axis position

    ldx CurrentXPosition        // load the X Register with 
                                // the current X Axis position
    jsr SetMazePositionData

// Is the Current Position The Finish -----------------------------------------------
    ldy CurrentYPosition        // load the Y Register with 
                                // the current Y Axis position

    ldx CurrentXPosition        // load the X Register with 
                                // the current X Axis position

    cpy EndYPosition            // Compare Y Register with the value of the EndYPosition
    beq NowTestTheXPosition     // Are we the Same, if so, lets check The X Position
    jmp MazeSolvingLoop         // No, not the same, lets carry on

NowTestTheXPosition:
    cpx EndXPosition            // Compare X Register with the value of the EndXPosition
    beq WeHaveFoundTheExit      // Are we the Same, if so, Thats It, we found the Exit
    jmp MazeSolvingLoop         // No, not the same, lets carry on

// Finish -----------------------------------------------------------------------------
WeHaveFoundTheExit:
    brk

FoundDoorJumpMatrix:
    .word TryWestDoor
    .word TrySouthDoor
    .word TryEastDoor
    .word TryNorthDoor

GetMazePositionData:
{
    // Inputs   : X Reg = X (Horizontal Axis) 0 -> 6
    //          : Y Reg = Y (Vertical Axis ) 0 -> 6
    // Output   : Acc = Cell Data

    jsr WorkOutMazeLocation // Work out the row loacation in the maze Array

    txa         // Copy The X Axis Value into the accumulator
    tay         // Now transfer that value into Y Register

    lda (MazeArrayAddressLo),y  // Get the Data from the Maze Location X,Y

    rts         // Return back to where you came from
}

SetMazePositionData:
{
    // Inputs   : X Reg = X (Horizontal Axis) 0 -> 6
    //          : Y Reg = Y (Vertical Axis ) 0 -> 6
    //          : Acc = Cell Data

    pha         // Push the Cell Data To the Stack, as the accumulator is used.
    jsr WorkOutMazeLocation // Work out the row loacation in the maze Array

    txa         // Copy The X Axis Value into the accumulator
    tay         // Now transfer that value into Y Register

    pla         // Pull the Cell Data back from the Stack
    sta (MazeArrayAddressLo),y  // Get the Data from the Maze Location X,Y

    rts         // Return back to where you came from
}

WorkOutMazeLocation:
{
    // Inputs   : X Reg = X (Horizontal Axis) 0 -> 6
    //          : Y Reg = Y (Vertical Axis ) 0 -> 6
    // Output   : Acc = Cell Data

    tya         // Copy Y Axis Value Accumulator

    // we need to times the Y Axis by 16 to give us the 
    // Row address in memory for that Maze Row
    asl         // times 2
    asl         // times 4
    asl         // times 8
    asl         // times 16

    clc                         // Clear the Carry always for Additions
    adc #<MazeArray             // Add the Lo Address Value of the maze Array
    sta MazeArrayAddressLo      // Store this Address Lo Value in Maze Array
                                // Lo Pointer 

    lda #>MazeArray             // Load the Hi Addess Value of the Maze Array
    adc #0                      // Add 0, because we dont have a Hi Value,#
                                // and will add the carry if required
    sta MazeArrayAddressHi      // Store this Address Hi Value in Maze Array
                                // Hi Pointer  
    rts         // Return back to where you came from
}