module pc(clk, rst, in, out);
    
    input clk, rst;
    input [31:0] in;
    output reg [31:0] out;

    always @(posedge clk)
        begin
            if (rst == 1)
                out <= 0;
            else
                out <= in;        
        end

endmodule