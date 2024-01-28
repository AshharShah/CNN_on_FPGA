module serial_shift
	#(
	parameter DLY_WIDTH = 8
	)
	(
	input 	clk,
	input	reset,
	input	ser_in,
	output reg [DLY_WIDTH-1:0] par_out
	);

	always@(posedge clk)
		if(reset)	par_out <= 0;
		else		par_out <= {par_out[DLY_WIDTH-2:0],ser_in};
endmodule