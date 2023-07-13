`include "maincontrol.v"
`include "alu-control.v"
`include "alu.v"
`include "registerfile.v"

module tb_alu;

reg [6:0] opcode;
reg [6:0] func7;
reg [2:0] func3;
reg [4:0] rs1, rs2, rd;
reg [31:0] instruction;

reg [31:0] writedata;

wire branch, memread, memtoreg, memwrite, alusrc, regwrite, zero;
wire [1:0] aluop;
wire [3:0] aluctl;
wire [31:0] a, b;
wire [31:0] out;

maincontrol  uutA(instruction[6:0], branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
alucontrol   uutB(aluop, instruction[31:25], instruction[14:12], aluctl);
alu          uutC(aluctl, a, b, out, zero);
registerfile uutD(instruction[19:15], instruction[24:20], instruction[11:7], writedata, regwrite, a, b);

initial 
    begin
        rs1           = 5'b00000;
        rs2           = 5'b00000;
        rd            = 5'b00000;
        opcode        = 7'b0110011;
        func7         = 7'b0000000;
        func3         = 3'b000;

        instruction = {func7, rs2, rs1, func3, rd, opcode};
    end

initial
    begin
        $dumpfile("myalu.vcd");
        $dumpvars(2, tb_alu);

        // Testing ADD function
        #1
        rs1           = 5'b00000;
        rs2           = 5'b00001;
        opcode        = 7'b0110011; // R-format
        func7         = 7'b0000000;
        func3         = 3'b000;
        instruction = {func7, rs2, rs1, func3, rd, opcode};

        #1
        $display("out x0+x1: %d", out);

        #1
        rs1           = 5'b00001;
        rs2           = 5'b00010;
        instruction = {func7, rs2, rs1, func3, rd, opcode};

        #1
        $display("out x1+x2: %d", out);

        #1
        rs1           = 5'b00010;
        rs2           = 5'b00011;
        instruction = {func7, rs2, rs1, func3, rd, opcode};

        #1
        $display("out x2+x3: %d", out);

        #1
        rs1           = 5'b00011;
        rs2           = 5'b00100;
        instruction = {func7, rs2, rs1, func3, rd, opcode};

        #1
        $display("out x3+x4: %d", out);

        #1
        rs1           = 5'b00000;
        rs2           = 5'b00101;
        instruction = {func7, rs2, rs1, func3, rd, opcode};

        #1
        $display("out x5+x0: %d", out);

        // Testing LOAD function
        #1
        rs1           = 5'b00000;
        rs2           = 5'b00001;
        opcode        = 7'b0000011; // Store Word
        func7         = 7'b0000000;
        func3         = 3'b000;
        instruction = {func7, rs2, rs1, func3, rd, opcode};

    end

endmodule