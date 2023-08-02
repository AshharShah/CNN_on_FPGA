module ifidreg(clk, pc,    ins,    branch,    memread,    memtoreg,    aluop,    memwrite,    alusrc,    regwrite, 
                    pc_if, ins_if, branch_if, memread_if, memtoreg_if, aluop_if, memwrite_if, alusrc_if, regwrite_if);

    input clk, branch, memread, memtoreg, memwrite, alusrc, regwrite;
    input [1:0] aluop;
    input [31:0] pc, ins;

    output reg [31:0] pc_if, ins_if;
    output reg branch_if, memread_if, memtoreg_if, memwrite_if, alusrc_if, regwrite_if;
    output reg [1:0] aluop_if;

    initial 
    begin
        pc_if       <= 0;
        ins_if      <= 0; 
        branch_if   <= 0; 
        memread_if  <= 0; 
        memtoreg_if <= 0; 
        aluop_if    <= 0;
        memwrite_if <= 0;
        alusrc_if   <= 0;
        regwrite_if <= 0; 
    end

    always @(posedge clk) 
    begin
        pc_if       <=  pc;
        ins_if      <= ins; 
        branch_if   <= branch; 
        memread_if  <= memread; 
        memtoreg_if <= memtoreg; 
        aluop_if    <= aluop;
        memwrite_if <= regwrite;
        alusrc_if   <= alusrc;
        regwrite_if <= regwrite;
    end

endmodule