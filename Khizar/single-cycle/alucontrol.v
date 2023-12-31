module alucontrol(aluop, func7, func3, aluctl);

    input [1:0] aluop;
    input [6:0] func7;
    input [2:0] func3;

    output reg [3:0] aluctl;

    always @ (aluop, func7, func3)
      begin
        case (aluop)
            2'b00:
              case (func3)
                3'b000:
                  aluctl <= 4'b0010;
                3'b001:
                  aluctl <= 4'b0011;
              endcase
            2'b01:
              case (func3)
                3'b000:
                  aluctl <= 4'b0110;
                3'b101:
                  aluctl <= 4'b0111;
              endcase
            2'b10:
              begin
                case (func7)
                    7'b0000000:
                      begin
                        case (func3)
                            3'b000:
                              aluctl <= 4'b0010;
                            3'b010:
                              aluctl <= 4'b0111;
                            3'b111:
                              aluctl <= 4'b0000;
                            3'b100:
                              aluctl <= 4'b1100;
                            3'b110:
                              aluctl <= 4'b0001;
                        endcase
                      end
                    7'b0100000:
                      begin
                        case (func3)
                            3'b000:
                              aluctl <= 4'b0110;
                        endcase
                      end
                endcase
              end
            2'b11:
              aluctl <= 4'b0010;
            default:
              aluctl <= 4'b0000;
        endcase
      end
endmodule