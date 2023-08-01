`include "alu.v"
`include "registerfile.v"
`include "insmemory.v"
`include "adder.v"
`include "datamemory.v"
`include "immediategen.v"
`include "mux2_1.v"
`include "pc.v"
`include "alucontrol.v"
`include "maincontrol.v"

module riscv(clk, rst);

    input clk, rst;

    wire [31:0] newpc, sumA;

    wire memtoreg,    branch,    memread,    memwrite,    alusrc,    regwrite;
    wire memtoreg_if, branch_if, memread_if, memwrite_if, alusrc_if, regwrite_if;
    wire memtoreg_id, branch_id, memread_id, memwrite_id, alusrc_id;
    wire memtoreg_ex, branch_ex, memread_ex, memwrite_ex;
    wire memtoreg_wb;

    wire [1:0] aluop, aluop_id, aluop_id;
    
    wire [3:0] aluctl;
    wire [31:0] ins;

    wire [31:0] sumB,       pc,     alures,     rd_id, b,    a,   writedata,   zero;
    wire [31:0] sumB_if,    pc_if,  alures_ex,  rd_ex, b_id, a_id,    readdata,    zero_ex;
    wire [31:0] sumB_id,    pc_id,  alures_wb,  rd_wb, b_ex, readdata_wb;
    wire [31:0] sumB_ex,

    , a, b, immediate, mux_out, alures, writedata, readdata;


    pc                  pcmod(clk, rst, newpc, pc);
    adder               adder(pc, 4, sumA);
    mux2_1              mux1(sumA, sumB_ex, pcsrc, newpc);
    instructionmemory   insmem(pc, ins);
    maincontrol         maincon(ins[6:0], branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
    
    //if
    ifidreg             if1(clk, pc,    ins,    branch,    memread,    memtoreg,    aluop,    memwrite,    alusrc,    regwrite, 
                                 pc_if, ins_if, branch_if, memread_if, memtoreg_if, aluop_if, memwrite_if, alusrc_if, regwrite_if);

    registerfile        regfile(clk, ins_if[19:15], ins_if[24:20], rd_wb, writedata, regwrite_if, a, b);
    immediategen        immgen(ins, immediate);
    
    //id
    idexreg             id1(clk, pc_if, a,    b,    immediate,    ins_if[30], ins_if[14:12], ins_if[11:7], branch_if, memread_if, memtoreg_if, aluop_if, memwrite_if, alusrc_if, 
                                 pc_id, a_id, b_id, immediate_id, func7_id,   func3_id,      rd_id,        branch_id, memread_id, memtoreg_id, aluop_id, memwrite_id, alusrc_id);
    adder               adder2(immediate_id, pc_id, sumB);
    alucontrol          alucon(aluop_id, func7_id, func3_id, aluctl);                   
    mux2_1              mux2(b_id, immediate_id, alusrc_id, mux_out);
    alu                 alu(aluctl, a_id, mux_out, alures, zero, overflow);

    //ex
    exmemreg            ex1(clk, sumB,    zero,    alures,    b_id, rd_id, branch_id, memread_id, memtoreg_id, memwrite_id, 
                                 sumB_ex, zero_ex, alures_ex, b_ex, rd_ex, branch_ex, memread_ex, memtoreg_ex, memwrite_ex);
    datamemory          datamem(clk, alures_ex, b_ex, memread_ex, memwrite_ex, readdata);
    assign pcsrc =      branch_ex & zero_ex;

    //wb
    memwbreg            wb1(clk, readdata,    alures_ex, rd_ex, memtoreg_ex, 
                                 readdata_wb, alures_wb, rd_wb, memtoreg_wb);
    mux2_1              mux3(alures_wb, readdata_wb, memtoreg_wb, writedata);

endmodule