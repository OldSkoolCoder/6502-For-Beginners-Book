*=$0 // For debugging only 
    
//=================================================
// Main

    // If/else (branch not taken)
    ldx #1          // Load 1 into X register
    beq l1          // Branch to l1 if Z = 1
    inx             // Increment the X register
l1:                 // Label l1

    // If/else (branch taken)
    bne l2          // Branch to l2 if Z = 0
    iny             // Increment the Y register
l2:                 // Label l2

    // Loop (increasing counter)
    ldy #0          // Load 0 into Y register
l3:                 // Label l3

// .for(var x=0; x<128; x++)        
// {                // too many butes for a
//     nop          // branch instruction to
// }                // jump over

    iny             // Increment the Y register
    cpy #2          // Compare Y & 2, set NZC flags
    bcc l3          // Branch to l3 if C = 0
 
//    bcs l5          // Branch to l5 if C != 0
//    jmp l3          // Jump to l3 
// l5:

//=================================================
