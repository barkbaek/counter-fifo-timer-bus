module	timer_reg(clk, reset_n, S_sel, S_address, S_wr, S_din, NEXT_master_state, NEXT_LOAD_VALUE, NEXT_COUNT_VALUE, NEXT_counter_state, S_dout, read_req, LOAD_ADDRESS, int_clear, CNT_CON, interrupt);
	input						clk, reset_n;
	input						S_sel;
	input			[7:0]		S_address;
	input						S_wr;
	input			[7:0]		S_din;
	input			[2:0]		NEXT_master_state;
	input			[7:0]		NEXT_LOAD_VALUE, NEXT_COUNT_VALUE;
	input			[1:0]		NEXT_counter_state;
	
	output reg	[7:0]		S_dout;
	output reg				read_req;
	output reg	[7:0]		LOAD_ADDRESS;
	output reg				int_clear;
	output reg				CNT_CON;
	output					interrupt;

	parameter				CNT_EN_IDLE_STATE  = 1'b0;
	parameter				CNT_EN_READ_REQ	 = 1'b1;
	
	parameter				INTRRT_IDLE_STATE	 = 1'b0;
	parameter				INTRRT_CLEAR_STATE = 1'b1;
	
	reg			[7:0]		NEXT_S_dout;
		
	reg						CNT_EN_NEXT_STATE;			// CNT_EN 의 combinational logic에 의해 계산된 값 저장.
	reg						CNT_EN_STATE;					// 클록이 상승에지에서 CNT_EN의 STATE 값.
	
	reg						INTRRT_NEXT_STATE;
	reg						INTRRT_STATE;
	
	reg						NEXT_INTRRUPT;
	reg						INTRRUPT;
	
	reg						NEXT_CNT_CON;
	reg			[7:0]		NEXT_LOAD_ADDRESS;
	
	reg			[7:0]		CUR_STATE;
	
	wire			[7:0]		CUR_STATE_w;
		
	// master_state & counter_state assign!
	timer_reg_mx2	U0_counter_state0_mx2(1'b0, 1'b1, NEXT_counter_state[0], CUR_STATE_w[0]);
	timer_reg_mx2	U1_counter_state1_mx2(1'b0, 1'b1, NEXT_counter_state[1], CUR_STATE_w[1]);
	timer_reg_mx2	 U2_master_state0_mx2(1'b0, 1'b1, NEXT_master_state[0],  CUR_STATE_w[2]);
	timer_reg_mx2	 U3_master_state1_mx2(1'b0, 1'b1, NEXT_master_state[1],  CUR_STATE_w[3]);
	timer_reg_mx2	 U4_master_state2_mx2(1'b0, 1'b1, NEXT_master_state[2],  CUR_STATE_w[4]);
	
	assign	CUR_STATE_w[7:5]	= 3'b0;								// CUR_STATE의 상위 3비트는 무조건 0.
	assign	interrupt = INTRRUPT;
	

	
	// 1-1. Sequential Circuit - (S_dout)
	always @ (posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0)			S_dout <= 8'b0;
		else								S_dout <= NEXT_S_dout;
	end	

	//-------------------------------------------------------------------------
	
	// 1-2. Combinational Logic - (NEXT_S_dout)
	always @ (NEXT_INTRRUPT or NEXT_CNT_CON or NEXT_LOAD_ADDRESS or NEXT_LOAD_VALUE or NEXT_COUNT_VALUE or CUR_STATE_w or S_sel  or S_address or S_wr)
	begin
			// 주소 = 8'h21,  S_wr == 0일 때 현재 INTRRUPT 값 출력.
			if((S_sel == 1'b1) && (S_address == 8'b00100001) && (S_wr == 1'b0) && (NEXT_INTRRUPT == 1'b0))
					NEXT_S_dout <= 8'b00000000;
			else if((S_sel == 1'b1) && (S_address == 8'b00100001) && (S_wr == 1'b0) && (NEXT_INTRRUPT == 1'b1))
					NEXT_S_dout <= 8'b00000001;
					
			// 주소 = 8'h22,  S_wr == 0일 때 현재 CNT_CON 값 출력.		
			else if((S_sel == 1'b1) && (S_address == 8'b00100010) && (S_wr == 1'b0) && (NEXT_CNT_CON == 1'b0))
					NEXT_S_dout <= 8'b00000000;
			else if((S_sel == 1'b1) && (S_address == 8'b00100010) && (S_wr == 1'b0) && (NEXT_CNT_CON == 1'b1))
					NEXT_S_dout <= 8'b00000001;
	
			// 주소 = 8'h23,  S_wr == 0일 때 현재 LOAD_ADDRESS 값 출력.		
			else if((S_sel == 1'b1) && (S_address == 8'b00100011) && (S_wr == 1'b0))
					NEXT_S_dout <= NEXT_LOAD_ADDRESS;
					
			// 주소 = 8'h24,  S_wr == 0일 때 현재 LOAD_VALUE 값 출력.				
			else if((S_sel == 1'b1) && (S_address == 8'b00100100) && (S_wr == 1'b0))
					NEXT_S_dout <= NEXT_LOAD_VALUE;
					
			// 주소 = 8'h25,  S_wr == 0일 때 현재 COUNT_VALUE 값 출력.
			else if((S_sel == 1'b1) && (S_address == 8'b00100101) && (S_wr == 1'b0))
					NEXT_S_dout <= NEXT_COUNT_VALUE;
					
			// 주소 = 8'h26,  S_wr == 0일 때 현재 STATE 상태 출력.
			else if((S_address == 8'b00100110) && (S_sel==1'b1) && (S_wr == 1'b0))
					NEXT_S_dout <= CUR_STATE_w;
					
			else	NEXT_S_dout <= 8'b00000000;			
	end

	//-------------------------------------------------------------------------	
	
	// 2-1.  Sequential Logic - (CNT_EN_STATE)
	always @ (posedge clk or negedge reset_n)
	begin
	if(reset_n == 1'b0)
		begin
			CNT_EN_STATE <= CNT_EN_IDLE_STATE;
		end
		else
		begin
			CNT_EN_STATE <= CNT_EN_NEXT_STATE;
		end
	end
	
	//-------------------------------------------------------------------------	
	
	// 2-2.  Combinational Logic - (CNT_EN_NEXT_STATE)
	always @ (CNT_EN_STATE or reset_n or CUR_STATE or S_wr or S_sel or S_address or S_din)
	begin
	case(CNT_EN_STATE)
		CNT_EN_IDLE_STATE:
		begin
				if(reset_n == 0)			CNT_EN_NEXT_STATE <= CNT_EN_IDLE_STATE;
				else if((CUR_STATE == 8'b0) && (S_wr == 1'b1) && (S_sel == 1'b1) && (S_address == 8'b00100000) && (S_din == 8'b00000001))
												CNT_EN_NEXT_STATE <= CNT_EN_READ_REQ;
				else							CNT_EN_NEXT_STATE <= CNT_EN_IDLE_STATE;
		end
		
		CNT_EN_READ_REQ:
		begin
			CNT_EN_NEXT_STATE <= CNT_EN_IDLE_STATE;
		end
		
		default:
		begin
			CNT_EN_NEXT_STATE <= CNT_EN_IDLE_STATE;
		end
		
	endcase
	end
	
	//-------------------------------------------------------------------------	
	
	// 2-3.  Combinational Logic - Output Logic (read_req)
		always @ (CNT_EN_STATE)
	begin
		case(CNT_EN_STATE)
		CNT_EN_IDLE_STATE:	read_req <= 1'b0;	
		CNT_EN_READ_REQ:		read_req <= 1'b1;			
		default:					read_req <= 1'b0;		
		endcase
	end
	
	//-------------------------------------------------------------------------
	
	// 3-1.  Sequential Logic - (INTRRT_STATE & interrupt)
	always @ (posedge clk or negedge reset_n)
	begin
	if(reset_n == 1'b0)
		begin
			INTRRT_STATE <= INTRRT_IDLE_STATE;
			INTRRUPT	 	 <= 1'b0;
		end
		else
		begin
			INTRRT_STATE <= INTRRT_NEXT_STATE;
			INTRRUPT		 <= NEXT_INTRRUPT;
		end
	end
	
	//-------------------------------------------------------------------------
		
	// 3-2.  Combinational Logic - (INTRRT_NEXT_STATE)
	always @ (INTRRT_STATE or reset_n or interrupt or S_wr or S_sel or S_address or S_din)
	begin
	case(INTRRT_STATE)
		INTRRT_IDLE_STATE:
			begin
				if(reset_n == 1'b0)		INTRRT_NEXT_STATE <= INTRRT_IDLE_STATE;
				else if((interrupt == 1'b1) && (S_wr == 1'b1) && (S_sel == 1'b1) && (S_address == 8'b00100001) && (S_din == 8'b00000000))
												INTRRT_NEXT_STATE <= INTRRT_CLEAR_STATE;
				else							INTRRT_NEXT_STATE <= INTRRT_IDLE_STATE;			
			end
		INTRRT_CLEAR_STATE:				INTRRT_NEXT_STATE <= INTRRT_IDLE_STATE;
		
		default:								INTRRT_NEXT_STATE <= INTRRT_IDLE_STATE;	
	endcase
	end
	
	//-------------------------------------------------------------------------
			
	// 3-3.  Combinational Logic - (NEXT_INTRRUPT)
	always @ (INTRRT_STATE or NEXT_counter_state or NEXT_COUNT_VALUE)
	begin
		case(INTRRT_STATE)
		INTRRT_IDLE_STATE:
		begin
				if((NEXT_counter_state == 2'b10) && (NEXT_COUNT_VALUE == 8'b00000000))
										NEXT_INTRRUPT 		<= 1'b1;
				else
										NEXT_INTRRUPT 		<= 1'b0;	
		end
		INTRRT_CLEAR_STATE:		NEXT_INTRRUPT		<= 1'b0;
		
		default:						NEXT_INTRRUPT		<= 1'b0;
		endcase
	end
	
	//-------------------------------------------------------------------------
				
	// 3-4.  Combinational Logic - Output Logic (int_clear)
	always @ (INTRRT_STATE)
	begin
		case(INTRRT_STATE)
		INTRRT_IDLE_STATE:	int_clear <= 1'b0;
		INTRRT_CLEAR_STATE:	int_clear <= 1'b1;
		default: 				int_clear <= 1'bx;
		endcase
	end

	//-------------------------------------------------------------------------
				
	// 4-1.  Sequential Circuit - (CNT_CON)	
	always @ (posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0)	CNT_CON <= 1'b0;
		else 						CNT_CON <= NEXT_CNT_CON;
	end

	//-------------------------------------------------------------------------
				
	// 4-2.  Combinational Logic - (NEXT_CNT_CON)	
	always @ (S_sel or S_address or S_wr or S_din or CNT_CON)
	begin
			if((S_sel == 1'b1) && (S_address == 8'b00100010) && (S_wr == 1'b1) && (S_din == 8'b00000001))
					NEXT_CNT_CON <= 1'b1;
			else if((S_sel == 1'b1) && (S_address == 8'b00100010) && (S_wr == 1'b1) && (S_din == 8'b00000000))
					NEXT_CNT_CON <= 1'b0;
			else	NEXT_CNT_CON <= CNT_CON;
	end
	
	//-------------------------------------------------------------------------

	// 5-1.  Sequential Circuit - (LOAD_ADDRESS)	
	always @ (posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0)	LOAD_ADDRESS <= 8'b0;
		else 						LOAD_ADDRESS <= NEXT_LOAD_ADDRESS;
	end		

	//-------------------------------------------------------------------------
	
	// 5-2.  Combinational Logic - (NEXT_LOAD_ADDRESS)
	always @ (S_sel or S_address or S_wr or S_din or LOAD_ADDRESS)
	begin
			if((S_sel == 1'b1) && (S_address == 8'b00100011) && (S_wr == 1'b1))
					NEXT_LOAD_ADDRESS <= S_din;
			else
					NEXT_LOAD_ADDRESS <= LOAD_ADDRESS;
	end	
	
	//-------------------------------------------------------------------------
	
	
	// 6-1.  Sequential Circuit - (CUR_STATE)
	always @ (posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0)
			CUR_STATE <= 8'b0;
		else
			CUR_STATE <= CUR_STATE_w;
	end

endmodule
module	timer_reg_mx2(d0, d1, s, y);
	input		d0, d1, s;
	output	y;
	assign	y = (s == 0) ? d0 : d1;
endmodule
