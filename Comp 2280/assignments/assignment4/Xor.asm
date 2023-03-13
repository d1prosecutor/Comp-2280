;Subroutine Xor
;This routine takes as parameters two 16-bit values, performs exclusive-Or on them and returns the result  

;Stack Frame:
;R5-5 - Saved R3
;R5-4 - Saved R2
;R5-3 - Saved R1
;R5-2 - Saved R5
;R5-1 - Saved R7
;R5+0 - Return address of the caller
;R5+1 - first 16-bit integer
;R5+2 - second 16-bit integer

;Data Dictionary:
;R0 - Used for push and pop routines, scratch register
;R1 - will hold the first 16-bit value
;R2 - will hold the second 16-bit value
;R3 - scratch register
;R5 - frame pointer
;R7 - Return address to caller
Xor
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
    
    Init_Xor
        LDR R1,R5,#1    ;Initialize R1 to hold the first interger
        LDR R2,R5,#2    ;Initialize R1 to hold the second interger
    End_Init_Xor

    Do_Xor
        ;First perform bitwise OR of the two intergers

        ;Perform the 'OR' operation on the operands stored in R1 and R2 and store the result in R0
        NOT R1, R1
        NOT R2, R2

        AND R0, R1, R2
        NOT R0, R0

        ;Then perform bitwise Xor of the two intergers

        ;R1 Stores Integer1
        ;R2 Stores Integer2
        LDR R1,R5,#1   
        LDR R2,R5,#2    

        ;Perform the 'XOR' operation on the operands stored in R1 and R2 and store the result in R3
        AND R3, R1, R2
        NOT R3, R3

        ;Use the value of (Integer1 OR Integer2) already calculated in the OR section(stored in R0)
        AND R0, R0, R3  ;R0 now holds R1 XOR R2

    End_Do_Xor
End_Xor
    ;Save the return value in the return address
    STR R0,R5,#0
    
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
