
//=================================================
// Constants

.label Purple          = $04
.label Green           = $05
.label Yellow          = $07

.label BORDCOL         = $1020 // Border Color
.label BGCOL0          = $1021 // Background Color

//=================================================

//=================================================
// BASIC Loader

*=$0000

//=================================================
// Main

    lda #Purple     // load A with 4
    sta BORDCOL     // store A to $1020
    ldx #Green      // load X with 5
    stx BGCOL0      // store X to $1021
    ldy #Yellow     // load Y with 7
    sty BORDCOL     // store Y to $1020
    tax             // copy A to X
    tya             // copy Y to A
    txa             // copy X to A
    tay             // copy A to Y
    pha             // Push A to the Stack
    lda #Yellow     // Load A with 7
    pla             // Pull Stack into A
    rts             // return to BASIC

//=================================================


