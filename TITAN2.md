# Proposed extended Titan #

## ALU extension ##

All arithmetic and logical instructions will allow specification of source and destination
registers from a set of four.

### Instruction format ###

    Opcode   Src  Dst
    -------  ---  ---
    X X X X  S S  D D   XXXX is the opcode for ADD, SUB, AND, OR, XOR
                        SS and DD, decoded as 0..3, identify registers A..D [or D..G*]

The operation performed is

    Dst <-- Dst <op> Src

The assembler syntax is

    ADD dst, src

The NOT opcode is a special case, since only the destination register is specified.

    Opcode   Src  Dst
    -------  ---  ---
    0 1 0 1  0 0  D D   Destination register DD (see above) is replaced by its complement.

These variants are open for future extension. Possibilities are INC and DEC.
    0 1 0 1  0 1  D D
    0 1 0 1  1 0  D D
    0 1 0 1  1 1  D D

(* - If it is a simpler circuit, the four register set referenced by this extension
can be D..G, as this can use the register select bits directly. This is preferable to
H..K because it should overlap the eight register set addressable by LDM and STM.)
    00 = D
    01 = E
    10 = F
    11 = G

## Indexed addressing mode ##

The memory load and store instructions (LDM and STM) are extended to store any of a set of eight
GPRs (A..H) and given an optional index mode which uses the absolute address offset by index
register A.

    Opcode   I  Src
    -------  -  -----
    1 1 1 0  0  S S S   Store source register (A..H) in absolute location
             1  S S S   Store source register (A..H) in absolute location offset by GPR H

    STM S, 0xHHHH
    STM S, 0xHHHH[A]

    1 1 1 1  0  D D D   Load destination register (A..H) from absolute location
             1  D D D   Load destination register (A..H) from absolute location offset by GPR H

    LDM D, 0xHHHH
    LDM D, 0xHHHH

The interpretation of SSS and DDD can be according to the low three bits of register number:
    000 = H
    001 = A
    010 = B
    ...
    111 = G

I have chosen H for index register for no good reason other than its low 3 bits are zero.


## Load constant ##

The NOP instruction is removed. For assembly purposes, a pseudo instruction NOP can be assembled
to one of the following null operations:

    POP Z
    AND R, R
    OR R, R
    etc

A new instruction, LDC, takes its place:

    Opcode
    -----------------
    0 0 0 0   D D D D   Destination register (A..N)
    X X X X   X X X X   Byte following instruction is the value to load
