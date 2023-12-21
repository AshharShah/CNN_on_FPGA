//////////////////////////////////////////////////////////////////////////////////
// Company: 		Renzym
// Engineer: 		Yasir Javed
// Design Name: 	Configuration Wishbone Generic
// Module Name:		config_wb
// Description: 	Configuration registers writable through wishbone interface
// 					Reads/writes on DEPTH number of resgisters each with DWIDTH width
//					
// Dependencies:	 
//
//////////////////////////////////////////////////////////////////////////////////
module config_wb_generic
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
    output 	[DWIDTH-1:0] 	wbs_dat_o
		
	);

    // WB MI A
    assign valid 	 = wbs_cyc_i && wbs_stb_i; 
    assign wstrb 	 = wbs_sel_i & {(DWIDTH/8){wbs_we_i}};
    assign wbs_dat_o = rdata;
    assign wdata 	 = wbs_dat_i;
	assign wbs_ack_o = ready;

	integer i;
	reg [DWIDTH-1:0] regs [0:DEPTH-1];
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
            if (valid && !ready) begin
                ready <= 1'b1;
                rdata <= regs[wbs_adr_i];
									
				for(i = 0; i < (DWIDTH/8); i=i+1)
					if (wstrb[i]) regs[wbs_adr_i][(i+1)*8-1:i*8]   <= wdata[(i+1)*8-1:i*8];
            end 
        end
    end

endmodule