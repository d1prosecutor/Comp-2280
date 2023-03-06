 ;/***************************************************************************************
 ;* NAME: Chukwunaza Chukwuocha
 ;* STUDENT NUMBER: 7928676
 ;* COURSE: COMP 2280, SECTION: A02
 ;* INSTRUCTOR: Emanuel Wiens
 ;* ASSIGNMENT: Lab 1, QUESTION: 2
 ;*
 ;* REMARKS: This program takes a Number(n) as input and calculates the sum of the first 
 ;			 'n' positive integers
 ;***************************************************************************************/

.orig x3000

;Preparing to print the header banner in output
;R0 Stores header banner
LEA R0 HEADER
PUTS; Print the header banner

;Clearing R2 to hold the sum
AND R2,R2,X0000

;Store the loop counter in R1
LD R1, DATA1

;End the loop if the counter is <=0 to begin with
BRNZ ENDWHILE

	;Start Loop
	WHILE
		ADD R2,R2,R1 ;Sum the number contained in R1(DATA) at each iteration of the loop and store in R2
		ADD, R1, R1, #-1 ;Decrement the loop counter
	BRP WHILE; Keep looping if the counter is still > 0

ENDWHILE

;Prepraing to print the endOfProgram Message
;R0 Stores endofProgram Message
LEA R0 ENDOFPGM
PUTS ; Print the EndOfPgm message stored in R0

HALT;

;Input
DATA1 .FILL #0
;Strings to print in the output
HEADER: .STRINGZ "NAME: Chukwunaza Chukwuocha\nSTUDENT NUMBER: 7928676\nCOURSE: COMP 2280, SECTION: A02\nINSTRUCTOR: Emanuel Wiens\nASSIGNMENT: Assignment 1, QUESION: 1\n\n"

ENDOFPGM: .STRINGZ "\nEnd of Program!\n"

.END

