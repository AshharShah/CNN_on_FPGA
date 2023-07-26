`include "maincontrol.v"
`include "alucontrol.v"
`include "alu.v"
`include "registerfile.v"
`include "instructionmemory.v"
`include "adder.v"
`include "datamemory.v"
`include "immediategen.v"
`include "mux2_1.v"
`include "pc.v"

module riscv(clk, rst);

    input clk, rst;

    wire [31:0] newpc;
    wire [31:0] pc;

    wire branch, memread, memtoreg, memwrite, alusrc, regwrite, zero;
    wire [1:0] aluop;
    wire [3:0] aluctl;
    wire [31:0] instruction, a, b, immediate, mux_out, alu_out, writedata, readdata, sumA, sumB;

    assign select = branch & immediate;

    adder               uutJ(pc, 4, sumA);
    adder               uutK(immediate, pc, sumB);
    mux2_1              uutL(sumA, sumB, select, newpc);
    pc                  uutP(clk, rst, newpc, pc);

    instructionmemory   uutA(pc, instruction);
    maincontrol         uutB(instruction[6:0], branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
    registerfile        uutF(clk, instruction[19:15], instruction[24:20], instruction[11:7], writedata, regwrite, a, b);
    immediategen        uutD(instruction, immediate);

    alucontrol          uutC(aluop, instruction[31:25], instruction[14:12], aluctl);                   
    mux2_1              uutE(b, immediate, alusrc, mux_out);
    alu                 uutG(aluctl, a, mux_out, alu_out, zero, overflow);

    datamemory          uutH(clk, alu_out[9:0], b, memread, memwrite, readdata);
    mux2_1              uutI(alu_out, readdata, memtoreg, writedata);

endmodule