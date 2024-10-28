    *=$0000     // Set the origin address (adjust as needed)

    sei             // Disable interrupts
    cld             // Clear decimal mode
    ldx #10         // Set the number for which to calculate the factorial
    jsr Factorial   // Call the recursive factorial function
    // Result is in the Accumulator
    brk             // Break (end of program)

Factorial:
    cpx #1          // Check if X is 1
    beq BaseCase    // If X is 1, return 1 (base case)
    dex             // Decrement X
    jsr Factorial   // Call the factorial function recursively for X-1
    txa             // Copy the result (X-1)! from the Accumulator to X
    inx             // Increment X to get X!
    rts             // Return

BaseCase:
    lda #1 // Load 1 into the Accumulator (factorial of 1)
    rts    // Return
