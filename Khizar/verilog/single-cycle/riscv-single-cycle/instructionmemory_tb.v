`include "instructionmemory.v"

module instructionmemory_tb;

    reg [9:0] pc;
    wire [31:0] instruction;

    integer i;
    integer NUMBER_OF_INSTRUCTIONS = 43 * 4;

    instructionmemory uut(pc, instruction);

    initial
        begin
            $dumpfile("../vcd/tb_instructionmemory.vcd");
            $dumpvars(1, instructionmemory_tb);

            $readmemh("instructions.txt", instructionmemory_tb.uut.memfile);
            #10

            for(i = 0; i < NUMBER_OF_INSTRUCTIONS; i = i + 4)
                begin
                    #1
                    pc = i;

                    #1
                    $display("pc: %d, ins: %d", pc, instruction);
                end
            
            #5
            for(i = 0; i < NUMBER_OF_INSTRUCTIONS; i = i + 4)
                begin
                    $display("memfile %d == %d", i, uut.memfile[i]);
                end

        end

endmodule