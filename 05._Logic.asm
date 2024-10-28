
*=$0 // For debugging only 
    
//=================================================
// Main

    // Set bits
    lda #%01010101  // Load $55 into accumulator
    ora #%11110000  // Set highest 4 bits
    
    // Clear bits
    lda #%10001111  // Load $8F into accumulator
    and #%11110000  // Clear lowest 4 bits 

    // Toggle bits
    lda #%11111111  // Load $FF into accumulator
    eor #%10000001  // Toggle bits 7 and 0

//=================================================

