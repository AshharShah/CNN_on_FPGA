`include "./conv.v"

module image_tb;

    reg clk, rst;

    integer i;
    integer j;

    convolution conv1();

    initial
        begin
            $dumpfile("./vcd/image.vcd");
            $dumpvars(2, image_tb);

            $readmemh("fil", image_tb.conv1.filter);
            $display("\n\nFilter:\n");

            for(i = 0; i < 3; i = i + 1)
            begin
                for(j = 0; j < 3; j = j + 1)
                begin
                    $display("%7b", conv1.filter[i][j]);
                end
            end
        end
endmodule