`include "maincontrol.v"
`include "alucontrol.v"
`include "alu.v"
`include "registerfile.v"
`include "instructionmemory.v"
`include "adder.v"
`include "datamemory.v"
`include "immediategen.v"
`include "mux2_1.v"
`include "state.v"

module combined_tb;

    reg clk;
    reg [9:0] pc;
    
    wire branch, memread, memtoreg, memwrite, alusrc, regwrite, zero;
    wire [1:0] aluop;
    wire [3:0] aluctl;
    wire [31:0] instruction, a, b, immediate, mux_out, alu_out, writedata, readdata, sumA, sumB;

    wire [1:0] state;

    wire [31:0] newpc;

    state               uuAX(clk, state);

    instructionmemory   uutA(clk, state, pc, instruction);
    maincontrol         uutB(clk, state, instruction[6:0], branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
    registerfile        uutF(clk, state, instruction[19:15], instruction[24:20], instruction[11:7], writedata, regwrite, a, b);
    immediategen        uutD(instruction, immediate);
    alucontrol          uutC(aluop, instruction[31:25], instruction[14:12], aluctl);                   
    mux2_1              uutE(b, immediate, alusrc, mux_out);
    alu                 uutG(aluctl, a, mux_out, alu_out, zero, overflow);
    datamemory          uutH(clk, state, alu_out[9:0], b, memread, memwrite, readdata); // decreased address to 10 bits, change later
    mux2_1              uutI(alu_out, readdata, memtoreg, writedata);

    // adder               uutK(immediate, pc, sumB);
    // mux2_1              uutL(sumA, sumB, select, pc);

    integer i;

    always #2 clk = ~clk;

    initial
        begin
            $dumpfile("../vcd/combined_tb.vcd");
            $dumpvars(2, combined_tb);

            clk = 0;
            pc  = 0;

            for(i = 0; i < 31; i = i + 1)
                begin
                    pc = i;
                    #16
                    $display("pc: %d", pc);
                    $display("ins: %d", instruction);
                    $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
                    $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
                    $display("immediate %d, mux_out %d",  immediate, mux_out);
                    $display("alu_out %d",  alu_out);
                    $display("readdata %d",  readdata);    
                end
            #160 $finish;
        end

endmodule