module datamemory(clk, state, address, writedata, memread, memwrite, readdata);

    input [1:0] state;
    input clk;
    input memread, memwrite;
    input [31:0] writedata;
    input [9:0] address; // change later
    
    output reg [31:0] readdata;

    reg [31:0] memfile [0:1023]; // increase memory size later

    always @ (clk)
        begin
            if (state == 2)
                begin
                    if (memwrite == 1)
                        memfile[address] <= writedata;
                    else if (memread == 1)
                        readdata <= memfile[address];
                end
        end

endmodule