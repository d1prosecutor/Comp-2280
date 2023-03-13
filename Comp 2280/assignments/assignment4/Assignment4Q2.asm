;This program reads in a number and generates that many random 16-bit values.
;In this program, because we are using push and pop routines, we assume the contents of R0 will not
;be guarentee across subroutine calls.
;So, do not save R0 onto the stack.
 
  .orig x3000

  LD R6,STACKBASE     ;initialize stack

;Code to read in a number.
;Register Dictionary for reading
;R0 - for I/O
;R1 - index into array Data
;R2 - element at current array index
;R3 - value of digit in question (between 0 and 15 for hex, 0 and 9 for decimal).  In the end R3 contains the result.
;R4 - The number being computed (the number represented by the input). THis will be copied into R3 at the end.
;R5 - scratch register.
;read in input and store into Data. Aside aside 4 bytes which is enough.

  LEA R0,StrPrompt  ;print user for input.
  trap x22
  LEA R1,Data
ReadLoop
  trap x20
   
  ADD R3,R0,#-10    ;R3 will be 0 if user hit <ENTER>
  BRz DoneRead   
  
  STR R0,R1,#0    ;store character read into array Data
  ADD R1,R1,#1    ;increment array index
  BR ReadLoop  
      
DoneRead
  AND R0,R0,#0    ;set R0 to 0
  STR R0,R1,#0    ;put null-terminating character onto string read (optional)

  LEA R0,StrNewline 
  trap x22
  LEA R0,Data     ;echo input string  to console
  trap x22  


ProcessInput      ;process the input
  AND R4,R4,#0    ;zero out result  
  LEA R1,Data     ;get start of input string
  LDR R2,R1,#0    ;get first character(must be # or x).
  LD R3,chPound   ;Load the character '#' into R3

  ADD R3,R3,R2    ;is the character '#'?
  BRz HandleDec   ;yes
HandleHex
  ADD R1,R1,#1    
  LDR R2,R1,#0    ;get first digit

HexCalc 
  LD R3,ch9
  ADD R3,R3,R2    ;see if it is > 9 
  BRp HexGt9      ;yes
  LD R3,ch0
  ADD R3,R3,R2    ;compute digits value
  BR HexNextChar
HexGt9  
  LD R3,chF
  ADD R3,R3,R2    ;see if it is > 'F'
  BRp HexGtF      ;yes
  LD R3,chA   
  ADD R3,R3,R2    ;compute value of digit
  ADD R3,R3,#10   ;R3 holds value of digit

  BR HexNextChar
HexGtF
  ;must be between 'a' and 'f'  
  LD R3,chLittleA   
  ADD R3,R3,R2    ;compute value of digit
  ADD R3,R3,#10   ;R3 holds value of digit
HexNextChar 
  ADD R4,R4,R3
  ADD R1,R1,#1
  LDR R2,R1,#0    ;get new digit
  ADD R2,R2,#0    ;see if value is zero (remember, we null terminated the string)
  BRz Done        ;yes, we are done!

  ADD R4,R4,R4    ;multiply result by 16 using four add instructions
  ADD R4,R4,R4    ;Add R4 to itself 4 times to multiply R4 by 16.
  ADD R4,R4,R4
  ADD R4,R4,R4  
    
  BR HexCalc      ;deal with current digit

;This handle conversion of decimal numbers.
HandleDec
  ADD R1,R1,#1    
  LDR R2,R1,#0    ;get first digit (must be between 0 and 9, since it is a decimal digit)

DecCalc     
  LD R3,ch0
  ADD R3,R3,R2    ;compute digits value
  ADD R4,R4,R3    ;add digit to result
DecNextChar 
  ADD R1,R1,#1
  LDR R2,R1,#0    ;get new digit
  ADD R2,R2,#0    ;see if value is zero (remember, we null terminated the string)
  BRz Done        ;yes, we are done!
  ADD R5,R4,R4    ;multiply R4 by 10
  ADD R5,R5,R5    ;since we do not have a multiply, we have to use a workaround.
  ADD R5,R5,R5
  ADD R3,R4,R4    ;At this point R3 = 2*R4, R5 = 8*R4.
  ADD R4,R3,R5    ;R4 = R3+R5 which is 10*R4

  BR DecCalc      ;deal with current digit  
Done
  ADD R3,R4,#0    ;copy final result into R3.

;------------------------------------------------------------------------
;Main part of code for generating random numbers
MAIN
AND R0,R0,0
ADD R0,R0,15

JSR PUSH

ADD R0,R0,#-14
JSR PUSH
JSR PUSH
JSR Permute
Jsr Pop



END_MAIN
      
HALT

;-----------------------------------------------------------------------------
;Data section
Data        .blkw   4 ;set aside 4 bytes for the input characters
StrPrompt .stringz  "\nEnter a *3* character number (include leading zeroes):"
StrGen    .stringz  " random numbers: "
StrNewline  .stringz  "\n"
StrUnderflow  .stringz  "\nStack Underflow, SP will not be changed."

Space     .fill  #32    ; space character

chPound   .fill   #-35  ;negative of the ASCII code for the '#' character
ch0       .fill   #-48  ;negative of the ASCII code for the '0' character
ch9       .fill   #-57  ;negative of the ASCII code for the '9' character
chA       .fill   #-65  ;negative of the ASCII code for the 'A' character
chF       .fill   #-70  ;negative of the ASCII code for the 'F' character
chLittleA .fill   #-97  ;negative of the ASCII code for the 'a' character

    
STACKBASE .fill   xFD00 ;start of stack


;------------------------------------------------------
;Subroutine Push
;pushes the contents of R0 onto the stack

;Data Dictionary:
;R0 - contains data to be pushed.
;R6 - stack pointer
Push
    ADD R6,R6,#-1; make space on the stack for pushing the data
    STR R0,R6,#0; push the contents of R0 onto the stack
End_Push
RET;

;------------------------------------------------------
;Subroutine Pop
;pops the contents of Top of Stack into R0

;Data Dictionary:
;R0 - holds the stackbase for underflow checking, will contain value of data popped at end of routine.
;R6 - stack pointer
Pop 
    ;Check if the stack pointer is at the base of the stack to avoid underflow
    ;first store the negative value of the stack base in R0 for comparison
    LD  R0,STACKBASE; 
    NOT R0,R0; 
    ADD R0,R0,#1; R0 holds (-stackBase) now

    ;Now compare the current position of the stack pointer with the stack base
    ADD R0,R0,R6
    BRZ End_Pop; Don't pop the stack if the stack pointer is at (or below) the base of the stack 

    Do_Pop
    LDR R0,R6,#0; store the contents of the top of the stack into R0 before popping
    ADD R6,R6,#1;
End_Pop
RET;


;Subroutine Permute
;Permute the 16-bit value passed in as a parameter, using WriteStep (another parameter passed in)
;as our permutation offset increment

;Stack Frame:
;R5-6 - Saved R4
;R5-5 - Saved R3
;R5-4 - Saved R2
;R5-3 - Saved R1
;R5-2 - Saved R5
;R5-1 - Saved R7
;R5+0 - return value
;R5+1 - The word to permute
;R5+2 - The writestep number of bits to permute by

;Data Dictionary:
;R0 - Used for push and pop routines, loop counter for shifting R4 WriteStep bits, temporary storage
;R1 - the value to permute
;R2 - the result of the permutation
;R3 - the bitmask used to look at a bit,read bitmask (moves from bit 0 to bit 15)
;R4 - the mask for updating our permuted result, write bitmask
;R5 - frame pointer
;R7 - Return address to caller
Permute
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

  Init_Permute
    ;setup and initialization
    ;
    add  R1,R5,#1     ;Load the parameter containing the data to permute
    
    and  R2,R2,#0     ;Initialize the resulting 16-bit integer to 0
  
    and  R3,R3,#0     ;the current read bitmask, initialized to 1 to start from least significant bit
    add  R3,R3,#1
    
    and  R4,R4,#0     ;the current write bitmask, initialized based on WriteStep
    add  R4,R4,#1

    add  R0,R5,#2     ;Initialize the writestep (number of times to shift)
    add  R0,R0,#-1    ;number of times to shift -1

    initLoop
        add  R4,R4,R4   
        add  R0,R0,#-1  ;update loop counter
      brzp initLoop
    End_initloop

  End_Init_Permute

  Do_Permute
    ;walk through the bits of Data and place them in their new location
    ;
    permuteLoop
        and  R0,R1,R3   ;compute current bit value
        brz  bitzero    ;if bit is 0, do not update our result

        ;turn on the bit at the current write bitmask to copy that bit (thanks for the OR assignment 1)
        not  R0,R4     
        not  R2,R2     
        and  R2,R0,R2  
        not  R2,R2     

      bitzero        
        ;move write bitmask by WriteStep shifts, checking for overflow to reset
        add  R0,R5,#2
        add  R0,R0,#-1  ; number of times to shift -1

      shiftLoop
        add  R4,R4,R4   
        brnp continue   ;because we're shifting one bit, overflow will hit zero
        add  R4,R4,#1   ;reset to the first bit

      continue
        add  R0,R0,#-1  ;update loop counter
        brzp shiftLoop

        add  R3,R3,R3       ;move read bitmask to look at next bit
        brnp permuteLoop    ;Keep looping while the read bit mask has not overflown to zero

    End_Do_Permute_Loop
  
  ;Store the result in the return address of the caller
  STR R2,R5,#0

  End_Do_Permute
End_Permute
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


;----------------------------------------------
;Subroutine Rand16 - generates a 16-bit positive random integer
;
;To make it positive we simply force the msb to be zero, which means we only need
;to produce 15 random bits per number.

;Stack Frame:
;R5-5 - Saved R3
;R5-4 - Saved R2
;R5-3 - Saved R1
;R5-2 - Saved R5
;R5-1 - Saved R7
;R5+0 - return value

;Data Dictionary:
;R0 - used for push and pop routines, also holds the random bit generated using rand1
;R1 - will hold the get_next_bit loop counter which counts the number of bits left to set
;R2 - will hold the shift_bit loop counter which counts the number times left to shift the bit
;R3 - will hold the resulting 16-bit integer formed
;R5 - frame pointer
;R7 - Return address to caller
Rand16
    ;First save context
    ADD R0,R7,#0
    JSR Push          ;save R7 since another routine is called

    ADD R0,R5,#0      ;save R5, important since this routine may be called from another routine.
    JSR Push

    ADD R5,R6,#2      ;make R5 point to return value 

    ADD R0,R1,#0
    JSR Push          ;save R1 since I will be using it as a pointer to the string of characters

    ADD R0,R2,#0
    JSR Push          ;save R2 since I will be using it to store the shift counter

    ADD R0,R3,#0
    JSR Push          ;save R3 since I will be using it as a bit mask

    Init_Rand16
    AND R1,R1,#0
    ADD R1,R1,#15     ;Initialize the get_next_bit loop counter

    AND R3,R3,#0      ;Initialize the resulting 16-bit integer to zero

    Get_Next_Bit
        ;Genegrate a random bit using the rand1 subroutine
        Get_Rand_Bit
            JSR PUSH          ;Push space for the return value of rand1
            JSR Rand1
            JSR POP           ;Now the new random bit generated is stored in R0
        End_Get_Rand_bit

        Brz End_Set_bit   ;If the new random bit is a zero, don't bother shifting and setting

        Shift_Bit
            ADD R2,R1,#-15    ;Initialize the shift_bit loop counter to the number of times to shift the bit to the left
                            ;(the loop counter goest from the negative to zero here)

            BRz End_Shift_Bit ;Don't Shift the bit if it should be at the least significant position in the new 16-bit integer

            ;Shift the bit to the current position in the new 16-bit integer
            Do_Shift
            ADD R0,R0,R0    ;Shift the bit one step to the left

            ADD R2,R2,#1    ;This shift-loop counter starts at negative and counts up to zero, !!{Might change, ask prof if its okay}

            BRn Do_Shift   ;Keep shifting till the bit is at the right position
            End_Do_Shift

        End_Shift_Bit

        ;Now set the bit at the current position in the new 16-bit integer to the result of rand1 using bitwise OR
        Set_Bit
            ;Perform the bitwise OR operation on the bit stored in R0 and the resulting integer stored in R3
            NOT R0, R0
            NOT R3, R3

            AND R3, R0, R3
            NOT R3, R3        ;Perform and Store (R0' NAND R3')->(which gives R0 OR R3) in R3
        End_Set_Bit

        ADD R1,R1,#-1     
        BRp Get_Next_Bit  ;Decrement loop counter and keep looping until all 15 (least significant) bits are set

    End_Get_Next_Bit

    ;Store the 16-bit integer formed in the return value address of the caller
    STR R3,R5,#0
End_Rand16
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
RET

;static variables for Rand1

StrSeed .stringz "asdfghjkl;' `1234567890-= ~!@#$%^&*()_+ qwertyuiop[]\ QWERTYUIOP{}| zxcvbnm,./ ASDFGHJKL: ZXCVBNM<>?"

charPointer .fill StrSeed

;----------------------------------------------
;Subroutine Rand1 - generates a random bit according to the rules specified in the assignment

;Stack Frame:
;R5-9 - Local variable for the least significant bit of the second character
;R5-8 - Local variable for the least significant bit of the first character
;R5-7 - Local variable for the shift counter
;R5-6 - Saved R4
;R5-5 - Saved R3
;R5-4 - Saved R2
;R5-3 - Saved R1
;R5-2 - Saved R5
;R5-1 - Saved R7
;R5+0 - return value (the random bit in bit position 0) 

;Data Dictionary:
;R0 - used for push and pop routines, scratch register
;R1 - holds the pointer to the string of characters being read
;R2 - shift counter, n, for the number of times to right shift a bit (reading the nth least significant bit from a character)
;R3 - will hold a bit mask which will be used to read the least significant bit each time
;R4 - scratch register, holds the current character being read
;R5 - frame pointer
;R7 - Return address to caller
Rand1
    ;First save context
    ADD R0,R7,#0
    JSR Push          ;save R7 since another routine is called

    ADD R0,R5,#0      ;save R5, important since this routine may be called from another routine.
    JSR Push

    ADD R5,R6,#2      ;make R5 point to return value 

    ADD R0,R1,#0
    JSR Push          ;save R1 since I will be using it as a pointer to the string of characters

    ADD R0,R2,#0
    JSR Push          ;save R2 since I will be using it to store the shift counter

    ADD R0,R3,#0
    JSR Push          ;save R3 since I will be using it as a bit mask

    ADD R0,R4,#0
    JSR Push          ;save R4 since I will be using it as a scratch register

    JSR Push          ;push space for the shift counter variable

    JSR Push          ;push space for storing the bit result of shifting the first character

    JSR Push          ;push space for storing the bit result of shifting the second character

Init_Rand1     
    ;Initialize the pointer to the first character in the string
    LD R1,charPointer
    STR R1,R5,#-6

    ;Initialize the shift counter, n, to 0
    AND R2,R2,#0
    STR R2,R5,#-7

    ;Initialize the bit mask to 1
    AND R3,R3,#0
    ADD R3,R3,#1 
End_Init_Rand1
;Read off n bits from each character, incrementing n each time and cycling back with modulo 9
Do_Rand1
    ;Increment the shift counter, n, for the next character to be read
    LDR R2,R5,#-7
    ADD R2,R2,#1      ;Increment n

    ;Cycle the shift counter by mod 9
    ADD R0,R2,#0
    JSR PUSH          ;Push n as the argument (A) onto the stack

    AND R0,R0,#0
    ADD R0,R0,#9
    JSR PUSH          ;Push 8 as the argument (B) onto the stack

    JSR PUSH          ;Push space for the return value

    JSR Modulo        ;Calculate A mod B

    JSR POP
    ADD R2,R0,#0      ;Store the return value in R2

    BRp Dont_Reset_Counter1
    ;If the result of the modulo is 0, then reset the counter to 1 (to read the 1st least significant bit)
    ADD R2,R2,#1   

    Dont_Reset_Counter1
    JSR POP
    JSR POP           ;Pop off the arguments

    STR R2,R5,#-7     ;Update the value of the local variable for the shift counter

    Read_First_Char
        ;Get the next character from the string
        LDR R4,R1,#0      
        BRp Shift_First_Char  ;Read the next character if it is not the null terminator

        ;If the character is the null terminator, reset the character pointer to the first character in the string
        ;Then continue reading 
        LEA R1,StrSeed         ;Reset the character pointer to the first character in the string
        ST R1,charPointer      ;Update the character pointer static variable to point to the next character that should be used

        LDR R4,R1,#0           ;Copy the character into R4 to prepare for shifting and reading

        Shift_First_Char
            ;Shift the character n times with division by 2
            ADD R0,R4,#0
            JSR PUSH        ;Push the character as the dividend onto the stack

            AND R0,R0,#0
            ADD R0,R0,#2
            JSR PUSH        ;Push 2 as the divisor onto the stack

            JSR PUSH        ;Push space for the return value

            JSR Divide  

            JSR POP         ;Pop the result from the stack
            ADD R4,R0,#0    ;Save that result in R4

            AND R0,R0,R3    ;Get the least significant bit of the result
            STR R0,R5,#-8   ;Save the least significant bit of the result on the stack

            JSR POP
            JSR POP         ;Pop the arguments

            ;The shift counter copy in the register is also used as the loop counter since its original value is on the stack
            ADD R2,R2,#-1   ;Decrement the shift counter until the character has been shifted n times
            BRp Shift_First_Char
        
        End_Shift_First_Char

    End_Read_First_Char

    ;Increment the shift counter, n, for the next character to be read
    LDR R2,R5,#-7
    ADD R2,R2,#1      ;Increment n

    ;Cycle the shift counter by mod 9
    ADD R0,R2,#0
    JSR PUSH          ;Push n as the argument (A) onto the stack

    AND R0,R0,#0
    ADD R0,R0,#9
    JSR PUSH          ;Push 8 as the argument (B) onto the stack

    JSR PUSH          ;Push space for the return value

    JSR Modulo        ;Calculate A mod B

    JSR POP
    ADD R2,R0,#0      ;Store the return value in R2

    BRp Dont_Reset_Counter2
    ;If the result of the modulo is 0, then reset the counter to 1 (to read the 1st least significant bit)
    ADD R2,R2,#1     

    Dont_Reset_Counter2
    JSR POP
    JSR POP           ;Pop off the arguments

    STR R2,R5,#-7     ;Update the value of the local variable for the shift counter

    Read_Second_Char
        ;Get the next character from the string
        ADD R1,R1,#1           ;Increment the pointer to get to the next character
        ST R1,charPointer      ;Update the character pointer static variable to point to the next character that should be used

        LDR R4,R1,#0           ;Copy the character into R4 to prepare for shifting and reading
        BRp Shift_Second_Char  ;Read the character if it is not the null terminator

        ;If the character is the null terminator, reset the character pointer to the first character in the string
        ;Then continue reading 
        LEA R1,StrSeed
        LDR R4,R1,#0

        ST R1,charPointer      ;Update the character pointer to point to the next character that should be used

        Shift_Second_Char
            ;Shift the character n times with division by 2
            ADD R0,R4,#0
            JSR PUSH        ;Push the character as the dividend onto the stack

            AND R0,R0,#0
            ADD R0,R0,#2
            JSR PUSH        ;Push 2 as the divisor onto the stack

            JSR PUSH        ;Push space for the return value

            JSR Divide  

            JSR POP         ;Pop the result from the stack
            ADD R4,R0,#0    ;Save that result in R4

            
            AND R0,R0,R3    ;Get the least significant bit of the result
            STR R0,R5,#-9   ;Save the least significant bit of the result on the stack

            JSR POP
            JSR POP         ;Pop the arguments

            ;The shift counter copy in the register is also used as the loop counter since its original value is on the stack
            ADD R2,R2,#-1   ;Decrement the shift counter until the character has been shifted n times
        BRp Shift_Second_Char

    End_Read_Second_Char

    ;Get the next character from the string
    ADD R1,R1,#1          ;Increment the pointer to get to the next character
    ST R1,charPointer     ;Update the character pointer to point to the next character that should be used


    ;Check if a random bit can be formed from the two read characters
    LDR R0,R5,#-8     ;Load the least significant bit of the first character
    LDR R4,R5,#-9     ;Load the least significant bit of the second character

    ;subtract the bits
    ;First negate the second bit
    NOT R4,R4
    ADD R4,R4,#1      ;R4 now holds the negative value of the second character's least significant bit

    ADD R4,R0,R4      ;Perform the subtraction

    BRz Do_Rand1          ;Read the next two characters if the two bits are the same

    BRp Return_One
    ;If the result is negative, then the two bits are 01 respectively, so return 0
    AND R0,R0,#0

    STR R0,R5,#0    ;Store zero in the return address of the caller
    BR End_Do_Rand1

    Return_One 
    ;If the result is positive, then the two bits are 10 respectively, so return 1
    AND R0,R0,#0
    ADD R0,R0,#1

    STR R0,R5,#0    ;Store one in the return address of the caller

End_Do_Rand1
End_Rand1
    ;Restore Saved context
    JSR POP
    JSR POP
    JSR Pop           ;Pop the local variables from the stack

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
  

;----------------------------------------------
;Subroutine Modulo - finds the remainder when dividing a non-negative number by a positive number
;
;implemented as A % B = A - (A/B) * B

;Data Dictionary:
;R0 - used for push and pop routines, holds the result of A mod B
;R1 - will hold 'A'
;R2 - will hold 'B'
;R5 - frame pointer
;R7 - Return address to caller

;Stack Frame:
;R5-4 - Saved R2
;R5-3 - Saved R1
;R5-2 - Saved R5
;R5-1 - Saved R7
;R5+0 - return value (will hold the value of A % B) 
;R5+1 - Parameter 2 (B)
;R5+2 - Parameter 1 (A)

Modulo
  ;First save context
  ADD R0,R7,#0
  JSR Push          ;save R7 since another routine is called

  ADD R0,R5,#0      ;save R5, important since this routine may be called from another routine.
  JSR Push

  ADD R5,R6,#2      ;make R5 point to return value 

  ADD R0,R1,#0
  JSR Push          ;save R1 since I will be using it

  ADD R0,R2,#0
  JSR Push          ;save R2 since I will be using it

Do_Modulo
  LDR R1,R5,#2      ;Load the first parameter(A) into R1
  LDR R2,R5,#1      ;Load the second parameter(B) into R2

  ;First calculate (A/B)
  ADD R0,R1,#0      ;Get the first parameter (dividend) to push as an argument onto the stack
  JSR PUSH          ;Push the argument onto the stack

  ADD R0,R2,#0      ;Get the second parameter (divisor) to push as an argument onto the stack
  JSR PUSH          ;Push the argument onto the stack

  JSR PUSH          ;push space for the return value

  JSR Divide        ;Calcualate (A/B)

  ;There's no need to pop the result (A/B) from the stack just yet since I will be using it immediately 
  ;Now calculate (A/B) * B by first pushing B from R2 onto the stack 

  ADD R0,R2,#0      
  JSR PUSH          ;Push B onto the stack

  JSR PUSH          ;push space for the return value

  JSR Multiply      ;Calcualate (A/B) * B

  JSR POP           ;Pop the result from the stack

  ADD R2,R0,#0      ;Store the result of (A/B) * B in R2 in preparation to calculate A mod B = A - (A/B) * B

  ;Pop all the rest of the arguments pushed onto the stack by this routine

  JSR POP 
  JSR POP 
  JSR POP
  JSR POP

  ;Now calculate A mod B = A - (A/B) * B
  ;R1 holds A
  ;R2 holds the result of (A/B) * B
  ;R0 holds the result of A - (A/B) * B which is A mod B
  NOT R2,R2
  ADD R2,R2,#1      ;R2 has now been flipped to its negative value (-(A/B) * B)

  ADD R0,R1,R2      ;R0 holds the output (A mod B)

  STR R0,R5,#0      ;Store the result of A mod B in the return value address of the caller

End_Do_Modulo
End_Modulo
  ;Restore Saved context
  JSR Pop           
  ADD R2,R0,#0      ;restore R2

  JSR Pop           
  ADD R1,R0,#0      ;restore R1

  JSR Pop           
  ADD R5,R0,#0      ;restore R5

  JSR Pop           
  ADD R7,R0,#0      ;restore R7
RET;

;---------------------------------------------------  
;Subroutine Multiply - Multiplies two numbers together

;Data Dictionary:
;R1 - will hold the first factor
;R2 - will hold the second factor
;R3 - will hold the local variable containing the Product
;R4 - scratch register
;R5 - frame pointer
;R7 - Return address to caller


;Stack Frame:
;R5-6 - Local variable for the product
;R5-5 - Saved R3
;R5-4 - Saved R2
;R5-3 - Saved R1
;R5-2 - Saved R5
;R5-1 - Saved R7
;R5+0 - return value (will hold the value of paramter 1 * parameter 2)
;R5+1 - Parameter 1 (first factor)
;R5+2 - Parameter 2 (second factor)  
Multiply
  ;First save context
  ADD R0,R7,#0
  JSR Push          ;save R7 since another routine is called

  ADD R0,R5,#0      ;save R5, important since this routine may be called from another routine.
  JSR Push

  ADD R5,R6,#2      ;make R5 point to return value 

  ADD R0,R1,#0
  JSR Push          ;save R1 since I will be using it

  ADD R0,R2,#0
  JSR Push          ;save R2 since I will be using it

  ADD R0,R3,#0
  JSR Push          ;save R3 since I will be using it

  AND R0,R0,#0      
  JSR Push          ;push #0 onto stack to initialize the local variable for the product

Do_Multiply
    LDR R1,R5,#1      ;Load the first factor into R1
    LDR R2,R5,#2      ;Load the second factor into R2

    BRZ End_Repeated_Add     ;If the second factor is 0, just return 0

    LDR R3,R5,#-6     ;Initialize the product to 0

    Repeated_Add
        ADD R3,R3,R1    ;increment the product by a factor of the the second parameter each time

        STR R3,R5,#-6   ;Update the local variable on the stack to hold the new product

        ADD R2,R2,#-1   ;Decrement the loop counter each time till it reaches zero
        BRP Repeated_Add

    End_Repeated_Add

End_Do_Multiply
End_Multiply
  ;Restore Saved context
  JSR Pop           ;Pop the local variable from the stack
  STR R0,R5,#0		  ;Store the result into the return value address of the caller

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


;---------------------------------------------------  
;Subroutine Divide - Divides a non-negative number by a positive number

;Data Dictionary:
;R1 - will hold the dividend
;R2 - will hold the divisor
;R3 - will hold the local variable containing the quotient
;R4 - scratch register
;R5 - frame pointer
;R7 - Return address to caller


;Stack Frame:
;R5-7 - Local variable for the quotient
;R5-6 - Saved R4
;R5-5 - Saved R3
;R5-4 - Saved R2
;R5-3 - Saved R1
;R5-2 - Saved R5
;R5-1 - Saved R7
;R5+0 - return value (will hold the value of paramter 1 / parameter 2)
;R5+1 - Parameter 2 (The divisor)
;R5+2 - Parameter 1 (The Dividend)  
Divide
    ;First save context
    ADD R0,R7,#0
    JSR Push          ;save R7 since another routine is called

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

    AND R0,R0,#0      
    JSR Push          ;push #0 onto stack to initialize the local variable for the quotient

Do_Divide
    LDR R1,R5,#2      ;Load the dividend into R1
    LDR R2,R5,#1      ;Load the divisor into R2

    ;Get the negative value of the divisor for division algorithm
    NOT R2,R2
    ADD R2,R2,#1      ;R2 holds (-Divisor)

    ADD R3,R1,R2             ;Check if the divisor <= the dividend
    BRN End_Repeated_Subtract     ;If the dividend is < the divisor then the result should just be zero

    LDR R3,R5,#-7     ;Initialize the quotient to zero

    Repeated_Subtract
        ADD R3,R3,#1    ;Increment the quotient
        STR R3,R5,#-7   ;Update the local variable on the stack to hold the new quotient

        ADD R1,R1,R2    ;Perform another step of division

        ;Keep dividing while the new dividend(after each step) >= the divisor
        ADD R4,R1,R2    ;Compare the new dividend with the divisor, R2 already holds (-divisor)

        BRZP Repeated_Subtract      ;Keep dividing while each (new) dividend is greater or equal to the divisor

    End_Repeated_Subtract

End_Do_Divide
End_Divide
  ;Restore Saved context
  JSR Pop           ;Pop the local variable from the stack
  STR R0,R5,#0		  ;Store the result into the return value address of the caller
    
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


;Constants required by print  
ASCII_MINUS_SIGN  .fill #45   ;ASCII CODE for '-'
ASCII_ZERO    .fill #48   ;ASCII CODE for '0'

;---------------------------------------------------  
;Subroutine Print - Prints the argument on the stack onto the console. Will print both postive and negative numbers and zero.

;Data Dictionary
;R0 -  Used for printing (should point to start of string before printing), and scratch register
;R5 - Frame pointer
;R6 - Stack Pointer
;R1 - parameter (which I call n)
;R2 - pointer to the local string allocated on the stack
;R3 - copy of the parameter value 
;R4 - holds result of division
;R7 - return address to caller

;Stack Frame:
;R5-13 - Start of string for holding number to be printed. 
;R5-6 - Saved R7
;R5-5 - Saved R4
;R5-4 - Saved R3
;R5-3 - Saved R2
;R5-2 - Saved R1
;R5-1 - Saved R5
;R5+0 - Number to be printed (which I'll call n)

  
Print
  ADD R0,R7,#0
  JSR Push          ;save R7 (since we will be using it)
  
  ADD R0,R5,#0      ;save R5, important since this routine may be called from another routine.
  JSR Push
  
  ADD R5,R6,#2      ;make R5 point to return value 

  ADD R0,R1,#0      ;save R1 (since we will be using it)
  JSR Push

  ADD R0,R2,#0
  JSR Push          ;save R2 (since we will be using it)

  ADD R0,R3,#0
  JSR Push          ;save R3 (since we will be using it)

  ADD R0,R4,#0
  JSR Push          ;save R4 (since we will be using it)


  ADD R6,R6,#-7     ;set aside 7 bytes on stack for string (number is at most 5 digits, optional -, and must have a null terminator)
  
  ADD R2,R5,#-8     ;point to end of allocated space for string
  AND R0,R0,#0      ;put #0 into R0
  STR R0,R2,#0      ;put ascii code 0 into end of string memory
  
    
  LDR R1,R5,#0      ;get arg (at R5+0)
  ADD R3,R1,#0      ;make a copy of the parameter
  ;need to determine if number is negative or not
  
  BRzp PosPrint
  
  NOT R1,R1         ;negate the negative 
  ADD R1,R1,#1      ;to get a positive number
                    ;will put in - sign at the end
PosPrint
  ADD R2,R2,#-1     ;R2 points to the spot in string to place next digit  

  ;We will use standard div/mod by 10 to extract the digits of n. 
  ;Also the string needs to be built backwards, starting list the least significant digit.
  ;For example, in the number 123, we need to get the 3 first, 2 second and the 1 last.

  ADD R0,R1,#0   
  JSR Push          ;push R1 onto stack
  AND R0,R0,#0      ;set R0 to 10
  ADD R0,R0,#10
  JSR Push          ;push #10 onto stack
  ADD R6,R6,#-1     ;set space for return value

  JSR Divide        ;divide number by 10

  JSR Pop
  ADD R1,R0,#0      ;R1 is now old R1 divide by 10

; no need to remove the arguments, we're using them again anyway
;  ADD R6,R6,#2      ;remove args from stack

  ADD R6,R6,#-1     ;set space for return value
  
  JSR Modulo        ;number mod 10

  JSR Pop           ;R0 contains the last digit of number

  ADD R6,R6,#2      ;remove args from stack
  
  LD R4,ASCII_ZERO
  ADD R0,R0,R4      ;R0 contains ASCII code for the digit
  STR R0,R2,#0      ;store the digit (ASCII Code) into the string

  ADD R1,R1,#0      ;test value of number n.
  BRp PosPrint      ;continue if it is positive

DonePrint

  ;deal with - sign if necessary 

  ADD R3,R3,#0      ;look at n (recall R3 contains it)
  BRzp NoMinus      ;see if it is non-negative, if so, do nothing
  
  ADD R2,R2,#-1     ;otherwise, add a '-' to the string.
  LD R0,ASCII_MINUS_SIGN
  STR R0,R2,#0
NoMinus
  ;Now print the string

  ADD R0,R2,#0      ;R0 now contains the 
  trap x22          ;print string.

  ADD R6,R6,#7      ;remove space for string on stack

  ;restore stack before returning

  JSR Pop
  ADD R4,R0,#0  ;retore R4

  JSR Pop
  ADD R3,R0,#0  ;retore R3

  JSR Pop       ;retore R2
  ADD R2,R0,#0

  JSR Pop
  ADD R1,R0,#0  ;retore R1

  JSR Pop       ;retore R5
  ADD R5,R0,#0

  JSR Pop
  ADD R7,R0,#0  ;retore R7

  RET
  
  .end
