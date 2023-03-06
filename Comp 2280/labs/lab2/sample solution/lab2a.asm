;COMP 2280
;Lab2, Q1 solution
;Read in a character, see if its last bit is 1.  If so, output the character.  If not,
;add 1 to the character ('s ascii code) and output the new character.

;Register Dictionary:
;R0 - Holds character read in.  Also holds address of strings to be displayed
;R1 - Holds a copy of character read in.  


  .orig  x3000      ;set origin

  lea    R0,prompt  ;get address of prompt
  trap   x22        ;display prompt
	
  trap   x20        ;read character from keyboard
	
  add    R1,R0,#0   ;copy R0 into R1	
  and    R1,R1,#1   ;determine value of last bit

  brz    bitis0     ;if R1 is 0 then go to else part
bitis1              ;if part
  trap   x21        ;output original character(which is in R0)
  br     endif      ;jump to endif (important)

bitis0              ;else part
  add    R0,R0,#1   ;add 1 to character
  trap   x21        ;print new character
endif
	
  lea    R0,eop     ;print end of processing msg
  trap   x22
	
  halt


prompt   .stringz "Enter a character:\n"
eop      .stringz "\nEnd of Processing.\n"

	.end	