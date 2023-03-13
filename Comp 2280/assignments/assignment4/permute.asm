;Subroutine Permute
;Permute the 16-bit value passed in as a parameter, using WriteStep (another parameter passed in)
;as our permutation offset increment

;Stack Frame:
;R5-5 - Saved R3
;R5-4 - Saved R2
;R5-3 - Saved R1
;R5-2 - Saved R5
;R5-1 - Saved R7
;R5+0 - return value
;R5+1 - The word to permute
;R5+2 - The writestep number of bits to permute by

;Data Dictionary:
;!!!!!!!!!!!!!!!!!!!R0 - counts the number of rounds required, and used for I/O
;R1 - the value to permute
;R2 - the result of the permutation
;R3 - the bitmask used to look at a bit (moves from bit 0 to bit 15)
;R4 - loop counter for going through each of the 16 bits in Data
;R5 - temporary storage
;R6 - the mask for updating our permuted result
;R7 - loop counter for shifting R6 WriteStep bits
  
permute
  ;First save context
  ADD R0,R7,#0
  JSR Push          ;save R7 since I will be using it

  ADD R0,R5,#0      ;save R5, important since this routine may be called from another routine.
  JSR Push

  ADD R5,R6,#2      ;make R5 point to return value 

  ADD R0,R1,#0
  JSR Push          ;save R1 since I will be using it

  ADD R0,R2,#0
  JSR Push          ;save R2 since I will be using it

  Init_Permute
    ;setup and initialization
    ;
    add  R1,R5,#1     ;Load the parameter containing the data to permute
    
    and  R2,R2,#0     ;Initialize the resulting 16-bit integer to 0
  
    and  R3,R3,#0     ;the current read bitmask, initialized to 1 to start from least significant bit
    add  R3,R3,#1
    
    and  R6,R6,#0     ;the current write bitmask, initialized based on WriteStep
    add  R6,R6,#1

    add  R7,R5,#2     ;Initialize the writestep (number of times to shift)
    add  R7,R7,#-1    ;number of times to shift -1

    initLoop
      add  R6,R6,R6   
      add  R7,R7,#-1  ;update loop counter
    brzp initLoop

    and  R4,R4,#0   ;initializing the loop counter for the number of bits to permute
    add  R4,R4,#15  ;number of times to loop -1, to read each bit of Data
  
  Do_Permute
    ;walk through the bits of Data and place them in their new location
    ;
    permuteLoop
      and  R5,R1,R3   ;compute current bit value
      brz  bitzero    ;if bit is 0, do not update our result

      ;turn on the bit at the current write bitmask to copy that bit (thanks for the OR assignment 1)
      not  R5,R6     
      not  R2,R2     
      and  R2,R5,R2  
      not  R2,R2     

    bitzero
      add  R3,R3,R3   ;move read bitmask to look at next bit
      
      ;move write bitmask by WriteStep shifts, checking for overflow to reset
      add  R7,R5,#2
      add  R7,R7,#-1  ; number of times to shift -1

    shiftLoop
      add  R6,R6,R6   
      brnp continue   ;because we're shifting one bit, overflow will hit zero
      add  R6,R6,#1   ;reset to the first bit

    continue
      add  R7,R7,#-1  ;update loop counter
      brzp shiftLoop

      add  R4,R4,#-1  ;update loop counter
      brzp permuteLoop
  End_Do_Permute_Loop


