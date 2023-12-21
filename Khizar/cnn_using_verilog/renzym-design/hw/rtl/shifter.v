module shifter
	#(
	parameter IN_WIDTH		= 20,
	parameter SHFT_WIDTH	= 4,
	parameter OUT_WIDTH		= 8
	)
	(
	input			[IN_WIDTH-1:0] 					in,
	input			[SHFT_WIDTH-1:0] 				shift,
	output	reg		[OUT_WIDTH-1:0]					out
    );

	always@*
		case (shift)
		00:	out	= in[IN_WIDTH-1-00: IN_WIDTH-OUT_WIDTH-00];
		01:	out	= in[IN_WIDTH-1-01: IN_WIDTH-OUT_WIDTH-01];
		02:	out	= in[IN_WIDTH-1-02: IN_WIDTH-OUT_WIDTH-02];
		03:	out	= in[IN_WIDTH-1-03: IN_WIDTH-OUT_WIDTH-03];
		04:	out	= in[IN_WIDTH-1-04: IN_WIDTH-OUT_WIDTH-04];
		05:	out	= in[IN_WIDTH-1-05: IN_WIDTH-OUT_WIDTH-05];
		06:	out	= in[IN_WIDTH-1-06: IN_WIDTH-OUT_WIDTH-06];
		07:	out	= in[IN_WIDTH-1-07: IN_WIDTH-OUT_WIDTH-07];
		08:	out	= in[IN_WIDTH-1-08: IN_WIDTH-OUT_WIDTH-08];
		09:	out	= in[IN_WIDTH-1-09: IN_WIDTH-OUT_WIDTH-09];
		10:	out	= in[IN_WIDTH-1-10: IN_WIDTH-OUT_WIDTH-10];
		11:	out	= in[IN_WIDTH-1-11: IN_WIDTH-OUT_WIDTH-11];
		12:	out	= in[IN_WIDTH-1-12: IN_WIDTH-OUT_WIDTH-12];
		endcase
endmodule
