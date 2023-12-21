`include "./conv.v"
`include "./image.v"

module conv_tb;

    integer i;
    integer j;

    reg [31:0] filter00 = 32'b10111111100111111101001010100110; // -1.248616;
    reg [31:0] filter01 = 32'b10111111101100010000100001101000; // -1.383069
    // real filter02 = -1.220503;
    // real filter10 = -1.248262;
    // real filter11 = -1.103052;
    // real filter12 =  1.349487;
    // real filter20 = -0.329048;
    // real filter21 = -0.733146;
    // real filter22 = -1.360132;

    convolution conv1();

    initial
        begin
            $dumpfile("./vcd/conv_tb.vcd");
            $dumpvars(2, conv_tb);

            for(i = 0; i < 2; i = i + 1)
            begin
                $display("%f", filter00 * filter01);
            end

            // $writememb(dump_location, array_name);
        end
endmodule