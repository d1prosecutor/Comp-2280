;Subroutine Decrypt
;This routine takes as parameters a pointer to a string, a 16-bit random number, and a 16-bit key value. 
;It will decrypt the string in-place, replacing each character with the decrypted value of the character.

;Stack Frame:
;R5-8 - Local variable which will hold the value to use for Xor each time
;R5-7 - Local variable which will hold the result of the Inverse permutation each time.
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

    ADD R0,R4,#0
    JSR Push          ;save R4 since I will be using it

    JSR Push          ;Push space for the local variable which will hold the result of Inv_permute each time

    ;Push space for the local variable which will hold the previous decrypted char, and the new decrypted char
    JSR Push        

    Init_Decrypt 
        LDR R1,R5,#0    ;Initialize R1 to hold the pointer to the string

        ;Initialize the value to Xor with the result of Inv_Perumte as the 16-bit random number for the first iteration
        LDR R0,R5,#1
        STR R0,R5,#-8   
        
        ;;;Initialize the first character in the string here in R2
    End_Init_Decrypt

    Do_Decrypt 
        ;Perform Inv_Permute on the next character in the string
        Do_Decrypt_Inv_Permute
            LDR R0,R5,#2 
            JSR Push        ;Push the key as 'writestep' argument onto the stack

            ADD R0,R2,#0  ;;;????????????????????????????check the string pointer thingy   
            JSR Push        ;Push the next character as an argument onto the stack

            JSR Push        ;Push space for the return value

            JSR Inv_Permute     

            JSR Pop
            STR R0,R5,#-7   ;Save the return value of Inverse_permute on the stack

            JSR Pop
            JSR Pop         ;Pop off all the arguments
        End_Decrypt_Inv_Permute

       ;Perform XOR on the result of Inv_Permute and the ??previous decrypted character??or just previous character?? 
        Do_Decrypt_Xor
            ;!!! Note - At the first iteration, the random number serves as the previous decrypted??????? character
            ;
            LDR R0,R5,#-7
            JSR Push        ;Push the result of Inv_Permute as an argument onto the stack

            ;R5-8 at this point holds the prev decrypted character?????????????????
            LDR R0,R5,#-8
            JSR Push        ;Push the previous decrypted character as an argument onto the stack

            JSR Push        ;Push space for the return value

            JSR Xor

            JSR Pop
            STR R0,R5,#-8   ;Save the return value of Xor on the stack
            ;R5-8 at this point holds the new decrypted character?????????????????

            JSR Pop
            JSR Pop         ;Pop off all the arguments
        End_Decrypt_Xor

        ;Replace the character being pointed to with the result of permute which is the encrypted character

        ;Check if all the characters have been encrypted, ie, keep encypting till the null terminator is reached
        ;Increment the string pointer to point to the next character in the string

    End_Do_Decrypt
End_Decrypt
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


