 ;/***************************************************************************************
 ;* NAME: Chukwunaza Chukwuocha
 ;* STUDENT NUMBER: 7928676
 ;* COURSE: COMP 2280, SECTION: A02
 ;* INSTRUCTOR: Emanuel Wiens
 ;* ASSIGNMENT: Assignment 1, QUESTION: 2
 ;*
 ;* REMARKS: This program performs a 2's complement negation on the data
 ;			 in DATA1  and stores the result in R2.
 ;			 The input expected is a hardcoded(not prompted) 16-bit number stored in Data1.
 ;***************************************************************************************/

.orig x3000

;Preparing to print the header banner in output

;R0 Stores header banner
LEA R0 HEADER
PUTS; Print the header banner
	
	;Perform the 2's Complement Negation of the input in Data1
	;and store the result in R2

	;R1 Stores Data1, then NOT(Data1)
	LD R1, Data1
	NOT R1, R1

	;R2 stores NOT(Data1) + 1
	ADD R2, R1, x0001


;Prepraing to print the endOfProgram Message
LEA R0 ENDOFPGM
PUTS ; Print the EndOfPgm message stored in R0

HALT;

;Input Operand
Data1 .FILL x0001

;Strings to print in the output
HEADER: .STRINGZ "NAME: Chukwunaza Chukwuocha\nSTUDENT NUMBER: 7928676\nCOURSE: COMP 2280, SECTION: A02\nINSTRUCTOR: Emanuel Wiens\nASSIGNMENT: Assignment 1, QUESION: 2\n\n"

ENDOFPGM: .STRINGZ "\nEnd of Program!\n"

.END