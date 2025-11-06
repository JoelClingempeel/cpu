`timescale 1 ns / 10 ps

module cpu_tb();

// Set to the binary file produced by running the assembler.
parameter string BINARY_FILE = "fibonacci.bin";

reg clk = 0;
reg rst = 0;

// Set MEMORY_SIZE to the desired number of two byte words.
cpu #(.MEMORY_SIZE(32)) uut (
    .clk(clk),
    .rst(rst)
);

always begin
    # 41.667
    clk = ~clk;
end

initial begin
    # 10
    rst = ~rst;
    # 10
    rst = ~rst;
    $readmemb(BINARY_FILE, uut.mem);
end

initial begin
    $dumpfile("_build/default/cpu_tb.vcd");
    $dumpvars(0, uut);
    # 10000
    $finish;
end

endmodule