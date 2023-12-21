module mult
	#(
	parameter WIDTH_A = 8,
	parameter WIDTH_B = 8
	)
	(
	input	signed		[WIDTH_A-1:0] 			a,
	input	signed		[WIDTH_B-1:0] 			b,
	output	reg	signed	[WIDTH_A+WIDTH_B-1:0]	out
    );

	always@* out = 	a*b;

endmodule