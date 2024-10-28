*=$0000
    // Initialize the loop counter for 16 bits
    lda #<4666      // Lo Byte of Value 4666
    ldy #>4666      // Hi Byte of Value 4666
    ldx #10
    jsr Divide_16Bit_By_8Bit
    brk

Dividend:   .word 0     // Number to be divided (16 Bit)
Divisor:    .byte 0     // Number to Divide by (8 Bit)
Result:     .word 0     // Quotient (16 Bit Result)
Remainder:  .byte 0     // Remainder (8 Bit)

Divide_16Bit_By_8Bit:
{
    sta Dividend        
    sty Dividend + 1    
    stx Divisor

    ldy #0
    sty Remainder       // Clear remainder
    sty Result          // Clear low byte of the quotient
    sty Result + 1      // Clear high byte of the quotient

    ldx #16

    // Start of the division loop
Loop:
    asl Dividend      // Shift the low byte of dividend left (carry into high byte)
    rol Dividend + 1  // Shift the high byte of dividend left (carry into remainder)
    rol Remainder     // Shift remainder left (carry into remainder)
    
    // Compare remainder with divisor
    lda Remainder     // Load current remainder in A
    cmp Divisor       // Compare with divisor
    bcc SkipSubtract  // If remainder < divisor, skip subtraction

    // Subtract divisor from remainder
    sec               // Set carry for subtraction
    sbc Divisor       // Subtract divisor from remainder
    sta Remainder     // Store new remainder

    // Set current quotient bit
    lda Result
    ora #1            // Set the least significant bit of the quotient
    sta Result        // Store updated quotient

SkipSubtract:
    // Shift quotient left for next bit
    asl Result        // Shift low byte of quotient left
    rol Result + 1    // Shift high byte of quotient left

    dex               // Decrement loop counter
    bne Loop          // Repeat for all 16 bits

    // After loop is done, the quotient is in QUOT_HI and QUOT_LO, remainder in REM
    lsr Result + 1    // Shift high byte of quotient left
    ror Result        // Shift low byte of quotient left

    lda Remainder     // Load final remainder
    rts               // Return
}
