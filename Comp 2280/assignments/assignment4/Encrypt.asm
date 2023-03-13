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
;R2 - will hold the first character in the string in R1, scratch register
;R3 - will hold the 16-bit random value
;R4 - will hold the 16-bit key 
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

    Init_Encrypt 
        LDR R1,R5,#0    ;Initialize R1 to hold the pointer to the string
        
        ;;;Initialize the first character in the string here in R2

        LDR R3,R5,#1    ;Initialize R1 to hold the 16-bit random value
        LDR R4,R5,#2    ;Initialize R1 to hold the 16-bit key
    End_Init_Encrypt

    Do_Encrypt        

    End_Do_Encrypt
End_Encrypt
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


