//////////////////////////////////////////////////////////////////////////////////
// Company: 		Renzym
// Engineer: 		Yasir Javed
// Design Name: 	Address Generation Unit
// Module Name:		agu
// Description: 	AGU generates BRAM address for 3xN convolution. It is assumed that image
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
module agu
	#(
	parameter KERN_COL_WIDTH 	= 3,
	parameter COL_WIDTH 		= 8,
	parameter KERN_CNT_WIDTH 	= 3,
	parameter IMG_ADDR_WIDTH 	= 8,
	parameter RSLT_ADDR_WIDTH 	= 8
	
	)
	(
	input								clk,
	input								reset,
	input								start,
	input								en_result_addr,
	
	// Configurations
	input 		[KERN_COL_WIDTH-1:0]	kern_cols,
	input		[COL_WIDTH-1:0]			cols,
	input		[KERN_CNT_WIDTH-1:0]	kerns,
	input		[IMG_ADDR_WIDTH-1:0]	stride,
	input								kern_addr_mode,
	input		[RSLT_ADDR_WIDTH-1:0]	result_cols,
	
	//
	output	reg	[KERN_CNT_WIDTH+KERN_COL_WIDTH-1:0]	kern_addr,
	output	reg	[IMG_ADDR_WIDTH-1:0]				img_addr,
	output	reg	[RSLT_ADDR_WIDTH-1:0]				result_addr,
	output	reg										clr_k_col_cnt,
	output	reg										clr_col_cnt,
	output	reg										done
	);

	reg start_d;
	reg start_res;
	reg	start_pedge;

	reg [KERN_COL_WIDTH-1:0]	k_col_cnt;	// kernel col count
	//reg							clr_k_col_cnt;
	reg							en_k_col_cnt;
	
	reg	[COL_WIDTH-1:0]			col_cnt;	// image col count
	//reg							clr_col_cnt;
	reg							en_col_cnt;
	
	reg	[KERN_CNT_WIDTH-1:0]	kerns_cnt;		// kernel# count
	reg							clr_kerns_cnt;
	reg							en_kerns_cnt;

	reg	[IMG_ADDR_WIDTH-1:0]	img_st;		
	reg							clr_img_st;
	reg							en_img_st;

	reg							clr_img_addr;
	reg							en_img_addr;
	reg							clr_result_addr;
	//reg							en_result_addr;
	
	// Kernel col counter
	always@(posedge clk)
		if(reset | clr_k_col_cnt)	k_col_cnt <= 0;
		else if(en_k_col_cnt) 		k_col_cnt <= k_col_cnt + 1;

	always@* clr_k_col_cnt 	= (k_col_cnt == kern_cols) & start;
	always@* en_k_col_cnt	= start;

	// Image col counter
	always@(posedge clk)
		if(reset | clr_col_cnt)	col_cnt <= 0;
		else if(en_col_cnt) 		col_cnt <= col_cnt + 1;

	always@* clr_col_cnt 	= (col_cnt == cols) & en_col_cnt;
	always@* en_col_cnt	= clr_k_col_cnt;

	// Kernel#  counter
	always@(posedge clk)
		if(reset | clr_kerns_cnt)	kerns_cnt <= 0;
		else if(en_kerns_cnt) 		kerns_cnt <= kerns_cnt + 1;

	always@* clr_kerns_cnt 	= (kerns_cnt == kerns) & en_kerns_cnt;
	always@* en_kerns_cnt	= clr_col_cnt;

	// Image address start value counter
	always@(posedge clk)
		if(reset | clr_img_st | start_pedge)	// ##TODO## Verify whether this works for 1x1 convolution case
			img_st <= stride;
		else if(en_img_st) 
			img_st <= img_st + stride;

	always@* clr_img_st = clr_col_cnt;
	always@* en_img_st	= clr_k_col_cnt;
	
	
	// Image BRAM Address
	always@(posedge clk)
		if(reset | clr_img_st)	img_addr <= 0;
		else if(clr_img_addr)	img_addr <= img_st;
		else if(en_img_addr) 	img_addr <= img_addr + 1;

	always@* clr_img_addr 	= clr_k_col_cnt;
	always@* en_img_addr	= start;
	
	always@* kern_addr = kern_addr_mode ? {kerns_cnt,k_col_cnt}:{1'b0,kerns_cnt,k_col_cnt[KERN_COL_WIDTH-2:0]};

	
	always@(posedge clk)
		if(reset)	start_d <= 0;
		else		start_d <= start;

	always@* start_pedge = start & ~start_d;
	
	// Results RAM address
	always@(posedge clk)
		if(reset | clr_result_addr)	result_addr <= 0;
		else if(en_result_addr) 	result_addr <= result_addr + 1;

	always@* clr_result_addr	= (result_addr == result_cols) & en_result_addr;
//	always@* en_result_addr		= start_res;	
	
	wire [7:0] clr_kerns_cnt_d;
	serial_shift
	#(
	.DLY_WIDTH 	(8				)
	)
	ser_shift_done
	(
	.clk		(clk			),
	.reset		(reset			),
	.ser_in		(clr_kerns_cnt	),
	.par_out	(clr_kerns_cnt_d)
	);
	
	always@(posedge clk)
		if(reset)					done <= 0;
		else if(clr_kerns_cnt_d[3])	done <= 1;
	

endmodule