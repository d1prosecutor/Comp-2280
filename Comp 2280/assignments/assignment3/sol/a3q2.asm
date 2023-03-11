;Assignment 3, question 2 sample solution
;LC-3 implementation of merging two arrays
;high level pseudo code

;rx = size(Result)
;ix = size(Data1)
;jx = size(Data2)
;while ix>=0 and jx>=0 do
;  if Data1[ix] > Data2[jx] then
;    Result[rx] = Data1[ix]
;    rx--
;    ix--
;  else
;    Result[rx] = Data2[jx]
;    rx--
;    jx--
;  end if
;end do

;Either Data1 or Data2 may have elements left so we need to consume them
;Note: only one will have elements left
;
;while ix>=0 do
;  Result[rx] = Data1[ix]
;  rx--
;  ix--
;
;while jx>=0 do
;  Result[rx] = Data2[jx]
;  rx--
;  jx--

;register dictionary
;-------------------
;R0 - used for reading/printing and scratch register
;R1 - rx, scratch after setting the base register
;R2 - ix
;R3 - jx
;R4 - base register for Result
;R5 - base register for Data1
;R6 - base register for Data2
;R7 - scratch

  .orig x3000

;initialize element counts for each list
  LD   r2,n1
  LD   r3,n2
  ADD  r1,r2,r3

  ADD  r2,r2,#-1
  ADD  r3,r3,#-1
  ADD  r1,r1,#-1

;initialize base registers to point at the *end* of each list
  LEA  r4,Result
  ADD  r4,r4,r1
  LEA  r5,Data1
  ADD  r5,r5,r2
  LEA  r6,Data2
  ADD  r6,r6,r3

while
;read values and determine which to merge
  LDR  r0,r5,#0
  LDR  r7,r6,#0

  NOT  r1,r7
  ADD  r1,r1,#1
  ADD  r1,r1,r0  ;compare by subtraction
  BRnz else
if
;put Data1[ix] into Result and move Data1's pointer
  STR  r0,r4,#0  
  ADD  r5,r5,#-1
  ADD  r2,r2,#-1
  BR   endif
else
;put Data2[jx] into Result and move Data2's pointer
  STR  r7,r4,#0  
  ADD  r6,r6,#-1
  ADD  r3,r3,#-1
endif
  ADD  r4,r4,#-1 ;always move Result's pointer
    
;are we done yet? Both cases must be true to keep going
  ADD  r0,r2,#0
  BRn  consumeData2 ;Data1 is empty so go ahead with Data2

  ADD  r0,r3,#0
  BRzp while

consumeData1
  LDR  r0,r5,#0
  STR  r0,r4,#0 
  ADD  r4,r4,#-1 
  ADD  r5,r5,#-1
  ADD  r2,r2,#-1
  BRzp consumeData1
  BR   printArray

consumeData2
  LDR  r0,r6,#0
  STR  r0,r4,#0  
  ADD  r4,r4,#-1 
  ADD  r6,r6,#-1
  ADD  r3,r3,#-1
  BRzp consumeData2

printArray      ;print merged array
  LEA R0,titleStr ;nice header text
  trap x22            

;reset size of result array
  LD   r2,n1
  LD   r3,n2
  ADD  r1,r2,r3

  LEA  r4,Result
  AND  r2,r2,#0  ;# of elements processed 
printLoop
  LDR  r0,r4,#0  ;get character at address in R4
  trap x21      ;print current data element (as an ASCII character)
  ADD  r4,r4,#1  ;move to next element
  ADD  r2,r2,#1  ;increment # of elements processed

  NOT  r5,r2     ;compute negative of R2
  ADD  r5,r5,#1  ;and store in R5

  ADD  r5,r1,r5  ;compute n - R2

  BRp  printLoop ;branch if there are still elements to be processed.
done
  halt

titleStr .stringz "merged list: "

Result .blkw  21
n1    .fill   14     ;# of data points
Data1 .fill   x20    ;test data
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

n2    .fill   7      ;# of data points
Data2 .fill   x2A    ;test data
      .fill   x2E 
      .fill   x30
      .fill   x3F
      .fill   x5B
      .fill   x7D
      .fill   x7E

  .end
