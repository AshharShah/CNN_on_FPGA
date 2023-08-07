module mux2_1(in1, in2, s, out);

    input [31:0] in1, in2;
    input s;

    output wire [31:0] out;

    assign out = (s == 0) ? in1 : in2;

endmodule