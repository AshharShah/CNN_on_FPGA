module maincontrol(opcode, branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite, jump);

  //opcode types
  localparam I    = 7'b0010011;
  localparam S    = 7'b0100011;
  localparam SB   = 7'b1100011;
  localparam I_LD = 7'b0000011;
  localparam R    = 7'b0110011;
  localparam J    = 7'b1101111;
  localparam JR   = 7'b1100111;

  input enable_hazard_control;
  input [6:0] opcode;

  output reg branch, memread, memtoreg, memwrite, alusrc, regwrite, jump;
  output reg [1:0] aluop;

  always @ (opcode)
  begin
    case (opcode)
      R:
        {aluop, alusrc, memtoreg, regwrite, memread, memwrite, branch, jump} <= 9'b10_0_0_1_0_0_0_0;
      I_LD:
        {aluop, alusrc, memtoreg, regwrite, memread, memwrite, branch, jump} <= 9'b11_1_1_1_1_0_0_0;
      S:
        {aluop, alusrc, memtoreg, regwrite, memread, memwrite, branch, jump} <= 9'b11_1_0_0_0_1_0_0;
      SB:
        {aluop, alusrc, memtoreg, regwrite, memread, memwrite, branch, jump} <= 9'b01_0_0_0_0_0_1_0;
      I: // for addi (i-type)
        {aluop, alusrc, memtoreg, regwrite, memread, memwrite, branch, jump} <= 9'b00_1_0_1_0_0_0_0;
      J, JR:
        {aluop, alusrc, memtoreg, regwrite, memread, memwrite, branch, jump} <= 9'b01_1_0_1_0_0_0_1;
      default:
        {aluop, alusrc, memtoreg, regwrite, memread, memwrite, branch, jump} <= 9'b00_0_0_0_0_0_0_0;
    endcase
  end

endmodule