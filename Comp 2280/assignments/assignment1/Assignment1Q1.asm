 ;/***************************************************************************************
 ;* NAME: Chukwunaza Chukwuocha
 ;* STUDENT NUMBER: 7928676
 ;* COURSE: COMP 2280, SECTION: A02
 ;* INSTRUCTOR: Emanuel Wiens
 ;* ASSIGNMENT: Assignment 1, QUESTION: 1
 ;*
 ;* REMARKS: This program performs a bitwise OR followed by a bitwise XOR on the data
 ;			 in DATA1 and DATA2 and stores the result in R3 and R4 respectively.
 ;			 The inputs expected are hardcoded(not prompted) 16-bit numbers stored in Data1
 ;			 and DATA2.
 ;***************************************************************************************/

.orig x3000

;Preparing to print the header banner in output
;R0 Stores header banner
LEA R0 HEADER
PUTS; Print the header banner

; bitwise OR
	;Store the two numbers(operands) in R1 and R2

	;R1 Stores Data1
	;R2 Stores Data2
	LD R1, Data1
	LD R2, Data2	

	;Perform the 'OR' operation on the operands stored in R1 and R2 and store the result in R3
	;Perform and Store (NOT R1) in R1
    NOT R1, R1

	;Perform and Store (NOT R2) in R2
	NOT R2, R2

	;Perform and Store (R1' NAND R2') ->(which gives R1 OR R2) in R3
	AND R3, R1, R2
	NOT R3, R3

;bitwise XOR
	;Store the two numbers(operands) in R1 and R2 (Overwites whatever junk is in R1 and R2)
	
	;R1 Stores Data1
	;R2 Stores Data2
	LD R1, Data1
	LD R2, Data2
	
	;Perform the 'XOR' operation on the operands stored in R1 and R2 and store the result in R4
	;Perform and store (R1 NAND R2) in R4
	AND R4, R1, R2
	NOT R4, R4

	;Perform and store (R3 AND R4) in R4
	; Uses the value of (Data1 OR Data2) already calculated in the OR section(stored in R3)
	AND R4, R3, R4 

;Prepraing to print the endOfProgram Message
;R0 Stores endofProgram Message
LEA R0 ENDOFPGM
PUTS ; Print the EndOfPgm message stored in R0

HALT;

;Input operands
Data1 .FILL x0001
Data2 .FILL x0000

;Strings to print in the output
HEADER: .STRINGZ "NAME: Chukwunaza Chukwuocha\nSTUDENT NUMBER: 7928676\nCOURSE: COMP 2280, SECTION: A02\nINSTRUCTOR: Emanuel Wiens\nASSIGNMENT: Assignment 1, QUESION: 1\n\n"

ENDOFPGM: .STRINGZ "\nEnd of Program!\n"

.END

