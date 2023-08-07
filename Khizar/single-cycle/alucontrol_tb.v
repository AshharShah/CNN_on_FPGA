`include "alucontrol.v"

module alucontrol_tb;//(aluop, func7, func3, aluctl);

    reg [1:0] aluop;
    reg [6:0] func7;
    reg [2:0] func3;

    wire [3:0] aluctl;

    alucontrol uut(aluop, func7, func3, aluctl);

    initial 
        begin
            $dumpfile("../vcd/alucontrol_tb.vcd");
            $dumpvars(1, alucontrol_tb);

            #1
            aluop = 2'b00;
            func7 = 7'b000_0000;
            func3 = 3'b000;

            #1
            $display("aluctl: %d", aluctl);

            #1
            aluop = 2'b00;
            func7 = 7'b000_1111;
            func3 = 3'b010;

            #1
            $display("aluctl: %d", aluctl);

            #1
            aluop = 2'b00;
            func7 = 7'b111_1001;
            func3 = 3'b111;

            #1
            $display("aluctl: %d", aluctl);

            #1
            aluop = 2'b01;
            func7 = 7'b000_1001;
            func3 = 3'b111;

            #1
            $display("aluctl: %d", aluctl);

            #1
            aluop = 2'b01;
            func7 = 7'b111_1101;
            func3 = 3'b001;

            #1
            $display("aluctl: %d", aluctl);

            #1
            aluop = 2'b01;
            func7 = 7'b001_1111;
            func3 = 3'b101;

            #1
            $display("aluctl: %d", aluctl);

            #1
            aluop = 2'b10;
            func7 = 7'b000_0000;
            func3 = 3'b000;

            #1
            $display("aluctl: %d", aluctl);

            #1
            aluop = 2'b10;
            func7 = 7'b010_0000;
            func3 = 3'b000;

            #1
            $display("aluctl: %d", aluctl);

            #1
            aluop = 2'b10;
            func7 = 7'b000_0000;
            func3 = 3'b111;

            #1
            $display("aluctl: %d", aluctl);

            #1
            aluop = 2'b10;
            func7 = 7'b000_0000;
            func3 = 3'b110;

            #1
            $display("aluctl: %d", aluctl);


        end

endmodule