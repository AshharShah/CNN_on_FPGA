//////////////////////////////////////////////////////////////////////////////////
// Company: 		Renzym
// Engineer: 		Yasir Javed
// Design Name: 	Renzym Convolver Top Testbench
// Module Name:		tb_ren_conv_top_wrapper
// Description:
//
// Dependencies:
//
//////////////////////////////////////////////////////////////////////////////////
module tb_ren_conv_top_wrapper;
	parameter NO_OF_INSTS		= 4;
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

	reg		[23:0]	image[0:31];
	reg		[23:0]	kernels[0:31];
	reg		[7:0]	result_sim[0:31];
	reg		[7:0]	result[0:31];

	integer i,iter;


	ren_conv_top_wrapper
	#(
	.NO_OF_INSTS		(NO_OF_INSTS		),
	.KERN_COL_WIDTH 	(KERN_COL_WIDTH 	),
	.COL_WIDTH 			(COL_WIDTH 			),
	.KERN_CNT_WIDTH 	(KERN_CNT_WIDTH 	),
	.IMG_ADDR_WIDTH 	(IMG_ADDR_WIDTH 	),
	.RSLT_ADDR_WIDTH 	(RSLT_ADDR_WIDTH 	)
	)
	ren_conv_top_wrapper_inst
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

parameter REG_BASE_ADDR 	= 32'h3000_0000;
parameter IMG_BASE_ADDR 	= 32'h3000_0100;
parameter KERN_BASE_ADDR 	= 32'h3000_0200;
parameter RES_BASE_ADDR 	= 32'h3000_0300;
parameter VERBOSE			= 2;
//-----------------------------------------------------------------------------
// Main test bench
//-----------------------------------------------------------------------------
initial
begin
	$dumpfile("wave.vcd");
	$dumpvars(0, tb_ren_conv_top_wrapper);

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

	// Configurations
	config_test(0);

	load_data;

	iter = 0;
	repeat(NO_OF_INSTS)
	begin
		
		write_image(iter);
		write_kernel(iter);
		$display("-------- iteration %0d ----------",iter);
		calculate_results;
		config_hw(iter,kern_cols-1,cols-1,kerns-1,stride,kern_addr_mode,result_cols-1,shift,en_max_pool,mask);
		poll_done(iter);
		repeat(10) @(posedge clk);
		readback_results(iter);
		repeat(10) @(posedge clk);
		compare_results;
		//$display("---- iteration %0d complete -----",iter);
		
		wb_write(REG_BASE_ADDR+ (iter << 24),0);	// Clear Start
		wb_write(REG_BASE_ADDR+ (iter << 24),2);	// Set soft reset
		
		for(i=0; i <32; i=i+1)
		begin
			result_sim[i]	<= 0;
			result[i]		<= 0;
		end
		wb_write(REG_BASE_ADDR+ (iter << 24),0);	// Clear soft reset
		iter=iter+1;
	end
	$display("STATUS: Simulation complete");

	$finish;
end
//-----------------------------------------------------------------------------
task config_test;
input [31:0] test_no;
begin
	if(test_no==0)		// Experiment in this case
	begin
	kern_cols			= 2;
    cols				= 8;
    kerns				= 3;
    stride				= 1;
    kern_addr_mode		= 0;
    shift				= 12;
    en_max_pool			= 1;
    mask				= 3'b111;
    result_cols			= en_max_pool ? cols*kerns/2 : cols*kerns;
	end
	else if(test_no==1)		// Typical case with even cols and max pool enabled
	begin
	kern_cols			= 3;
    cols				= 8;
    kerns				= 3;
    stride				= 1;
    kern_addr_mode		= 0;
    shift				= 12;
    en_max_pool			= 1;
    mask				= 3'b111;
    result_cols			= en_max_pool ? cols*kerns/2 : cols*kerns;
	end
	else if(test_no==2)	// Maxpool disabled
	begin
	kern_cols			= 3;
    cols				= 8;
    kerns				= 3;
    stride				= 1;
    kern_addr_mode		= 0;
    shift				= 12;
    en_max_pool			= 1;
    mask				= 3'b111;
    result_cols			= en_max_pool ? cols*kerns/2 : cols*kerns;
	end
	else if(test_no==3)	// overflow (with dummy data) in third kernel
	begin
	kern_cols			= 4;
    cols				= 8;
    kerns				= 3;
    stride				= 1;
    kern_addr_mode		= 0;
    shift				= 12;
    en_max_pool			= 1;
    mask				= 3'b111;
    result_cols			= en_max_pool ? cols*kerns/2 : cols*kerns;
	end
	
	$display("-----------SIMLULATION PARAMS------------");
	$display("kern_cols        = %0d",kern_cols);
	$display("cols             = %0d",cols		);
	$display("kerns            = %0d",kerns	);
	$display("stride           = %0d",stride	);
	$display("kern_addr_mode   = %0d",kern_addr_mode);
	$display("shift            = %0d",shift	);
	$display("en_max_pool      = %0d",en_max_pool);
	$display("mask             = %0d",mask		);
	$display("result_cols      = %0d",result_cols);
	$display("-----------------------------------------");
end
endtask
//-----------------------------------------------------------------------------
task poll_done;
input [7:0] inst_no;
reg [31:0] data_;
integer cnt;
begin
	data_ = 0;
	cnt = 0;
	while(!data_[0])
	begin
		wb_read(REG_BASE_ADDR + (inst_no << 24), data_);
		
		cnt=cnt+1;
		//$display("wbs_dat_o = %h",wbs_dat_o);
		if(cnt>100)
		begin
			$display("Stuck in polling for done... Finishing");
			$finish;
		end
		repeat(10) @(posedge clk);
	end
end
endtask
//-----------------------------------------------------------------------------
task compare_results;
integer error_cnt;
begin
	error_cnt = 0;
	for(i=0; i <result_cols; i=i+1)
	begin
		if(result[i] !== result_sim[i])
		begin
			error_cnt=error_cnt+1;
			$display("MISMATCH: Actual = %d != Simulated = %d at index %d, ERROR_CNT %d", result[i], result_sim[i],i,error_cnt);
			//$stop;
		end
		else
			if(VERBOSE>0)$display("   MATCH: Actual = %d == Simulated = %d at index %d", result[i], result_sim[i],i);

	end
	if(error_cnt==0)
		$display("STATUS: No errors found");
end
endtask
//-----------------------------------------------------------------------------
task readback_results;
input [7:0] inst_no;
begin
	for(i=0; i <result_cols; i=i+1)
		wb_read(RES_BASE_ADDR+ (inst_no << 24)+i*4, result[i]);
end
endtask
//-----------------------------------------------------------------------------
task calculate_results;
reg [20:0] conv_result [0:31];
integer ks, c,kc;
begin
	// convolve
	for(ks=0; ks<kerns;ks=ks+1)
	begin
		for(c=0; c<cols;c=c+1)
		begin
			conv_result[c+ks*cols] = 0;
			for(kc=0;kc<kern_cols;kc=kc+1)
			begin
				conv_result[c+ks*cols] = conv_result[c+ks*cols] +
								 mask[0] * (image[c+kc][ 7:0 ]*kernels[ks*(4<<kern_addr_mode)+kc][ 7:0 ]) +
								 mask[1] * (image[c+kc][15:8 ]*kernels[ks*(4<<kern_addr_mode)+kc][15:8 ]) +
								 mask[2] * (image[c+kc][23:16]*kernels[ks*(4<<kern_addr_mode)+kc][23:16]);
				if(VERBOSE>2)$display("conv[%2d] = %6d, ks %0d, c %0d, kc %0d, image %h kernel %h", 
									  c+ks*cols, conv_result[c+ks*cols],ks, c, kc, 
									  image[c+kc], kernels[ks*(4<<kern_addr_mode)+kc]);
			end
			if(VERBOSE>2)$display("");
		end
	end
	// max pool
	if(en_max_pool)
		for(ks=0; ks<kerns;ks=ks+1)
		begin
			for(c=0; c<cols;c=c+2)
			begin
				result_sim[ks*cols/2 + c/2] =  (conv_result[ks*cols + c] > conv_result[ks*cols + c+1])? conv_result[ks*cols + c]:conv_result[ks*cols + c+1];
				if(VERBOSE>1)$display("result_sim[%0d] = %0d", ks*cols/2 + c/2, result_sim[ks*cols/2 + c/2]);
			end
		end
	else
		for(c=0; c<result_cols;c=c+1)
		begin
			result_sim[c] =  conv_result[c];
			if(VERBOSE>1)$display("result_sim[%0d] = %0d",c,result_sim[c]);
		end

end
endtask
//-----------------------------------------------------------------------------
task load_data;
begin
	// TODO: Load from file instead
	// Dummy data for image
	for(i=0; i <32; i=i+1)
	begin
		image[i] =  i + ((i+1)<<8) + ((i+2)<<16);
	end

	// Dummy data for kernels
	for(i=0; i <32; i=i+1)
	begin
		kernels[i] =  (1+i/4) + (1+i/4)*'h100 + (1+i/4)*'h10000;
	end
end
endtask
//-----------------------------------------------------------------------------
task write_image;
input [7:0] inst_no;
begin
	for(i=0; i <32; i=i+1)
	begin
		wb_write(IMG_BASE_ADDR+ (inst_no << 24)+i*4, {8'd0,image[i]});
	end
end
endtask
//-----------------------------------------------------------------------------
task write_kernel;
input [7:0] inst_no;
begin
	for(i=0; i <32; i=i+1)
		wb_write(KERN_BASE_ADDR+ (inst_no << 24)+i*4, {8'd0,kernels[i]});
end
endtask
//-----------------------------------------------------------------------------
task config_hw;
input [7:0] inst_no;
input	[2:0]	kern_cols_in;
input	[7:0]	cols_in;
input	[2:0]	kerns_in;
input	[7:0]	stride_in;
input			kern_addr_mode_in;
input	[7:0]	result_cols_in;
input	[3:0]	shift_in;
input			en_max_pool_in;
input	[2:0]	mask_in;
begin
	// start			= regs[0][2];
	// kern_cols		= regs[1][2:0];
	// cols				= regs[1][15:8];
	// kerns			= regs[1][18:16];
	// stride			= regs[1][31:24];
	// kern_addr_mode	= regs[2][16];
	// shift			= regs[2][11:8];
	// en_max_pool		= regs[2][17];
	// mask				= regs[2][20:18];
	// result_cols		= regs[2][7:0];
	wb_write(REG_BASE_ADDR+ (inst_no << 24)+4, 	
								kern_cols_in 		  +
								(cols_in  	<< 8	) +
								(kerns_in 	<< 16	) +
								(stride_in 	<< 24	));

	wb_write(REG_BASE_ADDR+ (inst_no << 24)+8, 	
								result_cols_in 			   +
								(shift_in 			<< 8)  +
								(kern_addr_mode_in 	<< 16) +
								(en_max_pool_in 	<< 17) +
								(mask_in 			<< 18));

	wb_write(REG_BASE_ADDR+ (inst_no << 24),4);	// Start

end
endtask
//-----------------------------------------------------------------------------
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
		//$display("WISHBONE WRITE: Address=0x%h, Data=0x%h",addr,data);
		#1;
		wbs_stb_i	= 1'bx;
		wbs_cyc_i	= 0;
		wbs_we_i	= 1'hx;
		wbs_sel_i	= 4'hx;
		wbs_dat_i	= 32'hxxxx_xxxx;
		wbs_adr_i	= 32'hxxxx_xxxx;
	end
endtask
//-----------------------------------------------------------------------------
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
		//$display("WISHBONE READ: Address=0x%h, Data=0x%h, wbs_dat_o=0x%h",addr,data,wbs_dat_o);

	end
endtask
//-----------------------------------------------------------------------------

endmodule