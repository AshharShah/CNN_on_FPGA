module ifidreg(clk, pc, instruction, pc_out, instruction_out);

    input [31:0] pc, instruction;

    always @(posedge clk) 
    begin
        pc_out <= pc;
        instruction_out <= instruction;
    end

endmodule