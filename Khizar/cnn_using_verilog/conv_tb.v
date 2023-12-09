`include "./conv.v"
`include "./image.v"

module conv_tb;

    integer i;
    integer j;

    real filter00 = -1.248616;
    real filter01 = -1.383069;
    real filter02 = -1.220503;
    real filter10 = -1.248262;
    real filter11 = -1.103052;
    real filter12 =  1.349487;
    real filter20 = -0.329048;
    real filter21 = -0.733146;
    real filter22 = -1.360132;

    real sum = 0;

    real [31:0] conv_out [0:27][0:27];

    image im1();
    convolution conv1();

    initial
        begin
            $dumpfile("./vcd/conv_tb.vcd");
            $dumpvars(2, conv_tb);

            $readmemb("image1file.bin", im1.imfile);
            //$readmemb("fil", conv_tb.conv1.filter);
            #1
            for(i = 0; i < 28; i = i + 1)
            begin
                for(j = 0; j < 28; j = j + 1)
                begin

                    sum = im1.imfile[i-1][j-1] * filter00 + im1.imfile[i-1][j] * filter01 + im1.imfile[i-1][j+1] * filter02
                        + im1.imfile[i][j-1]   * filter10 + im1.imfile[i][j]   * filter11 + im1.imfile[i][j+1]   * filter12
                        + im1.imfile[i+1][j-1] * filter20 + im1.imfile[i+1][j] * filter21 + im1.imfile[i+1][j+1] * filter22;

                    $display("%8b -%d, %f", im1.imfile[i][j], j, sum);
                end
            end

            $writememb(dump_location, array_name);
        end
endmodule