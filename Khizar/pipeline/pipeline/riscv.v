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
`include "ifidreg.v"
`include "idexreg.v"
`include "exmemreg.v"
`include "memwbreg.v"
`include "forwardingunit.v"
`include "mux3_1.v"

module riscv(clk, rst);

    input clk, rst;

    wire [31:0] newpc, sumA;

    wire memtoreg,    branch,    memread,    memwrite,    alusrc,    regwrite;
    wire memtoreg_if, branch_if, memread_if, memwrite_if, alusrc_if, regwrite_if;
    wire memtoreg_id, branch_id, memread_id, memwrite_id, alusrc_id;
    wire memtoreg_ex, memread_ex, memwrite_ex;
    wire memtoreg_wb, func7, func7_id, zero;

    wire [1:0] aluop, aluop_if, aluop_id, forwardA, forwardB;

    wire [3:0] aluctl;
    wire [31:0] ins, ins_if;
    wire [4:0] rd_id, rd_ex, rd_wb, rs1_id, rs2_id;

    wire [31:0] sumB,       pc,     alures,     b,    a,   writedata, mux_out;
    wire [31:0] sumB_if,    pc_if,  alures_ex,  b_id, a_id,    readdata;
    wire [31:0] sumB_id,    pc_id,  alures_wb,  b_ex, readdata_wb, alu_in1, alu_in2;
    wire [31:0] immediate, immediate_id;
    wire [2:0] func3, func3_id;

    wire [31:0] sumB_ex;
    wire        zero_ex, branch_ex, pcsrc;

    pc                  pcmod(clk, rst, newpc, pc);
    adder               adder(pc, 4, sumA);
    mux2_1              mux1(sumA, sumB_ex, pcsrc, newpc);
    instructionmemory   insmem(pc, ins);
    maincontrol         maincon(ins_if[6:0], branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);

    //if
    ifidreg             if1(clk, pc, ins, pc_if, ins_if);

    registerfile        regfile(clk, ins_if[19:15], ins_if[24:20], rd_wb, writedata, regwrite_wb, a, b);
    immediategen        immgen(ins_if, immediate);

    //id
    idexreg             id1(clk, pc_if, a,    b,    immediate,    ins_if[30], ins_if[14:12], ins_if[11:7], branch,    memread,    memtoreg,    aluop,    memwrite,    alusrc,    regwrite,    ins_if[19:15], ins_if[24:20],
                                 pc_id, a_id, b_id, immediate_id, func7_id,   func3_id,      rd_id,        branch_id, memread_id, memtoreg_id, aluop_id, memwrite_id, alusrc_id, regwrite_id, rs1_id,        rs2_id);
    adder               adder2(immediate_id, pc_id, sumB);
    alucontrol          alucon(aluop_id, func7_id, func3_id, aluctl);
    mux2_1              mux2(b_id, immediate_id, alusrc_id, mux_out);

    forwardingunit      fwdunit(rs1_id, rs2_id, rd_ex, regwrite_ex, rd_wb, regwrite_wb, forwardA, forwardB);
    mux3_1              fwdAmux(a_id, alures_ex, writedata, forwardA, alu_in1);
    mux3_1              fwdBmux(mux_out, alures_ex, writedata, forwardB, alu_in2);

    alu                 alu(aluctl, alu_in1, alu_in2, alures, zero, overflow);

    //ex
    exmemreg            ex1(clk, sumB,    zero,    alures,    b_id, rd_id, branch_id, memread_id, memtoreg_id, memwrite_id, regwrite_id,
                                 sumB_ex, zero_ex, alures_ex, b_ex, rd_ex, branch_ex, memread_ex, memtoreg_ex, memwrite_ex, regwrite_ex);
    datamemory          datamem(clk, alures_ex, b_ex, memread_ex, memwrite_ex, readdata);

    assign pcsrc = branch_ex & zero_ex;

    //wb
    memwbreg            wb1(clk, readdata,    alures_ex, rd_ex, memtoreg_ex, regwrite_ex,
                                 readdata_wb, alures_wb, rd_wb, memtoreg_wb, regwrite_wb);
    mux2_1              mux3(alures_wb, readdata_wb, memtoreg_wb, writedata);

endmodule