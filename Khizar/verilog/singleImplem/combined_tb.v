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

    
wire branch, memread, memtoreg, memwrite, alusrc, regwrite, zero;
wire [1:0] aluop;
wire [3:0] aluctl;
wire [31:0] instruction, a, b, immediate, mux_out, alu_out, writedata, readdata, sumA, sumB;

instructionmemory   uutA(pc, instruction); // 0000_0000_0000___01110___000___01110___0010011
                            //001_0011      0          0       0        00      0         1        1
maincontrol         uutB(instruction[6:0], branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
                    //     00                                             2
alucontrol          uutC(aluop, instruction[31:25], instruction[14:12], aluctl);
                             // 01110         nothing 00000             01110         .....       1      
registerfile        uutF(instruction[19:15], instruction[24:20], instruction[11:7], writedata, regwrite, a, b);
immediategen        uutD(instruction, immediate);
mux2_1              uutE(b, immediate, alusrc, mux_out);
alu                 uutG(aluctl, a, mux_out, alu_out, zero, overflow);
datamemory          uutH(alu_out[9:0], b, memread, memwrite, readdata); // decreased address to 10 bits, change later
mux2_1              uutI(alu_out, readdata, memtoreg, writedata);

// adder               uutJ(pc, 4, sumA);
// adder               uutK(immediate, pc, sumB);
// mux2_1              uutL(sumA, sumB, select, pc);

initial
    begin
        $dumpfile("./vcd/combined_tb.vcd");
        $dumpvars(2, combined_tb);

        #1
        pc = 0;

        #1
        $display("pc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 1;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 2;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 3;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 4;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 6;

        #1
        $display("\nfd...................sfpc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 6;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 7;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 8;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 9;

        #1
        pc = 9;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 10;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 11;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 12;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 13;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 14;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 15;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 16;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 17;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 18;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 19;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

        #1
        pc = 20;

        #1
        $display("\npc: %d", pc);
        $display("ins: %d", instruction);
        $display("branch %d, memread %d, memtoreg %d, aluop %d, memwrite %d, alusrc %d, regwrite %d", branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
        $display("alu_ctl %d, writedata %d, a %d, b %",  aluctl, writedata, a, b);
        $display("immediate %d, mux_out %d",  immediate, mux_out);
        $display("alu_out %d",  alu_out);
        $display("readdata %d",  readdata);

    end

endmodule