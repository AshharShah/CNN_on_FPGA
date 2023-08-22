`include "riscv.v"

module riscv_tb;

    reg clk, rst;
    integer i;
    riscv core(clk, rst);

    always #1 clk = ~clk;

    initial
        begin
            $dumpfile("../vcd/riscv_pipeline.vcd");
            $dumpvars(4, riscv_tb);

            $readmemh("./set-instructions/binary-instructions.txt", core.insmem.memfile);

            clk = 0;

            #1
            rst = 1;

            #2
            rst = 0;

            #150 $finish;
        end
endmodule