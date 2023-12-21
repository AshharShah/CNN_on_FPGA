module dffram
	#(
	parameter DWIDTH = 24,
	parameter AWIDTH = 6
	)
	(
	input          				clk,
	input          				we,
	output reg 	[DWIDTH-1:0]	dat_o,
	output reg 	[DWIDTH-1:0]	dat_o2,
	input  		[DWIDTH-1:0]	dat_i,
	input  		[AWIDTH-1:0]	adr_w,
	input  		[AWIDTH-1:0]	adr_r
	);

reg [DWIDTH-1:0] r [0:(2**AWIDTH)-1];

always @(posedge clk)
begin
	if(we)	r[adr_w] <= dat_i;

	dat_o 	<= r[adr_w];
	dat_o2 	<= r[adr_r];

end


endmodule



  


