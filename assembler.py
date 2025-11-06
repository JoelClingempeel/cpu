import sys

alu_ops = {"addu": 0,
           "subu": 1,
           "mulu": 2,
           "divu": 3,
           "mod": 4,
           "not": 5,
           "and": 6,
           "or": 7,
           "xor": 8,
           "add": 9,
           "sub": 10,
           "mul": 11,
           "div": 12}
registers = {"A": 0,
             "B": 1,
             "C": 2}

if (len(sys.argv) != 2):
    print("Usage: python %s <file>" % sys.argv[0])
    print("<file> should have a .asm extension.")
    sys.exit()

out = []
in_file = sys.argv[1]
with open(in_file) as f:
    for line in f:
        tokens = line.split()
        instruction = tokens[0]
        operand1 = tokens[1] if len(tokens) > 1 else ""
        operand2 = tokens[2] if len(tokens) > 2 else ""
        operand1 = operand1.replace(",", "")
        if instruction in alu_ops:
            # ALU opcode format:
            # [dest (2 bits)][use_alu (1 bit)][use_register (1 bit)][alu_op (4 bits)]
            if operand2 in registers:
                # 0b11 sets use_alu flag to 1 and use_register flag to 1.
                opcode = (registers[operand1] << 6) + (0b11 << 4) + alu_ops[instruction]
                operand = registers[operand2]
            else:  # Second operand is an immediate.
                # 0b10 sets use_alu flag to 1 and use_register flag to 0.
                opcode = (registers[operand1] << 6) + (0b10 << 4) + alu_ops[instruction]
                operand = int(operand2)
        elif instruction in ("load", "store"):
            # LOAD/STORE opcode format:
            # [dest (2 bits)][1 for load or 2 for store (6 bits)]
            load_or_store = 1 if instruction == "load" else 2
            opcode = (registers[operand1] << 6) + load_or_store
            operand = int(operand2)
        elif instruction == "mov":
            # MOV opcode format:
            # [dest (2 bits)][0 (1 bit)][use_register (1 bit)][8 (4 bits)]
            if operand2 in registers:
                opcode = (registers[operand1] << 6) + (0b1 << 4) + 8
                operand = registers[operand2]
            else:
                opcode = (registers[operand1] << 6) + 8
                operand = int(operand2)
        elif instruction == "cmp":
            # CMP opcode format:
            # [dest (2 bits)][3 (6 bits)]
            opcode = (registers[operand1] << 6) + 3
            operand = registers[operand2]
        # Instructions halt, jmp, jz, jnz, and nop have a single opcode.
        elif instruction == "halt":
            opcode = 4
            operand = 0
        elif instruction == "jmp":
            opcode = 5
            operand = int(operand1)
        elif instruction == "jz":
            opcode = 6
            operand = int(operand1)
        elif instruction == "jnz":
            opcode = 7
            operand = int(operand1)
        elif instruction == "nop":
            opcode = 0
            operand = 0
        out.append(bin((opcode << 8) + operand)[2:])

out_file = in_file.replace(".asm", ".bin")
with open(out_file, 'w') as f:
    f.write('\n'.join(out))
