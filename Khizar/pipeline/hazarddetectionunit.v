module hazarddetectionunit(memread_id, rs1_if, rs2_if, rd_id, jump_ex, enable_if, enable_pc, enable_control);

    input memread_id, jump_ex;
    input [4:0] rs1_if, rs2_if, rd_id;
    
    output reg enable_if, enable_pc, enable_control;

    always @ (rs1_if, rs2_if, memread_id, rd_id)
    begin    
        // if (memread_id & !jump_ex & ((rd_id == rs1_if) | (rd_id == rs2_if)))
        //     begin
        //         enable_control <= 0;
        //         enable_pc      <= 0;
        //         enable_if      <= 0;
        //     end
        // else
        //     begin
                 enable_control <= 1;
                 enable_pc      <= 1;
                 enable_if      <= 1;
        //     end

    end



endmodule