module	top(clk, reset_n, M0_req, M0_address, M0_wr, M0_dout, M0_grant, M_din, timer_interrupt, fifo_cnt, fifo_flag);
	input					clk;
	input					reset_n;
	input					M0_req;
	input		[7:0]		M0_address;
	input					M0_wr;
	input		[7:0]		M0_dout;
	
	output				M0_grant;
	output	[7:0]		M_din;
	
	output				timer_interrupt;
	output	[3:0]		fifo_cnt;
	output	[5:0]		fifo_flag;
	
	// bus output 연결
	wire		[7:0]		M_din_w;
	wire					fifo_sel_w, timer_sel_w;
	wire					S_wr_w;
	wire		[7:0]		S_address_w;
	wire		[7:0]		S_din_w;
	wire		[7:0]		fifo_dout_w;
	wire		[7:0]		timer_dout_w;
	
	// bus와 timer 연결.
	wire 					M1_req_w;
	wire					M1_grant_w;
	wire					M1_wr_w;
	wire		[7:0]		M1_address_w;
	wire		[7:0]		M1_dout_w;
	

	bus				U0_bus(.clk(clk), 						.reset_n(reset_n),	 .M0_req(M0_req), 			.M0_address(M0_address),
								 .M0_wr(M0_wr),					.M0_dout(M0_dout), 	 .M0_grant(M0_grant), 		.M1_req(M1_req_w),
								 .M1_address(M1_address_w), 	.M1_wr(M1_wr_w), 		 .M1_dout(M1_dout_w), 		.M1_grant(M1_grant_w),
								 .M_din(M_din_w), 				.S0_sel(fifo_sel_w),	 .S1_sel(timer_sel_w), 		.S_address(S_address_w),
								 .S_wr(S_wr_w), 					.S_din(S_din_w), 		 .S0_dout(fifo_dout_w), 	.S1_dout(timer_dout_w));
							 
	fifo_top		U1_fifo_top(.clk(clk), 		.reset_n(reset_n),	 .sel(fifo_sel_w), 	.wr(S_wr_w), 	.address(S_address_w),
									.din(S_din_w), .dout(fifo_dout_w), 	 .fifo_cnt(fifo_cnt), 		.fifo_flag(fifo_flag));
									
	timer			U2_timer(.clk(clk), 					.reset_n(reset_n), 				 .M_req(M1_req_w), 		.M_address(M1_address_w),
								.M_wr(M1_wr_w), 			.M_dout(M1_dout_w), 				 .M_din(M_din_w), 		.M_grant(M1_grant_w),
								.S_sel(timer_sel_w), 	.S_address(S_address_w), 		 .S_wr(S_wr_w), 			.S_din(S_din_w),
								.S_dout(timer_dout_w), 	.interrupt(timer_interrupt));
						

	
	assign	M_din = M_din_w;

endmodule
