;Assignment 2 programming question

;Permute the 16-bit value found in Data, using WriteStep as our permutation offset increment
;
; Note: adding a number to itself is multiplying by 2, or shifting one bit
;       used for all of our bit reading and writing
;
;R0 - counts the number of rounds required, and used for I/O
;R1 - the value we are currently permuting
;R2 - the result of our current permutation
;R3 - the bitmask used to look at a bit (moves from bit 0 to bit 15)
;R4 - loop counter for going through each of the 16 bits in Data
;R5 - temporary storage
;R6 - the mask for updating our permuted result
;R7 - loop counter for shifting R6 WriteStep bits

  .orig x3000
  
;setup and initialization
;
  ld   R1,Data
  and  R0,R0,#0
  
rounds
  and  R2,R2,#0
  add  R0,R0,#1
  
;reset our masks
;
  and  R3,R3,#0  ;the current read bitmask
  add  R3,R3,#1
  
  and  R6,R6,#0  ;the current write bitmask, initialized based on WriteStep
  add  R6,R6,#1
  ld   R7,WriteStep
  add  R7,R7,#-1  ; number of times to shift -1
initLoop
  add  R6,R6,R6   
  add  R7,R7,#-1  ;update loop counter
  brzp initLoop

;walk through the bits of Data and place them in their new location
;
  and  R4,R4,#0
  add  R4,R4,#15  ;number of times to loop -1, to read each bit of Data

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
  ld   R7,WriteStep
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
  
  and  R1,R1,#0
  add  R1,R2,#0    ;R1 becomes R2 for our next round

  ;continue permuting until we return to the original value, which we can compare through subtraction (thanks again A1)
  ld   R5,Data
  not  R5,R5
  add  R5,R5,#1
  add  R5,R5,R1
  brnp rounds     ;keep going if the difference isn't 0, meaning they're not the same

;print the number of rounds completed
;
  and  R5,R5,#0
  add  R5,R5,R0
  
  lea  R0,StartStr
  trap x22
  
  ;use our ASCII shortcut to print the number of rounds, assumes < 10
  ld   R0,ZeroChar
  add  R0,R0,R5
  trap x21

  lea  R0,EndStr
  trap x22

;print end of program message 
theend
  lea  R0,EOPStr
  trap x22

  halt

Data      .fill   0xbeef  ;value to scramble
WriteStep .fill   0x0007  ;number of bits to move by for each write

ZeroChar  .fill   0x30    ;offset for converting our number to a printable character

StartStr  .stringz  "We performed "
EndStr    .stringz  " round(s).\n"
EOPStr    .stringz  "End of processing\n"
  .end


