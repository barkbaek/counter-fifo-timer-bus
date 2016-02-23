module	timer(clk, reset_n, M_req, M_address, M_wr, M_dout, M_din, M_grant, S_sel, S_address, S_wr, S_din, S_dout, interrupt);
	input						clk;
	input						reset_n;
	input			[7:0]		M_din;
	input						M_grant;
	
	input						S_sel;
	input			[7:0]		S_address;
	input						S_wr;
	input			[7:0]		S_din;
	
	output					M_req;
	output		[7:0]		M_address;
	output					M_wr;
	output		[7:0]		M_dout;
	output 		[7:0]		S_dout;
	output					interrupt;
	

	wire						CNT_EN;
	wire						read_req, int_clear, CNT_CON;
	wire			[7:0]		LOAD_ADDRESS;
	wire			[2:0]		NEXT_master_state;
	wire			[7:0]		NEXT_LOAD_VALUE, LOAD_VALUE, NEXT_COUNT_VALUE;
	wire			[1:0]		NEXT_counter_state;
		
	//instance
	// timer_reg
	timer_reg			U0_timer_reg(clk, reset_n, S_sel, S_address, S_wr, S_din, NEXT_master_state, NEXT_LOAD_VALUE,
											 NEXT_COUNT_VALUE, NEXT_counter_state, S_dout, read_req, LOAD_ADDRESS, int_clear,
											 CNT_CON, interrupt);
	
	// timer_master
	timer_master	U1_timer_master(clk, reset_n, read_req, LOAD_ADDRESS, M_grant, M_din, NEXT_master_state,
											 NEXT_LOAD_VALUE, LOAD_VALUE, CNT_EN, M_req, M_address, M_wr, M_dout);
	
	// timer_counter
	timer_counter	U2_timer_counter(clk, reset_n, CNT_EN, LOAD_VALUE, int_clear, CNT_CON, NEXT_COUNT_VALUE, NEXT_counter_state);
	
endmodule
