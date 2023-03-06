;Example of Hello World for LC-3
;Prints Hello World.
;save as HelloWorld.asm

		.orig	x3000		;put the following instructions starting
							;at address 0x3000

		lea		r0, mesg	;load addr of mesg into register r0
		trap	x22			;print string pointed to by r0
		halt				;halt the program

mesg	.stringz "Hi, I'm excited to be here.\n"
		.end