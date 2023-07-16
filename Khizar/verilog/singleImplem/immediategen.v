module immediategen(instruction, result);

    input [31:0] instruction;

    output reg [31:0] result;

    always @ (instruction)
        begin
            case (instruction[6:0])
                7'b0000011, 7'b0010011: result <= {{20{instruction[31]}}, instruction[31:20]};
                7'b0100011: result <= {{19{instruction[31]}}, instruction[31:25], instruction[11:7]};
                7'b1100011: result <= {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
                default: result <= 0;
            endcase
        end

endmodule
