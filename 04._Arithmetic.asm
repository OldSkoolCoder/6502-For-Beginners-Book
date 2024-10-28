
*=$0 // For debugging only 
    
//=================================================
// Main

    // 8-bit addition
    clc             // Clear carry before add
    lda #2          // Get first number
    adc #$0A        // Add to second number
    
    // 8-bit subtraction
    sec             // Set carry before subtract
    lda #88         // Get first number
    sbc #%00000011  // Subtract second number

    // Shift & Rotate
    asl             // Arithmetic shift left
    rol             // Rotate left
    lsr             // Logical shift right
    ror             // Rotate right

    // Binary coded decimal
    sed             // Set decimal mode
    clc             // Clear carry before add
    lda #2          // Get first number
    adc #$0A        // Add to second number
    cld             // Clear decimal mode

//=================================================
