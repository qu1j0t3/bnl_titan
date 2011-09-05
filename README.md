[bootnecklad](https://github.com/bootnecklad) is working on a homebrew processor
he calls [Titan](http://marc.cleave.me.uk/cpu/index.htm).

Here's my assembler for it.

## Pre-requisites ##

 * It requires [Chicken Scheme](http://call-cc.org/).
 * Further, it requires the [lalr](http://wiki.call-cc.org/eggref/4/lalr) "egg".
   Install this from the command line: `chicken-install lalr`

## Quick start ##

 * `make all`
 * `csi -s titan.scm < samples/counter.asm`

## Known issues ##

 * The assembler currently uses standard input only.
 * There is no object file output. An object file format is not yet defined for Titan.
 * Only backward label references are allowed, because there is currently
   only one assembly pass. This means that the sample files will not yet assemble.

## Links ##

 * bootnecklad's [assembler project](https://github.com/bootnecklad/Titan-Assembler)

