module instructionmemory(pc, instruction);

    input [9:0] pc; // change later
    
    output wire [31:0] instruction;

    reg [7:0] memfile [0:1023]; // increase memory size later

    assign instruction = {memfile[pc+3], memfile[pc+2], memfile[pc+1], memfile[pc]};

    // integer fd;
    // integer var;
    // integer i = 0;

    // initial
    //     begin // write instructions here

    //         //instructions from file
    //         fd = $fopen("instructions.txt", "r");

    //         while ( ! $feof(fd) ) 
    //             begin
    //                 $fgets(var, fd);
    //                 {memfile[i+3], memfile[i+2], memfile[i+1], memfile[i]} = var;
    //             end
    //     end

endmodule