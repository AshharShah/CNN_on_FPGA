`include "datamemory.v"

module datamemory_tb;//(address, writedata, memread, memwrite, readdata);

    reg memread, memwrite;
    reg [31:0] writedata;
    reg [9:0] address;
    
    wire [31:0] readdata;

    datamemory   uut(address, writedata, memread, memwrite, readdata);

    initial 
        begin
            $dumpfile("./vcd/datamemory_tb.vcd");
            $dumpvars(2, datamemory_tb);

            #1
            memread     = 0;
            memwrite    = 1;
            address     = 10'b00_0000_0000;

            #1
            writedata   = 32'b1100_0000_0000_0000_0000_0000_1111_0000;

            #1
            address     = 10'b00_0000_0001;

            #1
            writedata   = 32'b0000_0000_0000_0000_0000_1111_0000_0000;

            #1
            address     = 10'b00_0000_0010;

            #1
            writedata   = 32'b0000_0000_0000_0000_1111_0000_0000_0000;

            #1
            address     = 10'b00_0000_0011;

            #1
            writedata   = 32'b0000_0000_0000_1111_0000_0000_0000_0000;

            #1
            address     = 10'b01_0100_0101;

            #1
            writedata   = 32'b1111_0000_0000_0000_0000_1111_0000_0000;

            #1
            address     = 10'b11_0000_0101;

            #1
            writedata   = 32'b1001_0000_0110_0000_0000_1111_0000_0000;

            #1
            address     = 10'b10_1110_0000;

            #1
            writedata   = 32'b1100_0111_0000_0011_0000_1111_0000_0000;

            #1
            memread     = 1;
            memwrite    = 0;

            #1
            address     = 10'b00_0000_0000;

            #1
            $display("readdata: %d", readdata);

            #1
            address     = 10'b00_0000_0001;

            #1
            $display("readdata: %d", readdata);

            #1
            address     = 10'b00_0000_0010;

            #1
            $display("readdata: %d", readdata);

            #1
            address     = 10'b00_0000_0011;

            #1
            $display("readdata: %d", readdata);

            #1
            address     = 10'b01_0100_0101;

            #1
            $display("readdata: %d", readdata);

            #1
            address     = 10'b11_0000_0101;

            #1
            $display("readdata: %d", readdata);

            #1
            address     = 10'b10_1110_0000;

            #1
            $display("readdata: %d", readdata);

        end



endmodule