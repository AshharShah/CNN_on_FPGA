module alucontrol(aluop, func7, func3, jump, aluctl);

    input [1:0] aluop;
    input func7, jump;
    input [2:0] func3;

    output reg [3:0] aluctl;

    always @ (aluop, func7, func3)
      begin
        case (aluop)
            2'b00:
              begin
                case (func3)
                  3'b000: aluctl <= 4'b0010;
                  3'b001: aluctl <= 4'b0011;
                  3'b010: aluctl <= 4'b0111;
                  //3'b011: aluctl <= 4'b0000;
                  3'b100: aluctl <= 4'b1100;
                  3'b101: aluctl <= 4'b0100;
                  3'b110: aluctl <= 4'b0001;
                  3'b111: aluctl <= 4'b0000;
                endcase
              end
            2'b01:
              begin
                if (jump)
                  aluctl <= 4'b0010;
                else
                  begin
                    case (func3)
                      3'b000: aluctl <= 4'b0110;
                      3'b001: aluctl <= 4'b1000;
                      3'b101: aluctl <= 4'b0111;
                    endcase
                  end
              end
            2'b10: // for R-type instructions
              begin
                case (func7)
                    1'b0:
                      begin
                        case (func3)
                            3'b000:
                              aluctl <= 4'b0010;
                            3'b010:
                              aluctl <= 4'b0111;
                            3'b001:
                              aluctl <= 4'b0011;
                            3'b111:
                              aluctl <= 4'b0000;
                            3'b100:
                              aluctl <= 4'b1100;
                            3'b101:
                              aluctl <= 4'b0100;
                            3'b110:
                              aluctl <= 4'b0001;
                        endcase
                      end
                    1'b1:
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