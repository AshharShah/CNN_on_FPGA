//////////////////////////////////////////////////////////////////////////////////
// Company: 		Renzym
// Engineer: 		Yasir Javed
// Design Name: 	Configuration Wishbone
// Module Name:		config_wb
// Description: 	configuration registers writable through wishbone interface
// 					Reads/writes on DEPTH number of resgisters each with DWIDTH width
//					
// Dependencies:	 
//
//////////////////////////////////////////////////////////////////////////////////
module config_wb
	#(
		parameter DWIDTH = 32,
		parameter DEPTH	 = 4
	)
	(
	
    // Wishbone Slave ports (WB MI A)
    input 					wb_clk_i,
    input 					wb_rst_i,
    input 					wbs_stb_i,
    input 					wbs_cyc_i,
    input 					wbs_we_i,
    input 	[DWIDTH/8 -1:0] wbs_sel_i,
    input 	[DWIDTH-1:0] 	wbs_dat_i,
    input 	[DWIDTH-1:0] 	wbs_adr_i,
    output 					wbs_ack_o,
    output 	[DWIDTH-1:0] 	wbs_dat_o,
	
	// 
	input					done,
	output					start,

	output 		[2:0]		kern_cols,
	output		[7:0]		cols,
	output		[2:0]		kerns,
	output		[7:0]		stride,
	output					kern_addr_mode,
	output		[7:0]		result_cols,
	output		[3:0]		shift,
	output					en_max_pool
	
	);
	
	reg [DWIDTH-1:0] rdata;
	// Generic section to read/write on DEPTH number of resgisters each with DWIDTH width
    // WB MI A
    assign valid 	 = wbs_cyc_i && wbs_stb_i; 
    assign wstrb 	 = wbs_sel_i & {(DWIDTH/8){wbs_we_i}};
    assign wbs_dat_o = rdata;
    assign wdata 	 = wbs_dat_i;
	assign wbs_ack_o = ready;

	reg [DWIDTH-1:0] regs [0:DEPTH-1];
	integer i;
    always @(posedge clk) begin
        if (reset) 
		begin
			ready <= 0;
			for(i = 0; i < DEPTH; i=i+1)
				regs[i] <= 0;
        end 
		else 
		begin
            ready <= 1'b0;
            if (valid && !ready) 
			begin
                ready <= 1'b1;
                rdata <= regs[wbs_adr_i];
				
				if(wbs_adr_i == 0)
					rdata <= {regs[0][DWIDTH-1:1],done};
					
				for(i = 0; i < (DWIDTH/8); i=i+1)
					if (wstrb[i]) regs[wbs_adr_i][(i+1)*8-1:i*8]   <= wdata[(i+1)*8-1:i*8];
            end 
        end
    end

	// Specific mappings to configurations
	assign start			= regs[0][1];
	assign kern_cols		= regs[1][2:0];
    assign cols				= regs[1][15:8];
    assign kerns			= regs[1][18:16];
    assign stride			= regs[1][31:24];
    assign kern_addr_mode	= regs[2][0];
    assign result_cols		= regs[2][7:0];
    assign shift			= regs[2][11:8];
    assign en_max_pool		= regs[2][16];

endmodule