module registerfile(rs1, rs2, rd, writedata, regwrite, readdata1, readdata2);

    input [4:0] rs1, rs2, rd;
    input [31:0] writedata;
    input regwrite;

    output reg [31:0] readdata1, readdata2;

    reg [31:0] regfile [0:31];

    
    
    always @ (rs1, rs2, rd, writedata, regwrite)
        begin
          if (regwrite == 1)
            begin
              regfile[rd] <= writedata;
            end

          regfile[0] <= 0;

          readdata1 <= regfile[rs1];
          readdata2 <= regfile[rs2];
        end

endmodule