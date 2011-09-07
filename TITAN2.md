# Instruction set extensions: Titan-2 #

Copyright (C) 2011 Toby Thain <toby@telegraphics.com.au>


For an example of these instructions in use, see [this directory](titan2/).


## ALU extension ##

Most arithmetic and logical instructions allow specification of source and destination
registers from a set of four. All ALU instructions update the sign, carry and zero flags.

    Opcode   Sign   Carry   Zero
    ------   ----   -----   ----
    ADD      *      *       *      
    SUB      *      *       *
    AND      *      clear   *      AND R,R can be used to clear carry flag
    OR       *      set     *      OR R,R can be used to set carry flag     [optional feature]
    XOR      *      clear   *
    NOT      *      clear   *
    PSH, POP, JMP, JPI, JPZ, JPC, JPS, STM, LDM: flags unchanged
    
    * - Flags computed from result

### ADD, SUB, AND, OR, XOR ###

    Opcode   Src  Dst
    -------  ---  ---
    X X X X  S S  D D   XXXX is the opcode for ADD, SUB, AND, OR, XOR
                        SS and DD, decoded as 0..3, identify registers A..D

    Operation:          Dst <-- Dst <op> Src

    Syntax:             ADD dst, src

#### Notes ####

1.  `XOR R,R` and `SUB R,R` set R to zero in one byte. The assembler can therefore optimise
    `CLR A..D`. To set zero without touching flags, `MOV Z,R`.

2.  `ADD R,R` is a left shift, rotating high bit into carry.

3.  The null operations `AND R,R` and `OR R,R` can be used to set processor flags according to R
    (zero, sign). Carry flag is cleared or set, respectively.

### NOT ###

The `NOT` operation is a special case, since only the destination register is specified.

    Opcode   Src  Dst
    -------  ---  ---
    0 1 0 1  0 0  D D   Destination register DD (see above) is replaced by its binary complement.
    
    Syntax:             NOT A

The following three opcodes are open for future extension. Possibilities are *increment, decrement, 
shift right,* or *add carry bit.* Note that the latter would simplify long arithmetic
and also allow a simple implementation of bit rotates.

    0 1 0 1  0 1  D D
    0 1 0 1  1 0  D D
    0 1 0 1  1 1  D D

The four registers are mapped according to the 2 select bits as follows:

    00 = D
    01 = A
    10 = B
    11 = C

*If it simplifies the circuitry, then use registers D..G instead. This allows the top two register select bits
to be hard-wired.*

## Indexed addressing mode ##

The memory load and store instructions (`LDM` and `STM`) are extended to operate on
any of eight GPRs (A..H) and given an optional index mode which uses the absolute address
offset by index register H. (I have chosen H for index register for no good reason
other than its low 3 bits are zero.)

    Opcode   I  Src
    -------  -  -----
    1 1 1 0  0  S S S   Store source register (A..H) in absolute location
             1  S S S   Store source register (A..H) in absolute location offset by GPR H

    Syntax:             STM S, 0xZZZZ
                        STM S, 0xZZZZ[H]

    1 1 1 1  0  D D D   Load destination register (A..H) from absolute location
             1  D D D   Load destination register (A..H) from absolute location offset by GPR H

    Syntax:             LDM D, 0xZZZZ
                        LDM D, 0xZZZZ[H]

The interpretation of SSS and DDD can be according to the low three bits of register number:

    000 = Z   (load has no effect; store will set location to zero)
    001 = A
    010 = B
    ...
    111 = G


## Load constant ##

The `NOP` instruction is removed. (Instead, a pseudo instruction `NOP`
can be assembled to `POP Z`.)

A new instruction, `LDC`, takes its place:

    Opcode
    -----------------
    0 0 0 0   D D D D   Destination register (A..N; specifying Z will have no effect)
    X X X X   X X X X   Byte following instruction is the value to load
    
    Syntax:             LDC A, 0x19
