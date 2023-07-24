module alucontrol(aluop, func7, func3, aluctl);

    input [1:0] aluop;
    input [6:0] func7;
    input [2:0] func3;

    output reg [3:0] aluctl;

    always @ (aluop, func7, func3)
        begin
          if (aluop == 2'b00)
            aluctl <= 4'b0010;
          else if (aluop == 2'b01) 
            aluctl <= 4'b0110;
          else if (aluop == 2'b10)
            begin
              if (func7 == 7'b0000000)
                begin
                  if (func3 == 3'b000)
                    aluctl <= 4'b0010;
                  else if (func3 == 3'b111)
                    aluctl <= 4'b0000;
                  else if (func3 == 3'b100)
                    aluctl <= 4'b1100;
                  else if (func3 == 3'b110)
                    aluctl <= 4'b0001;
                end
              else if (func7 == 7'b0100000)
                begin
                  if (func3 == 3'b000)
                    aluctl <= 4'b0110;
                end
            end
        end

endmodule