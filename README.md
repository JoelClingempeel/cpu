# Basic RISC CPU

This project creates a basic RISC CPU without standard optimizations (pipelining, speculative execution, etc.).

### Registers:
 * A
 * B
 * C

### Instructions supported:
 * add(u)/sub(u)/mul(u)/div(u)/mod/not/and/or/xor reg, reg/literal
 * load/store reg
 * mov reg, reg/literal (signed only literals)
 * cmp reg, reg
 * halt
 * jmp/jz/jnz reg
 * nop

### Assembler usage:
`python assembler.py <file_name>`
<file_name> should have a .asm extension.

### Simulation:
To use the assembler output in a simulation, set the parameter `binary_file` near the top of `cpu_tb.v`.