;A simple example of calling a subroutine that computes the NAND of two values.

  .orig 0x3000

  LD R6,STACKBASE   ;initialize stack pointer to 0x4000

  LD R3,A           ;get data to be processed
  LD R4,B 
  
  ADD R6,R6,#-1     ;push argument A onto stack
  STR R3,R6,#0

  ADD R6,R6,#-1     ;push argument B onto stack
  STR R4,R6,#0    

  ADD R6,R6,#-1     ;set aside one word on stack for return value

  JSR NAND          ;call NAND subroutine

  LDR R0,R6,#0      ;get return value and put into R0

  ADD R6,R6,#3      ;remove two arguments from stack and the return value
  
  HALT              ;stop program

;subroutine NAND - computes NAND of the two numbers passed on the stack
;Data Dictionary
;R0 - Return Value, also the first parameter.
;R5 - Frame pointer
;R6 - Stack Pointer
;R1 - second parameter

;Stack Contents:
;R5+0 - return value
;R5+1 - Parameter 2
;R5+2 - Parameter 1

NAND
  ADD R6,R6,#-1     ;save R5, important since this routine may be called from another routine.
  STR R5,R6,#0
  
  ADD R5,R6,#1      ;make R5 point to return value 

  ADD R6,R6,#-1     ;save R0 (since we will be using it)
  STR R0,R6,#0

  ADD R6,R6,#-1     ;save R1 (since we will be using it)
  STR R1,R6,#0

  ;do NAND
  
  LDR R0,R5,#2      ;load first parameter into R0
  LDR R1,R5,#1      ;load 2nd parameter into R1

  AND R0,R0,R1      ;A AND B
  NOT R0,R0         ;NOT (A AND B), ie NAND of A and B.
  
  STR R0,R5,#0      ;put result onto stack


  LDR R1,R6,#0      ;restore R1
  ADD R6,R6,#1

  LDR R0,R6,#0      ;restore R0
  ADD R6,R6,#1


  LDR R5,R6,#0      ;restore R5
  ADD R6,R6,#1
  RET               ;return from subroutine

;End of Subroutine NAND
  


STACKBASE .FILL 0x4000
A   .FILL #20
B   .FILL #12

    .END
