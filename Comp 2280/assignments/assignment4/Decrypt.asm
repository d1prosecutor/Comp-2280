;Subroutine Decrypt
;This routine takes as parameters a pointer to a string, a 16-bit random number, and a 16-bit key value. 
;It will decrypt the string in-place, replacing each character with the decrypted value of the character.

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
;R2 - will hold the result of the Inverse permutation each time.
;R3 - will hold the previous encrypted char, and the new decrypted char
;R5 - frame pointer
;R7 - Return address to caller
Decrypt
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

    Init_Decrypt 
        LDR R1,R5,#0        ;Initialize R1 to hold the pointer to the string
        LDR R0,R1,#0        ;Check if the next character in the string is the null terminator
        BRz End_Do_Decrypt  ;Don't Decrypt an empty string 

        ;Initialize the value to XOR with the result of Inv_Perumte as the 16-bit random number for the first iteration
        LDR R3,R5,#1   
    End_Init_Decrypt

    Do_Decrypt 
        ;Perform Inv_Permute on the next character in the string
        Do_Decrypt_Inv_Permute
            LDR R0,R5,#2 
            JSR Push        ;Push the key as 'writestep' argument onto the stack

            LDR R0,R1,#0  
            JSR Push        ;Push the next character as an argument onto the stack

            JSR Push        ;Push space for the return value

            JSR Inv_Permute     

            JSR Pop
            ADD R2,R0,#0    ;Save the return value of Inverse_permute in R2

            JSR Pop
            JSR Pop         ;Pop off all the arguments
        End_Decrypt_Inv_Permute

        ;Perform XOR on the result of Inv_Permute and the previous encrypted character    
        ;!!! Note - At the first iteration, the random number serves as the previous encrypted character
        Do_Decrypt_Xor
            ADD R0,R2,#0
            JSR Push        ;Push the result of Inv_Permute as an argument onto the stack

            ;R3 at this point holds the previous encrypted character
            ADD R0,R3,#0
            JSR Push        ;Push the previous encrypted character as an argument onto the stack

            JSR Push        ;Push space for the return value

            JSR Xor

            JSR Pop
            STR R3,R0,#0   ;Save the return value of Xor on the stack
            ;R3 at this point holds the new decrypted character

            JSR Pop
            JSR Pop         ;Pop off all the arguments
        End_Decrypt_Xor

        ;Store the previous encrypted character, which is currently being pointed to by the string pointer
        LDR R0,R1,#0

        ;Replace the character being pointed to with the result of permute which is the encrypted character
        STR R3,R1,#0        ;overwrite the character at the current location with the encrypted character

        ;Now copy the stored previous encrypted character back into R3 for the next XOR operation
        ADD R3,R0,#0

        ;Check if all the characters have been encrypted, ie, keep encypting till the null terminator is reached
        ADD R1,R1,#1        ;Increment the string pointer to point to the next character in the string
        LDR R0,R1,#0        ;Check if the next character in the string is the null terminator

        BRp Do_Decrypt      ;Keep encrypting till the null terminator is reached

    End_Do_Decrypt
End_Decrypt
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


