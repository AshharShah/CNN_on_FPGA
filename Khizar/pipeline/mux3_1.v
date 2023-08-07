module mux3_1(in1, in2, in3, s, out);

    input [31:0] in1, in2, in3;
    input [1:0] s;

    output wire [31:0] out;

    //                                        00    01                    10    11
    assign out = (s[1] == 0) ? ((s[0] == 0) ? in1 : in2) : ((s[0] == 0) ? in3 : 0);

endmodule