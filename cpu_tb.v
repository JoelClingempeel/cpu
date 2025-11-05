`timescale 1 ns / 10 ps

module cpu_tb();

// Set to the binary file produced by running the assembler.
parameter string binary_file = "simple_test.bin";

reg clk = 0;
reg rst = 0;

cpu uut (
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
    $readmemb(binary_file, uut.mem);
end

initial begin
    $dumpfile("_build/default/cpu_tb.vcd");
    $dumpvars(0, uut);
    # 10000
    $finish;
end

endmodule