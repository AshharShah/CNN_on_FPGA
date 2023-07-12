module datamemory(address, writedata, memread, memwrite, memtoreg, result);

    input memread, memwrite, memtoreg;
    input [31:0] address, writedata;
    
    reg [31:0] readdata;

    output reg [31:0] result;

    reg [1023:0] memfile [0:31]; // increase memory size later

    always @ (address, writedata, memread, memwrite)
        begin
            if (memwrite == 1) // rd = 0 shouldn't be written
                memfile[address] <= writedata;
            else if (memread == 1)
                readdata <= memfile[address];

            if (memtoreg)
                result <= readdata;
            else
                result <= address;
        end

endmodule