/ Single LED runs on the LED port
/ Copyright (C) sppt

/ NAME: Running Light
/ AUTHOR: SPPT
/ DATE: 15-JUNE-2011

#Init
0x01  ;Variable, Bit Pattern on start
0x01  ;Constant, 1

;first resets A and puts 1 into B.
#Main_Loop
LDM 0x0000
MOV B,A
STM 0xFFFD
JMP #Shift_Left

#On_Carry
LDM 0x0001   ;1
ADD
MOV B,A

#Shift_Left  ;How the hell am I gonna shift? Add A+B with B=A ?
ADD
MOV B,A
JPC On_Carry ;ADD 0x01 to A
STM 0xFFFDDERP ;Output current number to LEDs

#Wait
CLR A
NOT         ;inverts 0, thus putting 255 into A
MOV B,C     ;B=1
SUB         ;-1 from loop
PSH A       ;Pushes loop remainder onto stack
XOR         ;Checks for equality
JPZ Shift_left  ;If equal, loop is over, returns to MAIN loop
POP         ;Pops loop remainder back into A
JMP Main_loop  ;returns to looping


