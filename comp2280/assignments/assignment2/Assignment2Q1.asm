 ;/***************************************************************************************
 ;* NAME: Chukwunaza Chukwuocha
 ;* STUDENT NUMBER: 7928676
 ;* COURSE: COMP 2280, SECTION: A02
 ;* INSTRUCTOR: Emanuel Wiens
 ;* ASSIGNMENT: Assignment 2, QUESTION: 1
 ;*
 ;* REMARKS: This program that permutes the bits of the 16-bit data item stored in the
 ;*			 memory location Data by a number defined in the location Writestep. 
 ;*			 It performs this permuting operation on the resulting word until the result
 ;*			 returns to the value in Data
 ;***************************************************************************************/

.orig x3000

;Preparing to print the header banner in output
;R0 Stores header banner
LEA R0 HEADER
PUTS; Print the header banner

;R3 Stores the value of the Vraiable DATA which is to be permuted
LD R3, DATA

;Make a copy of the original value of DATA and store in TEMPDATA
;This TEMP DATA variable will contain the Actual number to keep permuting through the rounds
ST R3, TEMPDATA

;R1 stores the output - (number of rounds taken to return to original value)
AND R1,R1,x0000; set R1 to 0

;R2 is the address where the individual bits will be copied to
AND R2, R2, x0000; set R2 to 0

	LOOP1
		; Reinitialize the register R3 to hold the value of 'DATA'
		LD R3, DATA

		; Reinitialize the register R4 to hold the initial value of 'WRITESTEP'
		LD R4, WRITESTEP

		;Calculate Data - R2(Result) to check if the numbers are the same (if Data-result = 0)

		;First get '-R2'
		;Perform the 2's Complement Negation of the value in R2 and store the result in R2
		NOT R2, R2
		ADD R2, R2, x0001;R2 stores (NOT(R2) + 1)

		;check if Data + R2 = 0 (R2 stores a negative number at this point)
		ADD R5, R3, R2

		BRZ ENDLOOP1; END LOOP if the RESULT is same as DATA

		;;If the RESULT is not Same as DATA then another round of permutes is needed
		
		;Load in the new DATA to be permuted (TEMPDATA)
		LD R3, TEMPDATA

		; Reinitialize the register R2 to 0 for new permutation copying
		AND R2, R2, x0000; set R2 to 0

		;Increment the value of the rounds counter stored in R1
		ADD R1, R1, x0001

		;Create a bit mask which will be used to copy the bits, R6 holds this mask
		; starting from the least significant bit
        LD R6, ONE; Load 1 into R6 which will signify the L.S.B		

		LOOP2
		    ;;Copy the individual bits of Data starting from the least significant
			;Store the current individual bit to be copied from DATA(R3) in R5
			AND R5, R3, R6
			
			;SHIFT that bit to be copied WRITESTEP times to the left
			;
			ST R4 TEMPWRITESTEP;First store a copy of the current value of the writestep

			ADD R4, R4, #0 ;This is just to make R4 the most recently modified recent register to set 
			;the Condition Code
			
			;If the value of the loop counter in R4 (writestep) is zero to begin with,
			;don't shift the bits
			BRZ ENDSHIFT
			WHILE 

				;If R5 (Bit to be copied is zero entering the loop, nothing is to be changed)
				;Just keep decrementing the loop counter
	
				ADD R5,R5,#0 ;This is just to make R5 the most recently modified recent to set
				;the Condition Code

				BRZ NO_CHANGE; If the copy bit zero, just decrement counter	

            	LD R5, ONE
					
				;The ROTATE block rotates a bit by moving it to the left each time the rotate loop is run
			 	ROTATE
					ADD R5, R5, R5

					;When R5 goes to Zero, that individual bit's position needs to be reset
					;back to the least significant bit (extreme right)
					BRZ RESET

					;If R5 is still positive or Negative, then then position is still within range -> continue
					ADD R4, R4, #-1

					;When the loop counter goes to zero, exit the loop by branching to ENDSHIFT
					BRZ ENDSHIFT

				BRP ROTATE

				;The RESET Block resets the rotation(permutation) of a bit back to the position of
				;least significant bit(extreme right) 
				RESET 
					LD R5, ONE
					ADD R4, R4, #-1
					
					;When the loop counter goes to zero, exit the loop by branching to ENDSHIFT
					BRZ ENDSHIFT
				BR ROTATE

				;The NO_CHANGE block does nothing to the bit so it just decrements the loop counter 
				;to zero so that the loop can terminate immediately
				NO_CHANGE
					AND R4, R4, 0
			ENDSHIFT

			;;Copy that bit over to the result address (R2) using bitwise OR
				;;Perform the 'OR' operation on the operands stored in R2 and R5 and store the result in R2

				;Perform and Store (NOT R2) in R2
				NOT R2, R2

				;Perform and Store (NOT R5) in R5
				NOT R5, R5

				;Perform and Store (R2 NAND R5) ->(which gives R2 OR R5) in R2
				AND R2, R2, R5
				NOT R2, R2

				;Store this new permutation in TEMPDATA
				ST R2, TEMPDATA

				;Shift the bit mask(stored in R6) to the left to copy the next least signifiant bit from DATA
				ADD R6, R6, R6

			;Monitor when all 16 bits have been copied by checking if the bit mask has overflown to negative.
			;Since it overflows to negative(17 bits), just the 16-bits of zeroes are stored in LC-3,
			;Hence, the bitmask should be zero when all bits have been copied
			BRZ LOOP1; Branch back to the outer loop when all the 16 bits from DATA have been copied

			;If all the 16 bits have not been copied then to find the next location to 
			;copy to, increment TEMPWRITESTEP by WRITESTEP
			LD R0, WRITESTEP
			LD R4, TEMPWRITESTEP; Copy the tempwritestep back to the writestep register
			ADD R4, R0, R4; add the original value of WRITESTEP to its current (temporary) value
			
		BR LOOP2
			
	ENDLOOP1

;Prepearing to print out the number of rounds it took to permute the number given in DATA
ST	R1, NUMROUNDS
LEA R0, OUTPUT
PUTS
LD	R0, ZERO
ADD	R0, R0, R1

OUT; Print out the result as an ascii character

;Prepraing to print the endOfProgram Message
;R0 Stores endofProgram Message
LEA R0 ENDOFPGM
PUTS ; Print the EndOfPgm message stored in R0

HALT;

;Input operands
DATA .FILL x0001
WRITESTEP .FILL #3
ONE .FILL #1
ZERO .FILL #48

;Storing the temporary values for data and writestep which will be used in permuting
TEMPDATA .BLKW 1
TEMPWRITESTEP .BLKW 1
NUMROUNDS .BLKW 1

;Strings to print in the output
HEADER: .STRINGZ "NAME: Chukwunaza Chukwuocha\nSTUDENT NUMBER: 7928676\nCOURSE: COMP 2280, SECTION: A02\nINSTRUCTOR: Emanuel Wiens\nASSIGNMENT: Assignment 1, QUESION: 1\n\n"
OUTPUT: .STRINGZ "The number of rounds is : "
ENDOFPGM: .STRINGZ "\n\nEnd of Program!\n"

.END

