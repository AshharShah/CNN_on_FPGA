//////////////////////////////////////////////////////////////////////////////////
// Company: 		Renzym
// Engineer: 		Yasir Javed
// Design Name: 	Renzym Convolver Top
// Module Name:		ren_conv_top
// Description:
//
// Dependencies:	Configs and BRAMs.
//
//////////////////////////////////////////////////////////////////////////////////
`include "ren_conv.v"
`include "dffram.v"
`include "regs.v"


module ren_conv_top
	#(
	parameter MY_ADDR			= 8'h30,
	parameter MY_ADDR_MSB		= 32,
	parameter MY_ADDR_LSB		= 24,
	parameter KERN_COL_WIDTH 	= 3,
	parameter COL_WIDTH 		= 8,
	parameter KERN_CNT_WIDTH 	= 3,
	parameter IMG_ADDR_WIDTH 	= 6,
	parameter RSLT_ADDR_WIDTH 	= 6
	)
	(
    // Wishbone Slave ports (WB MI A)
    input 			wb_clk_i,
    input 			wb_rst_i,
    input 			wbs_stb_i,
    input 			wbs_cyc_i,
    input 			wbs_we_i,
    input [3:0] 	wbs_sel_i,
    input [31:0] 	wbs_dat_i,
    input [31:0] 	wbs_adr_i,
    output 			wbs_ack_o,
    output [31:0] 	wbs_dat_o

	);

	wire 			we_regs;
	wire 			we_img_ram;
	wire 			we_kern_ram;
	wire 			we_res_ram;
	wire	[31:0]	data_out_regs;
	wire	[7:0]	data_out_result;
	wire			clk;
	wire			reset;
	reg				ready;
	reg		[31:0]	rdata;
	wire			start;
	wire 	[2:0]	kern_cols;
	wire	[7:0]	cols;
	wire	[2:0]	kerns;
	wire	[7:0]	stride;
	wire			kern_addr_mode;
	wire	[7:0]	result_cols;
	wire	[3:0]	shift;
	wire			en_max_pool;
	wire	[2:0]	mask;
	wire			done;
	
	wire	[23:0]	img_data;
	wire	[23:0]	kern_data;	
	wire	[KERN_CNT_WIDTH+KERN_COL_WIDTH-1:0]	kern_addr;
	wire	[IMG_ADDR_WIDTH-1:0]				img_addr;
	wire	[RSLT_ADDR_WIDTH-1:0]				result_addr;
	wire	[7:0]	result_data;
	wire			result_valid;
	
	assign clk 		= wb_clk_i;
	assign reset	= wb_rst_i;


    assign valid 	 = (wbs_adr_i[MY_ADDR_MSB-1:MY_ADDR_LSB] == MY_ADDR) & wbs_cyc_i & wbs_stb_i;
//    assign wstrb 	 = wbs_sel_i & {(DWIDTH/8){wbs_we_i}};
    assign wbs_dat_o = rdata;
	assign wbs_ack_o = ready;

	assign we_regs 		= (wbs_adr_i[9:8]==0) & valid & wbs_we_i;
	assign we_img_ram	= (wbs_adr_i[9:8]==1) & valid & wbs_we_i;
	assign we_kern_ram	= (wbs_adr_i[9:8]==2) & valid & wbs_we_i;
	assign we_res_ram	= (wbs_adr_i[9:8]==3) & valid & wbs_we_i;

	always@(posedge clk)
		if(reset)					rdata <= 0;
		else if(wbs_adr_i[9:8]==0)	rdata <= data_out_regs;
		else if(wbs_adr_i[9:8]==3)	rdata <= data_out_result;
		
	always@(posedge clk)
		if(reset | ready)			ready <= 0;
		else if(valid & ~ready)		ready <= 1;	

	regs
	#(
		.DWIDTH	(32)
	)
	cfg_regs_inst
	(
	.clk			(clk			),
	.reset			(reset			),
	.addr			(wbs_adr_i[3:2]	),
	.wr_en			(we_regs		),
	.data_in		(wbs_dat_i		),
	.data_out		(data_out_regs	),	
	.done			(done			),
	.start			(start			),
	.soft_reset		(soft_reset		),
	.kern_cols		(kern_cols		),
	.cols			(cols			),
	.kerns			(kerns			),
	.stride			(stride			),
	.kern_addr_mode	(kern_addr_mode	),
	.result_cols	(result_cols	),
	.shift			(shift			),
	.en_max_pool	(en_max_pool	),
	.mask			(mask			),
	.accum_ovrflow	(accum_ovrflow	)
	);


	ren_conv
	#(
	.KERN_COL_WIDTH 	(KERN_COL_WIDTH ),
	.COL_WIDTH 			(COL_WIDTH 		),
	.KERN_CNT_WIDTH 	(KERN_CNT_WIDTH ),
	.IMG_ADDR_WIDTH 	(IMG_ADDR_WIDTH ),
	.RSLT_ADDR_WIDTH 	(RSLT_ADDR_WIDTH)
	)
	ren_conv_inst
	(
	.clk			(clk			),
	.reset			(reset|soft_reset),
	.start			(start			),
	.done			(done			),
	.kern_cols		(kern_cols		),
	.cols			(cols			),
	.kerns			(kerns			),
	.stride			(stride[5:0]	),
	.kern_addr_mode	(kern_addr_mode	),
	.result_cols	(result_cols[5:0]),
	.shift			(shift			),
	.en_max_pool	(en_max_pool	),
	.mask			(mask			),
	.img_data		(img_data		),
	.kern_data		(kern_data		),
	.kern_addr		(kern_addr		),
	.img_addr		(img_addr		),
	.result_addr	(result_addr	),
	.result_data	(result_data	),
	.result_valid	(result_valid	),
	.accum_ovrflow	(accum_ovrflow	)
	);

	dffram
	#(
	.DWIDTH (24),
	.AWIDTH (6 )
	)
	img_dffram
	(
	.clk		(clk			),
	.we			(we_img_ram		),
	.dat_o		(				),
	.dat_o2		(img_data		),
	.dat_i		(wbs_dat_i[23:0]),
	.adr_w		(wbs_adr_i[7:2]	),
	.adr_r		(img_addr		)
	);

	dffram
	#(
	.DWIDTH (24),
	.AWIDTH (6 )
	)
	kerns_dffram
	(
	.clk		(clk			),
	.we			(we_kern_ram	),
	.dat_o		(				),
	.dat_o2		(kern_data		),
	.dat_i		(wbs_dat_i[23:0]),
	.adr_w		(wbs_adr_i[7:2]	),
	.adr_r		(kern_addr		)
	);

	dffram
	#(
	.DWIDTH (8),
	.AWIDTH (6 )
	)
	results_dffram
	(
	.clk		(clk			),
	.we			(result_valid & ~done	),
	.dat_o		(				),
	.dat_o2		(data_out_result),
	.dat_i		(result_data	),
	.adr_w		(result_addr	),
	.adr_r		(wbs_adr_i[7:2])
	);

endmodule