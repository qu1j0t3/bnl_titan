/ Copyright (C) bootnecklad - All Rights Reserved 2011 
/ Outputs a string from a pointer and returns to an address
/ (Started by bootnecklad, corrected by his human compiler THANKS JULIAN!,
/  finished by bootnecklad)

/Initialise Constants
  LDM 0x0053  /0x0053 contains a constant, value 1
  MOV A,H     /H=1 Constant value 1
  LDM 0x0052  /0x0052 contains length of ASCII string, dec 10
  MOV A,M     /M is the loop counter. Set M to length of ASCII string


/Setup pointer to chars
  LDM 0x0055  /Gets Low byte of address of first char
  STM 0x0037  /Store Low Byte of address of first char in 0x002f
  LDM 0x0056  /Gets high byte of address of first char
  STM 0x0036  /Store high Byte of address of first char in 0x002e


/Setup return address
  LDM 0x0057  /Gets low byte of return address
  STM 0x0043  /Stores low byte of return address in 0x003a
  LDM 0x0058  /Gets high byte of return address
  STM 0x0042  /Stores low byte of return address in 0x003b


/Main Loop
  LDM 0x0054  /0x0054 holds ASCII value for 'A'
  MOV A,B     /Sets B=65, ie ASCII value for 'A'
  LDM 0x0000  /Get value of the offset of the current char into Acc (0000 is only a dummy address)
  0x0         /High Byte of address of current char
  0x0         /Low byte of address of current char
  ADD         /Add current char offset to ASCII value for 'A' Creates correct ASCII value
  STM 0xfffe  /Outputs ASCII value to serial port one
  MOV H, B    /Moves H to B, ie Sets B=1
  MOV M,A     /Moves M to A, A=M
  SUB         /Decrements loop count
  JPZ 0x0000  /If counter=0, end loop, return address here (0000 is only a dummy address)
  MOV A,M     /Save decremented loop count in M. ie number of loops to go
  LDM 0x0037  /Get Low Byte of address of current char
  MOV H,B     /Moves H to B, ie Sets B=1
  ADD         /Increments pointer to address of next char
  STM 0x0037  /Stores address of next char in 0x002f
  JMP 0x0030  / Jump to start of loop


/Data
  0x0A        /Length of string
  0x01        /Constant, value 1
  0x41        /ASCII Value for 'A'
  0x59        /Low byte of address of first char
  0x00        /High byte of address of first char
  0x00        /Low byte of return address
  0x00        /High byte of return address


/String
  0x07        /H, defined as number of chars on from 'A'
  0x04        /E
  0x0b        /L
  0x0b        /L
  0x0e        /O
  0xDF        /Space, Using twos complement, 41+DF=20, 20=ASCII Space
  0x16        /W
  0x0e        /O
  0x11        /R
  0x0B        /L
  0x03        /D


