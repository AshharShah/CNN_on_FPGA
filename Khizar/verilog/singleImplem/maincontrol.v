module maincontrol(instruction, branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);

    input [7:0] instruction;

    output branch, memread, memtoreg, memwrite, alusrc, regwrite;
    output [1:0] aluop;

    always @ (instruction)
        begin
          case (instruction)
            7'b0110011: alusrc <=  
            default: 
          endcase
        end


endmodule