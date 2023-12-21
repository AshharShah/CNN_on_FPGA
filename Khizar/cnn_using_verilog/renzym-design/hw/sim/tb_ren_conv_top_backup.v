module tb_ren_conv_top;
	parameter KERN_COL_WIDTH 	= 3;
	parameter COL_WIDTH 		= 8;
	parameter KERN_CNT_WIDTH 	= 3;
	parameter IMG_ADDR_WIDTH 	= 6;
	parameter RSLT_ADDR_WIDTH 	= 6;

    // Wishbone Slave ports (WB MI A)
    reg 			wb_clk_i;
    reg 			wb_rst_i;
    reg 			wbs_stb_i;
    reg 			wbs_cyc_i;
    reg 			wbs_we_i;
    reg 	[3:0] 	wbs_sel_i;
    reg 	[31:0] 	wbs_dat_i;
    reg 	[31:0] 	wbs_adr_i;
    wire 			wbs_ack_o;
    wire 	[31:0] 	wbs_dat_o;

	reg				clk;
	reg				reset;

	reg		[2:0]	kern_cols;
	reg		[7:0]	cols;
	reg		[2:0]	kerns;
	reg		[7:0]	stride;
	reg				kern_addr_mode;
	reg		[7:0]	result_cols;
	reg		[3:0]	shift;
	reg				en_max_pool;
	reg		[2:0]	mask;

	integer i;


	ren_conv_top
	#(
	.KERN_COL_WIDTH 	(KERN_COL_WIDTH 	),
	.COL_WIDTH 			(COL_WIDTH 			),
	.KERN_CNT_WIDTH 	(KERN_CNT_WIDTH 	),
	.IMG_ADDR_WIDTH 	(IMG_ADDR_WIDTH 	),
	.RSLT_ADDR_WIDTH 	(RSLT_ADDR_WIDTH 	)
	)
	ren_conv_top_inst
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
    .wbs_ack_o		(wbs_ack_o	),
    .wbs_dat_o		(wbs_dat_o	)
	);

always@* wb_clk_i = clk;
always@* wb_rst_i = reset;

initial
begin
	clk = 0;
	forever #5 clk = ~clk;
end

	parameter REG_BASE_ADDR 	= 'h000;
	parameter IMG_BASE_ADDR 	= 'h100;
	parameter KERN_BASE_ADDR 	= 'h200;
	parameter RES_BASE_ADDR 	= 'h300;

initial
begin
	$dumpfile("wave.vcd");
	$dumpvars(0, tb_ren_conv_top);

    wb_clk_i	= 0;
    wbs_stb_i	= 0;
    wbs_cyc_i	= 0;
    wbs_we_i	= 0;
    wbs_sel_i	= 0;
    wbs_dat_i	= 0;
    wbs_adr_i	= 0;
	reset		= 0;

	repeat(2) @(posedge clk);
	#1 reset		= 1;
	repeat(2) @(posedge clk);
	#1 reset		= 0;

	repeat(10) @(posedge clk);
	// Write image
	for(i=0; i <32; i=i+1)
	begin
		wb_write(IMG_BASE_ADDR+i, i + ((i+1)<<8) + ((i+2)<<16));
	end
	// Write kernel
	for(i=0; i <32; i=i+1)
	begin
//		wb_write(KERN_BASE_ADDR+i, i + i*'h100 + i*'h10000);
		wb_write(KERN_BASE_ADDR+i, 1 + 1*'h100 + 1*'h10000);
	end

	// Configurations
											// start			= regs[0][1];
	kern_cols			= 2;				// kern_cols		= regs[1][2:0];
    cols				= 7;                // cols				= regs[1][15:8];
    kerns				= 2;                // kerns			= regs[1][18:16];
    stride				= 1;                // stride			= regs[1][31:24];
    kern_addr_mode		= 0;                // kern_addr_mode	= regs[2][16];
    result_cols			= 11;                // result_cols		= regs[2][7:0];
    shift				= 12;                // shift			= regs[2][11:8];
    en_max_pool			= 1;                // en_max_pool		= regs[2][17];
    mask				= 3'b111;           // mask				= regs[2][20:18];


	wb_write(REG_BASE_ADDR+1, 	kern_cols 	+ 
								(cols  	<< 8	) + 
								(kerns 	<< 16	) + 
								(stride << 24	));

	wb_write(REG_BASE_ADDR+2, 	result_cols + 
								(shift 			<< 8) + 
								(kern_addr_mode << 16) + 
								(en_max_pool 	<< 17) + 
								(mask 			<< 18));

	wb_write(REG_BASE_ADDR,4);	// Start

	repeat(1000) @(posedge clk);


	$finish;
end

task wb_write;
	input [31:0] addr;
	input [31:0] data;
	begin
		@(posedge clk);
		#1;
		wbs_stb_i	= 1;
		wbs_cyc_i	= 1;
		wbs_we_i	= 1;
		wbs_sel_i	= 4'hf;
		wbs_dat_i	= data;
		wbs_adr_i	= addr;

		@(posedge clk);

		while(~wbs_ack_o)	@(posedge clk);
		$display("WISHBONE WRITE: Address=0x%h, Data=0x%h",addr,data);
		#1;
		wbs_stb_i	= 1'bx;
		wbs_cyc_i	= 0;
		wbs_we_i	= 1'hx;
		wbs_sel_i	= 4'hx;
		wbs_dat_i	= 32'hxxxx_xxxx;
		wbs_adr_i	= 32'hxxxx_xxxx;
	end
endtask

task wb_read;
	input 	[31:0] addr;
	output 	[31:0] data;
	begin

		@(posedge clk);
		#1;
		wbs_stb_i	= 1;
		wbs_cyc_i	= 1;
		wbs_we_i	= 0;
		wbs_sel_i	= 4'hf;
		wbs_adr_i	= addr;

		@(posedge clk);

		while(~wbs_ack_o)	@(posedge clk);

		// negate wishbone signals
		#1;
		wbs_stb_i	= 1'bx;
		wbs_cyc_i	= 0;
		wbs_we_i	= 1'hx;
		wbs_sel_i	= 4'hx;
		wbs_adr_i	= 32'hxxxx_xxxx;
		data		= wbs_dat_o;
		$display("WISHBONE READ: Address=0x%h, Data=0x%h",addr,data);

	end
endtask

endmodule