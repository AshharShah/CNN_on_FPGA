`include "./image.v"
`include "./conv.v"

module image_tb;

    reg clk, rst;

    integer i;
    integer j;

    image im1();
    convolution conv1();

    initial
        begin
            $dumpfile("./vcd/image.vcd");
            $dumpvars(2, image_tb);

            $readmemb("image1file", image_tb.im1.imfile);

            for(i = 0; i < 784; i = i + 1)
            begin
                $display("%7b", im1.imfile[i]);
            end

        end
endmodule