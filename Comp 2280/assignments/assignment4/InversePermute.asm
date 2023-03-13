;Subroutine InversePermute
;Inverse Permute the 16-bit value passed in as a parameter, using readStep (another parameter passed in)
;as our permutation offset increment

;Stack Frame:
;R5-5 - Saved R3
;R5-4 - Saved R2
;R5-3 - Saved R1
;R5-2 - Saved R5
;R5-1 - Saved R7
;R5+0 - return value
;R5+1 - The word to permute
;R5+2 - The readstep number of bits to permute by

;Data Dictionary:
;R0 - Used for push and pop routines, loop counter for shifting R4 readstep bits, temporary storage
;R1 - the value to inverse permute
;R2 - the result of the inverse permutation
;R3 - the mask for updating our permuted result (write bitmask)
;R4 - the bitmask used to look at a bit (read bitmask)
;R5 - frame pointer
;R7 - Return address to caller
Inv_Permute
  ;First save context
  ADD R0,R7,#0
  JSR Push          ;save R7 another routine will be called

  ADD R0,R5,#0      ;save R5, important since this routine may be called from another routine.
  JSR Push

  ADD R5,R6,#2      ;make R5 point to return value 

  ADD R0,R1,#0
  JSR Push          ;save R1 since I will be using it

  ADD R0,R2,#0
  JSR Push          ;save R2 since I will be using it

  ADD R0,R3,#0
  JSR Push          ;save R3 since I will be using it

  ADD R0,R4,#0
  JSR Push          ;save R4 since I will be using it

  Init_Inv_Permute
    ;setup and initialization
    ;
    ldr  R1,R5,#1     ;Load the parameter containing the data to permute
    
    and  R2,R2,#0     ;Initialize the resulting 16-bit integer to 0
  
    and  R3,R3,#0     ;the current write bitmask, initialized to 1 to start from least significant bit
    add  R3,R3,#1
    
    and  R4,R4,#0     ;the current read bitmask, initialized based on WriteStep
    add  R4,R4,#1

    ldr  R0,R5,#2     ;Initialize the number of times to shift the readstep
    add  R0,R0,#-1    ;number of times to shift -1

    initLoop_Inv
        ;Initialize the readstep bitmask
        add  R4,R4,R4   
        add  R0,R0,#-1  ;update loop counter
      brzp initLoop_Inv
    End_initloop_Inv

  End_Init_Inv_Permute

  Do_Inv_Permute
    ;walk through the bits of Data and place them in their new location
    ;
    permuteLoop_Inv
        and  R0,R1,R4   ;compute current bit value
        brz  bitzero_Inv    ;if bit is 0, do not update our result

        ;turn on the bit at the current write bitmask to copy that bit (thanks for the OR assignment 1)
        not  R0,R3     
        not  R2,R2     
        and  R2,R0,R2  
        not  R2,R2     

      bitzero_Inv      
        ;move read bitmask by readstep shifts, checking for overflow to reset
        ldr  R0,R5,#2
        add  R0,R0,#-1  ; number of times to shift -1

      shiftLoop_Inv
        add  R4,R4,R4   
        brnp continue_Inv   ;because we're shifting one bit, overflow will hit zero
        add  R4,R4,#1       ;reset to the first bit

      continue_Inv
        add  R0,R0,#-1  ;update loop counter
        brzp shiftLoop_Inv

        add  R3,R3,R3           ;move write bitmask to store at the next bit location
        brnp permuteLoop_Inv    ;Keep looping while the write bit mask has not overflown to zero

    End_Do_Inv_Permute_Loop

  End_Do_Inv_Permute
End_Inv_Permute
  ;Store the result in the return address of the caller
  STR R2,R5,#0
  
  ;Restore Saved context
  JSR Pop           
  ADD R4,R0,#0      ;restore R4

  JSR Pop           
  ADD R3,R0,#0      ;restore R3

  JSR Pop           
  ADD R2,R0,#0      ;restore R2

  JSR Pop           
  ADD R1,R0,#0      ;restore R1

  JSR Pop           
  ADD R5,R0,#0      ;restore R5

  JSR Pop           
  ADD R7,R0,#0      ;restore R7
RET;


