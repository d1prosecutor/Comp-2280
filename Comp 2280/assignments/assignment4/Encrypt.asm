;Subroutine Encrypt
;This routine takes as parameters a pointer to a string, a 16-bit random number, and a 16-bit key value. 
;It will encrypt the string in-place, replacing each character with the encrypted value of the character

;Stack Frame:
;R5-8 - Local variable which will hold the result of the permutation each time (the encypted character)
;R5-7 - Local variable which will hold the prev encrypted character, and  also the value to permute each time
;R5-6 - Saved R4
;R5-5 - Saved R3
;R5-4 - Saved R2
;R5-3 - Saved R1
;R5-2 - Saved R5
;R5-1 - Saved R7
;R5+0 - A pointer to a string
;R5+1 - A 16-bit random number
;R5+2 - A 16-bit key value

;Data Dictionary:
;R0 - Used for push and pop routines, scratch register
;R1 - will hold the pointer to the string
;R2 - will hold the next character in the string in R1
;R3 - 
;R4 - 
;R5 - frame pointer
;R7 - Return address to caller
Encrypt
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

    ;Push space for the local variable which will hold the prev encrypted char, and the value to permute each time
    JSR Push 

    JSR Push          ;Push space for the local variable which will hold the result of permute each time

    Init_Encrypt 
        LDR R1,R5,#0    ;Initialize R1 to hold the pointer to the string

        LDR R0,R5,#1
        STR R0,R5,#-7   ;Initialize the value to permute as the 16-bit random number for the first iteration
        
        ;;;Initialize the first character in the string here in R2
    End_Init_Encrypt

    Do_Encrypt  
       ;Perform XOR on the next character in the string and the previous encrypted character
        Do_Encrypt_Xor
            ;!!! Note - At the first iteration, the random number serves as the previous encrypted character
            ;
            ADD R0,R2,#0  ;;;????????????????????????????check the string pointer thingy   
            JSR Push        ;Push the next character as an argument onto the stack

            ;R5-7 at this point holds the previous encrypted character
            LDR R0,R5,#-7
            JSR Push        ;Push the previous encrypted character as an argument onto the stack

            JSR Push        ;Push space for the return value

            JSR Xor

            JSR Pop
            STR R0,R5,#-7   ;Save the return value of Xor on the stack
            ;R5-7 at this point holds the value to permute

            JSR Pop
            JSR Pop         ;Pop off all the arguments
        End_Encrypt_Xor

        ;Perform permute on the result of Xor
        Do_Encrypt_Permute
            LDR R0,R5,#2 
            JSR Push        ;Push the key as 'writestep' argument onto the stack

            LDR R0,R5,#-7   
            JSR Push        ;Push the result of the Xor operation as the word (argument) to permute

            JSR Push        ;Push space for the return value

            JSR Permute     

            JSR Pop
            STR R0,R5,#-8   ;Save the return value of permute on the stack

            JSR Pop
            JSR Pop         ;Pop off all the arguments
        End_Encrypt_Permute

        ;Replace the character being pointed to with the result of permute which is the encrypted character

        ;Check if all the characters have been encrypted, ie, keep encypting till the null terminator is reached
        ;Increment the string pointer to point to the next character in the string

    End_Do_Encrypt
End_Encrypt
;Restore Saved context
  JSR Pop  
  JSR Pop           ;Pop the local variable

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


