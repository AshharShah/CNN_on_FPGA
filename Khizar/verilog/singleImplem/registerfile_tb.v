`include "registerfile.v"

module registerfile_tb;

    reg [4:0] rs1, rs2, rd;
    reg [31:0] writedata;
    reg regwrite;
    wire [31:0] readdata1, readdata2;

    //rs1, rs2, rd, writedata, regwrite, readdata1, readdata2
    registerfile uut(rs1, rs2, rd, writedata, regwrite, readdata1, readdata2);

    //initialize some registers
    initial
        begin
            $dumpfile("./vcd/registerfile_tb.vcd");
            $dumpvars(1, registerfile_tb);

            #1
            regwrite = 1;

            #1 // x0 = 0
            rd            = 5'b00000;

            #1
            writedata     = {{28{1'b0}}, 4'b0000};

            #1 // x1 = 1
            rd            = 5'b00001;
            
            #1
            writedata     = {{28{1'b0}}, 4'b0001};

            #1 // x2 = 2
            rd            = 5'b00010;
                 
            #1
            writedata     = {{28{1'b0}}, 4'b0010};

            #1 // x3 = 3
            rd            = 5'b00011;
         
            #1
            writedata     = {{28{1'b0}}, 4'b0011};

            #1 // x4 = 4
            rd            = 5'b00100;
           
            #1
            writedata     = {{28{1'b0}}, 4'b0100};
            
            #1 // x5 = 5
            rd            = 5'b00101;
          
            #1
            writedata     = {{28{1'b0}}, 4'b0101};
            
            #1
            rs1           = 5'b00000;
            rs2           = 5'b00001;

            #1
            $display("x0: %d", readdata1);
            $display("x1: %d", readdata2);

            #1
            rs1           = 5'b00010;
            rs2           = 5'b00011;

            #1
            $display("x2: %d", readdata1);
            $display("x3: %d", readdata2);

            #1
            rs1           = 5'b00100;
            rs2           = 5'b00101;

            #1
            $display("x4: %d", readdata1);
            $display("x5: %d", readdata2);

            #1
            rs1           = 5'b00010;
            rs2           = 5'b00100;

            #1
            $display("x2: %d", readdata1);
            $display("x4: %d", readdata2);

            #1
            regwrite = 0;

            #1 // x0 = 0
            rd            = 5'b00001;

            #1
            writedata     = {{28{1'b0}}, 4'b0100};

            #1 // x0 = 0
            rd            = 5'b00011;

            #1
            writedata     = {{28{1'b0}}, 4'b0110};

            #1
            rs1           = 5'b00001;
            rs2           = 5'b00011;

            #1
            $display("x1: %d", readdata1);
            $display("x3: %d", readdata2);

        end



endmodule