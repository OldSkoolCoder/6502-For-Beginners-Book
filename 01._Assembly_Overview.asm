
// Main
Start:
    .byte %10101001 // $A9 = lda(immediate mode)
    .byte %00000010 // $02 
    .byte %10001101 // $8D = sta(absolute mode)
    .byte %00100000 // $20 = ADDRESS low byte
    .byte %00000000 // $00 = ADDRESS high byte
    .byte %00000000 // $00 = brk

    // A more concise way of writing the above
    // .byte $A9, $02, $85, $20, $00, $00

//=================================================

    lda #$02  // load A (# = immediate mode)
    sta.abs $0020 // store A to $0020 memory
    brk       // return to BASIC


