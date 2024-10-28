
// Constants

.const Black        = $00
.const White        = $01
.const Red          = $02
.const Cyan         = $03
.const Purple       = $04
.const Green        = $05
.const Blue         = $06
.const Yellow       = $07
.const Orange       = $08
.const Brown        = $09
.const LightRed     = $0A
.const DarkGray     = $0B
.const MediumGray   = $0C
.const LightGreen   = $0D
.const LightBlue    = $0E
.const LightGray    = $0F

// Labels

.label BGCOL0       = $1021 // Colour Location

//=================================================

//=================================================
// Main
*=$0000
Start:
    lda #White       //  1. Immediate
    sta BGCOL0       //  2. Absolute
    sta $7B          //  3. Zero Page
    tay              //  4. Implied
    jmp (lut1)       //  5. Indirect Absolute
jumpToHere1:         //  label
    lda lut2,x       //  6. Absolute Indexed, X
    sta myVariable,y //  7. Absolute Indexed, Y
jumpToHere2:         //  label
    lda $7B,x        //  8. Zero Page Indexed, X
    stx $7A,y        //  9. Zero Page Indexed, Y
    lda ($7C,x)      // 10. Indexed Indirect
    lda ($7C),y      // 11. Indirect Indexed
    beq jumpToHere2  // 12. Relative
    asl              // 13. Accumulator
    rts              // return to BASIC

//=================================================

//=================================================
// Variables

myVariable: .byte 0,0 // 2 bytes reserved

//=================================================

//=================================================
// Lookup Tables
*=$1035
// Variables reserved for the look up tables
lut1:
    .byte <jumpToHere1 // low byte of address
    .byte >jumpToHere1 // high byte of address

lut2:
    .byte Green
    .byte Purple
    .byte Cyan

//=================================================



