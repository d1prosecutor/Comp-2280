;Subroutine Encrypt
;This routine takes as parameters a pointer to a string, a 16-bit random number, and a 16-bit key value. 
;It will encrypt the string in-place, replacing each character with the encrypted value of the character

;Stack Frame:
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
;R2 - will hold the prev encrypted character, current encrypted character, and the value to permute each time
;R3 - will hold the result of the permutation each time (the encypted character)
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

    Init_Encrypt 
        LDR R1,R5,#0        ;Initialize R1 to hold the pointer to the string
        LDR R0,R1,#0        ;Check if the next character in the string is the null terminator
        BRz End_Do_Encrypt  ;Don't Encrypt an empty string 

        LDR R2,R5,#1    ;Initialize the value to permute as the 16-bit random number for the first iteration
    End_Init_Encrypt

    Do_Encrypt  
        ;Perform XOR on the next character in the string and the previous encrypted character
        ;!!! Note - At the first iteration, the random number serves as the previous encrypted character
        Do_Encrypt_Xor
            LDR R0,R1,#0    
            JSR Push        ;Push the next character as an argument onto the stack

            ;R2 at this point holds the previous encrypted character
            ADD,R0,R2,#0
            JSR Push        ;Push the previous encrypted character as an argument onto the stack

            JSR Push        ;Push space for the return value

            JSR Xor

            JSR Pop
            ADD R2,R0,#0   ;Save the return value of Xor in R2
            ;R2 at this point holds the value to permute

            JSR Pop
            JSR Pop         ;Pop off all the arguments
        End_Encrypt_Xor

        ;Perform permute on the result of Xor
        Do_Encrypt_Permute
            LDR R0,R5,#2 
            JSR Push        ;Push the key as 'writestep' argument onto the stack

            ADD,R0,R2,#0
            JSR Push        ;Push the result of the Xor operation as the word (argument) to permute

            JSR Push        ;Push space for the return value

            JSR Permute     

            JSR Pop
            ADD R2,R0,#0   ;Save the return value of permute, the encrypted character, in R2

            JSR Pop
            JSR Pop         ;Pop off all the arguments
        End_Encrypt_Permute

        ;Replace the character being pointed to with the result of permute which is the encrypted character
        STR R2,R1,#0        ;overwrite the character at the current location with the encrypted character

        ; ;Now store the encrypted character in R2 for the next XOR operation 
        ; ADD R2,R3,#0

        ;Check if all the characters have been encrypted, ie, keep encypting till the null terminator is reached
        ADD R1,R1,#1        ;Increment the string pointer to point to the next character in the string
        LDR R0,R1,#0        ;Check if the next character in the string is the null terminator

        BRnp Do_Encrypt      ;Keep encrypting till the null terminator is reached

    End_Do_Encrypt
End_Encrypt
;Restore Saved context

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


