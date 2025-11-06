module alu(
    input wire [3:0] alu_op,
    input wire [7:0] alu_operand1,
    input wire [7:0] alu_operand2,
    output reg [7:0] alu_out
);

localparam ALU_OP_ADDU = 4'd0;
localparam ALU_OP_SUBU = 4'd1;
localparam ALU_OP_MULU = 4'd2;
localparam ALU_OP_DIVU = 4'd3;
localparam ALU_OP_MOD = 4'd4;
localparam ALU_OP_NOT = 4'd5;
localparam ALU_OP_AND = 4'd6;
localparam ALU_OP_OR = 4'd7;
localparam ALU_OP_XOR = 4'd8;
localparam ALU_OP_ADD = 4'd9;
localparam ALU_OP_SUB = 4'd10;
localparam ALU_OP_MUL = 4'd11;
localparam ALU_OP_DIV = 4'd12;

always @(*) begin
    case (alu_op)
        ALU_OP_ADDU: begin
            alu_out = alu_operand1 + alu_operand2;
        end
        ALU_OP_SUBU: begin
            alu_out = alu_operand1 - alu_operand2;
        end
        ALU_OP_MULU: begin
            alu_out = alu_operand1 * alu_operand2;
        end
        ALU_OP_DIVU: begin
            alu_out = alu_operand1 / alu_operand2;
        end
        ALU_OP_MOD: begin
            alu_out = alu_operand1 % alu_operand2;
        end
        ALU_OP_NOT: begin
            alu_out = ~alu_operand1;
        end
        ALU_OP_AND: begin
            alu_out = alu_operand1 & alu_operand2;
        end
        ALU_OP_OR: begin
            alu_out = alu_operand1 | alu_operand2;
        end
        ALU_OP_OR: begin
            alu_out = alu_operand1 ^ alu_operand2;
        end
        ALU_OP_ADD: begin
            alu_out = $signed(alu_operand1) + $signed(alu_operand2);
        end
        ALU_OP_SUB: begin
            alu_out = $signed(alu_operand1) - $signed(alu_operand2);
        end
        ALU_OP_MUL: begin
            alu_out = $signed(alu_operand1) * $signed(alu_operand2);
        end
        ALU_OP_DIV: begin
            alu_out = $signed(alu_operand1) / $signed(alu_operand2);
        end
        default: begin
            alu_out = 8'd0;
        end
    endcase
end

endmodule