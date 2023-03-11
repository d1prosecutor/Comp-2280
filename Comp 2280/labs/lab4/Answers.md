###  My result for the fibonacci of the input n is stored in R4.
<br />

#### When n = 24. The result is -19168, which is the two's complement interpretation of fib(24) = 46368,
#### so it essentially overflows into a negative number  whenm n=24 which might not necessarily mean that the result is incorrect.
<br />

#### For all greater values than 24, ie n>24, the result of fib(n) would be too big to store in a 16-bit system like LC-3,
#### Hence, the result would not be incorrect even if the 2's complement integer was interpreted as an unsigned integer.
<br />

#### As long as the stack is big enough to contain all the activation records being created by the recursive calls, the result is consistent.
<br />

#### On the other hand, if there is not enough space to contain all the activation records created by the recursive calls in the program,  
#### the stack blows into my code and data section, then my program will eventually try to execute some data on the stack  
#### as if it was an instruction (because an instruction was previously located in that memory address), and the program will fail, giving a  
#### 'Priviledge mode violation' error.  
<br />

#### Note that however when i use stack base xffff (specifically), the result doesn't show for any input n whatsoever