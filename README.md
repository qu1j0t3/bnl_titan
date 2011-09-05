bootnecklad is working on a processor he calls ["Titan"](http://marc.cleave.me.uk/cpu/index.htm).

Here's my assembler for it.

## Pre-requisites ##

 * It requires [Chicken Scheme](http://call-cc.org/).
 * Further, it requires the [lalr](http://wiki.call-cc.org/eggref/4/lalr) "egg".
   Install this from the command line: `chicken-install lalr`

## Quick start ##

 * `make all`
 * `csi -s titan.scm < input.asm`

## Known issues ##

 * The `CLR` opcode is not yet supported, but it exists in some source files.
 * The assembler currently uses standard input only.
 * There is no object file output. An object file format is not yet defined for Titan.

## Other things here ##

I've committed bootnecklad's original assembler source, *assembler.c*, to this project, 
since I feel it belongs under version control so that it can be completed collaboratively.
