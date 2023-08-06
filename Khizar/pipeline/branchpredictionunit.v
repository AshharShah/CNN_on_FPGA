module branchpredictionunit(rs1_if, rs2_if, rd_id, branch, a, b, pc_src, flush_if);

    input branch;
    input [31:0] a, b;
    input [4:0] rs1_if, rs2_if, rd_id;
    output reg flush_if, pc_src;

    initial
    begin
        flush_if <= 0;
    end

    always @ (branch, a, b)
    begin
        if (branch == 0)
        begin
            flush_if <= 0;
            pc_src   <= 0;
        end
        else
        begin
            if (rd_id == rs1_if | rd_id == rs2_if)
            begin
                flush_if <= 1;
                pc_src   <= 1;
            end
            else
            begin
                flush_if <= (a == b) ? 1: 0;
                pc_src   <= (a == b) ? 1: 0;
            end
        end
    end

endmodule