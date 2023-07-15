module instructionmemory(pc, instruction);

    input [9:0] pc; // change later
    
    output reg [31:0] instruction;

    reg [31:0] memfile [0:1023]; // increase memory size later

    initial
        begin
            // write instructions here
            memfile[0] <= 32'b0101_0111_0000_0000_0101_0111_0000_0000;
            memfile[1] <= 32'b0111_0111_0000_0100_0101_0111_1000_0010;
            memfile[2] <= 32'b0101_0111_0010_1010_0101_0111_0010_0000;
            memfile[3] <= 32'b0101_0111_0010_0000_0101_0111_0110_0011;
            memfile[4] <= 32'b0111_0111_0100_0100_0111_0111_1001_0010;
            memfile[5] <= 32'b0101_0111_0010_1011_0101_0111_0010_1100;
        end

    always @ (pc)
        begin
            instruction <= memfile[pc];
        end

endmodule