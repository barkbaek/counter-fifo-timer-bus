module	fifo_top(clk, reset_n, sel, wr, address, din, dout, fifo_cnt, fifo_flag);
	input						clk;
	input						reset_n;
	input						sel;
	input						wr;
	input			[7:0]		address;
	input			[7:0]		din;
	output 		[7:0]		dout;
	output 		[3:0]		fifo_cnt;
	output 		[5:0]		fifo_flag;
	
	reg						cur_sel;
	reg			[7:0]		next_address;
	
	wire						cur_sel_w;
	
	wire 			[3:0]		wr_dec;														// decode 이후의 wr값
	wire						F0WR_EN, F1WR_EN, F2WR_EN, F3WR_EN;									// writing 모드 - 4개의 fifo중 한가지 선택 위해..
	wire						F0RD_EN, F1RD_EN, F2RD_EN, F3RD_EN;									// reading 모드 - 4개의 fifo중 한가지 선택 위해..
	wire						wr_wr, rd_wr;												// wr모드 선택시
	wire						wr_wr1, rd_wr1;											// sel위한 wire.
	
	wire			[7:0]		dout1, 		dout2, 		dout3, 		dout4;
	wire			[3:0]		fifo_cnt1, 	fifo_cnt2, 	fifo_cnt3, 	fifo_cnt4;
	wire						full1, 		full2, 		full3, 		full4;
	wire						empty1, 		empty2, 		empty3, 		empty4;
	wire						wr_ack1,		wr_ack2,		wr_ack3,		wr_ack4;
	wire						wr_err1,		wr_err2,		wr_err3,		wr_err4;
	wire						rd_ack1,		rd_ack2,		rd_ack3,		rd_ack4;
	wire						rd_err1,		rd_err2,		rd_err3,		rd_err4;
	
	// output 정의 위한 wire - dout
	wire			[7:0]		mx_out_U0_w1,	mx_out_U0_w2,	mx_out_U0_w3,	mx_out_U0_w4;
	wire			[7:0]		mx_out_U0_w5,	mx_out_U0_w6,	mx_out_U0_w7,	mx_out_U0_w8;
	wire			[7:0]		mx_out_U1_w1,	mx_out_U1_w2,	mx_out_U1_w3,	mx_out_U1_w4;
	wire			[7:0]		mx_out_U2_w1,	mx_out_U2_w2;
	wire			[7:0]		mx_out_U3_w1;
	
	// output 정의 위한 wire - fifo_cnt
	wire			[3:0]		mx_cnt_U0_w1,	mx_cnt_U0_w2,	mx_cnt_U0_w3,	mx_cnt_U0_w4;
	wire			[3:0]		mx_cnt_U0_w5,	mx_cnt_U0_w6,	mx_cnt_U0_w7,	mx_cnt_U0_w8;
	wire			[3:0]		mx_cnt_U1_w1,	mx_cnt_U1_w2,	mx_cnt_U1_w3,	mx_cnt_U1_w4;
	wire			[3:0]		mx_cnt_U2_w1,	mx_cnt_U2_w2;
	wire			[3:0]		mx_cnt_U3_w1;
	
	// output 정의 위한 wire - full	
	wire						mx_ful_U0_w1,	mx_ful_U0_w2,	mx_ful_U0_w3,	mx_ful_U0_w4;
	wire						mx_ful_U0_w5,	mx_ful_U0_w6,	mx_ful_U0_w7,	mx_ful_U0_w8;
	wire						mx_ful_U1_w1,	mx_ful_U1_w2,	mx_ful_U1_w3,	mx_ful_U1_w4;
	wire						mx_ful_U2_w1,	mx_ful_U2_w2;
	wire						mx_ful_U3_w1;

	// output 정의 위한 wire - empty	
	wire						mx_emp_U0_w1,	mx_emp_U0_w2,	mx_emp_U0_w3,	mx_emp_U0_w4;
	wire						mx_emp_U0_w5,	mx_emp_U0_w6,	mx_emp_U0_w7,	mx_emp_U0_w8;
	wire						mx_emp_U1_w1,	mx_emp_U1_w2,	mx_emp_U1_w3,	mx_emp_U1_w4;
	wire						mx_emp_U2_w1,	mx_emp_U2_w2;
	wire						mx_emp_U3_w1;

	// output 정의 위한 wire - wr_ack
	wire						mx_wr_ack_U0_w1,	mx_wr_ack_U0_w2,	mx_wr_ack_U0_w3,	mx_wr_ack_U0_w4;
	wire						mx_wr_ack_U0_w5,	mx_wr_ack_U0_w6,	mx_wr_ack_U0_w7,	mx_wr_ack_U0_w8;
	wire						mx_wr_ack_U1_w1,	mx_wr_ack_U1_w2,	mx_wr_ack_U1_w3,	mx_wr_ack_U1_w4;
	wire						mx_wr_ack_U2_w1,	mx_wr_ack_U2_w2;
	wire						mx_wr_ack_U3_w1;

	// output 정의 위한 wire - wr_err
	wire						mx_wr_err_U0_w1,	mx_wr_err_U0_w2,	mx_wr_err_U0_w3,	mx_wr_err_U0_w4;
	wire						mx_wr_err_U0_w5,	mx_wr_err_U0_w6,	mx_wr_err_U0_w7,	mx_wr_err_U0_w8;
	wire						mx_wr_err_U1_w1,	mx_wr_err_U1_w2,	mx_wr_err_U1_w3,	mx_wr_err_U1_w4;
	wire						mx_wr_err_U2_w1,	mx_wr_err_U2_w2;
	wire						mx_wr_err_U3_w1;

	// output 정의 위한 wire - rd_ack
	wire						mx_rd_ack_U0_w1,	mx_rd_ack_U0_w2,	mx_rd_ack_U0_w3,	mx_rd_ack_U0_w4;
	wire						mx_rd_ack_U0_w5,	mx_rd_ack_U0_w6,	mx_rd_ack_U0_w7,	mx_rd_ack_U0_w8;
	wire						mx_rd_ack_U1_w1,	mx_rd_ack_U1_w2,	mx_rd_ack_U1_w3,	mx_rd_ack_U1_w4;
	wire						mx_rd_ack_U2_w1,	mx_rd_ack_U2_w2;
	wire						mx_rd_ack_U3_w1;
	
	// output 정의 위한 wire - rd_err
	wire						mx_rd_err_U0_w1,	mx_rd_err_U0_w2,	mx_rd_err_U0_w3,	mx_rd_err_U0_w4;
	wire						mx_rd_err_U0_w5,	mx_rd_err_U0_w6,	mx_rd_err_U0_w7,	mx_rd_err_U0_w8;
	wire						mx_rd_err_U1_w1,	mx_rd_err_U1_w2,	mx_rd_err_U1_w3,	mx_rd_err_U1_w4;
	wire						mx_rd_err_U2_w1,	mx_rd_err_U2_w2;
	wire						mx_rd_err_U3_w1;
	
	// sel = 1일 때만 output출력위한 wire 선언.
	wire			 [7:0]	sel_dout_w;
	wire	 		 [3:0]	sel_fifo_cnt_w;
	wire						sel_full_w;
	wire						sel_empty_w;
	wire						sel_wr_ack_w;
	wire						sel_wr_err_w;
	wire						sel_rd_ack_w;
	wire						sel_rd_err_w;

	wire			 [7:0]	last_dout_w;
	wire	 		 [3:0]	last_fifo_cnt_w;
	wire						last_full_w;
	wire						last_empty_w;
	wire						last_wr_ack_w;
	wire						last_wr_err_w;
	wire						last_rd_ack_w;
	wire						last_rd_err_w;
	
	
	//instance
	//1. mux
	mx2			 U00_read_mx2(1'b1, 1'b0, wr, rd_wr1);
	mx2			U11_write_mx2(1'b0, 1'b1, wr, wr_wr1);
	
	//1-1. sel
	mx2			 U00_sel_mx2(1'b0, rd_wr1, sel, rd_wr);
	mx2			 U11_sel_mx2(1'b0, wr_wr1, sel, wr_wr);
	
	//2. Decoder
	decoder 		U0_decoder(reset_n, address, wr_dec);
	
	//3. wr이 1이라면
	_andcn 		U1_wr_and(wr_dec[0], wr_wr, F0WR_EN);
	_andcn 		U2_wr_and(wr_dec[1], wr_wr, F1WR_EN);
	_andcn 		U3_wr_and(wr_dec[2], wr_wr, F2WR_EN);
	_andcn 		U4_wr_and(wr_dec[3], wr_wr, F3WR_EN);
	
	//4. rd가 1이라면
	_andcn 		U1_rd_and(wr_dec[0], rd_wr, F0RD_EN);
	_andcn 		U2_rd_and(wr_dec[1], rd_wr, F1RD_EN);
	_andcn 		U3_rd_and(wr_dec[2], rd_wr, F2RD_EN);
	_andcn 		U4_rd_and(wr_dec[3], rd_wr, F3RD_EN);
	
	//5. synchronous fifo instance
	fifo			U0_fifo(.clk(clk), .reset_n(reset_n), .wr_en(F0WR_EN), .rd_en(F0RD_EN), .din(din), .dout(dout1), .data_count(fifo_cnt1), .full(full1), .empty(empty1), .wr_ack(wr_ack1), .wr_err(wr_err1), .rd_ack(rd_ack1), .rd_err(rd_err1));
	fifo			U1_fifo(.clk(clk), .reset_n(reset_n), .wr_en(F1WR_EN), .rd_en(F1RD_EN), .din(din), .dout(dout2), .data_count(fifo_cnt2), .full(full2), .empty(empty2), .wr_ack(wr_ack2), .wr_err(wr_err2), .rd_ack(rd_ack2), .rd_err(rd_err2));
	fifo			U2_fifo(.clk(clk), .reset_n(reset_n), .wr_en(F2WR_EN), .rd_en(F2RD_EN), .din(din), .dout(dout3), .data_count(fifo_cnt3), .full(full3), .empty(empty3), .wr_ack(wr_ack3), .wr_err(wr_err3), .rd_ack(rd_ack3), .rd_err(rd_err3));
	fifo			U3_fifo(.clk(clk), .reset_n(reset_n), .wr_en(F3WR_EN), .rd_en(F3RD_EN), .din(din), .dout(dout4), .data_count(fifo_cnt4), .full(full4), .empty(empty4), .wr_ack(wr_ack4), .wr_err(wr_err4), .rd_ack(rd_ack4), .rd_err(rd_err4));

	//6. output - dout 정의..
	ot_mx2		U0_1_ot_mx2(8'b0,		dout1,	next_address[0],	mx_out_U0_w1);
	ot_mx2		U0_2_ot_mx2(dout2,	dout3,	next_address[0],	mx_out_U0_w2);
	ot_mx2		U0_3_ot_mx2(dout4,	8'b0,		next_address[0],	mx_out_U0_w3);
	ot_mx2		U0_4_ot_mx2(8'b0,		8'b0,		next_address[0],	mx_out_U0_w4);
	ot_mx2		U0_5_ot_mx2(8'b0,		8'b0,		next_address[0],	mx_out_U0_w5);
	ot_mx2		U0_6_ot_mx2(8'b0,		8'b0,		next_address[0],	mx_out_U0_w6);
	ot_mx2		U0_7_ot_mx2(8'b0,		8'b0,		next_address[0],	mx_out_U0_w7);
	ot_mx2		U0_8_ot_mx2(8'b0,		8'b0,		next_address[0],	mx_out_U0_w8);
	
	ot_mx2		U1_1_ot_mx2(mx_out_U0_w1,		mx_out_U0_w2,		next_address[1],	mx_out_U1_w1);
	ot_mx2		U1_2_ot_mx2(mx_out_U0_w3,		mx_out_U0_w4,		next_address[1],	mx_out_U1_w2);
	ot_mx2		U1_3_ot_mx2(mx_out_U0_w5,		mx_out_U0_w6,		next_address[1],	mx_out_U1_w3);
	ot_mx2		U1_4_ot_mx2(mx_out_U0_w7,		mx_out_U0_w8,		next_address[1],	mx_out_U1_w4);
	
	ot_mx2		U2_1_ot_mx2(mx_out_U1_w1,		mx_out_U1_w2,		next_address[2],	mx_out_U2_w1);
	ot_mx2		U2_2_ot_mx2(mx_out_U1_w3,		mx_out_U1_w4,		next_address[2],	mx_out_U2_w2);
	
	ot_mx2		U3_1_ot_mx2(mx_out_U2_w1,		mx_out_U2_w2,		next_address[3],	mx_out_U3_w1);
		

	//7. output - fifo_cnt 정의..
	
	cnt_mx2		U0_1_cnt_mx2(4'b0,			fifo_cnt1,		next_address[0],	mx_cnt_U0_w1);
	cnt_mx2		U0_2_cnt_mx2(fifo_cnt2,		fifo_cnt3,		next_address[0],	mx_cnt_U0_w2);
	cnt_mx2		U0_3_cnt_mx2(fifo_cnt4,		4'b0,				next_address[0],	mx_cnt_U0_w3);
	cnt_mx2		U0_4_cnt_mx2(4'b0,			4'b0,				next_address[0],	mx_cnt_U0_w4);
	cnt_mx2		U0_5_cnt_mx2(4'b0,			4'b0,				next_address[0],	mx_cnt_U0_w5);
	cnt_mx2		U0_6_cnt_mx2(4'b0,			4'b0,				next_address[0],	mx_cnt_U0_w6);
	cnt_mx2		U0_7_cnt_mx2(4'b0,			4'b0,				next_address[0],	mx_cnt_U0_w7);
	cnt_mx2		U0_8_cnt_mx2(4'b0,			4'b0,				next_address[0],	mx_cnt_U0_w8);
	
	cnt_mx2		U1_1_cnt_mx2(mx_cnt_U0_w1,	mx_cnt_U0_w2,	next_address[1],	mx_cnt_U1_w1);
	cnt_mx2		U1_2_cnt_mx2(mx_cnt_U0_w3,	mx_cnt_U0_w4,	next_address[1],	mx_cnt_U1_w2);
	cnt_mx2		U1_3_cnt_mx2(mx_cnt_U0_w5,	mx_cnt_U0_w6,	next_address[1],	mx_cnt_U1_w3);
	cnt_mx2		U1_4_cnt_mx2(mx_cnt_U0_w7,	mx_cnt_U0_w8,	next_address[1],	mx_cnt_U1_w4);
	
	cnt_mx2		U2_1_cnt_mx2(mx_cnt_U1_w1,	mx_cnt_U1_w2,	next_address[2],	mx_cnt_U2_w1);
	cnt_mx2		U2_2_cnt_mx2(mx_cnt_U1_w3,	mx_cnt_U1_w4,	next_address[2],	mx_cnt_U2_w2);
	
	cnt_mx2		U3_1_cnt_mx2(mx_cnt_U2_w1,	mx_cnt_U2_w2,	next_address[3],	mx_cnt_U3_w1);
	

	//7.	output - full 정의..
	
	mx2			U0_1_full_mx2(1'b0,			full1,			next_address[0],	mx_ful_U0_w1);
	mx2			U0_2_full_mx2(full2,			full3,			next_address[0],	mx_ful_U0_w2);
	mx2			U0_3_full_mx2(full4,			1'b0,				next_address[0],	mx_ful_U0_w3);
	mx2			U0_4_full_mx2(1'b0,			1'b0,				next_address[0],	mx_ful_U0_w4);
	mx2			U0_5_full_mx2(1'b0,			1'b0,				next_address[0],	mx_ful_U0_w5);
	mx2			U0_6_full_mx2(1'b0,			1'b0,				next_address[0],	mx_ful_U0_w6);
	mx2			U0_7_full_mx2(1'b0,			1'b0,				next_address[0],	mx_ful_U0_w7);
	mx2			U0_8_full_mx2(1'b0,			1'b0,				next_address[0],	mx_ful_U0_w8);
	
	mx2			U1_1_full_mx2(mx_ful_U0_w1,	mx_ful_U0_w2,		next_address[1],	mx_ful_U1_w1);
	mx2			U1_2_full_mx2(mx_ful_U0_w3,	mx_ful_U0_w4,		next_address[1],	mx_ful_U1_w2);
	mx2			U1_3_full_mx2(mx_ful_U0_w5,	mx_ful_U0_w6,		next_address[1],	mx_ful_U1_w3);
	mx2			U1_4_full_mx2(mx_ful_U0_w7,	mx_ful_U0_w8,		next_address[1],	mx_ful_U1_w4);
	
	mx2			U2_1_full_mx2(mx_ful_U1_w1,	mx_ful_U1_w2,		next_address[2],	mx_ful_U2_w1);
	mx2			U2_2_full_mx2(mx_ful_U1_w3,	mx_ful_U1_w4,		next_address[2],	mx_ful_U2_w2);
	
	mx2			U3_1_full_mx2(mx_ful_U2_w1,	mx_ful_U2_w2,		next_address[3],	mx_ful_U3_w1);

	
	//8.  output - empty 정의..
	
	mx2			U0_1_empty_mx2(1'b0,			empty1,			next_address[0],	mx_emp_U0_w1);
	mx2			U0_2_empty_mx2(empty2,		empty3,			next_address[0],	mx_emp_U0_w2);
	mx2			U0_3_empty_mx2(empty4,		1'b0,				next_address[0],	mx_emp_U0_w3);
	mx2			U0_4_empty_mx2(1'b0,			1'b0,				next_address[0],	mx_emp_U0_w4);
	mx2			U0_5_empty_mx2(1'b0,			1'b0,				next_address[0],	mx_emp_U0_w5);
	mx2			U0_6_empty_mx2(1'b0,			1'b0,				next_address[0],	mx_emp_U0_w6);
	mx2			U0_7_empty_mx2(1'b0,			1'b0,				next_address[0],	mx_emp_U0_w7);
	mx2			U0_8_empty_mx2(1'b0,			1'b0,				next_address[0],	mx_emp_U0_w8);
	
	mx2			U1_1_empty_mx2(mx_emp_U0_w1,	mx_emp_U0_w2,		next_address[1],	mx_emp_U1_w1);
	mx2			U1_2_empty_mx2(mx_emp_U0_w3,	mx_emp_U0_w4,		next_address[1],	mx_emp_U1_w2);
	mx2			U1_3_empty_mx2(mx_emp_U0_w5,	mx_emp_U0_w6,		next_address[1],	mx_emp_U1_w3);
	mx2			U1_4_empty_mx2(mx_emp_U0_w7,	mx_emp_U0_w8,		next_address[1],	mx_emp_U1_w4);
	
	mx2			U2_1_empty_mx2(mx_emp_U1_w1,	mx_emp_U1_w2,		next_address[2],	mx_emp_U2_w1);
	mx2			U2_2_empty_mx2(mx_emp_U1_w3,	mx_emp_U1_w4,		next_address[2],	mx_emp_U2_w2);
	
	mx2			U3_1_empty_mx2(mx_emp_U2_w1,	mx_emp_U2_w2,		next_address[3],	mx_emp_U3_w1);
	

	//9.  output - wr_ack 정의..
	
	mx2			U0_1_wr_ack_mx2(1'b0,		wr_ack1,			next_address[0],	mx_wr_ack_U0_w1);
	mx2			U0_2_wr_ack_mx2(wr_ack2,	wr_ack3,			next_address[0],	mx_wr_ack_U0_w2);
	mx2			U0_3_wr_ack_mx2(wr_ack4,	1'b0,				next_address[0],	mx_wr_ack_U0_w3);
	mx2			U0_4_wr_ack_mx2(1'b0,		1'b0,				next_address[0],	mx_wr_ack_U0_w4);
	mx2			U0_5_wr_ack_mx2(1'b0,		1'b0,				next_address[0],	mx_wr_ack_U0_w5);
	mx2			U0_6_wr_ack_mx2(1'b0,		1'b0,				next_address[0],	mx_wr_ack_U0_w6);
	mx2			U0_7_wr_ack_mx2(1'b0,		1'b0,				next_address[0],	mx_wr_ack_U0_w7);
	mx2			U0_8_wr_ack_mx2(1'b0,		1'b0,				next_address[0],	mx_wr_ack_U0_w8);
	
	mx2			U1_1_wr_ack_mx2(mx_wr_ack_U0_w1,		mx_wr_ack_U0_w2,		next_address[1],	mx_wr_ack_U1_w1);
	mx2			U1_2_wr_ack_mx2(mx_wr_ack_U0_w3,		mx_wr_ack_U0_w4,		next_address[1],	mx_wr_ack_U1_w2);
	mx2			U1_3_wr_ack_mx2(mx_wr_ack_U0_w5,		mx_wr_ack_U0_w6,		next_address[1],	mx_wr_ack_U1_w3);
	mx2			U1_4_wr_ack_mx2(mx_wr_ack_U0_w7,		mx_wr_ack_U0_w8,		next_address[1],	mx_wr_ack_U1_w4);
	
	mx2			U2_1_wr_ack_mx2(mx_wr_ack_U1_w1,		mx_wr_ack_U1_w2,		next_address[2],	mx_wr_ack_U2_w1);
	mx2			U2_2_wr_ack_mx2(mx_wr_ack_U1_w3,		mx_wr_ack_U1_w4,		next_address[2],	mx_wr_ack_U2_w2);
	
	mx2			U3_1_wr_ack_mx2(mx_wr_ack_U2_w1,		mx_wr_ack_U2_w2,		next_address[3],	mx_wr_ack_U3_w1);
	
	
	//10. 	output - wr_err 정의..
	
	mx2			U0_1_wr_err_mx2(1'b0,		wr_err1,			next_address[0],	mx_wr_err_U0_w1);
	mx2			U0_2_wr_err_mx2(wr_err2,	wr_err3,			next_address[0],	mx_wr_err_U0_w2);
	mx2			U0_3_wr_err_mx2(wr_err4,	1'b0,				next_address[0],	mx_wr_err_U0_w3);
	mx2			U0_4_wr_err_mx2(1'b0,		1'b0,				next_address[0],	mx_wr_err_U0_w4);
	mx2			U0_5_wr_err_mx2(1'b0,		1'b0,				next_address[0],	mx_wr_err_U0_w5);
	mx2			U0_6_wr_err_mx2(1'b0,		1'b0,				next_address[0],	mx_wr_err_U0_w6);
	mx2			U0_7_wr_err_mx2(1'b0,		1'b0,				next_address[0],	mx_wr_err_U0_w7);
	mx2			U0_8_wr_err_mx2(1'b0,		1'b0,				next_address[0],	mx_wr_err_U0_w8);
	
	mx2			U1_1_wr_err_mx2(mx_wr_err_U0_w1,		mx_wr_err_U0_w2,		next_address[1],	mx_wr_err_U1_w1);
	mx2			U1_2_wr_err_mx2(mx_wr_err_U0_w3,		mx_wr_err_U0_w4,		next_address[1],	mx_wr_err_U1_w2);
	mx2			U1_3_wr_err_mx2(mx_wr_err_U0_w5,		mx_wr_err_U0_w6,		next_address[1],	mx_wr_err_U1_w3);
	mx2			U1_4_wr_err_mx2(mx_wr_err_U0_w7,		mx_wr_err_U0_w8,		next_address[1],	mx_wr_err_U1_w4);
	
	mx2			U2_1_wr_err_mx2(mx_wr_err_U1_w1,		mx_wr_err_U1_w2,		next_address[2],	mx_wr_err_U2_w1);
	mx2			U2_2_wr_err_mx2(mx_wr_err_U1_w3,		mx_wr_err_U1_w4,		next_address[2],	mx_wr_err_U2_w2);
	
	mx2			U3_1_wr_err_mx2(mx_wr_err_U2_w1,		mx_wr_err_U2_w2,		next_address[3],	mx_wr_err_U3_w1);
	
	
	//11. output - rd_ack 정의..
	
	mx2			U0_1_rd_ack_mx2(1'b0,		rd_ack1,			next_address[0],	mx_rd_ack_U0_w1);
	mx2			U0_2_rd_ack_mx2(rd_ack2,	rd_ack3,			next_address[0],	mx_rd_ack_U0_w2);
	mx2			U0_3_rd_ack_mx2(rd_ack4,	1'b0,				next_address[0],	mx_rd_ack_U0_w3);
	mx2			U0_4_rd_ack_mx2(1'b0,		1'b0,				next_address[0],	mx_rd_ack_U0_w4);
	mx2			U0_5_rd_ack_mx2(1'b0,		1'b0,				next_address[0],	mx_rd_ack_U0_w5);
	mx2			U0_6_rd_ack_mx2(1'b0,		1'b0,				next_address[0],	mx_rd_ack_U0_w6);
	mx2			U0_7_rd_ack_mx2(1'b0,		1'b0,				next_address[0],	mx_rd_ack_U0_w7);
	mx2			U0_8_rd_ack_mx2(1'b0,		1'b0,				next_address[0],	mx_rd_ack_U0_w8);
	
	mx2			U1_1_rd_ack_mx2(mx_rd_ack_U0_w1,		mx_rd_ack_U0_w2,		next_address[1],	mx_rd_ack_U1_w1);
	mx2			U1_2_rd_ack_mx2(mx_rd_ack_U0_w3,		mx_rd_ack_U0_w4,		next_address[1],	mx_rd_ack_U1_w2);
	mx2			U1_3_rd_ack_mx2(mx_rd_ack_U0_w5,		mx_rd_ack_U0_w6,		next_address[1],	mx_rd_ack_U1_w3);
	mx2			U1_4_rd_ack_mx2(mx_rd_ack_U0_w7,		mx_rd_ack_U0_w8,		next_address[1],	mx_rd_ack_U1_w4);
	
	mx2			U2_1_rd_ack_mx2(mx_rd_ack_U1_w1,		mx_rd_ack_U1_w2,		next_address[2],	mx_rd_ack_U2_w1);
	mx2			U2_2_rd_ack_mx2(mx_rd_ack_U1_w3,		mx_rd_ack_U1_w4,		next_address[2],	mx_rd_ack_U2_w2);
	
	mx2			U3_1_rd_ack_mx2(mx_rd_ack_U2_w1,		mx_rd_ack_U2_w2,		next_address[3],	mx_rd_ack_U3_w1);
	

	//12. output - rd_err 정의..
	
	mx2			U0_1_rd_err_mx2(1'b0,		rd_err1,			next_address[0],	mx_rd_err_U0_w1);
	mx2			U0_2_rd_err_mx2(rd_err2,	rd_err3,			next_address[0],	mx_rd_err_U0_w2);
	mx2			U0_3_rd_err_mx2(rd_err4,	1'b0,				next_address[0],	mx_rd_err_U0_w3);
	mx2			U0_4_rd_err_mx2(1'b0,		1'b0,				next_address[0],	mx_rd_err_U0_w4);
	mx2			U0_5_rd_err_mx2(1'b0,		1'b0,				next_address[0],	mx_rd_err_U0_w5);
	mx2			U0_6_rd_err_mx2(1'b0,		1'b0,				next_address[0],	mx_rd_err_U0_w6);
	mx2			U0_7_rd_err_mx2(1'b0,		1'b0,				next_address[0],	mx_rd_err_U0_w7);
	mx2			U0_8_rd_err_mx2(1'b0,		1'b0,				next_address[0],	mx_rd_err_U0_w8);
	
	mx2			U1_1_rd_err_mx2(mx_rd_err_U0_w1,		mx_rd_err_U0_w2,		next_address[1],	mx_rd_err_U1_w1);
	mx2			U1_2_rd_err_mx2(mx_rd_err_U0_w3,		mx_rd_err_U0_w4,		next_address[1],	mx_rd_err_U1_w2);
	mx2			U1_3_rd_err_mx2(mx_rd_err_U0_w5,		mx_rd_err_U0_w6,		next_address[1],	mx_rd_err_U1_w3);
	mx2			U1_4_rd_err_mx2(mx_rd_err_U0_w7,		mx_rd_err_U0_w8,		next_address[1],	mx_rd_err_U1_w4);
	
	mx2			U2_1_rd_err_mx2(mx_rd_err_U1_w1,		mx_rd_err_U1_w2,		next_address[2],	mx_rd_err_U2_w1);
	mx2			U2_2_rd_err_mx2(mx_rd_err_U1_w3,		mx_rd_err_U1_w4,		next_address[2],	mx_rd_err_U2_w2);
	
	mx2			U3_1_rd_err_mx2(mx_rd_err_U2_w1,		mx_rd_err_U2_w2,		next_address[3],	mx_rd_err_U3_w1);
	
	
	// sel = 1일 때만 output들 출력되도록 정의 (sel과 최종 output값이 저장되어있는 wire를 mux로 처리.)
	// sel 값을 클록이 상승에지일 때 cur_sel에 넣어주기.
	always @ (posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0)
			cur_sel <= 1'b0;
		else
			cur_sel <= sel;
	end

	assign 	cur_sel_w = cur_sel;
	
	// 1. dout
	//1-1. 최종 mux처리 (Schematic Last Mux(The Final Mux) 참고.)
	ot_mx2	U1_dout_last_mx(8'b00000000, 8'b11111111, cur_sel_w, sel_dout_w);
	//1-2. 최종 and처리로 sel == 0 이면 작동 X(Schematic Last And(The Final And) 참고.)
	_andcn8	U1_dout_last_and(sel_dout_w, mx_out_U3_w1, last_dout_w);
	
	// 2. fifo_cnt
	//2-1. 최종 mux처리 (Schematic Last Mux(The Final Mux) 참고.)
	cnt_mx2	U2_fifo_cnt_last_mx(4'b0000, 4'b1111, cur_sel_w, sel_fifo_cnt_w);
	//2-2. 최종 and처리로 sel == 0 이면 작동 X(Schematic Last And(The Final And) 참고.)
	_andcn4	U2_fifo_cnt_last_and(sel_fifo_cnt_w, mx_cnt_U3_w1, last_fifo_cnt_w);
	
	// 3. full
	//3-1. 최종 mux처리 (Schematic Last Mux(The Final Mux) 참고.)
	mx2		U3_full_last_mx(1'b0, 1'b1, cur_sel_w, sel_full_w);
	//3-2. 최종 and처리로 sel == 0 이면 작동 X(Schematic Last And(The Final And) 참고.)
	_andcn	U3_full_last_and(sel_full_w, mx_ful_U3_w1, last_full_w);
	
	// 4. empty
	//4-1. 최종 mux처리 (Schematic Last Mux(The Final Mux) 참고.)
	mx2		U4_empty_last_mx(1'b0, 1'b1, cur_sel_w, sel_empty_w);
	//4-2. 최종 and처리로 sel == 0 이면 작동 X(Schematic Last And(The Final And) 참고.)
	_andcn	U4_empty_last_and(sel_empty_w, mx_emp_U3_w1, last_empty_w);
	
	// 5. wr_ack
	//5-1. 최종 mux처리 (Schematic Last Mux(The Final Mux) 참고.)
	mx2		U5_wr_ack_last_mx(1'b0, 1'b1, cur_sel_w, sel_wr_ack_w);
	//5-2. 최종 and처리로 sel == 0 이면 작동 X(Schematic Last And(The Final And) 참고.)
	_andcn	U5_wr_ack_last_and(sel_wr_ack_w, mx_wr_ack_U3_w1, last_wr_ack_w);
	
	// 6. wr_err
	//6-1. 최종 mux처리 (Schematic Last Mux(The Final Mux) 참고.)
	mx2		U6_wr_err_last_mx(1'b0, 1'b1, cur_sel_w, sel_wr_err_w);
	//6-2. 최종 and처리로 sel == 0 이면 작동 X(Schematic Last And(The Final And) 참고.)
	_andcn	U6_wr_err_last_and(sel_wr_err_w, mx_wr_err_U3_w1, last_wr_err_w);
	
	// 7. rd_ack
	//7-1. 최종 mux처리 (Schematic Last Mux(The Final Mux) 참고.)
	mx2		U7_rd_ack_last_mx(1'b0, 1'b1, cur_sel_w, sel_rd_ack_w);
	//7-2. 최종 and처리로 sel == 0 이면 작동 X(Schematic Last And(The Final And) 참고.)
	_andcn	U7_rd_ack_last_and(sel_rd_ack_w, mx_rd_ack_U3_w1, last_rd_ack_w);	
	
	// 8. rd_err
	//8-1. 최종 mux처리 (Schematic Last Mux(The Final Mux) 참고.)
	mx2		U8_rd_err_last_mx(1'b0, 1'b1, cur_sel_w, sel_rd_err_w);
	//8-2. 최종 and처리로 sel == 0 이면 작동 X(Schematic Last And(The Final And) 참고.)
	_andcn	U8_rd_err_last_and(sel_rd_err_w, mx_rd_err_U3_w1, last_rd_err_w);	
		
	
	
	// 선택된 output들 assign!
	assign		dout 				= last_dout_w;
	assign		fifo_cnt 		= last_fifo_cnt_w;
	
	assign		fifo_flag[5]	= last_full_w;
	assign		fifo_flag[4]	= last_empty_w;
	assign		fifo_flag[3]	= last_wr_ack_w;
	assign		fifo_flag[2]	= last_wr_err_w;
	assign		fifo_flag[1]	= last_rd_ack_w;
	assign		fifo_flag[0]	= last_rd_err_w;

	// address output에 넘겨주기	
	always @ (posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0)
			next_address <= 8'b0;
		else
			next_address <= address;
	end


endmodule
module	decoder(reset_n, address, wr_dec);  // decoder
	input					reset_n;
	input			[7:0]	address;
	output reg	[3:0]	wr_dec;

	always @ (reset_n or address)
	begin
	if(reset_n == 1'b0)
			wr_dec = 4'b0000;
	else if(reset_n == 1'b1)
		begin
		  if((address[0] == 1) && (address[1] == 0) && (address[2] == 0) && (address[3] == 0))
			wr_dec = 4'b0001;
		else if((address[0] == 0) && (address[1] == 1) && (address[2] == 0) && (address[3] == 0))
			wr_dec = 4'b0010;
		else if((address[0] == 1) && (address[1] == 1) && (address[2] == 0) && (address[3] == 0))
			wr_dec = 4'b0100;
		else if((address[0] == 0) && (address[1] == 0) && (address[2] == 1) && (address[3] == 0))
			wr_dec = 4'b1000;
		else
			wr_dec = 4'b0000;
		end
	else
			wr_dec = 4'b0000;
	end
endmodule
module	_andcn(a, b, y);					// 1bit And gate
	input	a, b;
	output	y;
	assign y = a & b;
endmodule
module	_andcn4(a, b, y);					// 4bit And gate
	input		[3:0]		a, b;
	output	[3:0]		y;
	assign	y = a & b;
endmodule
module	_andcn8(a, b, y);					// 8bit And gate
	input		[7:0]		a, b;
	output	[7:0]		y;
	assign	y = a & b;
endmodule

module	cnt_mx2(d0, d1, s, y);				// wr선택위해.., output 정의위해..
	input		s;
	input		[3:0] d0, d1;
	output	[3:0]	y;
	
	assign	y = (s == 0 ) ? d0 : d1; 
endmodule
module	ot_mx2(d0, d1, s, y);				// wr선택위해.., output 정의위해..
	input		s;
	input		[7:0] d0, d1;
	output	[7:0]	y;
	
	assign	y = (s == 0 ) ? d0 : d1; 
endmodule
module	mx2(d0, d1, s, y);
	input		d0, d1, s;
	output	y;
	assign y = (s == 0) ? d0 : d1;
endmodule
