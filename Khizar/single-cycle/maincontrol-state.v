module maincontrol(state, instruction, branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);

    input [1:0] state;
    input [6:0] instruction;

    output reg branch, memread, memtoreg, memwrite, alusrc, regwrite;
    output reg [1:0] aluop;

    

    always @ (state, instruction)
        begin
          case (instruction)
            7'b0110011: 
              begin
                alusrc <= 0;
                memtoreg <= 0;
                regwrite <= 1;
                memread <= 0;
                memwrite <= 0;
                branch <= 0;
                aluop <= 2'b10;
              end
            7'b0000011: 
              begin
                alusrc <= 1;
                memtoreg <= 1;
                regwrite <= 1;
                memread <= 1;
                memwrite <= 0;
                branch <= 0;
                aluop <= 2'b00;
              end
            7'b0100011:
              begin
                alusrc <= 1;
                regwrite <= 0;
                memread <= 0;
                memwrite <= 1;
                branch <= 0;
                aluop <= 2'b00;
              end
            7'b1100011: 
              begin
                alusrc <= 0;
                regwrite <= 0;
                memread <= 0;
                memwrite <= 0;
                branch <= 1;
                aluop <= 2'b01;
              end
            7'b0010011: // for addi (i-type)
              begin
                alusrc <= 1;
                regwrite <= 1;
                memtoreg <= 0;
                memread <= 0;
                memwrite <= 0;
                branch <= 0;
                aluop <= 2'b00;
              end

            default: 
              begin
                alusrc <= 0;
                regwrite <= 0;
                memread <= 0;
                memwrite <= 0;
                memtoreg <= 0;
                branch <= 0;
                aluop <= 2'b00;
              end
          endcase

          if (state == 0 | state == 1)
          begin
             alusrc <= 0;
             regwrite <= 0;
             memread <= 0;
             memwrite <= 0;
             memtoreg <= 0;
             branch <= 0;
             aluop <= 2'b00;
          end

        end

endmodule