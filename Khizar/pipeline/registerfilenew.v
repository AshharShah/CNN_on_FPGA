module registerfilenew(clk, rs1, rs2, rd, writedata, regwrite, readdata1, readdata2);

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

    wire x1 = (rd == rs1 & rd != 0 & regwrite == 1);
    wire x2 = (rd == rs2 & rd != 0 & regwrite == 1);
    assign readdata1 =  x1 ? writedata: regfile[rs1];
    assign readdata2 =  x2 ? writedata: regfile[rs2];

    always @ (posedge clk)
    begin
        if (regwrite == 1 & rd != 0)
          regfile[rd] <= writedata;

    end

endmodule