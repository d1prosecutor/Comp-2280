;Assignment 1, Question 1
;This program computes the bitwise OR and XOR of two registers

;Register Dictionary
;R1, R2 - contains the two operands to OR
;R3 - contains the result of the OR
;R4 - contains the result of the XOR

  .orig x3000

  AND R3,R3,#0  ;clear results (not needed here, but always a good idea)
  AND R4,R4,#0

  LD R1,data1   ;retrieve operands to OR
  LD R2,data2
  
;Use De Morgan's rule to do the OR. ie NOT(A or B) = (NOT A) & (NOT B)

  NOT R1,R1     ;NOT A
  NOT R2,R2     ;NOT B
  AND R3,R1,R2  ;(NOT A) AND (NOT B)
  NOT R3,R3     ;A OR B

;With the OR we can now do the XOR = (A OR B) AND (NOT (A AND B))
  NOT R1,R1     ;restore A and B
  NOT R2,R2
  AND R4,R1,R2  ;A AND B
  NOT R4,R4     ;NOT(A AND B)
  AND R4,R4,R3  ;A XOR B

  halt

data1 .fill xff30
data2 .fill x3045
  
  .end

  