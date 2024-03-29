# Instruction set extensions: Titan-2 #

Copyright (C) 2011 Toby Thain <toby@telegraphics.com.au>


For an example of these instructions in use, see [this directory](titan2/).


## ALU extension ##

Most arithmetic and logical instructions allow specification of source and destination
registers from a set of four. All ALU instructions update the sign, carry and zero flags.

    Opcode   Sign   Carry   Zero
    ------   ----   -----   ----
    ADD      *      *       *      
    SUB      *      *       *      [For SUB, carry flag can use same circuitry as ADD?]
    AND      *      clear   *      AND R,R can be used to clear carry flag  [optional feature]
    OR       *      set     *      OR R,R can be used to set carry flag     [optional feature]
    XOR      *      clear   *      [clearing flag is optional]
    NOT      *      clear   *      [clearing flag is optional]
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
    
    Syntax:             NOT R

The following three opcodes are open for future extension. Possibilities are *increment, decrement, 
shift right,* or *add carry bit.* Note that the latter would simplify long arithmetic, long shifts,
and byte sized rotates. Long arithmetic would be important to C (operations on values larger than a byte)
and so I have tentatively assigned `SHR` and `ADC`.

    Opcode        Dst
    ------------  ---
    0 1 0 1  0 1  D D   SHR R   Shift R right by one bit. Shift carry flag into high bit and low bit into carry.
    0 1 0 1  1 0  D D   ADC R   Add carry flag to register R.
    0 1 0 1  1 1  D D   ???     Not yet implemented.

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
offset by index register D *[can be changed - but should be a register accessible by ALU instructions].*

    Opcode   I  Src
    -------  -  -----
    1 1 1 0  0  S S S   Store source register (Z, A..G) in absolute location
             1  S S S   Store source register (Z, A..G) in absolute location offset by GPR D

    Syntax:             STM R, 0xZZZZ
                        STM R, 0xZZZZ[D]

    1 1 1 1  0  D D D   Load destination register (A..G) from absolute location
             1  D D D   Load destination register (A..G) from absolute location offset by GPR D

    Syntax:             LDM R, 0xZZZZ
                        LDM R, 0xZZZZ[D]

The interpretation of SSS and DDD can be according to the low three bits of register number:

    000 = Z   (load has no effect; store will set location to zero)
    001 = A
    010 = B
    ...
    111 = G


## Load constant ##

The `NOP` instruction is removed. (Instead, a pseudo instruction `NOP` can be assembled to `POP Z`.)

A new instruction, `LDC`, takes its place:

    Opcode    Dst
    -------   -------
    0 0 0 0   D D D D   Destination register (A..N; specifying Z will have no effect)
    X X X X   X X X X   Byte following instruction is the value to load
    
    Syntax:             LDC R, 0x19


## Subroutines ##

Since the lower four bits were unused by classic Titan, the `JMP` opcodes are broken down
into new operations.

    Opcode    Sub-op
    -------   -------
    1 0 0 1   0 0 0 0   JMP as defined by classic Titan (jump absolute)
              0 0 0 1   JPI as defined by classic Titan (jump indirect)
              1 0 0 0   JSR: push program counter and jump to absolute address
              X X X X   Remaining opcodes are not defined

The `JPI` instruction is removed and replaced by `RTS` (return from subroutine).

    1 0 1 0   0 0 0 0   RTS: pop program counter value, effecting a subroutine return
              X X X X   Remaining opcodes are not defined