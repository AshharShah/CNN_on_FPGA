`include "maincontrol.v"
`include "alucontrol.v"
`include "alu.v"
`include "registerfile.v"
`include "instructionmemory.v"
`include "adder.v"
`include "datamemory.v"
`include "immediategen.v"
`include "mux2_1.v"

module combined_tb;

    reg [9:0] pc;
    reg clk;
    
    wire branch, memread, memtoreg, memwrite, alusrc, regwrite, zero;
    wire [1:0] aluop;
    wire [3:0] aluctl;
    wire [31:0] instruction, a, b, immediate, mux_out, alu_out, writedata, readdata, sumA, sumB;

    instructionmemory   uutA(pc, instruction);
    maincontrol         uutB(instruction[6:0], branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
    registerfile        uutF(clk, instruction[19:15], instruction[24:20], instruction[11:7], writedata, regwrite, a, b);
    immediategen        uutD(instruction, immediate);
    alucontrol          uutC(aluop, instruction[31:25], instruction[14:12], aluctl);                   
    mux2_1              uutE(b, immediate, alusrc, mux_out);
    alu                 uutG(aluctl, a, mux_out, alu_out, zero, overflow);
    datamemory          uutH(clk, alu_out[9:0], b, memread, memwrite, readdata); // decreased address to 10 bits, change later
    mux2_1              uutI(alu_out, readdata, memtoreg, writedata);

    //adder               uutJ(pc, 4, pc);
    // adder               uutK(immediate, pc, sumB);
    // mux2_1              uutL(sumA, sumB, select, pc);

    integer i;

    always #1 clk = ~clk;

    initial
        begin
            $dumpfile("../vcd/combined_tb_b.vcd");
            $dumpvars(2, combined_tb);

            $readmemh("ins", uutA.memfile);
            pc = -1;
            clk = 0;

            #2
            for(i = 0; i < 200; i = i + 4)
                begin
                    #6
                    pc = i;
                    $display("te pc: %d", pc);
                end

            #340 $finish;
        end

endmodule