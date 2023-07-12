`include "maincontrol.v"
`include "alu-control.v"
`include "alu.v"
`include "registerfile.v"

module tb_alu;

reg [6:0] opcode;
reg [6:0] func7;
reg [2:0] func3;
reg [4:0] rs1, rs2, rd;

wire [31:0] a, b;

reg [31:0] instruction;

reg [31:0] writedata;

wire branch, memread, memtoreg, memwrite, alusrc, regwrite, zero;
wire [1:0] aluop;
wire [3:0] aluctl;
wire [31:0] out;

maincontrol  uutA(instruction[6:0], branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
alucontrol   uutB(aluop, instruction[31:25], instruction[14:12], aluctl);
alu          uutC(aluctl, a, b, out, zero);
registerfile uutD(instruction[19:15], instruction[24:20], instruction[11:7], writedata, regwrite, a, b);

initial 
    begin
        rs1           = 5'b00000;
        rs2           = 5'b00000;
        opcode        = 7'b0110011;
        func7         = 7'b0000000;
        func3         = 3'b000;

        instruction = {func7, rs1, rs2, func3, rd, opcode};
    end

initial
    begin
        $dumpfile("myalu.vcd");
        $dumpvars(1, tb_alu);

        #2
        rs1           = 5'b00000;
        rs2           = 5'b00000;
        opcode        = 7'b0110011;
        func7         = 7'b0000000;
        func3         = 3'b000;

        instruction = {func7, rs1, rs2, func3, rd, opcode};

        $display("out: %d", out);

        #2
        rs1           = 5'b00000;
        rs2           = 5'b00000;
        opcode        = 7'b0110011;
        func7         = 7'b0000000;
        func3         = 3'b000;

        instruction = {func7, rs1, rs2, func3, rd, opcode};

        $display("out: %d", out);

        #2
        rs1           = 5'b00000;
        rs2           = 5'b00000;
        opcode        = 7'b0110011;
        func7         = 7'b0000000;
        func3         = 3'b000;

        instruction = {func7, rs1, rs2, func3, rd, opcode};

        $display("out: %d", out);

        #2
        rs1           = 5'b00000;
        rs2           = 5'b00000;
        opcode        = 7'b0110011;
        func7         = 7'b0000000;
        func3         = 3'b000;

        instruction = {func7, rs1, rs2, func3, rd, opcode};

        $display("out: %d", out);

        #2
        rs1           = 5'b00000;
        rs2           = 5'b00000;
        opcode        = 7'b0110011;
        func7         = 7'b0000000;
        func3         = 3'b000;

        instruction = {func7, rs1, rs2, func3, rd, opcode};

        $display("out: %d", out);

        #2
        $display("out: %d", out);
    end

endmodule
