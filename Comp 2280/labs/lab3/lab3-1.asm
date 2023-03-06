 ;/***************************************************************************************
 ;* NAME: Chukwunaza Chukwuocha
 ;* STUDENT NUMBER: 7928676
 ;* COURSE: COMP 2280, SECTION: A02
 ;* INSTRUCTOR: Emanuel Wiens
 ;* ASSIGNMENT: Lab 3, QUESTION: 1
 ;*
 ;* REMARKS: This program computes the maximum value stored in the array Data 
 ;			(whose length is given by label n), and puts the value in R3
 ;***************************************************************************************/

.orig   x3000

	;Store the loop counter (length of the data array) in R0
	AND R0, R0, #0; Clearing R0
	LD	R0,n

	;Store the address of the start of the array in R2
	LEA R1, Data

	; Getting the First value in the array and setting it as the initial max
	LDR R3, R1, #0; Keeping the offset at zero since i will be changing the base register
	ST	R3, currMax
	
	;Now loop from the end of the array till the start 
	LOOP
		;Store the current max in R3 to use for comparison
		LD R3, currMax; 

		; Getting the next value in the array
		LDR R4, R1, #0; Keeping the offset at zero since we will be changing the base register

		ADD R1, R1, #1; Changing the base register to point to the next value in the array

		; Calculating (currMax(R3) - currValue(R5))
		; negating the current value being read from the array and storing it in R5
		NOT	R5, R4
		ADD R5, R5, #1;
		ADD R3, R3, R5;

		;If the result is positive/Zero then the value of the current maximum remains unchanged
		BRZP NO_CHANGE

			;Else the new value being read is the current max and we need to update the address
			;holding the max value with the current value being read (stored in R4)
			ST	R4, currMax;

		NO_CHANGE
		ADD R0, R0, #-1; Decrementing the loop counter

	BRP LOOP; Kepp looping while within the bounds of the array

	;Store the max value in R3 after looping (when the max has been found)
	LD R3, currMax

HALT

Data  .fill 3 ;array of data values
      .fill 10
      .fill 6
      .fill 9
      .fill 7

n     .fill 5 ;length of Data array

currMax	.blkw 1

  .end