module ifidreg(clk, enable_if, pcsrc, pc, ins, pc_if, ins_if);

    input clk, enable_if, pcsrc;
    input [31:0] pc, ins;

    output reg [31:0] pc_if, ins_if;

    initial 
    begin
        pc_if       <= 0;
        ins_if      <= 0; 
    end

    always @(posedge clk) 
    begin
        if (enable_if == 1 && pcsrc == 0)
        begin
            pc_if       <=  pc;
            ins_if      <= ins; 
        end
        else
        begin
            pc_if       <= 0;
            ins_if      <= 0;
        end
    end

endmodule