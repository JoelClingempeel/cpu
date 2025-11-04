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
        instruction, operand1, operand2 = line.split()
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
            print(bin((opcode << 8) + operand))
