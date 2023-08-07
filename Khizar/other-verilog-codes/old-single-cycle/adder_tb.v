`include "adder.v"

module adder_tb;

    reg [31:0] in1, in2;
    wire [31:0] out;

    adder uut(in1, in2, out);

    initial 
        begin
            $dumpfile("./vcd/adder_tb.vcd");
            $dumpvars(1, adder_tb);

            #1
            in1 = 32'b0000_0000_0000_0000_0100_0000_0100_0000;
            in2 = 32'b0000_0000_0000_0100_0100_0000_0000_1111;

            #1
            $display("out: %d", out);  

            #1
            in1 = 32'b0000_0000_0000_0000_0000_0000_0000_1111;
            in2 = 32'b0000_0000_0000_0000_0000_0000_0000_1111;

            #1
            $display("out: %d", out);        
        end

endmodule