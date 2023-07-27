`include "datamemory.v"

module datamemory_tb;//(address, writedata, memread, memwrite, readdata);

    reg clk;
    reg memread, memwrite;
    reg [31:0] writedata;
    reg [9:0] address;
    
    wire [31:0] readdata;

    datamemory   uut(clk, address, writedata, memread, memwrite, readdata);

    always #1 clk = ~clk;

    initial 
        begin
            $dumpfile("../vcd/datamemory_tb.vcd");
            $dumpvars(2, datamemory_tb);

            clk = 0;

            #3
            memread     = 0;
            memwrite    = 1;
            address     = 10'b00_0000_0000;

            #3
            writedata   = 32'b1100_0000_0000_0000_0000_0000_1111_0000;

            #3
            address     = 10'b00_0000_0001;

            #3
            writedata   = 32'b0000_0000_0000_0000_0000_1111_0000_0000;

            #3
            address     = 10'b00_0000_0010;

            #3
            writedata   = 32'b0000_0000_0000_0000_1111_0000_0000_0000;

            #3
            address     = 10'b00_0000_0011;

            #3
            writedata   = 32'b0000_0000_0000_1111_0000_0000_0000_0000;

            #3
            address     = 10'b01_0100_0101;

            #3
            writedata   = 32'b1111_0000_0000_0000_0000_1111_0000_0000;

            #3
            address     = 10'b11_0000_0101;

            #3
            writedata   = 32'b1001_0000_0110_0000_0000_1111_0000_0000;

            #3
            address     = 10'b10_1110_0000;

            #3
            writedata   = 32'b1100_0111_0000_0011_0000_1111_0000_0000;

            #3
            memread     = 1;
            memwrite    = 0;

            #3
            address     = 10'b00_0000_0000;

            #3
            $display("readdata: %d", readdata);

            #3
            address     = 10'b00_0000_0001;

            #3
            $display("readdata: %d", readdata);

            #3
            address     = 10'b00_0000_0010;

            #3
            $display("readdata: %d", readdata);

            #3
            address     = 10'b00_0000_0011;

            #3
            $display("readdata: %d", readdata);

            #3
            address     = 10'b01_0100_0101;

            #3
            $display("readdata: %d", readdata);

            #3
            address     = 10'b11_0000_0101;

            #3
            $display("readdata: %d", readdata);

            #3
            address     = 10'b10_1110_0000;

            #3
            $display("readdata: %d", readdata);

            $finish;
        end



endmodule