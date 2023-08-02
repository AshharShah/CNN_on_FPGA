`include "alu.v"
`include "registerfile.v"
`include "instructionmemory.v"
`include "adder.v"
`include "datamemory.v"
`include "immediategen.v"
`include "mux2_1.v"
`include "pc.v"
`include "alucontrol.v"
`include "maincontrol.v"

module riscv(clk, rst);

    input clk, rst;

    wire [31:0] newpc;
    wire [31:0] pc;

    wire branch, memread, memtoreg, memwrite, alusrc, regwrite, zero;
    wire [1:0] aluop;
    wire [3:0] aluctl;
    wire [31:0] instruction, a, b, immediate, mux_out, alu_out, writedata, readdata, sumA, sumB;

    assign select = branch & zero;

    adder               adder(pc, 4, sumA);
    adder               adder2(immediate, pc, sumB);
    mux2_1              mux1(sumA, sumB, select, newpc);
    pc                  pcmod(clk, rst, newpc, pc);

    instructionmemory   insmem(pc, instruction);
    maincontrol         maincon(instruction[6:0], branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
    registerfile        regfile(clk, instruction[19:15], instruction[24:20], instruction[11:7], writedata, regwrite, a, b);
    immediategen        immgen(instruction, immediate);

    alucontrol          alucon(aluop, instruction[31:25], instruction[14:12], aluctl);                   
    mux2_1              mux2(b, immediate, alusrc, mux_out);
    alu                 alu(aluctl, a, mux_out, alu_out, zero, overflow);

    datamemory          datamem(clk, alu_out[9:0], b, memread, memwrite, readdata);
    mux2_1              mux3(alu_out, readdata, memtoreg, writedata);

endmodule