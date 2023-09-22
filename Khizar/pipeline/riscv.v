`include "alu.v"
`include "registerfilenew.v"
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
`include "hazarddetectionunit.v"
`include "mux2_1b.v"

module riscv(clk, rst);

    input clk, rst;

    wire memtoreg,    branch,    memread,    memwrite,    alusrc,    regwrite,    zero,    func7,    pcsrc, jump, jump_id, jump_ex;
    wire memtoreg_if, branch_if, memread_if, memwrite_if, alusrc_if, regwrite_if, zero_ex, func7_id;
    wire memtoreg_id, branch_id, memread_id, memwrite_id, alusrc_id, regwrite_cn;
    wire memtoreg_ex, branch_ex, memread_ex, memwrite_ex;
    wire memtoreg_wb, enable_pc, enable_if,  memwrite_cn;

    wire [1:0] aluop, aluop_if, aluop_id, forwardA, forwardB;
    wire [2:0] func3, func3_id, func3_ex;
    wire [3:0] aluctl;
    wire [4:0] rd_id, rd_ex, rd_wb, rs1_id, rs2_id;
    wire [6:0] opcode_id;

    wire [31:0] sumB,       pc,     alures,     b,       a,       immediate,    readdata,    ins, four;
    wire [31:0] sumB_if,    pc_if,  alures_ex,  b_id,    a_id,    immediate_id, readdata_wb, ins_if;
    wire [31:0] sumB_id,    pc_id,  alures_wb,  alu_in1, alu_in1_enhanced, alu_in2, alu_in2_enhanced, writedata,    alu_2_bef;
    wire [31:0] sumB_ex,    newpc,  mux_out,    b_ex,    sumA,    sumB_in2, alu_or_mem_ex;

    //new
    wire enable_control, signal_pc_new;

    pc                  pcmod(clk, rst, newpc, enable_pc, pc);
    adder               adder(pc, 4, sumA);
    mux2_1              mux1(sumA, sumB_ex, pcsrc, newpc);
    instructionmemory   insmem(pc, ins);
    
    //if
    ifidreg             if1(clk, enable_if, pcsrc, pc, ins, pc_if, ins_if);

    hazarddetectionunit hdetect(memread_id, ins_if[19:15], ins_if[24:20], rd_id, jump_ex, enable_if, enable_pc, enable_control);
    mux2_1b             mux4(1'b0, regwrite, enable_control, regwrite_cn);
    mux2_1b             mux5(1'b0, memwrite, enable_control, memwrite_cn);

    registerfilenew     regfile(clk, ins_if[19:15], ins_if[24:20], rd_wb, writedata, regwrite_wb, a, b);
    immediategen        immgen(ins_if, immediate);
    maincontrol         maincon(ins_if[6:0], branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite, jump);

    //id
    idexreg             id1(clk, pc_if, a,    b,    immediate,    ins_if[30], ins_if[14:12], ins_if[11:7], ins_if[6:0], branch,    memread,    memtoreg,    aluop,    memwrite_cn,    alusrc, regwrite_cn, ins_if[19:15], ins_if[24:20], pcsrc, jump, 
                                 pc_id, a_id, b_id, immediate_id, func7_id,   func3_id,      rd_id,        opcode_id,   branch_id, memread_id, memtoreg_id, aluop_id, memwrite_id, alusrc_id, regwrite_id, rs1_id,        rs2_id, jump_id);
    
    assign signal_pc_new = (opcode_id == 7'b1100111);

    mux2_1              mux9(pc_id, a_id, signal_pc_new, sumB_in2);

    adder               adder2(immediate_id, sumB_in2, sumB);
    alucontrol          alucon(aluop_id, func7_id, func3_id, jump_id, aluctl);
    //mux2_1              mux2(b_id, immediate_id, alusrc_id, mux_out);
    forwardingunit      fwdunit(rs1_id, rs2_id, rd_ex, regwrite_ex, rd_wb, regwrite_wb, forwardA, forwardB);
    
    
    mux3_1              fwdAmux(a_id, alu_or_mem_ex, writedata, forwardA, alu_in1);
    mux2_1              mux7(alu_in1, pc_id, jump_id, alu_in1_enhanced);
    
    mux3_1              fwdBmux(b_id, alu_or_mem_ex, writedata, forwardB, alu_2_bef);
    mux2_1              mux6(alu_2_bef, immediate_id, alusrc_id, alu_in2);

    assign four = {{29{1'b0}}, 3'b100};

    mux2_1              mux8(alu_in2, four, jump_id, alu_in2_enhanced);

    alu                 alu(aluctl, alu_in1_enhanced, alu_in2_enhanced, alures, zero, overflow);

    //ex
    exmemreg            ex1(clk, sumB,    zero,    alures,    alu_2_bef, rd_id, branch_id, memread_id, memtoreg_id, memwrite_id, regwrite_id, func3_id, pcsrc, jump_id, 
                                 sumB_ex, zero_ex, alures_ex, b_ex, rd_ex, branch_ex, memread_ex, memtoreg_ex, memwrite_ex, regwrite_ex,      func3_ex, jump_ex);
    
    datamemory          datamem(clk, alures_ex, b_ex, memread_ex, memwrite_ex, func3_ex, readdata);

    mux2_1              mux10(alures_ex, readdata, memread_ex, alu_or_mem_ex);

    assign pcsrc = (branch_ex & zero_ex) | jump_ex;

    //wb
    memwbreg            wb1(clk, readdata,    alures_ex, rd_ex, memtoreg_ex, regwrite_ex,
                                 readdata_wb, alures_wb, rd_wb, memtoreg_wb, regwrite_wb);
    
    mux2_1              mux3(alures_wb, readdata_wb, memtoreg_wb, writedata);

endmodule