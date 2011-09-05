/ Will count up to the nth number of Fibonacci.
/ Copyright (C) sppt

 
#Initialize
LDM 0x0017
MOV C,A		/ Current number (Fn-1)
LDM 0x0018
MOV D,A		/ Previous number	(Fn-2)
CLR A		
LDM 0x0019
MOV E,A		/ Loop amount
CLR A
0x01			/ Constant, initial value curr
0x00			/ Constant, initial value prev
0x06			/ Variable n, 0 < n < F
 
/ Decrease the amount of loops to do,
/ Jump to end if 0
#Main
MOV A,E
JPZ #Output	/ Jump to output routine when Loop Amount = 0
LDM 0x0014	/ A <-- 1
MOV B,A		/ B <-- 1
MOV A,E		/ A <-- Loop amount
SUB			/ A <-- Loop Amount - 1
 
MOV E,A		/ E <-- Loop Amount - 1

/ Add Fn-1 and Fn-2
MOV A,C		/ A <-- Fn-1
MOV B,D		/ B <-- Fn-2
ADD				/ Add Fn-1 and Fn-2
MOV D,C		/ Store Fn-1 in Fn-2
MOV C,A		/ Store Fn in Fn-1
JMP	#Main	/ Back to beginning of Main


#Output
NOP
MOV A,C		/ A <-- Current
STM 0xFFFD	/ Output current number to LEDs
NOP
JMP #Output  / Jump to NOP to prevent premature ending of program


