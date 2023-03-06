 ;/***************************************************************************************
 ;* NAME: Chukwunaza Chukwuocha
 ;* STUDENT NUMBER: 7928676
 ;* COURSE: COMP 2280, SECTION: A02
 ;* INSTRUCTOR: Emanuel Wiens
 ;* ASSIGNMENT: Lab 1, QUESTION: 1
 ;*
 ;* REMARKS: This program takes a charcter as input and prints the character if its last bit 
 ;			 is set, else it prints the next bit
 ;***************************************************************************************/

.orig x3000

;Preparing to print the header banner in output
;R0 Stores header banner
LEA R0 HEADER
PUTS; Print the header banner

;Get the input character (ascii) from the user
TRAP X20

;Get the last bit of that value gotten from the user
AND R1,R0,X0001

	;If the last bit is a 1 then print out the charcter
	BRZ ELSE
		TRAP X21
	BR ENDIF

	;Else if the last bit is a zero then add 1 to the character and then print it
	ELSE
		ADD R0,R0,x0001
		TRAP X21
	ENDIF

;Prepraing to print the endOfProgram Message
;R0 Stores endofProgram Message
LEA R0 ENDOFPGM
PUTS ; Print the EndOfPgm message stored in R0

HALT;

;Strings to print in the output
HEADER: .STRINGZ "NAME: Chukwunaza Chukwuocha\nSTUDENT NUMBER: 7928676\nCOURSE: COMP 2280, SECTION: A02\nINSTRUCTOR: Emanuel Wiens\nASSIGNMENT: Assignment 1, QUESION: 1\n\n"

ENDOFPGM: .STRINGZ "\nEnd of Program!\n"

.END

