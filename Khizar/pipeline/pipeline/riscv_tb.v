`include "riscv.v"

module riscv_tb;

    reg clk, rst;
    riscv core(clk, rst);

    always #1 clk = ~clk;

    initial
        begin
            $dumpfile("../vcd/riscv_pipeline.vcd");
            $dumpvars(4, riscv_tb);

            $readmemh("./set-instructions/ins.txt", core.insmem.memfile);

            clk = 0;

            #1
            rst = 1;

            #15
            rst = 0;



            #350 $finish;
        end

endmodule