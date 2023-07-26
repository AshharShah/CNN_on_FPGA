`include "riscv.v"

module riscv_tb;

    reg clk, rst;
    riscv core(clk, rst);
    
    always #1 clk = ~clk;

    initial
        begin
            $dumpfile("../vcd/riscv.vcd");
            $dumpvars(2, riscv_tb);

            $readmemh("ins", core.uutA.memfile);
            
            #1
            clk = 0;

            #1
            rst = 1;

            #3
            rst = 0;

            #200 $finish;
        end

endmodule