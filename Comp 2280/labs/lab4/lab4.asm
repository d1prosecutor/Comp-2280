;This program computes the FIB of a number.

  ;Data Dictionary
  ;R3 - Input number n  which is the argument to push
  ;R4 - Stores output of fib(n)
  ;R6 - Stack pointer
  .orig 0x3000

  LD R6,STACKBASE   ;initialize stack pointer to 0x4000

  LD R3,n           ;get the number to calculate the fibonacci
  
  ADD R6,R6,#-1     ;push the number n as an argument onto stack
  STR R3,R6,#0

  ADD R6,R6,#-1     ;push one word on stack for return value

  JSR FIB           ;call FIB subroutine

  LDR R4,R6,#0      ;get return value and put into R4

  ADD R6,R6,#2      ;remove the argument and the return value from stack
  
  HALT              ;stop program

;subroutine FIB - computes FIB(n) of the argument, n, passed on the stack
;Data Dictionary
;R0 - Return Value.
;R1 - Scratch register
;R2 - Stores return value of fib(n-1)
;R3 - Stores return value of fib(n-2)
;R5 - Frame pointer
;R6 - Stack Pointer
;R7 - Program counter

;Stack Contents:
;R5+0 - return value
;R5+1 - Parameter 1 (the only paramter [n])

FIB
  ;Save context
  ADD R6,R6,#-1     ;save R5, important since this routine may be called from another routine.
  STR R5,R6,#0
  
  ADD R5,R6,#1      ;make R5 point to return value 

  ADD R6,R6,#-1     ;save R0 (since we will be using it)
  STR R0,R6,#0

  ADD R6,R6,#-1     ;save R1 (since we will be using it)
  STR R1,R6,#0

  ADD R6,R6,#-1     ;save R2 (since we will be using it)
  STR R2,R6,#0

  ADD R6,R6,#-1     ;save R3 (since we will be using it)
  STR R3,R6,#0

  ADD R6,R6,#-1     ;save R7 (Since we will need it to return from a subroutine)
  STR R7,R6,#0

  ;Calculate fib

  LDR R1,R5,#1      ;load the parameter, n, into R1

  ;Check if the parameter, n, is a base case, that is if n = 0 or n = 1

  ADD R1,R1,#-1		;If the result of n-1 is <= 0 then n <= 1
  BRnz BASECASE_ONE

  ;If the parameter is a recursive cases then make two recursive calls to Fib function

  ;Call fib(n-1)
  LDR R1,R5,#1		;load the parameter, n, into R1
  ADD R1,R1,#-1		;Calculate n-1 as the next argument to pass into the fib function

  ADD R6,R6,#-1     ;push the number n-1 as an argument onto stack
  STR R1,R6,#0

  ADD R6,R6,#-1     ;push one word on stack for return value

  JSR FIB           ;call FIB subroutine

  LDR R2,R6,#0      ;save return value of fib(n-1) in R2

  ADD R6,R6,#2      ;remove the argument and the return value from stack
  

  ;Call fib(n-2)
  LDR R1,R5,#1		;load the parameter, n, into R1
  ADD R1,R1,#-2		;Calculate n-2 as the next argument to pass into the fib function

  ADD R6,R6,#-1     ;push the number n-2 as an argument onto stack
  STR R1,R6,#0

  ADD R6,R6,#-1     ;push one word on stack for return value

  JSR FIB           ;call FIB subroutine

  LDR R3,R6,#0      ;save return value of fib(n-2) in R3

  ADD R6,R6,#2      ;remove the argument and the return value from stack

  ;Calculate fib(n) by fib(n-1) + fib(n-2)
  ADD R0,R2,R3		;store fib(n-1) + fib(n-2) in R0

  STR R0,R5,#0      ;put result onto stack

  BR RESTORE

  ;return 1
  BASECASE_ONE
  AND R0,R0,#0		;clear R0 to hold the return value of 1
  ADD R0,R0,#1		;store the return value 1 in R0

  STR R0,R5,#0      ;put return value onto stack

  ;Pop the current activation record by restoring saved context and returning
  RESTORE
  LDR R7,R6,#0      ;restore R7
  ADD R6,R6,#1

  LDR R3,R6,#0      ;restore R3
  ADD R6,R6,#1

  LDR R2,R6,#0      ;restore R2
  ADD R6,R6,#1

  LDR R1,R6,#0      ;restore R1
  ADD R6,R6,#1

  LDR R0,R6,#0      ;restore R0
  ADD R6,R6,#1

  LDR R5,R6,#0      ;restore R5
  ADD R6,R6,#1
  RET               ;return from FIB subroutine

;End of Subroutine FIB
  
STACKBASE .FILL 0x4000
n   .FILL #4

    .END
