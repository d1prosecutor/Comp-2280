 ;/***************************************************************************************
 ;* NAME: Chukwunaza Chukwuocha
 ;* STUDENT NUMBER: 7928676
 ;* COURSE: COMP 2280, SECTION: A02
 ;* INSTRUCTOR: Emanuel Wiens
 ;* ASSIGNMENT: Assignment 3, QUESTION: 2
 ;*
 ;* REMARKS: This program merges two sorted arrays, Data1 of size n1 and Data2 of size n2,
 ; 			 into the array 'Result', and prints the contents of Result after merging.
 ;***************************************************************************************/

;R0 is used for I/O operations
;R1 holds the pointer to the first sorted array
;R2 holds the pointer to the second sorted array
;R3 holds the pointer to the resulting sorted array
;R4 is used to count the number of items left in both arrays
;R5 Holds the loop counter which is the sum of the sizes of the two sorted arrays
;R6 holds the curent data of Array1
;R7 holds the curent data of Array2

.orig x3000

	;Preparing to print the header banner in output
	;R0 Stores header banner
	LEA R0 HEADER
	PUTS; Print the header banner

;    private static void merge(int[] arr, int start, int mid, int end, int[] TEMP)
;    {
;        //Pointers for the Left and Right sub-arrays and Current Index of the temp array respectively
;        int currL = start;
;        int currR = mid;
;        int currIndex;
		
		;R1 holds the pointer to the first sorted array
		;R2 holds the pointer to the second sorted array
		;R3 holds the pointer to the resulting sorted array
		LEA	R1, Data1
		LEA	R2, Data2
		LEA	R3, Result		

	;        for (currIndex = start; currIndex < end; currIndex++)

		;We're working on all the elements of two Sorted arrays (instead of two halves of one sorted array as in H.L.L)
		;so the index range is the sum of their lengths
		;R1 is equivalent to the start of the first half of the one array('TEMP' in H.L.L)
		;R2 is equivalent to the start of the second half of the same array(TEMP) in H.L.L
		;R3 is equivalent to currIndex

		;R5 Holds the loop counter which is the sum of the sizes of the two sorted arrays
		;This is equivalent to the number of values in the 'TEMP' Array being currently worked on
		LD	R5, Length; R5 = numItems
		
		BRNZ ENDPRINT; If the size of the resulting array is <=0, don't merge or print

		;R4 is used to count the number of items left in both arrays
		WHILE

	;            if (start < mid && (currR >= end || arr[currL] < arr[currR]))

			IF 
				;Store the number of items left to copy from array1 in R4
				;If array1 has been completely copied over, just go and copy
				;from the second array
				LD R4, n1
				BRNZ ELSE

				;Check if array2 has items left to copy
				;If it doesnt, just copy from Array 1 without comparing

				;First Store the number of items left to copy from array2 in R4
				;If array2 has been completely copied over, just go and copy
				;from the second array
				LD	R4, n2
				BRNZ COPY_ARRAY1

				;Store the current data of the two arrays
				;R6 holds the curent data of Array1
				;R7 holds the curent data of Array2
				LDR	R6,	R1, #0 
				LDR R7, R2, #0

				;Negate the value in the second array
				NOT	R7, R7
				ADD R7, R7, #1

				ADD	R0,	R6, R7;

				;If the result is positive then copy the data from the second array
				BRP ELSE

				COPY_ARRAY1
				;If the result is positive then the current data in Array1 is bigger 
				;-> Copy that data to the result array

				;Get the current data in the first array 
				LDR R6, R1, #0

	;                temp[currIndex] = arr[currL];
				;Then copy the data into the result array
				STR R6, R3, #0

	;                currL++;
				;Move the pointer of Array1 -> The current array that was just copied from
				;To point to the next value in this array
				ADD	R1, R1, #1

				;Decrement the number of items left to copy from Array1 and store that value back in 'n1'
				LD	R4, n1
				ADD	R4, R4, #-1
				ST	R4, n1; update the number of items left to copy from arr1

			BR ALWAYS_DO

	;              else
			ELSE
				;Get the current data in the second array 
				LDR R7, R2, #0

	;                temp[currIndex] = arr[currR];
				;Then copy this data to the result array
				STR R7, R3, #0

	;                currR++;
				;Move the pointer of Array2 -> The current array that was just copied from
				;To point to the next value in this array
				ADD	R2, R2, #1

				;Decrement the number of items left to copy from Array2 and store that value back in 'n2'
				LD	R4, n2
				ADD	R4, R4, #-1
				ST	R4, n2; update the number of items left to copy from arr2

			;This block will always be run no matter what condition was met
			;It updates the pointer to the next free location in the resulting array to copy to
			;It is always updated because in each iteration, one value is always copied into the resulting array
			ALWAYS_DO

			;Move the pointer of the result array to point to the next
			;Location to copy a value into
			ADD	R3, R3, #1; currIndex++

			;Decrement the loop counter to indicate that another location in the resulting array was
			;successfully copied to.
			ADD R5, R5, #-1; numItems--

			;Keep looping and copying if all values have not been copied
			BRP WHILE
		
		;}//end merge
		ENDWHILE


	;Print out the resulting array
	;R2 Holds the counter for the index of the resulting array
	;R3 points to the start of the resulting array
	AND	R2, R2, #0
	LEA	R3, Result; R3 = arrPtr

	PRINT
		;copy each value from this array to R0 in order to print it
		LDR	R0, R3, #0

		;Print the current value
		OUT;

		;Increment the array Pointer and array Counter
		ADD	R3, R3, #1; arrPtr ++;
		ADD	R2, R2, #1; i++
		
		;Compare the loop counter with the size of the result array to checck if the iteration is over
		;R1 holds the negative of the maximum index of the result array for comparison
		;R4 holds the result of this comparison
		LD	R1, length
		ADD	R1, R1, #-1;Decrement to get the max Index of the array from the length of the array

		;Now negate this max index in R1
		NOT	R1, R1
		ADD	R1, R1, #1

		;Now compare the current index with the max Index of the array to check if the iteration is complete
		ADD	R4, R1, R2

	BRNZ PRINT; Keep printing while the counter != length of the result array

	ENDPRINT

	;Prepraing to print the endOfProgram Message
	;R0 Stores endofProgram Message
	LEA R0 ENDOFPGM
	PUTS ; Print the EndOfPgm message stored in R0

	HALT;

;The two sorted arrays
n1    .fill   14     
Data1 .fill   x20    
      .fill   x2A
      .fill   x2A 
      .fill   x30
      .fill   x34
      .fill   x38
      .fill   x3F
      .fill   x5A
      .fill   x5C 
      .fill   x5E 
      .fill   x60
      .fill   x69
      .fill   x6E
      .fill   x7B

n2    .fill   7      
Data2 .fill   x2A    
      .fill   x2E 
      .fill   x30
      .fill   x3F
      .fill   x5B
      .fill   x7D
      .fill   x7E

;My result array (Empty at first) 
Length	.fill	#21; Length of my result array
Result	.BLKW	#21


;Strings to print in the output
HEADER: .STRINGZ "NAME: Chukwunaza Chukwuocha\nSTUDENT NUMBER: 7928676\nCOURSE: COMP 2280, SECTION: A02\nINSTRUCTOR: Emanuel Wiens\nASSIGNMENT: Assignment 1, QUESION: 1\n\n"
OUTPUT: .STRINGZ "The number of rounds is : "
ENDOFPGM: .STRINGZ "\n\nEnd of Program!\n"

.END

