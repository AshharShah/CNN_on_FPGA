module datamemory(address, writedata, memread, memwrite, readdata);

    input memread, memwrite;
    input [31:0] writedata;
    input [9:0] address; // change later
    
    output reg [31:0] readdata;

    reg [31:0] memfile [0:1023]; // increase memory size later

    always @ (address, writedata, memread, memwrite)
        begin
            if (memwrite == 1)
                memfile[address] <= writedata;
            else if (memread == 1)
                readdata <= memfile[address];
        end

endmodule