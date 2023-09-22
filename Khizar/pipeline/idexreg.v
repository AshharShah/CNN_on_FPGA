module idexreg(clk, pc_if, a,    b,    immediate,    func7,      func3,    rd,    opcode_if, branch_if, memread_if, memtoreg_if, aluop_if, memwrite_if, alusrc_if, regwrite_if, rs1_if, rs2_if, pcsrc, jump, 
                    pc_id, a_id, b_id, immediate_id, func7_id,   func3_id, rd_id, opcode_id, branch_id, memread_id, memtoreg_id, aluop_id, memwrite_id, alusrc_id, regwrite_id, rs1_id, rs2_id, jump_id);

    input clk, branch_if, memread_if, memtoreg_if, memwrite_if, alusrc_if, func7, regwrite_if, pcsrc, jump;
    input [1:0] aluop_if;
    input [31:0] pc_if, a, b, immediate;
    input [4:0] rd, rs1_if, rs2_if;
    input [2:0] func3;
    input [6:0] opcode_if;

    output reg branch_id, memread_id, memtoreg_id, memwrite_id, alusrc_id, func7_id, regwrite_id, jump_id;
    output reg [1:0] aluop_id;
    output reg [31:0] pc_id, a_id, b_id, immediate_id;
    output reg [4:0] rd_id, rs1_id, rs2_id;
    output reg [2:0] func3_id;
    output reg [6:0] opcode_id;

    initial
    begin
        branch_id    <= 0;
        memread_id   <= 0;
        memtoreg_id  <= 0;
        memwrite_id  <= 0;
        alusrc_id    <= 0;
        aluop_id     <= 0;
        pc_id        <= 0;
        a_id         <= 0;
        b_id         <= 0;
        immediate_id <= 0;
        rd_id        <= 0;
        func3_id     <= 0;
        func7_id     <= 0;
        regwrite_id  <= 0;
        rs1_id       <= 0;
        rs2_id       <= 0;
        jump_id      <= 0;
        opcode_id    <= 0;
    end

    always @(posedge clk)
    begin
        if (pcsrc)
            begin
                branch_id    <= 0;
                memread_id   <= 0;
                memtoreg_id  <= 0;
                memwrite_id  <= 0;
                alusrc_id    <= 0;
                aluop_id     <= 0;
                pc_id        <= 0;
                a_id         <= 0;
                b_id         <= 0;
                immediate_id <= 0;
                rd_id        <= 0;
                func3_id     <= 0;
                func7_id     <= 0;
                regwrite_id  <= 0;
                rs1_id       <= 0;
                rs2_id       <= 0;
                jump_id      <= 0;
                opcode_id    <= 0;
            end
        else
            begin
                branch_id    <= branch_if;
                memread_id   <= memread_if;
                memtoreg_id  <= memtoreg_if;
                memwrite_id  <= memwrite_if;
                alusrc_id    <= alusrc_if;
                aluop_id     <= aluop_if;
                pc_id        <= pc_if;
                a_id         <= a;
                b_id         <= b;
                immediate_id <= immediate;
                rd_id        <= rd;
                func3_id     <= func3;
                func7_id     <= func7;
                regwrite_id  <= regwrite_if;
                rs1_id       <= rs1_if;
                rs2_id       <= rs2_if;
                jump_id      <= jump;
                opcode_id    <= opcode_if;
            end
    end

endmodule