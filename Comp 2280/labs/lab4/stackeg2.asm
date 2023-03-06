;This example shows how to allocate a local array of length 15 and fill it with the numbers
; from 1 to n, where we assume that n <= 15
;n is passed as an argument to the subroutine.
;It doesn't do anything else, but can easily be changed to process the array.


  .orig 0x3000

  LD R6,STACKBASE     ;initialize stack pointer to 0x4000

  LD R0,n             ;get data to be processed

  ADD R6,R6,#-1       ;push argument B onto stack
  STR R0,R6,#0    

  JSR FillArray       ;call subroutine

  ADD R6,R6,#1        ;pop argument off stack
  
  HALT                ;stop program

;subroutine FillArray- write 1 to n into a local array, where n is the sole parameter
;assume n <=15
;Data Dictionary
;R0 - address of current array index
;R1 - the value n (parameter passed)
;R2 - the current value to write into array
;R3 - scratch register
;R5 - Frame pointer
;R6 - Stack Pointer


;Stack contents (after setting up R5 and saving registers)
;R5-20 -addr of start of array
;R5-5 - Saved R3
;R5-4 - Saved R2
;R5-3 - Saved R1
;R5-2 - Saved R0
;R5-1 - Saved R5
;R5+0 - 1st argument

FillArray

  ADD R6,R6,#-1     ;save R5, important since this routine may be called from another routine.
  STR R5,R6,#0
  
  ADD R5,R6,#1      ;make R5 point to the last parameter passed

  ADD R6,R6,#-1     ;save R0 (since we will be using it)
  STR R0,R6,#0

  ADD R6,R6,#-1     ;save R1 (since we will be using it)
  STR R1,R6,#0

  ADD R6,R6,#-1     ;save R2
  STR R2,R6,#0

  ADD R6,R6,#-1     ;save R3
  STR R3,R6,#0

  ADD R6,R6,#-15    ;set aside 15 bytes on stack for array 

  LDR R1,R5,#0      ;load parameter from stack (value n)
  

  ADD R0,R5,#-10    ;R0 points to start of local array
  ADD R0,R0,#-10

  AND R2,R2,#0
  ADD R2,R2,#1      ;set counter i to 1 (also value to stored in array position)

  NOT R3,R2         ;compute negative of current value i to put in array (R2)
  ADD R3,R3,#1      
  
  ADD R3,R1,R3      ;Computing n - i
  BRn Done          ;if i > n, then done
      
Loop
  STR R2,R0,#0      ;store value in current array index
  ADD R0,R0,#1      ;increment array index
  
  add R2,R2,#1      ;increment counter i

  NOT R3,R2         ;compute negative of current value i to put in array (R2)
  ADD R3,R3,#1      
  
  ADD R3,R1,R3      ;Computing n - i
  BRzp Loop         ;loop if n >= i

Done
  ADD R6,R6,#15     ;release space set aside for array  

  LDR R3,R6,#0      ;restore R3
  ADD R6,R6,#1

  LDR R2,R6,#0      ;restore R2
  ADD R6,R6,#1

  LDR R1,R6,#0      ;restore R1
  ADD R6,R6,#1

  LDR R0,R6,#0      ;restor R0
  ADD R6,R6,#1

  LDR R5,R6,#0      ;restore R5
  ADD R6,R6,#1
  RET               ;return from subroutine

;End of Subroutine FillArray
    


STACKBASE .FILL 0x4000
n   .FILL   0x02

    .END
