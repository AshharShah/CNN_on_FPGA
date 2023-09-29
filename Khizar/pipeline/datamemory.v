module datamemory(clk, address, writedata, memread, memwrite, func3_ex, readdata);

    input clk, memread, memwrite;
    input [2:0] func3_ex;
    input [31:0] writedata;
    input [31:0] address; // change later
    
    output wire [31:0] readdata;
    wire [15:0] one_byte;
    wire [7:0] half_word;
    wire [31:0] one_word;

    reg [7:0] memfile [0:1023]; // increase memory size later

    assign one_word  = {memfile[address+3], memfile[address+2], memfile[address+1], memfile[address]};
    assign one_byte  = {{24{memfile[address][7]}}, memfile[address]};
    assign half_word = {{16{memfile[address][15]}}, memfile[address+1], memfile[address]};

    assign readdata  = (memread == 1) ?  (func3_ex == 3'b010 ? one_word  : 
                                         (func3_ex == 3'b001 ? half_word : 
                                         (func3_ex == 3'b000 ? one_byte  : 0))) : 0;

    always @ (posedge clk)
        begin
            if (memwrite == 1)
                begin
                    if (func3_ex == 3'b010)
                        {memfile[address+3], memfile[address+2], memfile[address+1], memfile[address]} <= writedata;
                    else if (func3_ex == 3'b001)
                        {memfile[address+1], memfile[address]} <= writedata[15:0];
                    else
                        memfile[address] <= writedata[7:0];
                end
        end

endmodule