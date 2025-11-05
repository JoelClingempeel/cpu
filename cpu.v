module cpu(
    input wire clk,
    input wire rst
);

parameter MEMORY_SIZE = 32;  // In two byte words
// Apply mask to strip destination bits from instructions.
parameter [7:0] STRIP_DEST_MASK = 8'b00111111;

// Storage
reg [7:0] registers [2:0];
reg [15:0] mem [0:MEMORY_SIZE-1];
reg [$clog2(MEMORY_SIZE)-1:0] pc = 0;
reg [7:0] load_store_buffer;
reg load_flag;
reg store_flag;
reg zero_flag;
reg halted;

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

// For individual byte access instead of via 2 byte words
wire [7:0] word_addr = operand >> 1;
wire high_or_low = operand % 2;

integer i;  // For initializing memory

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Only initialize memory to 0 if synthesizing.
        // In simulations, the test bench reads from a file.
        `ifdef SYNTHESIS
            for (i = 0; i < MEMORY_SIZE; i++) begin
                mem[i] <= 16'b0;
            end
        `endif
        registers[0] <= 8'b101;
        registers[1] <= 8'b0;
        registers[2] <= 8'b0;
        pc <= 8'b0;
        load_store_buffer <= 8'b0;
        load_flag <= 1'b0;
        store_flag <= 1'b0;
        zero_flag <= 1'b0;
        halted <= 1'b0;
    end else if (!halted) begin
        // Use two cycle load/store to handle single port RAM.
        // Load/Store Cycle 2: Load/store update when flag is set.
        if (load_flag) begin
            registers[destination] <= load_store_buffer;
            load_flag <= 0;
            pc <= pc + 1'b1;
        end else if (store_flag) begin
            if (high_or_low == 1'b1) begin
                mem[word_addr][15:8] <= load_store_buffer;
            end else begin
                mem[word_addr][7:0] <= load_store_buffer;
            end
            store_flag <= 0;
            pc <= pc + 1'b1;
        // Load/Store Cycle 1: Copy data to buffer and set flag.
        end else if ((op_code & STRIP_DEST_MASK) == 8'd1) begin  // LOAD
            if (high_or_low == 1'b1) begin
                load_store_buffer <= mem[word_addr][15:8];
            end else begin
                load_store_buffer <= mem[word_addr][7:0];
            end
            load_flag <= 1'b1;
            zero_flag <= 1'b0;
        end else if ((op_code & STRIP_DEST_MASK) == 8'd2) begin  // STORE
            load_store_buffer <= registers[destination];
            store_flag <= 1'b1;
            zero_flag <= 1'b0;
        // For ALU instructions, write ALU output to destination register.
        end else if (use_alu) begin
            registers[destination] <= alu_out;
            pc <= pc + 1'b1;
            zero_flag <= 1'b0;
        end else if ((op_code & STRIP_DEST_MASK) == 8'd3) begin  // CMP
            zero_flag <= (registers[destination] == registers[operand]);
            pc <= pc + 1'b1;
        end else if (op_code == 8'd4) begin  // HALT
            halted <= 1'b1;
            zero_flag <= 1'b0;
        end else if (op_code == 8'd5) begin  // JMP
            pc <= operand;
            zero_flag <= 1'b0;
        end else if (op_code == 8'd6) begin  // JZ
            if (zero_flag == 1'b1) begin
                pc <= operand;
            end else begin
                pc <= pc + 1'b1;
            end
            zero_flag <= 1'b0;
        end else if (op_code == 8'd7) begin  // JNZ
            if (zero_flag == 1'b0) begin
                pc <= operand;
            end else begin
                pc <= pc + 1'b1;
            end
            zero_flag <= 1'b0;
        end else begin
            pc <= pc + 1'b1;
            zero_flag <= 1'b0;
        end
    end
end

endmodule