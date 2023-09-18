module alu(aluctl, a, b, out, zero, overflow);

    input [3:0] aluctl; 

    input [31:0] a;
    input [31:0] b;

    output reg [31:0] out;
    output zero, overflow;

    assign zero = (out == 0);

    always @ (aluctl, a, b)
        begin
            case (aluctl)
                0: out <= a & b;
                1: out <= a | b;
                2: out <= a + b;
                3: out <= a << b; // do b[4:0] later
                4: out <= a >> b;
                5: out <= a >> b;
                6: out <= a - b;
                7: out <= (a < b ? 1: 0);
                8: out <= (a == b);
                12: out <= a ^ b;
                default: out <= 0;
            endcase
        end

endmodule