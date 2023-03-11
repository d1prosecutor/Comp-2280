;Assignment 3, Question 1
;This program traverses the linked listed who's head/top node starts at Top.
;In each node, data is at offset 0, pointer to next node is at offset 1.
;Register Dictionary
;--------------------
;R2 - Address of top
;R1 - Address of current node
;R0 - Data to print


  .orig x3000
  
  LEA R1,Top     ;get address of Head node
  ADD R2,R1,#0   ;remember top
Loop
  LDR R0,R1,#0   ;get data to print
  trap x21       ;print character
  LEA R0,Newline
  trap x22       ;print a newline
  LDR R1,R1,#1   ;get address of next node in list
;
; subtract pointers (using R3 as scratch) -- if the result is zero we have the same pointer
;
  NOT R3,R1
  ADD R3,R3,#1
  ADD R3,R3,R2
  BRnp Loop      ;process node if next != top
  
  LEA R0,EOP
  trap x22       ;End of processing
  
  HALT
  
Newline .stringz "\n"
EOP .stringz "End of Processing\n"

;here is the linked list 
Top   .fill 65    
      .fill N1      
N3    .fill 71    
      .fill N4      
N4    .fill 73  
      .fill N5    
N5    .fill 76  
      .fill Top     
N2    .fill 69  
      .fill N3    
N1    .fill 67  
      .fill N2    

  .end
