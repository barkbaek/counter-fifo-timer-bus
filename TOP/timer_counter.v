module	timer_counter(clk, reset_n, CNT_EN, LOAD_VALUE, int_clear, CNT_CON, NEXT_COUNT_VALUE, NEXT_counter_state);
	input					clk, reset_n;
	input					CNT_EN;
	input			[7:0]	LOAD_VALUE;
	input					int_clear;
	input					CNT_CON;
	output reg	[7:0]	NEXT_COUNT_VALUE;				// reg에서 S_dout출력 위해 NEXT_를 보내준다.
	output reg	[1:0]	NEXT_counter_state;			// reg에서 S_dout출력 위해 NEXT_를 보내준다.
	
	reg			[1:0]	counter_state;
	reg			[7:0]	COUNT_VALUE;
	
	parameter		counter_IDLE_STATE  		=	2'b00;
	parameter		counter_COUNT_STATE 		=	2'b01;
	parameter		counter_INTRRUPT_STATE	=	2'b10;
	
	//-------------------------------------------------------------------------
	
	// Sequential Circuit - (counter_state)
	always @ (posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0) 			counter_state <= counter_IDLE_STATE;
		else								counter_state <= NEXT_counter_state;
	end
	
	//-------------------------------------------------------------------------
	
	// Combinational Logic - (NEXT_counter_state)
	always @ (counter_state or reset_n or LOAD_VALUE or CNT_EN or COUNT_VALUE or int_clear or CNT_CON)
	begin
	case(counter_state)
	
	counter_IDLE_STATE:
		begin
		if(reset_n==1'b0)												NEXT_counter_state <= counter_IDLE_STATE;
		else if(CNT_EN == 1'b0)										NEXT_counter_state <= counter_IDLE_STATE;
		else if(LOAD_VALUE == 8'b0)								NEXT_counter_state <= counter_IDLE_STATE;
		else if((CNT_EN == 1'b1) && (LOAD_VALUE != 8'b0))	NEXT_counter_state <= counter_COUNT_STATE;
		else																NEXT_counter_state <= counter_IDLE_STATE;
		end

	counter_COUNT_STATE:
		begin
		if(reset_n==1'b0)												NEXT_counter_state <= counter_IDLE_STATE;
		else if(COUNT_VALUE == 8'b0)								NEXT_counter_state <= counter_INTRRUPT_STATE;
		else																NEXT_counter_state <= counter_COUNT_STATE;
		end

	counter_INTRRUPT_STATE:
		begin
		if(reset_n == 1'b0)											NEXT_counter_state <= counter_IDLE_STATE;
		else if((int_clear == 1'b1) && (CNT_CON == 1'b0))	NEXT_counter_state <= counter_IDLE_STATE;
		else if((int_clear == 1'b1) && (CNT_CON == 1'b1))	NEXT_counter_state <= counter_COUNT_STATE;
		else																NEXT_counter_state <= counter_INTRRUPT_STATE;
		end
		
	default:
		begin
				NEXT_counter_state 	<= counter_IDLE_STATE;
		end
		
	endcase
	end	
		
	//-------------------------------------------------------------------------
	
	// Sequential Circuit - (COUNT_VALUE)
	always @ (posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0)			COUNT_VALUE <= 8'b0;
		else								COUNT_VALUE <= NEXT_COUNT_VALUE;
	end
	
	//-------------------------------------------------------------------------
	
	// Combinational Logic - (NEXT_COUNT_VALUE)
	always @ (counter_state or CNT_EN or LOAD_VALUE or COUNT_VALUE or int_clear or CNT_CON)
	begin
		case(counter_state)
		
		counter_IDLE_STATE:
		begin
			if((CNT_EN == 1'b1) && (LOAD_VALUE != 8'b0))
				NEXT_COUNT_VALUE <= LOAD_VALUE;
			else
				NEXT_COUNT_VALUE <= 8'b0;
		end
		
		counter_COUNT_STATE:
		begin
				if(COUNT_VALUE == 8'b00000001)
					NEXT_COUNT_VALUE <= 8'b0;
				else if(COUNT_VALUE != 8'b00000000)
					NEXT_COUNT_VALUE <= COUNT_VALUE - 8'b00000001;
				else
					NEXT_COUNT_VALUE <= 8'b0;
		end
		
		counter_INTRRUPT_STATE:
		begin
				if((int_clear == 1'b1) && (CNT_CON == 1'b1))
					NEXT_COUNT_VALUE <= LOAD_VALUE;
				else
					NEXT_COUNT_VALUE <= 8'b0;
		end
		
		default:
		begin
				NEXT_COUNT_VALUE	  <= 8'b0;
		end
		
		endcase
	end
	

endmodule
