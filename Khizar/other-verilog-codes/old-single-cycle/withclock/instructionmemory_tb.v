`include "instructionmemory.v"

module instructionmemory_tb;

    reg [9:0] pc;
    reg clk;
    
    wire [31:0] instruction;

    instructionmemory uut(clk, pc, instruction);

    always @( posedge clk )
        begin
            $display("pc: %d, ins--: %d", pc, instruction);
            pc <= pc + 1;
        end

    always
        #2 clk = ~clk;

    initial
        begin
            $dumpfile("../vcd/instructionmemory_tb.vcd");
            $dumpvars(1, instructionmemory_tb);

            clk = 0;
            pc  = 0;

            #140 $finish;
        end

endmodule
                
            // #1
            // pc = 0;

            // #1
            // $display("ins: %d", instruction);

            // #1
            // pc = 1;

            // #1
            // $display("ins: %d", instruction);

            // #1
            // pc = 2;

            // #1
            // $display("ins: %d", instruction);

            // #1
            // pc = 3;

            // #1
            // $display("ins: %d", instruction);

            // #1
            // pc = 4;

            // #1
            // $display("ins: %d", instruction);

            // #1
            // pc = 5;

            // #1
            // $display("ins: %d", instruction);

            // #1
            // pc = 6;

            // #1
            // $display("ins: %d", instruction);
        //end

//endmodule