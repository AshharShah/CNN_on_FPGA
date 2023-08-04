module forwardingunit(rs1_id, rs2_id, rd_ex, regwrite_ex, rd_wb, regwrite_wb, forwardA, forwardB);

    input [4:0] rs1_id, rs2_id, rd_ex, rd_wb;
    input regwrite_ex, regwrite_wb;

    output reg[1:0] forwardA, forwardB;

    always @(rs1_id, rs2_id, rd_ex, regwrite_ex, rd_wb, regwrite_wb)
    begin
        if      (regwrite_ex & (rd_ex != 0) & (rd_ex == rs1_id))
                    forwardA <= 2'b01;
        else if (regwrite_wb & (rd_wb != 0) & (rd_wb == rs1_id))
                    forwardA <= 2'b10;
        else
                    forwardA <= 2'b00;

        if      (regwrite_ex & (rd_ex != 0) & (rd_ex == rs2_id))
                    forwardB <= 2'b01;
        else if (regwrite_wb & (rd_wb != 0) & (rd_wb == rs2_id))
                    forwardB <= 2'b10;
        else
                    forwardB <= 2'b00;
    end

endmodule