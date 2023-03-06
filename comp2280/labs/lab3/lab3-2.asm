 ;/***************************************************************************************
 ;* NAME: Chukwunaza Chukwuocha
 ;* STUDENT NUMBER: 7928676
 ;* COURSE: COMP 2280, SECTION: A02
 ;* INSTRUCTOR: Emanuel Wiens
 ;* ASSIGNMENT: Lab 1, QUESTION: 2
 ;*
 ;* REMARKS: Your program should print the letter A if user enters '0', 
 ;			 and prints Z if user enters '1'.  The letters A and Z are stored in chr1 and chr2 respectively,
 ;			 and are accessed using chrPtr1 and chrPtr2 using indirecting addressing instruction LDI.
 ;			 DO NOT access chr1,chr2 directly, but instead do it indirectly. This program takes a Number(n) 
 ; 			 as input and calculates the sum of the first 'n' positive integers
 ;***************************************************************************************/
  .orig x3000
	GETC 

	;Check if the user enters a 0
	LD	R1, zero
	ADD R1, R0, R1
	BRZ PRINT_A; Print A if the character entered was '0'
	
	;If the user didn't enter 0, check if '1' is entered
	LD	R1, one
	ADD R1, R0, R1
	BRZ PRINT_Z; Print Z if the input character was '1'

	;Else print nothing (Branch to the end)
	BR END_CONDITION

	PRINT_A
		LDI R0, chrPtr1
		OUT;
	BR END_CONDITION

	PRINT_Z
		LDI R0, chrPtr2
		OUT;

  END_CONDITION
  halt


chrPtr1  .fill  chr1    ; note the label to define the pointer -- let the assembler figure out the location
chrPtr2  .fill  chr2    ; the location that will change as we add/remove code

chr1     .fill  #65 ;'A'
chr2     .fill  #90 ;'Z'

zero     .fill  #-48
one		 .fill	#-49

  .end