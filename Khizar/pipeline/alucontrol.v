module alucontrol(aluop, func7, func3, aluctl);

    input [1:0] aluop;
    input func7;
    input [2:0] func3;

    output reg [3:0] aluctl;

    always @ (aluop, func7, func3)
      begin
        case (aluop)
            2'b00:
              aluctl <= 4'b0010;
            2'b01:
              aluctl <= 4'b0110;
            2'b10: // for R-type instructions
              begin
                case (func7)
                    1'b0:
                      begin
                        case (func3)
                            3'b000:
                              aluctl <= 4'b0010;
                            3'b111:
                              aluctl <= 4'b0000;
                            3'b100:
                              aluctl <= 4'b1100;
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
            default:
              aluctl <= 4'b0000;
        endcase
      end
endmodule