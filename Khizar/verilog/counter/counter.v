module counter (
    input clk,
    input rst,
    input inc,
    input dec,
    output reg [3:0] count
);

reg        enable;
reg [3:0] mux_out;

always @ (*)
    enable = inc | dec;

always @ (*)
    begin
 
      case (inc)
        1'b0: mux_out = count - 1;
        1'b1: mux_out = count + 1;
      endcase

    end

always @ (posedge clk)
    if (rst)
        count <= #1 0;
    else if (enable)
        count <= #1 mux_out;

endmodule
