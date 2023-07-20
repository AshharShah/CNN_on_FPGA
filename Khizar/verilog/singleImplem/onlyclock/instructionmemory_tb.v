`include "instructionmemory.v"

module instructionmemory_tb;

    reg [9:0] pc;
    
    wire [31:0] instruction;

    instructionmemory uut(pc, instruction);

    initial
        begin
            $dumpfile("./vcd/instructionmemory_tb.vcd");
            $dumpvars(1, instructionmemory_tb);

            #1
            pc = 0;

            #1
            $display("ins: %d", instruction);

            #1
            pc = 1;

            #1
            $display("ins: %d", instruction);

            #1
            pc = 2;

            #1
            $display("ins: %d", instruction);

            #1
            pc = 3;

            #1
            $display("ins: %d", instruction);

            #1
            pc = 4;

            #1
            $display("ins: %d", instruction);

            #1
            pc = 5;

            #1
            $display("ins: %d", instruction);

            #1
            pc = 6;

            #1
            $display("ins: %d", instruction);
        end

endmodule