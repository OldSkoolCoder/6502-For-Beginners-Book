    *=$0000   // Set the origin address (adjust as needed)
    sei          // Disable interrupts
    cld          // Clear decimal mode
    ldx #10      // Set the number of Fibonacci numbers to generate
    jsr FibonacciLoop // Call the Fibonacci loop
    brk          // Break (end of program)

Result:
    .word $0000
    .word $0000

FibonacciLoop:
    lda #0       // Load the first Fibonacci number (F(0)) into the accumulator
    sta Result   // Store the result in memory
    lda #1       // Load the second Fibonacci number (F(1)) into the accumulator
    sta Result+1 // Store the result in memory
    ldx #2       // Initialize the counter

FibonacciLoopBody:
    jsr Fibonacci // Call the recursive Fibonacci function
    sta Result+2, X // Store the result in memory
    inx          // Increment the counter
    cpx #10      // Check if 10 Fibonacci numbers have been generated
    bcc FibonacciLoopBody // If not, continue the loop
    rts          // Return

Fibonacci:
    cpx #0       // Check if X is 0 (base case)
    beq FibonacciBaseCase // If X is 0, return 0
    cpx #1       // Check if X is 1 (base case)
    beq FibonacciBaseCase // If X is 1, return 1

    dex          // Decrement X
    jsr Fibonacci // Call Fibonacci recursively for X-1
    tax          // Copy the result for X-1 from the Accumulator to X
    dex          // Decrement X again
    jsr Fibonacci // Call Fibonacci recursively for X-2
    clc          // Clear the carry flag
    adc Result+1 // Add the result for X-2 to the result for X-1
    sta Result+1 // Store the sum in memory
    rts          // Return

FibonacciBaseCase:
    txa          // Copy X to the Accumulator
    rts          // Return
