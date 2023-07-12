`include "maincontrol.v"
`include "alu-control.v"
`include "alu.v"

module tb_alu;

reg [6:0] opcode;
reg [6:0] func7;
reg [2:0] func3;

reg [31:0] instruction;
reg [3:0] a, b;

wire branch, memread, memtoreg, memwrite, alusrc, regwrite, zero;
wire [1:0] aluop;
wire [3:0] aluctl, out;

maincontrol uutA(instruction[6:0], branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
alucontrol  uutB(aluop, instruction[31:25], instruction[14:12], aluctl);
alu         uutC(aluctl, a, b, out, zero);

initial 
    begin
        a           = 4'b0000;
        b           = 4'b0000;
        opcode      = 7'b0110011;
        func7       = 7'b0000000;
        func3       = 3'b000;

        instruction = {func7, 1'b0, b, 1'b0, a, func3, 5'b00000, opcode};
    end

initial
    begin
        $dumpfile("myalu.vcd");
        $dumpvars(1, tb_alu);

        #2
        a           = 4'b0000;
        b           = 4'b0000;
        opcode      = 7'b0110011;
        func7       = 7'b0000000;
        func3       = 3'b000;

        instruction = {func7, 1'b0, b, 1'b0, a, func3, 5'b00000, opcode};

        $display("out: %d", out);

        #2
        a           = 4'b0001;
        b           = 4'b0000;
        opcode      = 7'b0110011;
        func7       = 7'b0000000;
        func3       = 3'b000;

        instruction = {func7, 1'b0, b, 1'b0, a, func3, 5'b00000, opcode};

        $display("out: %d", out);

        #2
        a           = 4'b0010;
        b           = 4'b0001;
        opcode      = 7'b0110011;
        func7       = 7'b0000000;
        func3       = 3'b000;

        instruction = {func7, 1'b0, b, 1'b0, a, func3, 5'b00000, opcode};

        $display("out: %d", out);

        #2
        a           = 4'b0001;
        b           = 4'b0010;
        opcode      = 7'b0110011;
        func7       = 7'b0000000;
        func3       = 3'b000;

        instruction = {func7, 1'b0, b, 1'b0, a, func3, 5'b00000, opcode};

        $display("out: %d", out);

        #2
        a           = 4'b0111;
        b           = 4'b0001;
        opcode      = 7'b0110011;
        func7       = 7'b0000000;
        func3       = 3'b000;

        instruction = {func7, 1'b0, b, 1'b0, a, func3, 5'b00000, opcode};

        $display("out: %d", out);

        #2
        $display("out: %d", out);
    end

endmodule
