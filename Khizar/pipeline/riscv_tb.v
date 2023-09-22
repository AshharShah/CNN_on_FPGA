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

            //$readmemh({"./set-instructions/test-", test_case_number, ".hex"}, core.insmem.memfile);
            $readmemh("./set-instructions/corrected-test-18.hex", core.insmem.memfile);


            clk = 0;

            #1
            rst = 1;

            #2
            rst = 0;

            #1000 $finish;
        end
endmodule