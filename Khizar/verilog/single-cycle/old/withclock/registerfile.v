module registerfile(clk, state, rs1, rs2, rd, writedata, regwrite, readdata1, readdata2);

    input clk;
    input [1:0] state;

    input [4:0] rs1, rs2, rd;
    input [31:0] writedata;
    input regwrite;

    output reg [31:0] readdata1, readdata2;

    reg [31:0] regfile [0:31];

    initial 
        begin
          regfile[0] <= 0;
        end

    always @ (posedge clk)
        begin
          if (state == 1)
          begin
            if (regwrite == 1 && rd != 0)
              begin
                regfile[rd] <= writedata;
              end

            regfile[0] <= 0;

            readdata1 <= regfile[rs1];
            readdata2 <= regfile[rs2];
          end
        end

endmodule