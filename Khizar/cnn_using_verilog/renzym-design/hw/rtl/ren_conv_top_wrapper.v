//////////////////////////////////////////////////////////////////////////////////
// Company: 		Renzym
// Engineer: 		Yasir Javed
// Design Name: 	Renzym Convolver Top Wrapper
// Module Name:		ren_conv_top_wrapper
// Description:		Instantiates 4/6 instances of ren_conv_top
//
// Dependencies:	
//
//////////////////////////////////////////////////////////////////////////////////
`include "ren_conv_top.v"

module ren_conv_top_wrapper
	#(
	parameter NO_OF_INSTS		= 4,
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
    output reg [31:0] 	wbs_dat_o

	);

wire		wbs_ack_out_0;
wire		wbs_ack_out_1;
wire		wbs_ack_out_2;
wire		wbs_ack_out_3;
wire [31:0]	wbs_dat_out_0;
wire [31:0]	wbs_dat_out_1;
wire [31:0]	wbs_dat_out_2;
wire [31:0]	wbs_dat_out_3;

reg	[1:0]	addr_r;

always@(posedge wb_clk_i) addr_r <= wbs_adr_i[25:24];

assign 		wbs_ack_o = wbs_ack_out_0 | wbs_ack_out_1 | wbs_ack_out_2 | wbs_ack_out_3;
/*
always@*	wbs_dat_o = (wbs_dat_out_0 & {32{wbs_ack_out_0}}) | 
						(wbs_dat_out_1 & {32{wbs_ack_out_1}}) |
						(wbs_dat_out_2 & {32{wbs_ack_out_2}}) |
						(wbs_dat_out_3 & {32{wbs_ack_out_3}});
*/

always@*
	case(addr_r)
	2'd0:	wbs_dat_o = wbs_dat_out_0;
	2'd1:	wbs_dat_o = wbs_dat_out_1;
	2'd2:	wbs_dat_o = wbs_dat_out_2;
	2'd3:	wbs_dat_o = wbs_dat_out_3;
	endcase

	ren_conv_top
	#(
	.MY_ADDR			(8'h30+0			),
	.MY_ADDR_MSB		(32					),
	.MY_ADDR_LSB		(24					),
	.KERN_COL_WIDTH 	(KERN_COL_WIDTH 	),
	.COL_WIDTH 			(COL_WIDTH 			),
	.KERN_CNT_WIDTH 	(KERN_CNT_WIDTH 	),
	.IMG_ADDR_WIDTH 	(IMG_ADDR_WIDTH 	),
	.RSLT_ADDR_WIDTH 	(RSLT_ADDR_WIDTH 	)
	)
	ren_conv_top_inst_0
	(
	// Wishbone Slave ports (WB MI A)
	.wb_clk_i		(wb_clk_i	),
	.wb_rst_i		(wb_rst_i	),
	.wbs_stb_i		(wbs_stb_i	),
	.wbs_cyc_i		(wbs_cyc_i	),
	.wbs_we_i		(wbs_we_i	),
	.wbs_sel_i		(wbs_sel_i	),
	.wbs_dat_i		(wbs_dat_i	),
	.wbs_adr_i		(wbs_adr_i	),
	.wbs_ack_o		(wbs_ack_out_0),
	.wbs_dat_o		(wbs_dat_out_0)
	);

	ren_conv_top
	#(
	.MY_ADDR			(8'h30+1			),
	.MY_ADDR_MSB		(32					),
	.MY_ADDR_LSB		(24					),
	.KERN_COL_WIDTH 	(KERN_COL_WIDTH 	),
	.COL_WIDTH 			(COL_WIDTH 			),
	.KERN_CNT_WIDTH 	(KERN_CNT_WIDTH 	),
	.IMG_ADDR_WIDTH 	(IMG_ADDR_WIDTH 	),
	.RSLT_ADDR_WIDTH 	(RSLT_ADDR_WIDTH 	)
	)
	ren_conv_top_inst_1
	(
	// Wishbone Slave ports (WB MI A)
	.wb_clk_i		(wb_clk_i	),
	.wb_rst_i		(wb_rst_i	),
	.wbs_stb_i		(wbs_stb_i	),
	.wbs_cyc_i		(wbs_cyc_i	),
	.wbs_we_i		(wbs_we_i	),
	.wbs_sel_i		(wbs_sel_i	),
	.wbs_dat_i		(wbs_dat_i	),
	.wbs_adr_i		(wbs_adr_i	),
	.wbs_ack_o		(wbs_ack_out_1),
	.wbs_dat_o		(wbs_dat_out_1)
	);

	ren_conv_top
	#(
	.MY_ADDR			(8'h30+2			),
	.MY_ADDR_MSB		(32					),
	.MY_ADDR_LSB		(24					),
	.KERN_COL_WIDTH 	(KERN_COL_WIDTH 	),
	.COL_WIDTH 			(COL_WIDTH 			),
	.KERN_CNT_WIDTH 	(KERN_CNT_WIDTH 	),
	.IMG_ADDR_WIDTH 	(IMG_ADDR_WIDTH 	),
	.RSLT_ADDR_WIDTH 	(RSLT_ADDR_WIDTH 	)
	)
	ren_conv_top_inst_2
	(
	// Wishbone Slave ports (WB MI A)
	.wb_clk_i		(wb_clk_i	),
	.wb_rst_i		(wb_rst_i	),
	.wbs_stb_i		(wbs_stb_i	),
	.wbs_cyc_i		(wbs_cyc_i	),
	.wbs_we_i		(wbs_we_i	),
	.wbs_sel_i		(wbs_sel_i	),
	.wbs_dat_i		(wbs_dat_i	),
	.wbs_adr_i		(wbs_adr_i	),
	.wbs_ack_o		(wbs_ack_out_2),
	.wbs_dat_o		(wbs_dat_out_2)
	);

	ren_conv_top
	#(
	.MY_ADDR			(8'h30+3			),
	.MY_ADDR_MSB		(32					),
	.MY_ADDR_LSB		(24					),
	.KERN_COL_WIDTH 	(KERN_COL_WIDTH 	),
	.COL_WIDTH 			(COL_WIDTH 			),
	.KERN_CNT_WIDTH 	(KERN_CNT_WIDTH 	),
	.IMG_ADDR_WIDTH 	(IMG_ADDR_WIDTH 	),
	.RSLT_ADDR_WIDTH 	(RSLT_ADDR_WIDTH 	)
	)
	ren_conv_top_inst_3
	(
	// Wishbone Slave ports (WB MI A)
	.wb_clk_i		(wb_clk_i	),
	.wb_rst_i		(wb_rst_i	),
	.wbs_stb_i		(wbs_stb_i	),
	.wbs_cyc_i		(wbs_cyc_i	),
	.wbs_we_i		(wbs_we_i	),
	.wbs_sel_i		(wbs_sel_i	),
	.wbs_dat_i		(wbs_dat_i	),
	.wbs_adr_i		(wbs_adr_i	),
	.wbs_ack_o		(wbs_ack_out_3),
	.wbs_dat_o		(wbs_dat_out_3)
	);


/*	
	wire [NO_OF_INSTS-1:0]		wbs_ack_out;
	wire [31:0]					wbs_dat_out[0:NO_OF_INSTS-1];
	wire [31:0]					wbs_dat_out_[0:NO_OF_INSTS-1];

	
	always@*
	begin
		if(NO_OF_INSTS == 2)			wbs_dat_o = wbs_dat_o[0] | wbs_dat_o[1];
		else if(NO_OF_INSTS == 3)		wbs_dat_o = wbs_dat_o[0] | wbs_dat_o[1] | wbs_dat_o[2];
		else if(NO_OF_INSTS == 4)		wbs_dat_o = wbs_dat_o[0] | wbs_dat_o[1] | wbs_dat_o[2] | wbs_dat_o[3];
		else if(NO_OF_INSTS == 5)		wbs_dat_o = wbs_dat_o[0] | wbs_dat_o[1] | wbs_dat_o[2] | wbs_dat_o[3] | wbs_dat_o[4];
		else if(NO_OF_INSTS == 6)		wbs_dat_o = wbs_dat_o[0] | wbs_dat_o[1] | wbs_dat_o[2] | wbs_dat_o[3] | wbs_dat_o[4] | wbs_dat_o[5];
		else							wbs_dat_o = wbs_dat_o[0];
	end
	
	
	genvar i;
	generate
		for (i=0; i<NO_OF_INSTS; i=i+1) 
		begin
			ren_conv_top
			#(
			.MY_ADDR			(8'h30+i			),
			.MY_ADDR_MSB		(32					),
			.MY_ADDR_LSB		(24					),
			.KERN_COL_WIDTH 	(KERN_COL_WIDTH 	),
			.COL_WIDTH 			(COL_WIDTH 			),
			.KERN_CNT_WIDTH 	(KERN_CNT_WIDTH 	),
			.IMG_ADDR_WIDTH 	(IMG_ADDR_WIDTH 	),
			.RSLT_ADDR_WIDTH 	(RSLT_ADDR_WIDTH 	)
			)
			ren_conv_top_inst_i
			(
			// Wishbone Slave ports (WB MI A)
			.wb_clk_i		(wb_clk_i	),
			.wb_rst_i		(wb_rst_i	),
			.wbs_stb_i		(wbs_stb_i	),
			.wbs_cyc_i		(wbs_cyc_i	),
			.wbs_we_i		(wbs_we_i	),
			.wbs_sel_i		(wbs_sel_i	),
			.wbs_dat_i		(wbs_dat_i	),
			.wbs_adr_i		(wbs_adr_i	),
			.wbs_ack_o		(wbs_ack_out[i]),
			.wbs_dat_o		(wbs_dat_out[i])
			);
			assign wbs_dat_out_[i] = wbs_dat_out[i] & {32{wbs_ack_out[i]}};
		end
	endgenerate
*/
endmodule