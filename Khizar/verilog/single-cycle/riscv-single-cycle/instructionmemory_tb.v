`include "instructionmemory.v"

module instructionmemory_tb;

    reg [9:0] pc;
    wire [31:0] instruction;

    integer i;
    integer MEM_LOCATIONS_PER_INS   = 4;
    integer NUMBER_OF_INSTRUCTIONS  = 43;
    integer MEM_LOCATIONS           = 0;

    instructionmemory uut(pc, instruction);

    initial
        begin
            $dumpfile("../vcd/tb_instructionmemory.vcd");
            $dumpvars(1, instructionmemory_tb);

            #10
            MEM_LOCATIONS = NUMBER_OF_INSTRUCTIONS * MEM_LOCATIONS_PER_INS;
            $readmemh("ins", instructionmemory_tb.uut.memfile);

            #5
            for(i = 0; i < MEM_LOCATIONS; i = i + 4)
                begin
                    #1
                    pc = i;

                    #1
                    $display("pc: %d, ins: %h", pc, instruction);
                end
            
            #5
            for(i = 0; i < MEM_LOCATIONS; i = i + 4)
                begin
                    $display("memfile %d == %h", i,   instructionmemory_tb.uut.memfile[i]);
                    $display("memfile %d == %h", i+1, instructionmemory_tb.uut.memfile[i+1]);
                    $display("memfile %d == %h", i+2, instructionmemory_tb.uut.memfile[i+2]);
                    $display("memfile %d == %h", i+3, instructionmemory_tb.uut.memfile[i+3]);
                end
        end
endmodule