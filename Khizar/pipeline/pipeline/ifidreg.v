module ifidreg(clk, pc, ins, pc_if, ins_if);

    input clk;
    input [31:0] pc, ins;

    output reg [31:0] pc_if, ins_if;

    initial 
    begin
        pc_if       <= 0;
        ins_if      <= 0; 
    end

    always @(posedge clk) 
    begin
        pc_if       <=  pc;
        ins_if      <= ins; 
    end

endmodule