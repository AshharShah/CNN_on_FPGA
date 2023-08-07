module mux2_1b(in1, in2, s, out);

    input in1, in2;
    input s;

    output wire out;

    assign out = (s == 0) ? in1 : in2;

endmodule