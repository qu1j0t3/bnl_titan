/ Copyright (C) bootnecklad

/ Continuously counts from 0 to 255 with a wait loop so the user can see the incrementation.

			
/initialise constants
   LDM 0x0005  /0x contains constant, 1
   MOV B,A     /B used for incrementation
   0x01        /255 Constant
   CLR A       /Counting starts from 0

/main loop
   ADD
   STM 0xFFFD  /Outputs to LED port
   PSH A       /Pushes current value onto stack for storage
   JMP 0x0025  /Jumps to wait loop
   POP A       /Pops counting value into A
   JMP 0x0009  /Continues counting

/wait loop
   CLR A
   NOT         /inverts 0, thus putting 255 into A
   MOV B,C     /B=1
   SUB         /-1 from loop
   PSH A       /Pushes loop remainder onto stack
   XOR         /Checks for equality
   JPZ 0x0021  /If equal, loop is over, returns to main loop
   POP A       /Pops loop remainder back into A
   JMP 0x0029  /returns to looping
