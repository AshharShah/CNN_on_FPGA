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

        //initialize some registers
        #1
        rd            = 5'b00000;
        instruction = {func7, rs2, rs1, func3, rd, opcode};

        #1
        writedata     = {{28{1'b0}}, 4'b0000};

        #1 // x1 = 1
        rd            = 5'b00001;
        instruction = {func7, rs2, rs1, func3, rd, opcode};

        #1
        writedata     = {{28{1'b0}}, 4'b0001};

        #1 // x2 = 2
        rd            = 5'b00010;
        instruction = {func7, rs2, rs1, func3, rd, opcode};
        
        #1
        writedata     = {{28{1'b0}}, 4'b0010};

        #1 // x3 = 3
        rd            = 5'b00011;
        instruction = {func7, rs2, rs1, func3, rd, opcode};
        
        #1
        writedata     = {{28{1'b0}}, 4'b0011};

        #1 // x4 = 4
        rd            = 5'b00100;
        instruction = {func7, rs2, rs1, func3, rd, opcode};
        
        #1
        writedata     = {{28{1'b0}}, 4'b0100};
        
        #1 // x5 = 5
        rd            = 5'b00101;
        instruction = {func7, rs2, rs1, func3, rd, opcode};
        
        #1
        writedata     = {{28{1'b0}}, 4'b0101};
        
        #2
        rs1           = 5'b00000;
        instruction = {func7, rs2, rs1, func3, rd, opcode};

        $display("readdata1 x0: %d", a);

        #2
        rs1           = 5'b00001;
        instruction = {func7, rs2, rs1, func3, rd, opcode};

        $display("readdata1 x1: %d", a);

        #2
        rs1           = 5'b00010;
        instruction = {func7, rs2, rs1, func3, rd, opcode};

        $display("readdata1 x2: %d", a);

        #2
        rs1           = 5'b00011;
        instruction = {func7, rs2, rs1, func3, rd, opcode};

        $display("readdata1 x3: %d", a);

        #2
        rs1           = 5'b00100;
        instruction = {func7, rs2, rs1, func3, rd, opcode};

        $display("readdata1 x4: %d", a);

        #2
        rs1           = 5'b00000;
        rs2           = 5'b00001;
        opcode        = 7'b0110011;
        func7         = 7'b0000000;
        func3         = 3'b000;

        instruction = {func7, rs2, rs1, func3, rd, opcode};

        $display("out first: %d", out);

        #2
        rs1           = 5'b00001;
        rs2           = 5'b00010;
        opcode        = 7'b0110011;
        func7         = 7'b0000000;
        func3         = 3'b000;

        instruction = {func7, rs2, rs1, func3, rd, opcode};

        $display("out: %d", out);

        #2
        rs1           = 5'b00010;
        rs2           = 5'b00011;
        opcode        = 7'b0110011;
        func7         = 7'b0000000;
        func3         = 3'b000;

        instruction = {func7, rs2, rs1, func3, rd, opcode};

        $display("out: %d", out);

        #2
        rs1           = 5'b00011;
        rs2           = 5'b00100;
        opcode        = 7'b0110011;
        func7         = 7'b0000000;
        func3         = 3'b000;

        instruction = {func7, rs2, rs1, func3, rd, opcode};

        $display("out: %d", out);

        #2
        $display("out: %d", out);
    end

endmodule
