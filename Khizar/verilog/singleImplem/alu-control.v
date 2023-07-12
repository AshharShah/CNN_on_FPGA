module alucontrol(aluop, func7, func3, aluctl);

    input [1:0] aluop;
    input [6:0] func7;
    input [2:0] func3;

    output reg [3:0] aluctl;

    always @ (aluop, func7, func3)
        begin
          case ()
            32: op <= 2;
            34: op <= 6;
            36: op <= 0;
            37: op <= 1;
            default: op <= 15;
          endcase
        end





endmodule