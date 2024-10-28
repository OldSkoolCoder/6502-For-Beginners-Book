    *=$0000
    lda #6      // Load multiplicand into Y register
    ldy #5      // Load multiplier into the accumulator
    jsr MultiplyRoutine // Call the multiplication routine
    // Product is now in the X register and the accumulator
    brk

Multiplier:     .byte 0
Multiplicand:   .byte 0
Result:         .word 0

MultiplyRoutine:
{
    ldx #0          // Initialize the product (result) to 0
    sty Multiplier  // Load the multiplier into the accumulator
    sta Multiplicand // Load the multiplicand into the Y register
    stx Result      // Store the initial product
    stx Result + 1  // Store the initial product Hi

Loop:
    clc             // Clear the carry flag
    lda Result
    adc Multiplier  // Add the product to the accumulator
    sta Result

    bcc NoCarry
    inc Result + 1  // Add 1 to Hi Byte is required

NoCarry:
    dey         // Decrement the multiplicand
    bpl Loop    // If the multiplicand is not zero, continue the loop

Done:
    // The product is in the X register and the accumulator
    ldx Result
    lda Result + 1
    rts
}
