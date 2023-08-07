module registerfile(clk, rs1, rs2, rd, writedata, regwrite, readdata1, readdata2);

    input clk;
    input [4:0] rs1, rs2, rd;
    input [31:0] writedata;
    input regwrite;

    output wire [31:0] readdata1, readdata2;

    reg [31:0] regfile [0:31];

    initial 
      begin
        regfile[0] <= 0;    
      end

    assign readdata1 = regfile[rs1];
    assign readdata2 = regfile[rs2];

    always @ (posedge clk)
      begin
        if (regwrite == 1 & rd != 0)
          regfile[rd] <= writedata;          
      end

endmodule