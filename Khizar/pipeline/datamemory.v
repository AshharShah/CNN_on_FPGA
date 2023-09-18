module datamemory(clk, address, writedata, memread, memwrite, func3_ex, readdata);

    input clk, memread, memwrite;
    input [2:0] func3_ex;
    input [31:0] writedata;
    input [31:0] address; // change later
    
    output wire [31:0] readdata;

    reg [7:0] memfile [0:1023]; // increase memory size later

    assign readdata = (memread == 1) ? {memfile[address+3], memfile[address+2], memfile[address+1], memfile[address]} : 0;

    always @ (posedge clk)
        begin
            if (memwrite == 1)
                {memfile[address+3], memfile[address+2], memfile[address+1], memfile[address]} <= writedata;
        end

endmodule