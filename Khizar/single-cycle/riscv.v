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
    wire [31:0] instruction, a, b, immediate, mux_out, alu_out, write_out, readdata, sumA, sumB, writedata, pc_or_rs1;

    assign select = branch & (zero | jal_select);
    assign islink = (instruction[6:0] == 7'b1100111);
    
    mux2_1              pcrs1(pc, a, islink, pc_or_rs1);
    adder               adder(pc, 4, sumA);
    adder               adder2(immediate, pc_or_rs1, sumB);
    mux2_1              mux1(sumA, sumB, select, newpc);
    pc                  pcmod(clk, rst, newpc, pc);

    mux2_1              mux2(write_out, sumA, jal_select, writedata);

    instructionmemory   insmem(pc, instruction);
    maincontrol         maincon(instruction[6:0], branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite, jal_select);
    registerfile        regfile(clk, instruction[19:15], instruction[24:20], instruction[11:7], writedata, regwrite, a, b);
    immediategen        immgen(instruction, immediate);

    alucontrol          alucon(aluop, instruction[31:25], instruction[14:12], aluctl);                   
    mux2_1              mux3(b, immediate, alusrc, mux_out);
    alu                 alu(aluctl, a, mux_out, alu_out, zero, overflow);

    datamemory          datamem(clk, alu_out[9:0], b, memread, memwrite, readdata);
    mux2_1              mux4(alu_out, readdata, memtoreg, write_out);

endmodule