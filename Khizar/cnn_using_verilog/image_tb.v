`include "./image.v"

module image_tb;

    reg clk, rst;

    integer i;
    integer j;
    integer fd;

    image im1();

    initial
        begin
            $dumpfile("./vcd/image.vcd");
            $dumpvars(2, image_tb);

            //$readmemh({"./set-instructions/test-", test_case_number, ".hex"}, core.insmem.memfile);
            //$readmemh("image1.png", image_tb.im1.imfile);
            fd = $fopen("./image1.png", "r");

            $fgets(image_tb.im1.imfile, fd);

            for(i = 0; i < 3; i = i + 1)
                begin
                    $display("%0s", im1.imfile[i]);
                end
            // for(i = 0; i < 3; i = i + 1)
            // begin
            //     for(j = 0; j < 3; j = j + 1)
            //     begin
            //         #1
            //         $display("%b", im1.imfile[i][j]);
            //     end
            // end
            $fclose(fd);
        end
endmodule