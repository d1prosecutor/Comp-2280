;Course comp2280
;Assignment 1, Question 2
;This program computes the 2's complement negation of a number

;Register Dictionary
;R1 - contains the value to find 2's complement negation of 
;R2 - contains the negation of R1

	.orig x3000

	AND R2,R2,#0	;clear result (not needed here, but always a good idea)

	LD R1,data1	  ;retrieve value to find 2's complement negation of
	ADD R2,R1,#0	;move R1 into R2
			
;Use fact that -B =  (NOT B) + 1 (remember, encoding used is 2's complement)

	NOT R2,R2	    ;NOT B
	ADD R2,R2,#1	;Add 1 to (NOT B)
		
	halt

data1	.fill	xff30	;put whatever data you would like to test your pgm with.

	
	.end
