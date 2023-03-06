.orig	x3000
and		r3,r3,x0	;clear R3

and		r1,r1,x0
add		r1,r1,x5	;r1 is set to 5

and 	r2,r2,x0
add		r2,r2,x6	;r2 is set to 6

add		r3,r1,r2	;r3 <- r1 + r2

halt
.end