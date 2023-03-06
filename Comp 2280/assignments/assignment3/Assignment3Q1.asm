 ;/***************************************************************************************
 ;* NAME: Chukwunaza Chukwuocha
 ;* STUDENT NUMBER: 7928676
 ;* COURSE: COMP 2280, SECTION: A02
 ;* INSTRUCTOR: Emanuel Wiens
 ;* ASSIGNMENT: Assignment 3, QUESTION: 1
 ;*
 ;* REMARKS: This program Implements the given circular linked list, traverses the linked 
 ;			 linked list and prints out the data(as ASCII character) of each Node in it. 
 ;***************************************************************************************/
	;R0 is used for I/O
	;R1 holds the address of the current node being pointed to
	;R2 holds the data contained by the current node being pointed to by R1
	;R3 holds the copy of the adress of TOP for comparison purposes
	;R4 holds the result of the comparison between R1(current Node address) and R3(TOP node address)

	.orig x3000

	;Preparing to print the header banner in output
	;R0 Stores header banner
	LEA R0 HEADER
	PUTS; Print the header banner

	;Load the address of the top of the circular linked list into R1
	;R1 holds the address of the current node being pointed to
	LEA	R1, TOP; R1 == curr

	;Make a copy of the address of TOP so we can keep track of when the list has been traversed
	;R3 holds the copy of the adress of TOP
	ADD	R3, R1, #0;
	
	;Make the copy of the address negative for "equals" comparison
	;R3 HOLDS -R1
	NOT R3, R3; first flip the bits
	ADD R3, R3, #1; 2's complement negation

WHILE_NOT_BACK_AT_TOP
	;R2 holds the data contained by the current node being pointed to by R1
	LDR	R2, R1, #0; R2 = curr(R1)->data

	;Print out the data in the current node
	;First move this data from R2 to R0 in order to print
	ADD	R0, R2, #0; R0 = R2
	OUT;

	;Increment the offset of R1 so as to get the pointer to the next node
	LDR	R1, R1, #1; curr == curr->next

	;Compare the address of the current node with the top node to check if the 
	;Traversal has been completed
	;R4 holds the result of the comparison between R1(current Node address) and R3(TOP node address)
	ADD	R4, R1, R3
BRNP WHILE_NOT_BACK_AT_TOP; Keep traversing until top is returned to
	

	;Prepraing to print the endOfProgram Message
	;R0 Stores endofProgram Message
	LEA R0 ENDOFPGM
	PUTS ; Print the EndOfPgm message stored in R0

	HALT;

;Nodes in the circular linked list
TOP		.FILL	#65
		.FILL	NODE6
NODE2	.FILL	#71
		.FILL	NODE3
NODE3	.FILL	#73
		.FILL	NODE4
NODE4	.FILL	#76
		.FILL	TOP
NODE5	.FILL	#69
		.FILL	NODE2
NODE6	.FILL	#67
		.FILL	NODE5


;Strings to print in the output
HEADER: .STRINGZ "NAME: Chukwunaza Chukwuocha\nSTUDENT NUMBER: 7928676\nCOURSE: COMP 2280, SECTION: A02\nINSTRUCTOR: Emanuel Wiens\nASSIGNMENT: Assignment 1, QUESION: 1\n\n"
OUTPUT: .STRINGZ "The number of rounds is : "
ENDOFPGM: .STRINGZ "\n\nEnd of Program!\n"

.END

