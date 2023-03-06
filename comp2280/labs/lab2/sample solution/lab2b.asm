;COMP 2280 
;Lab 2, Question 2
; sums the values from 1 to M[data] and holds it in register R2

;Register Dictionary:
;R0 - Holds address of strings to be displayed
;R1 - Holds the current loop counter value. 
;R2 - Holds the sum


  .orig x3000     ;set origin

  and   R2,R2,#0  ;initialize sum to 0
  ld    R1,data   ;get initial loop counter value from memory
  brz   endwhile
loop
  add   R2,R2,R1  ;add counter value to sum
  add   R1,R1,#-1 ;decrement loop counter
  brp   loop      ;branch to top of loop if loop counter is still positive
endwhile
	
  lea   R0,eop    ;print end of processing message
  trap  x22

  halt

data    .fill     #12
eop     .stringz  "\nEnd of Processing.\n"

  .end	