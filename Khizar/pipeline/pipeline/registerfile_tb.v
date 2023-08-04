`include "registerfile.v"

module registerfile_tb;

    reg clk;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] writedata;
    reg regwrite;
    wire [31:0] readdata1, readdata2;

    //rs1, rs2, rd, writedata, regwrite, readdata1, readdata2
    registerfile uut(clk, rs1, rs2, rd, writedata, regwrite, readdata1, readdata2);

    always #1 clk = ~clk;

    //initialize some registers
    initial
        begin
            $dumpfile("../vcd/registerfile_tb.vcd");
            $dumpvars(1, registerfile_tb);

            clk = 0;

            #3
            regwrite = 1;

            #3 // x0 = 0
            rd            = 5'b00000;
            writedata     = {{28{1'b0}}, 4'b0000};

            #3 // x1 = 1
            rd            = 5'b00001;
            writedata     = {{28{1'b0}}, 4'b0001};

            #3 // x2 = 2
            rd            = 5'b00010;
            writedata     = {{28{1'b0}}, 4'b0010};

            #3 // x3 = 3
            rd            = 5'b00011;
            writedata     = {{28{1'b0}}, 4'b0011};

            #3 // x4 = 4
            rd            = 5'b00100;
            writedata     = {{28{1'b0}}, 4'b0100};
            
            #3 // x5 = 5
            rd            = 5'b00101;
            writedata     = {{28{1'b0}}, 4'b0101};
            
            #3
            rs1           = 5'b00000;
            rs2           = 5'b00001;
            $display("x0: %d", readdata1);
            $display("x1: %d", readdata2);

            #3
            rs1           = 5'b00010;
            rs2           = 5'b00011;
            $display("x2: %d", readdata1);
            $display("x3: %d", readdata2);

            #3
            rs1           = 5'b00100;
            rs2           = 5'b00101;
            $display("x4: %d", readdata1);
            $display("x5: %d", readdata2);

            #3
            rs1           = 5'b00010;
            rs2           = 5'b00100;
            $display("x2: %d", readdata1);
            $display("x4: %d", readdata2);

            #3
            regwrite = 0;
            rd            = 5'b00001;
            writedata     = {{28{1'b0}}, 4'b0100};

            #3 // x0 = 0
            rd            = 5'b00011;
            writedata     = {{28{1'b0}}, 4'b0110};

            #3
            rs1           = 5'b00001;
            rs2           = 5'b00011;
            $display("x1: %d", readdata1);
            $display("x3: %d", readdata2);

            #300 $finish;

        end



endmodule