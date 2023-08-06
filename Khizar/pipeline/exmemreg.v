module exmemreg(clk, zero,    alures,    b_id, rd_id, branch_id, memread_id, memtoreg_id, memwrite_id, regwrite_id,
                     zero_ex, alures_ex, b_ex, rd_ex, branch_ex, memread_ex, memtoreg_ex, memwrite_ex, regwrite_ex);

    input clk, zero, branch_id, memread_id, memtoreg_id, memwrite_id, regwrite_id;
    input [31:0] alures, b_id;
    input [4:0] rd_id;

    output reg zero_ex, branch_ex, memread_ex, memtoreg_ex, memwrite_ex, regwrite_ex;
    output reg [31:0] alures_ex, b_ex;
    output reg [4:0] rd_ex;

    initial 
    begin
        zero_ex     <=  0;
        branch_ex   <=  0;
        memread_ex  <=  0;
        memtoreg_ex <=  0;
        memwrite_ex <=  0;
        alures_ex   <=  0;
        b_ex        <=  0;
        rd_ex       <=  0;
        regwrite_ex <=  0;
    end

    always @(posedge clk) 
    begin
        zero_ex     <=  zero;
        branch_ex   <=  branch_id;
        memread_ex  <=  memread_id;
        memtoreg_ex <=  memtoreg_id;
        memwrite_ex <=  memwrite_id;
        alures_ex   <=  alures;
        b_ex        <=  b_id;
        rd_ex       <=  rd_id;
        regwrite_ex <= regwrite_id;
    end

endmodule


    