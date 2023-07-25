module maincontrol(clk, instruction, branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);

  //opcode types
  localparam I = 7'b0010011;
  localparam S = 7'b0100011;
  localparam SB = 7'b1100011;
  localparam I_LD = 7'b0000011;

  input clk;
  input [6:0] instruction;

  output reg branch, memread, memtoreg, memwrite, alusrc, regwrite;
  output reg [1:0] aluop;

  always @ (instruction)
    begin
      case (instruction)
        7'b0110011:
          {aluop, alusrc, memtoreg, regwrite, memread, memwrite, branch} = 8'b10_0_0_1_0_0_0;
        7'b0000011:
          {aluop, alusrc, memtoreg, regwrite, memread, memwrite, branch} = 8'b00_1_1_1_1_0_0;
        7'b0100011:
          {aluop, alusrc, memtoreg, regwrite, memread, memwrite, branch} = 8'b00_1_0_0_0_1_0;
        7'b1100011:
          {aluop, alusrc, memtoreg, regwrite, memread, memwrite, branch} = 8'b01_0_0_0_0_0_1;
        7'b0010011: // for addi (i-type)
          {aluop, alusrc, memtoreg, regwrite, memread, memwrite, branch} = 8'b00_1_0_1_0_0_0;
        default:
          {aluop, alusrc, memtoreg, regwrite, memread, memwrite, branch} = 8'b00_0_0_0_0_0_0;
      endcase
    end

endmodule