//////////////////////////////////////////////////////////////////////////////////
// Company: 		Renzym
// Engineer: 		Yasir Javed
// Design Name: 	Renzym Convolver
// Module Name:		ren_conv
// Description: 	Renzym Convolver cumputes 3xN convolution. It is assumed that image
//					and kernels are stored in external BRAMs. The results are written  
//					back to external BRAM too. Simlarly configurations are also assumed
//					to be external. Based on configurations, this block will start
//					working when start signal is asserted (level signal) and when done
//					done signal will be asserted. There is an optional maxpool layer too.
//
//					Configs and BRAMs are kept external, so that this generic block can 
//					remain independent and can mux between different configs and datas.
//					It also keeps provision of making it cascadable open.
//
//					External config block also ensures that there can be different such 
//					blocks for different interfaces (e.g. AXI, Wishbone etc.) without affecting
//					rest of the design.
// 
// Dependencies:	Configs and BRAMs. 
//
//////////////////////////////////////////////////////////////////////////////////
`include "agu.v"
`include "datapath.v"

module ren_conv
	#(
	parameter KERN_COL_WIDTH 	= 3,
	parameter COL_WIDTH 		= 8,
	parameter KERN_CNT_WIDTH 	= 3,
	parameter IMG_ADDR_WIDTH 	= 8,
	parameter RSLT_ADDR_WIDTH 	= 8,
	parameter SHFT_WIDTH		= 4,
	parameter IMG_DWIDTH		= 24,
	parameter KERN_DWIDTH		= 24,
	parameter RESULT_DWIDTH		= 8
	)
	(
	input								clk,
	input								reset,

	input								start,
	output								done,
	
	// Configurations
	input 		[KERN_COL_WIDTH-1:0]	kern_cols,
	input		[COL_WIDTH-1:0]			cols,
	input		[KERN_CNT_WIDTH-1:0]	kerns,
	input		[IMG_ADDR_WIDTH-1:0]	stride,
	input								kern_addr_mode,
	input		[RSLT_ADDR_WIDTH-1:0]	result_cols,
	input		[SHFT_WIDTH-1:0]		shift,
	input								en_max_pool,
	input		[2:0]					mask,
		

	// BRAMs interface signals
	input		[IMG_DWIDTH-1:0]		img_data,
	input		[KERN_DWIDTH-1:0]		kern_data,
	
	output		[KERN_CNT_WIDTH+KERN_COL_WIDTH-1:0]	kern_addr,
	output		[IMG_ADDR_WIDTH-1:0]				img_addr,

	output		[RSLT_ADDR_WIDTH-1:0]				result_addr,
	output		[RESULT_DWIDTH-1:0]					result_data,
	output											result_valid,
	output											accum_ovrflow
	);

	wire clr_k_col_cnt;
	wire clr_col_cnt;
	
	agu
	#(
	.KERN_COL_WIDTH 	(KERN_COL_WIDTH 	),
	.COL_WIDTH 			(COL_WIDTH 			),
	.KERN_CNT_WIDTH 	(KERN_CNT_WIDTH 	),
	.IMG_ADDR_WIDTH 	(IMG_ADDR_WIDTH 	),
	.RSLT_ADDR_WIDTH 	(RSLT_ADDR_WIDTH 	)
	
	)
	agu_inst
	(
	.clk			(clk			),
	.reset			(reset			),
	.start			(start			),
	.en_result_addr	(result_valid	),
	.kern_cols		(kern_cols		),
	.cols			(cols			),
	.kerns			(kerns			),
	.stride			(stride			),
	.kern_addr_mode	(kern_addr_mode	),
	.result_cols	(result_cols	),
	.kern_addr		(kern_addr		),
	.img_addr		(img_addr		),
	.result_addr	(result_addr	),
	.clr_k_col_cnt	(clr_k_col_cnt	),
	.clr_col_cnt	(clr_col_cnt	),
	.done			(done			)
	);


	datapath
	#(
	.IMG_DWIDTH 	(24	),
	.KERN_DWIDTH 	(24	),
	.RESULT_DWIDTH	(8	),
	.SHFT_WIDTH		(4  )
	)
	datapath_inst
	(
	.clk			(clk			),
	.reset			(reset			),
	.start			(start			),
	.shift			(shift			),
	.en_max_pool	(en_max_pool	),
	.img_data		(img_data		),
	.kern_data		(kern_data		),
	.result_data	(result_data	),
	.result_valid	(result_valid	),
	.mask			(mask			),
	.clr_k_col_cnt	(clr_k_col_cnt	),
	.clr_col_cnt	(clr_col_cnt	),
	.accum_ovrflow	(accum_ovrflow	)
	);


endmodule
