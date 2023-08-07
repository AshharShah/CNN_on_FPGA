//`include "counter.v"

module tb_counter;

reg clk;
reg rst;
reg inc;
reg dec;
wire [3:0] count;

counter uut(clk, rst, inc, dec, count);

initial 
    begin
        clk = 1;
        forever #5 clk = ~clk;    
    end

initial
    begin
        $dumpfile("mycounter.vcd");
        $dumpvars(1, tb_counter);

        rst = 0;
        inc = 0;
        dec = 0;

        @ (posedge clk)
            rst <= #1 1;

        @ (posedge clk)
            #1 rst = 0;

        @ (posedge clk)
            # 1 inc <= 1;

        repeat(2) @ (posedge clk);
            #1  inc = 0;
                dec = 1;

        @ (posedge clk)
            #1  dec = 0;

        $display("Count: %d", count);

        repeat(20) @ (posedge clk);
        
    end

endmodule
