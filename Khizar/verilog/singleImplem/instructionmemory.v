module instructionmemory(pc, instruction);

    input [9:0] pc; // change later
    
    output reg [31:0] instruction;

    reg [31:0] memfile [0:1023]; // increase memory size later

    initial
        begin // write instructions here
            // x0 = 0 already done

            //  addi x10, x0, 1
            //                immediate         rs1   func3   rd       opcode     
            memfile[0] <= 32'b0000_0000_0001___00000___000___01010___000_0011;

            

            //  addi x2, x1, 1.  0000000000000000000000001            0010011
            memfile[1] <= 32'b0000_0000_0001___00001___000___00010___000_0011;

            //  addi x2, x1, 1
            //memfile[2] <= 32'b0000000___00000___00010___000___00010___000_0011;
              
            //  addi x4, x3, 1 
            //memfile[3] <= 32'b0000000___00000___00011___000___00011___000_0011;

            //  addi x4, x3, 1
            //memfile[4] <= 32'b0000000___00000___00100___000___00100___000_0011;

            //  addi x4, x3, 1
            //memfile[5] <= 32'b0000000___00000___00101___000___00101___000_0011;
        end

    always @ (pc)
        begin
            instruction <= memfile[pc];
        end

endmodule