`timescale 1 ns / 10 ps

module cpu_tb();

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
end

initial begin
    $dumpfile("_build/default/cpu_tb.vcd");
    $dumpvars(0, uut);
    # 10000
    $finish;
end

endmodule