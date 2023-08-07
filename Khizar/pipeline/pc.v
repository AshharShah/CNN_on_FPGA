module pc(clk, rst, in, enable, out);
    
    input clk, rst, enable;
    input [31:0] in;
    output reg [31:0] out;

    always @(posedge clk)
        begin
            if (rst == 1)
                out <= 0;
            else if (enable == 1)
                out <= in;
        end

endmodule