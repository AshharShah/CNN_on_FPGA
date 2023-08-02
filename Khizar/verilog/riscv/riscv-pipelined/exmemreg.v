module exmemreg(clk, sumB,    zero,    alures,    b_id, rd_id, branch_id, memread_id, memtoreg_id, memwrite_id, 
                     sumB_ex, zero_ex, alures_ex, b_ex, rd_ex, branch_ex, memread_ex, memtoreg_ex, memwrite_ex);

    input clk, zero, branch_id, memread_id, memtoreg_id, memwrite_id;
    input [31:0] sumB, alures, b_id;
    input [4:0] rd_id;

    output reg zero_ex, branch_ex, memread_ex, memtoreg_ex, memwrite_ex;
    output reg [31:0] sumB_ex, alures_ex, b_ex;
    output reg [4:0] rd_ex;

    always @(posedge clk) 
    begin
        zero_ex     <=  zero;
        branch_ex   <=  branch_id;
        memread_ex  <=  memread_id;
        memtoreg_ex <=  memtoreg_id;
        memwrite_ex <=  memwrite_id;
        sumB_ex     <=  sumB;
        alures_ex   <=  alures;
        b_ex        <=  b_id;
        rd_ex       <=  rd_id;
    end

endmodule


    