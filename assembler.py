import sys

alu_ops = {"add": 0,
           "sub": 1,
           "mul": 2,
           "div": 3,
           "mod": 4,
           "not": 5,
           "and": 6,
           "or": 7,
           "xor": 8}
registers = {"A": 0,
             "B": 1,
             "C": 2}

if (len(sys.argv) != 2):
    print("Usage: python %s <file>" % sys.argv[0])
    sys.exit()
with open(sys.argv[1]) as f:
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
        elif instruction == "halt":
            opcode = 4
            operand = 0
        elif instruction == "nop":
            opcode = 0
            operand = 0
        print(bin((opcode << 8) + operand))
