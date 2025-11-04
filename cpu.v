module cpu(
    input wire clk,
    input wire rst
);

parameter MEMORY_SIZE = 16;  // In bytes

// Storage
reg [7:0] registers [2:0];
reg [15:0] mem [0:MEMORY_SIZE-1];
reg [$clog2(MEMORY_SIZE)-1:0] pc = 0;

// Getting opcode and operand (1 byte each)
// (For two operand instructions like "ADD A, 3", the first operand
//  is always a register and is encoded in the opcode byte.)
wire [15:0] full_instruction = mem[pc];
wire [7:0] op_code = full_instruction[15:8];
wire [7:0] operand = full_instruction[7:0];

// ALU opcode format:
// [dest (2 bits)][use_alu (1 bit)][use_register (1 bit)][alu_op (4 bits)]
// (Data always flows through, but with use_alu off the output is not
//  written anywhere.)
wire [3:0] alu_op = op_code[3:0];
wire use_register = op_code[4];
wire use_alu = op_code[5];
wire [1:0] destination = op_code[7:6];
wire [7:0] alu_operand1 = registers[destination];
wire [7:0] alu_operand2 = (use_register == 1'b1) ? registers[operand[1:0]] : operand;
wire [7:0] alu_out;
alu my_alu(
    .alu_op(alu_op),
    .alu_operand1(alu_operand1),
    .alu_operand2(alu_operand2),
    .alu_out(alu_out)
);

// These wires are not strictly needed but useful to track register values
// in a simulator.
wire [7:0] A_reg;
wire [7:0] B_reg; 
wire [7:0] C_reg;
assign A_reg = registers[0];
assign B_reg = registers[1];
assign C_reg = registers[2];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        mem[0] <= 16'b0010000000101010;
        mem[1] <= 16'b0010000100000011;
        mem[2] <= 16'b0010000000101010;
        mem[3] <= 16'b0010011000110000;
        mem[4] <= 16'b0;
        mem[5] <= 16'b0111000000000000;
        mem[6] <= 16'b1011000000000001;
        mem[7] <= 16'b0;
        registers[0] <= 8'b0;
        registers[1] <= 8'b101;
        registers[2] <= 8'b1;
        pc <= 8'b0;
    end else if (use_alu) begin
        // For ALU instructions, write ALU output to destination register.
        registers[destination] <= alu_out;
        pc <= pc + 1'b1;
    end else begin
        // TODO: Implement load/store, halt, jump, and conditional jump.
        pc <= pc + 1'b1;
    end
    
end

endmodule