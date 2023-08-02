module instructionmemory(pc, instruction);

    input [31:0] pc; // change later

    output wire [31:0] instruction;

    reg [7:0] memfile [0:1023]; // increase memory size later

    assign instruction = {memfile[pc+3], memfile[pc+2], memfile[pc+1], memfile[pc]};

endmodule