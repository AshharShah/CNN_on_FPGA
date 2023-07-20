module mux2_1(in1, in2, s, out);

    input [31:0] in1, in2;
    input s;

    output reg [31:0] out;

    always @ (in1, in2, s)
        begin
            if (s == 0)
                out <= in1;
            else
                out <= in2;
        end

endmodule