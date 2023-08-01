module immediategen(instruction, result);

    //opcode types
    localparam I = 7'b0010011;
    localparam S = 7'b0100011;
    localparam SB = 7'b1100011;
    localparam I_LD = 7'b0000011;
    //localparam J = 7'b1101111;

    input [31:0] instruction;

    output reg [31:0] result;

    always @ (instruction)
        begin
            case (instruction[6:0])
                I_LD, I: 
                    result <= {{20{instruction[31]}}, instruction[31:20]};
                S: 
                    result <= {{19{instruction[31]}}, instruction[31:25], instruction[11:7]};
                SB: 
                    result <= {{18{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
                //J:
                //    result <= {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
                    
                default: result <= 0;
            endcase
        end

endmodule