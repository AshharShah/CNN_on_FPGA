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
    reg [1:0] state;
    reg select;

    wire branch, memread, memtoreg, memwrite, alusrc, regwrite, zero;
    wire [1:0] aluop;
    wire [3:0] aluctl;
    wire [31:0] instruction, a, b, immediate, mux_out, alu_out, writedata, readdata, sumA, sumB;

    instructionmemory   uutA(clk, pc, instruction);
    maincontrol         uutB(state, instruction[6:0], branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
    registerfile        uutF(clk, instruction[19:15], instruction[24:20], instruction[11:7], writedata, regwrite, a, b);
    immediategen        uutD(instruction, immediate);
    alucontrol          uutC(aluop, instruction[31:25], instruction[14:12], aluctl);                   
    mux2_1              uutE(b, immediate, alusrc, mux_out);
    alu                 uutG(aluctl, a, mux_out, alu_out, zero, overflow);
    datamemory          uutH(clk, alu_out[9:0], b, memread, memwrite, readdata); // decreased address to 10 bits, change later
    mux2_1              uutI(alu_out, readdata, memtoreg, writedata);

    //adder               uutJ(pc, 1, pc);
    // adder               uutK(immediate, pc, sumB);
    //mux2_1              uutL(pc, sumB, select, newpc);

    integer i;

    always #1 clk = ~clk;

    always @(posedge clk) 
        begin
            if (state == 0)
                begin
                    //immediate = ins[7], ins[25:30]
                    pc = (branch & zero) ?  pc+immediate : pc+1;
                    state = state + 1;        
                end
            else if (state == 5)
                begin
                    state = 0;
                end
            else
                state = state + 1;
        end

    initial
        begin
            $dumpfile("../vcd/tb_automate_pc_1.vcd");
            $dumpvars(2, combined_tb);

            pc = -1;
            clk = 0;
            state = 0;

            #400 $finish;
        end

endmodule