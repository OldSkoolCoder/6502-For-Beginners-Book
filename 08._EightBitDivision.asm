    *=$0000
    lda #51     // Load dividend into the accumulator
    ldy #5      // Load divisor into Y register
    jsr DivideRoutine // Call the division routine
    // Quotient is now in the X register, remainder is in the accumulator
    brk

Divisor:    .byte 0
Dividend:   .byte 0
Quotient:   .byte 0
Remainder:  .byte 0

DivideRoutine:
{

    sta Dividend    // Store Number to be divided
    sty Divisor     // Store Divisor
    ldx #0          // Initialize the quotient (result) to 0
    stx Quotient    // Store the initial quotient
    stx Remainder   // Store the initial Remainder

Loop:
    cmp Divisor     // Compare the number with divisor
    bcc Done        // If no borrow (accumulator >= divisor), proceed

    sec             // Set the carry flag for borrow
    sbc Divisor     // Subtract the divisor from the accumulator
    bcc Done        // If borrow after subtraction, division is done

    inx             // Increment the quotient
    bne Loop        // If the divisor is not zero, continue the loop

Done:
    sta Remainder   // Store Final Remainder
    stx Quotient    // Store the final quotient
    // The remainder is in the accumulator, and the Quotient is in XReg
    rts
}
