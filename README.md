# Basic RISC CPU

This project creates a basic RISC CPU without standard optimizations (pipelining, speculative execution, etc.).

### Registers:
 * `A`
 * `B`
 * `C`
 * `D`

### Instructions supported:
 * `add(u)/sub(u)/mul(u)/div(u)/mod/not/and/or/xor reg, reg/literal`
 * `load/store reg`
 * `mov reg, reg/literal` (signed only literals)
 * `cmp reg, reg`
 * `halt`
 * `jmp/jz/jnz/jg/jl reg` (signed only for `jg/jl`)
 * `nop`

### Assembler usage:
`python assembler.py <file_name>` \
<file_name> should have a .asm extension.

### Simulation:
To use the assembler output in a simulation, set the parameters `BINARY_FILE` and `MEMORY_SIZE` near the top of `cpu_tb.v`. Note that `MEMORY_SIZE` is the number of *two byte words*.

### Demo programs:
 * `simple_test.asm` - demonstrates using various instructions.
 * `fibonacci.asm` - computes Fibonacci numbers by iteratively mapping (A, B) <- (A + B, A) using C as a counter and D as a temporary buffer.
   - This stops after 11 loop iterations because after that A would overflow.