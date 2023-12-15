module tb_agu;
	parameter KERN_COL_WIDTH 	= 3;
	parameter COL_WIDTH 		= 8;
	parameter KERN_CNT_WIDTH 	= 3;
	parameter IMG_ADDR_WIDTH 	= 8;
	parameter RSLT_ADDR_WIDTH 	= 8;

	reg								clk;
	reg								reset;
	reg								start;
	
	// Configurations
	reg 	[KERN_COL_WIDTH-1:0]	kern_cols;
	reg		[COL_WIDTH-1:0]			cols;
	reg		[KERN_CNT_WIDTH-1:0]	kerns;
	reg		[IMG_ADDR_WIDTH-1:0]	stride;
	reg								kern_addr_mode;
	reg		[RSLT_ADDR_WIDTH-1:0]	result_cols;
	
	//
	wire	[KERN_CNT_WIDTH+KERN_COL_WIDTH-1:0]	kern_addr;
	wire	[IMG_ADDR_WIDTH-1:0]				img_addr;
	wire	[RSLT_ADDR_WIDTH-1:0]				result_addr;


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
	.kern_cols		(kern_cols		),
	.cols			(cols			),
	.kerns			(kerns			),
	.stride			(stride			),
	.kern_addr_mode	(kern_addr_mode	),
	.result_cols	(result_cols	),
	.kern_addr		(kern_addr		),
	.img_addr		(img_addr		),
	.result_addr	(result_addr	)
	);

initial
begin
	clk = 0;
	forever #5 clk = ~clk;
end


initial
begin
	$dumpfile("wave.vcd");
	$dumpvars(0, tb_agu);
	
    reset			= 0;
    start			= 0;
    kern_cols		= 2;
    cols			= 10;
    kerns			= 3;
    stride			= 1;
    kern_addr_mode	= 0;
	result_cols		= 10;


	repeat(2) @(posedge clk);
	#1 reset		= 1;

	repeat(2) @(posedge clk);
	#1 reset		= 0;
	
	repeat(10) @(posedge clk);
	
	#1 start = 1;
	repeat(100) @(posedge clk);
	

	$finish;
end

endmodule