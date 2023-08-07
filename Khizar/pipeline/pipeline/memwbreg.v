module memwbreg(clk, readdata,    alures_ex, rd_ex, memtoreg_ex, regwrite_ex,
                     readdata_wb, alures_wb, rd_wb, memtoreg_wb, regwrite_wb);

    input clk, memtoreg_ex, regwrite_ex;
    input [31:0] readdata, alures_ex;
    input [4:0] rd_ex;

    output reg memtoreg_wb, regwrite_wb;
    output reg [31:0] readdata_wb, alures_wb;
    output reg [4:0]  rd_wb;

    initial 
    begin
        memtoreg_wb <= 0;
        alures_wb   <= 0;
        readdata_wb <= 0;
        rd_wb       <= 0; 
        regwrite_wb <= 0;
    end

    always @(posedge clk) 
    begin
        memtoreg_wb <= memtoreg_ex;
        alures_wb   <= alures_ex;
        readdata_wb <= readdata;
        rd_wb       <= rd_ex;
        regwrite_wb <= regwrite_ex;  
    end

endmodule