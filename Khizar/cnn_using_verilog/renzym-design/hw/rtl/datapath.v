`include "serial_shift.v"
`include "mult.v"
`include "shifter.v"
`include "max_pool.v"

module datapath
	#(
	parameter IMG_DWIDTH 	= 24,
	parameter KERN_DWIDTH 	= 24,
	parameter RESULT_DWIDTH	= 8,
	parameter SHFT_WIDTH	= 4
	)
	(
	input								clk,
	input								reset,
	input								start,
	
	input		[SHFT_WIDTH-1:0]		shift,
	input								en_max_pool,
	input		[2:0]					mask,
	
	input		[IMG_DWIDTH-1:0]		img_data,
	input		[KERN_DWIDTH-1:0]		kern_data,
	
	output		[RESULT_DWIDTH-1:0]		result_data,
	output								result_valid,
	input								clr_k_col_cnt,
	input								clr_col_cnt,
	output 	reg							accum_ovrflow

	);


	wire 	[15:0]	mult_out0;
	wire 	[15:0]	mult_out1;
	wire 	[15:0]	mult_out2;
	
	reg 	[15:0]	mult_out0_r;
	reg 	[15:0]	mult_out1_r;
	reg 	[15:0]	mult_out2_r;
	
	reg		[19:0]	mult_accum;
	reg		[20:0]	mult_accum_r;
	reg		[20:0]	mult_accum_mux;
	reg				clr_mult_accum;
	
	wire	[7:0]	shift_out;
	wire	[7:0]	max_pool_out;
	wire			max_pool_valid;
	wire 	[7:0] 	clr_col_cnt_d;
	
	// Multipliers
	mult
	#(
	.WIDTH_A	(8),
	.WIDTH_B	(8)
	)
	mult_inst0
	(
	.a			(img_data[7:0]),
	.b			(kern_data[7:0]),
	.out        (mult_out0)
    );

	mult
	#(
	.WIDTH_A	(8),
	.WIDTH_B	(8)
	)
	mult_inst1
	(
	.a			(img_data[15:8]),
	.b			(kern_data[15:8]),
	.out        (mult_out1)
    );

	mult
	#(
	.WIDTH_A	(8),
	.WIDTH_B	(8)
	)
	mult_inst2
	(
	.a			(img_data[23:16]),
	.b			(kern_data[23:16]),
	.out        (mult_out2)
    );

	// Pipeline and accumulate
	always@(posedge clk)
		if(reset)
		begin
			mult_out0_r	<= 0;
			mult_out1_r <= 0;
			mult_out2_r <= 0;
		end
		else
		begin
			mult_out0_r	<= {16{mask[0]}} & mult_out0;
			mult_out1_r <= {16{mask[1]}} & mult_out1;
			mult_out2_r <= {16{mask[2]}} & mult_out2;
		end
	
	always@(posedge clk)
		if(reset)	
			mult_accum_r <= 0;
		else
			mult_accum_r <= mult_accum_mux + {{5{mult_out0_r[15]}},mult_out0_r} + 
											 {{5{mult_out1_r[15]}},mult_out1_r} + 
											 {{5{mult_out2_r[15]}},mult_out2_r};
	
	always@* mult_accum_mux = clr_mult_accum ? 0: mult_accum_r;
	always@* mult_accum 	= mult_accum_r[19:0];
	//always@* accum_ovrflow 	= mult_accum_r[20] ^ mult_accum_r[19];
	
	always@(posedge clk)
		if(reset)		
			accum_ovrflow <= 0;
		else if((mult_accum_r[20] ^ mult_accum_r[19]) & start_d[2])
			accum_ovrflow <= 1;
		
	
	shifter
	#(
	.IN_WIDTH	(20),
	.SHFT_WIDTH	(SHFT_WIDTH)
	)
	shifter_inst
	(
	.in			(mult_accum),
	.shift		(shift),
	.out        (shift_out)
    );
	
	// Max pool (optional)
	max_pool
	#(
	.DWIDTH 		(8				)
	)
	max_pool_inst
	(
	.clk			(clk			),
	.reset			(reset | clr_col_cnt_d[3]),
	.en_maxpool		(en_max_pool	),
	.data_in		(shift_out		),
	.valid_in		(clr_mult_accum	& start_d[2]),
	.data_out		(result_data	),
	.valid_out		(result_valid	)
	);
	
	parameter DLY_WIDTH = 16;
	wire [DLY_WIDTH-1:0] start_d;

	serial_shift
	#(
	.DLY_WIDTH 	(DLY_WIDTH	)
	)
	ser_shift_start
	(
	.clk		(clk			),
	.reset		(reset			),
	.ser_in		(start			),
	.par_out	(start_d		)
	);
	
	
	parameter CLR_DLY = 2;
	parameter CLR_DLY_WIDTH = 3;
	wire [CLR_DLY_WIDTH-1:0] clr_k_col_cnt_d;
	
	serial_shift
	#(
	.DLY_WIDTH 	(CLR_DLY_WIDTH	)
	)
	ser_shift_clr_k_col
	(
	.clk		(clk			),
	.reset		(reset			),
	.ser_in		(clr_k_col_cnt	),
	.par_out	(clr_k_col_cnt_d)
	);
	
	always@* clr_mult_accum = clr_k_col_cnt_d[CLR_DLY] | ~start_d[2];


	
	serial_shift
	#(
	.DLY_WIDTH 	(8				)
	)
	ser_shift_clr_col
	(
	.clk		(clk			),
	.reset		(reset			),
	.ser_in		(clr_col_cnt	),
	.par_out	(clr_col_cnt_d	)
	);
	
endmodule