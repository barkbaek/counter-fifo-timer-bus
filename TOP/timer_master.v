module	timer_master(clk, reset_n, read_req, LOAD_ADDRESS, M_grant, M_din, NEXT_master_state, NEXT_LOAD_VALUE, LOAD_VALUE, CNT_EN, M_req, M_address, M_wr, M_dout);
	input						clk, reset_n;
	input						read_req;
	input			[7:0]		LOAD_ADDRESS;
	input						M_grant;
	input			[7:0]		M_din;
	
	output reg	[2:0]		NEXT_master_state;
	output reg	[7:0]		NEXT_LOAD_VALUE;
	output reg	[7:0]		LOAD_VALUE;
	output reg				CNT_EN;
	output reg				M_req;
	output reg	[7:0]		M_address;
	output reg				M_wr;
	output reg	[7:0]		M_dout;
		

	reg			[2:0]		master_state;

	parameter	master_IDLE_STATE			=	3'b000;
	parameter	master_READ_REQ_STATE	=	3'b001;
	parameter	master_READ_GRA_STATE	=	3'b010;
	parameter	master_READ_DEL_STATE 	= 	3'b011;
	parameter	master_CNT_EN_STATE		=	3'b100;
	
	//-------------------------------------------------------------------------
	
	// Sequential Circuit - (master_state)
	always @ (posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0) 			master_state <= master_IDLE_STATE;
		else								master_state <= NEXT_master_state;
	end
	
	//-------------------------------------------------------------------------
	
	// Combinational Logic - (NEXT_master_state Logic)
	
	always @ (master_state or reset_n or read_req or M_grant)
	begin
	case(master_state)
	master_IDLE_STATE:
		begin
			if(reset_n==1'b0)									NEXT_master_state <= master_IDLE_STATE;
			else if(read_req == 1'b0)						NEXT_master_state <= master_IDLE_STATE;
			else if(read_req == 1'b1)						NEXT_master_state <= master_READ_REQ_STATE;
			else													NEXT_master_state <= master_IDLE_STATE;
			//CNT_EN==0만들어주기.
		end
	master_READ_REQ_STATE:
		begin
			if(reset_n==1'b0)									NEXT_master_state <= master_IDLE_STATE;
			else if(M_grant == 1'b0)						NEXT_master_state <= master_READ_REQ_STATE;
			else if(M_grant == 1'b1)						NEXT_master_state <= master_READ_GRA_STATE;
			else													NEXT_master_state <= master_READ_REQ_STATE;
			// 명심해야할 점은 grant는 버스에서 클록이 상승에지때 떨어지므로 클록에 안이어주고 그냥 받으면된다.
		end
	master_READ_GRA_STATE:
		begin
			if(reset_n==0)										NEXT_master_state <= master_IDLE_STATE;
			else													NEXT_master_state <= master_READ_DEL_STATE;
			// 이때 M_address, M_wr, M_dout은 클록 상승에지때  아웃.
		end
	master_READ_DEL_STATE:
		begin
			if(reset_n==0)										NEXT_master_state <= master_IDLE_STATE;
			else													NEXT_master_state <= master_CNT_EN_STATE;
			//M_req <= 1'b0;만들어주기 ※M_din은 그냥 이어주기
		end
	master_CNT_EN_STATE:
		begin
																	NEXT_master_state <= master_IDLE_STATE;
			// 무조건 IDLE STATE으로 돌아가는데 한싸이클 동안은 CNT_EN==1 유지해주기.
		end
	default:
		begin
																	NEXT_master_state <= master_IDLE_STATE;
		end
	endcase
	end
	
	//-------------------------------------------------------------------------
	
	// Sequential Circuit - (LOAD_VALUE)
	always @ (posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0)
				LOAD_VALUE	 <= 8'b0;
		else
				LOAD_VALUE	 <= NEXT_LOAD_VALUE;
	end
	
	//-------------------------------------------------------------------------
	
	// Combinational Logic - (NEXT_LOAD_VALUE Logic)
	always @ (master_state or LOAD_VALUE or M_din)
	begin
		case(master_state)
		master_IDLE_STATE:		NEXT_LOAD_VALUE	<= LOAD_VALUE;
		master_READ_REQ_STATE:	NEXT_LOAD_VALUE	<= LOAD_VALUE;
		master_READ_GRA_STATE:	NEXT_LOAD_VALUE	<= LOAD_VALUE;
		master_READ_DEL_STATE:	NEXT_LOAD_VALUE	<= M_din;
		master_CNT_EN_STATE:		NEXT_LOAD_VALUE	<= LOAD_VALUE;
		default:						NEXT_LOAD_VALUE	<=	8'bx;
		endcase
	end
	
	//-------------------------------------------------------------------------
	
	// Combinational Circuit - Output Logic
	always @ (master_state or LOAD_ADDRESS)
	begin
		case(master_state)
		master_IDLE_STATE:
		begin
				M_req 				<= 1'b0;
				M_wr					<= 1'b0;
				M_dout				<= 8'b0;
				CNT_EN 				<= 1'b0;
				M_address 			<= 8'b0;
		end
		master_READ_REQ_STATE:
		begin	
				M_req 				<= 1'b1;
				M_wr					<= 1'b0;
				M_dout				<= 8'b0;
				CNT_EN 				<= 1'b0;
				M_address	  		<= 8'b0;

		end
		master_READ_GRA_STATE:
		begin
				M_req 				<= 1'b1;
				M_wr					<= 1'b0;
				M_dout				<= 8'b0;		
				CNT_EN 				<= 1'b0;
				M_address			<= LOAD_ADDRESS;
		end
		master_READ_DEL_STATE:
		begin
				M_req 				<= 1'b0;
				M_wr					<= 1'b0;
				M_dout				<= 8'b0;		
				CNT_EN 				<= 1'b0;
				M_address 			<= 8'b0;				
		end
		master_CNT_EN_STATE:
		begin
				M_req 				<= 1'b0;
				M_wr					<= 1'b0;
				M_dout				<= 8'b0;		
				CNT_EN 				<= 1'b1;
				M_address 			<= 8'b0;				
		end
		default:
		begin
				M_req 				<= 1'bx;
				M_wr					<= 1'bx;
				M_dout				<= 8'bx;		
				CNT_EN 				<= 1'bx;
				M_address 			<= 8'bx;		
		end
		endcase
	end
	
endmodule
