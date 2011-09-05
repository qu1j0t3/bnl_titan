/ Copyright (C) bootnecklad - All Rights Reserved 2011 
/ Counts as fast as possible while outputing to LED port

/initialise constants
   LDM 0x0006  /0x000B contains constant, 1
   MOV B,A     /B=1 Constant value
   CLR A       /Counting starts from 0
   0x01        /Constant, 1

/main loop
   ADD
   STM 0xFFFD  /Outputs to LED port
   JMP 0x0007  /Loops back


