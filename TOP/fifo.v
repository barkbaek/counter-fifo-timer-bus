module fifo(clk, reset_n, wr_en, rd_en, din, dout, data_count, full, empty, wr_ack, wr_err, rd_ack, rd_err);
	input 				clk, reset_n, wr_en, rd_en;
	input			[7:0]	din;
	output reg	[7:0]	dout;
	output reg	[3:0]	data_count;
	output reg			full, empty, wr_ack, wr_err, rd_ack, rd_err;
	
	reg			[3:0] fifo_STATE;										// fifo_STATE
	reg			[3:0]	NEXT_fifo_STATE;								// NEXT_fifo_STATE
	

	reg 			[2:0]	head; // Pointer for nextf read
	reg 			[2:0]	tail; // Pointer for next write
	
	reg			[2:0]	NEXT_head;
	reg			[2:0]	NEXT_tail;
	reg			[3:0]	NEXT_data_count;
	reg			[7:0]	NEXT_dout;

	parameter	fifo_INIT_STATE				= 4'b0000;
	parameter	fifo_INIT_READ_ERR_STATE 	= 4'b0001;
	parameter	fifo_WRITE_STATE 				= 4'b0010;
	parameter	fifo_FULL_STATE 				= 4'b0011;
	parameter	fifo_WRITE_ERR_STATE  		= 4'b0100;
	
	parameter	fifo_READ_STATE				= 4'b0101;
	parameter	fifo_EMPTY_STATE				= 4'b0110;
	parameter	fifo_READ_ERR_STATE			= 4'b0111;
	parameter	fifo_NOP_STATE					= 4'b1000;
	
	wire			[7:0]	reg_r_out;		// 리드모드시 레지스터파일 통해 값 나옴.
	wire					we_w;
	
	// instance 레지스터파일.
	register_file	U0_register_file(.clk(clk), .wAddr(NEXT_tail), .wData(din), .we(wr_en), .no_full(we_w), .rAddr(NEXT_head), .rData(reg_r_out));
	fifo_mx2				  U0_rf_mx_we(1'b1, 1'b0, full, we_w);

	//---------------------------------------------------------------------------------	

	// Sequential Circuit - data_count , tail, head	
	always @ (posedge clk or negedge reset_n)
	begin
	if(reset_n==1'b0)												// reset_n 작동시
		begin
			data_count	<= 4'b0000;
			tail 			<= 3'b000;
			head 			<= 3'b000;
		end
	else 
		begin
			data_count	<= NEXT_data_count;
			tail 			<= NEXT_tail;
			head 			<= NEXT_head;
		end
	end
	
	//---------------------------------------------------------------------------------
	
	// Combinational Logic - (data_count, tail, head)
		always @ (fifo_STATE or wr_en or rd_en or full or empty or tail or head or data_count)
	begin
				if((wr_en==1'b1) && (rd_en==1'b0))
					begin
						if(full == 1'b1)
							begin
								NEXT_data_count 	<= data_count;
								NEXT_head 		 	<= head;
								NEXT_tail		 	<= tail;
							end						
						else
							begin
								NEXT_data_count 	<= data_count + 4'b0001;
								NEXT_head 			<= head;
								if(tail == 3'b111)
									NEXT_tail 		<= 3'b000;
								else
									NEXT_tail 		<= tail + 3'b001;
							end
					end
				else if((wr_en==1'b0) && (rd_en==1'b1))
					begin
						if(empty == 1'b1)
							begin
								NEXT_data_count 	<= data_count;
								NEXT_tail 		 	<= tail;
								NEXT_head 		 	<= head;
							end
						else
							begin
								NEXT_data_count 	<= data_count - 4'b0001;
								NEXT_tail 		 	<= tail;
								if(head == 3'b111)
									NEXT_head 		<= 3'b000;
								else
									NEXT_head 	 	<= head + 3'b001;
							end
					end
				else if((wr_en==1'b0) && (rd_en==1'b0))
					begin
								NEXT_data_count	<= data_count;
								NEXT_tail			<= tail;
								NEXT_head			<= head;					
					end
				else
					begin
								NEXT_data_count	<= data_count;
								NEXT_tail			<= tail;
								NEXT_head			<= head;						
					end
	end
	
	
	//---------------------------------------------------------------------------------	
	
	// Sequential Circuit - fifo_STATE
	always @ (posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0) 		fifo_STATE <= fifo_INIT_STATE;
		else							fifo_STATE <= NEXT_fifo_STATE;
	end

	//---------------------------------------------------------------------------------
	
	// Combinational Logic - (NEXT_fifo_STATE)
	always @ (fifo_STATE or reset_n or rd_en or wr_en or full or empty or data_count )
	begin
	case(fifo_STATE)
	
	fifo_INIT_STATE:
		begin
			if(~reset_n) 													NEXT_fifo_STATE <= fifo_INIT_STATE;
			else
				begin
					if((wr_en==1'b0) && (rd_en==1'b1))				NEXT_fifo_STATE <= fifo_INIT_READ_ERR_STATE;
					else if((wr_en==1'b1) && (rd_en==1'b0))		NEXT_fifo_STATE <= fifo_WRITE_STATE;
					else if((wr_en==1'b0) && (rd_en==1'b0))		NEXT_fifo_STATE <= fifo_NOP_STATE;
					else														NEXT_fifo_STATE <= fifo_NOP_STATE;
				end
		end
		
	fifo_INIT_READ_ERR_STATE:
		begin
			if(~reset_n) 													NEXT_fifo_STATE <= fifo_INIT_STATE;
			else
				begin
					if((wr_en==1'b0) && (rd_en==1'b1))				NEXT_fifo_STATE <= fifo_INIT_READ_ERR_STATE;
					else if((wr_en==1'b1) && (rd_en==1'b0))		NEXT_fifo_STATE <= fifo_WRITE_STATE;
					else if((wr_en==1'b0) && (rd_en==1'b0))		NEXT_fifo_STATE <= fifo_NOP_STATE;
					else														NEXT_fifo_STATE <= fifo_NOP_STATE;
				end
		end
		
	fifo_WRITE_STATE:
		begin
			if(~reset_n) 													NEXT_fifo_STATE <= fifo_INIT_STATE;
			else
				begin
					if((wr_en==1'b1) && (rd_en==1'b0)) 
					begin
						if(data_count == 4'b0111)						NEXT_fifo_STATE <= fifo_FULL_STATE;
						else													NEXT_fifo_STATE <= fifo_WRITE_STATE;
					end
					else if((wr_en==1'b0) && (rd_en==1'b1))		NEXT_fifo_STATE <= fifo_READ_STATE;
					else if((wr_en==1'b0) && (rd_en==1'b0))		NEXT_fifo_STATE <= fifo_NOP_STATE;
					else														NEXT_fifo_STATE <= fifo_NOP_STATE;
				end
		end
		
	fifo_FULL_STATE:
		begin
			if(~reset_n) 													NEXT_fifo_STATE <= fifo_INIT_STATE;
			else
				begin
					if((wr_en==1'b1) && (rd_en==1'b0))				NEXT_fifo_STATE <= fifo_WRITE_ERR_STATE;
					else if((wr_en==1'b0) && (rd_en==1'b1))	 	NEXT_fifo_STATE <= fifo_READ_STATE;
					else if((wr_en==1'b0) && (rd_en==1'b0))		NEXT_fifo_STATE <= fifo_NOP_STATE;
					else														NEXT_fifo_STATE <= fifo_NOP_STATE;
				end
		end
		
	fifo_WRITE_ERR_STATE:
		begin
			if(~reset_n)		 											NEXT_fifo_STATE <= fifo_INIT_STATE;
			else
				begin
					if((wr_en==1'b1) && (rd_en==1'b0))				NEXT_fifo_STATE <= fifo_WRITE_ERR_STATE;
					else if((wr_en==1'b0) && (rd_en==1'b1))	 	NEXT_fifo_STATE <= fifo_READ_STATE;
					else if((wr_en==1'b0) && (rd_en==1'b0))		NEXT_fifo_STATE <= fifo_NOP_STATE;
					else														NEXT_fifo_STATE <= fifo_NOP_STATE;
				end
		end
		
	fifo_READ_STATE:
		begin
			if(~reset_n) 													NEXT_fifo_STATE <= fifo_INIT_STATE;
			else
				begin
					if((wr_en==1'b1) && (rd_en==1'b0))				NEXT_fifo_STATE <= fifo_WRITE_STATE;
					else if((wr_en==1'b0) && (rd_en==1'b1))
					begin
						if(data_count == 4'b0001)						NEXT_fifo_STATE <= fifo_EMPTY_STATE;
						else													NEXT_fifo_STATE <= fifo_READ_STATE;
					end
					else if((wr_en==1'b0) && (rd_en==1'b0))		NEXT_fifo_STATE <= fifo_NOP_STATE;
					else														NEXT_fifo_STATE <= fifo_NOP_STATE;
				end

		end
		
	fifo_EMPTY_STATE:
		begin
			if(~reset_n) 													NEXT_fifo_STATE <= fifo_INIT_STATE;
			else
				begin
					if((wr_en==1'b1) && (rd_en==1'b0))				NEXT_fifo_STATE <= fifo_WRITE_STATE;
					else if((wr_en==1'b0) && (rd_en==1'b1))		NEXT_fifo_STATE <= fifo_READ_ERR_STATE;
					else if((wr_en==1'b0) && (rd_en==1'b0))		NEXT_fifo_STATE <= fifo_NOP_STATE;
					else														NEXT_fifo_STATE <= fifo_NOP_STATE;
				end
		end
		
	fifo_READ_ERR_STATE:
		begin
			if(~reset_n) 													NEXT_fifo_STATE <= fifo_INIT_STATE;
			else
			begin
					if((wr_en==1'b1) && (rd_en==1'b0))				NEXT_fifo_STATE <= fifo_WRITE_STATE;
					else if((wr_en==1'b0) && (rd_en==1'b1))		NEXT_fifo_STATE <= fifo_READ_ERR_STATE;
					else if((wr_en==1'b0) && (rd_en==1'b0))		NEXT_fifo_STATE <= fifo_NOP_STATE;
					else														NEXT_fifo_STATE <= fifo_NOP_STATE;
			end
		end
		
	fifo_NOP_STATE:
		begin
			if(~reset_n) 													NEXT_fifo_STATE <= fifo_INIT_STATE;
			else
				begin
					if((wr_en==1'b1) && (rd_en==1'b0))
					begin
						if(data_count==4'b0111)							NEXT_fifo_STATE <= fifo_FULL_STATE;		
						else if(full == 1'b1)							NEXT_fifo_STATE <= fifo_WRITE_ERR_STATE;
						else													NEXT_fifo_STATE <= fifo_WRITE_STATE;
					end
					else if((wr_en==1'b0) && (rd_en==1'b1))
					begin
						if(data_count==4'b0001)							NEXT_fifo_STATE <= fifo_EMPTY_STATE;
						else if(empty == 1'b1)							NEXT_fifo_STATE <= fifo_READ_ERR_STATE;
						else													NEXT_fifo_STATE <= fifo_READ_STATE;
					end
					else if((wr_en==1'b0) && (rd_en==1'b0))		NEXT_fifo_STATE <= fifo_NOP_STATE;
					else														NEXT_fifo_STATE <= fifo_NOP_STATE;					
				end
		end
		
	default:																	NEXT_fifo_STATE <= fifo_INIT_STATE;
	
	endcase
	end
	
	//---------------------------------------------------------------------------------	
	
	// Sequential Circuit - (dout)
	always @ (posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0)
			dout <= 8'b0;
		else
			dout <= NEXT_dout;
	end

	//---------------------------------------------------------------------------------	
	
	// Combinational Logic - (NEXT_dout)
	always @ (wr_en or rd_en or reg_r_out or empty)
	begin
		if((wr_en == 1'b0) && (rd_en == 1'b1))
			begin
				if(empty == 1'b1)
					NEXT_dout	<= 8'b0;
				else
					NEXT_dout	<= reg_r_out;
			end
		else if((wr_en==1'b0) && (rd_en==1'b0))
					NEXT_dout	<= 8'b0;
		else
					NEXT_dout	<= 8'b0;
	end
	
	//---------------------------------------------------------------------------------	
	
	// Combinational Logic - Output Logic
	always @ (fifo_STATE or data_count)
	begin
		case(fifo_STATE)
		
		fifo_INIT_STATE : 
		begin
			full			<= 1'b0;
			empty			<= 1'b1;
			wr_ack		<= 1'b0;
			wr_err		<= 1'b0;
			rd_ack		<= 1'b0;
			rd_err		<= 1'b0;
		end
		
		fifo_INIT_READ_ERR_STATE:
		begin
			full			<= 1'b0;
			empty			<= 1'b1;
			wr_ack		<= 1'b0;
			wr_err		<= 1'b0;
			rd_ack		<= 1'b0;
			rd_err		<= 1'b1;
		end
		
		fifo_WRITE_STATE:
		begin
			empty			<= 1'b0;
			wr_ack		<= 1'b1;
			wr_err		<= 1'b0;
			rd_ack		<= 1'b0;
			rd_err		<= 1'b0;
			if(data_count == 4'b1000)
				full		<= 1'b1;
			else
				full		<= 1'b0;
		end
		
		fifo_FULL_STATE:
		begin
			full			<= 1'b1;
			empty			<= 1'b0;
			wr_ack		<= 1'b1;	
			wr_err		<= 1'b0;
			rd_ack		<= 1'b0;
			rd_err		<= 1'b0;
		end
		
		fifo_WRITE_ERR_STATE:
		begin
			full			<= 1'b1;
			empty			<= 1'b0;		
			wr_ack		<= 1'b0;
			wr_err		<= 1'b1;
			rd_ack		<= 1'b0;
			rd_err		<= 1'b0;
		end
		
		fifo_READ_STATE:
		begin
			full			<= 1'b0;
			wr_ack		<= 1'b0;
			wr_err		<= 1'b0;
			rd_ack		<= 1'b1;
			rd_err		<= 1'b0;
			if(data_count == 4'b0000)
				empty		<= 1'b1;
			else
				empty		<= 1'b0;
		end
		
		fifo_EMPTY_STATE:
		begin
			full			<= 1'b0;
			empty			<= 1'b1;
			wr_ack		<= 1'b0;
			wr_err		<= 1'b0;
			rd_ack		<= 1'b1;
			rd_err		<= 1'b0;
		end
		
		fifo_READ_ERR_STATE:
		begin			
			full			<= 1'b0;
			empty			<= 1'b1;
			wr_ack		<= 1'b0;
			wr_err		<= 1'b0;
			rd_ack		<= 1'b0;
			rd_err		<= 1'b1;
		end
	
		fifo_NOP_STATE:
		begin
			wr_ack		<= 1'b0;
			wr_err		<= 1'b0;
			rd_ack		<= 1'b0;
			rd_err		<= 1'b0;
			if(data_count == 4'b1000)
				begin
				full		<= 1'b1;
				empty		<= 1'b0;
				end
			else if(data_count == 4'b0000)
				begin
				full		<= 1'b0;
				empty		<= 1'b1;
				end
			else
				begin
				full		<= 1'b0;
				empty		<= 1'b0;						
				end
		end
		default:
		begin
			full			<= 1'bx;
			empty			<= 1'bx;
			wr_ack		<= 1'bx;
			wr_err		<= 1'bx;
			rd_ack		<= 1'bx;
			rd_err		<= 1'bx;
		end
		endcase
	end
	
endmodule
	
module	register_file(clk, wAddr, wData, we, no_full, rAddr, rData);
	input					clk;
	input			[2:0]	wAddr;			// = tail 주소
	input			[7:0]	wData;			// = din[7:0]
	input					we;
	input					no_full;
	input			[2:0]	rAddr;
	output reg	[7:0]	rData;
	
	reg			[7:0]	wDecoder;
	
	reg			[7:0]	reg0;
	reg			[7:0]	reg1;
	reg			[7:0]	reg2;
	reg			[7:0]	reg3;
	reg			[7:0]	reg4;
	reg			[7:0]	reg5;
	reg			[7:0]	reg6;
	reg			[7:0]	reg7;
	
	reg			[7:0]	NEXT_reg0;
	reg			[7:0]	NEXT_reg1;
	reg			[7:0]	NEXT_reg2;
	reg			[7:0]	NEXT_reg3;
	reg			[7:0]	NEXT_reg4;
	reg			[7:0]	NEXT_reg5;
	reg			[7:0]	NEXT_reg6;
	reg			[7:0]	NEXT_reg7;

	wire					we_w;

	always @ (wAddr)
	begin
	case(wAddr)						
	3'b000: wDecoder = 8'b00000001;	//	reg7
	3'b001: wDecoder = 8'b00000010;	//	reg0
	3'b010: wDecoder = 8'b00000100;	//	reg1
	3'b011: wDecoder = 8'b00001000;	//	reg2
	3'b100: wDecoder = 8'b00010000;	//	reg3
	3'b101: wDecoder = 8'b00100000;	//	reg4
	3'b110: wDecoder = 8'b01000000;	//	reg5
	3'b111: wDecoder = 8'b10000000;	//	reg6
	endcase							
	end
	
	//---------------------------------------------------------------------------------
	
	// Sequential Circuit - (reg)
	always @ (posedge clk)
	begin
		reg0 	<=		NEXT_reg0;
		reg1 	<=		NEXT_reg1;
		reg2 	<=		NEXT_reg2;
		reg3 	<=		NEXT_reg3;
		reg4 	<=		NEXT_reg4;
		reg5 	<=		NEXT_reg5;
		reg6 	<=		NEXT_reg6;
		reg7 	<=		NEXT_reg7;
	end
	
	//---------------------------------------------------------------------------------
	
	fifo_and1		U0_rf_we(we, no_full, we_w);
	// Combinational Logic - (NEXT_reg)
	always @ (wDecoder or we_w or wData or reg0 or reg1 or reg2 or reg3 or reg4 or reg5 or reg6 or reg7)
	begin
		if(we_w == 1'b1)
			begin
				if(wDecoder == 8'b00000001)
					begin
						NEXT_reg0 <= reg0;
						NEXT_reg1 <= reg1;
						NEXT_reg2 <= reg2;
						NEXT_reg3 <= reg3;
						NEXT_reg4 <= reg4;
						NEXT_reg5 <= reg5;
						NEXT_reg6 <= reg6;
						NEXT_reg7 <= wData;
					end
				else if(wDecoder == 8'b00000010)
					begin
						NEXT_reg0 <= wData;				
						NEXT_reg1 <= reg1;
						NEXT_reg2 <= reg2;
						NEXT_reg3 <= reg3;
						NEXT_reg4 <= reg4;
						NEXT_reg5 <= reg5;
						NEXT_reg6 <= reg6;
						NEXT_reg7 <= reg7;
					end
				else if(wDecoder == 8'b00000100)
					begin
						NEXT_reg0 <= reg0;
						NEXT_reg1 <= wData;				
						NEXT_reg2 <= reg2;
						NEXT_reg3 <= reg3;
						NEXT_reg4 <= reg4;
						NEXT_reg5 <= reg5;
						NEXT_reg6 <= reg6;
						NEXT_reg7 <= reg7;						
					end
				else if(wDecoder == 8'b00001000)
					begin
						NEXT_reg0 <= reg0;
						NEXT_reg1 <= reg1;
						NEXT_reg2 <= wData;
						NEXT_reg3 <= reg3;
						NEXT_reg4 <= reg4;
						NEXT_reg5 <= reg5;
						NEXT_reg6 <= reg6;
						NEXT_reg7 <= reg7;						
					end
				else if(wDecoder == 8'b00010000)
					begin
						NEXT_reg0 <= reg0;
						NEXT_reg1 <= reg1;
						NEXT_reg2 <= reg2;
						NEXT_reg3 <= wData;
						NEXT_reg4 <= reg4;
						NEXT_reg5 <= reg5;
						NEXT_reg6 <= reg6;
						NEXT_reg7 <= reg7;					
					end
				else if(wDecoder == 8'b00100000)
					begin
						NEXT_reg0 <= reg0;
						NEXT_reg1 <= reg1;
						NEXT_reg2 <= reg2;
						NEXT_reg3 <= reg3;
						NEXT_reg4 <= wData;						
						NEXT_reg5 <= reg5;
						NEXT_reg6 <= reg6;
						NEXT_reg7 <= reg7;						
					end
				else if(wDecoder == 8'b01000000)
					begin
						NEXT_reg0 <= reg0;
						NEXT_reg1 <= reg1;
						NEXT_reg2 <= reg2;
						NEXT_reg3 <= reg3;
						NEXT_reg4 <= reg4;
						NEXT_reg5 <= wData;						
						NEXT_reg6 <= reg6;
						NEXT_reg7 <= reg7;						
					end
				else if(wDecoder == 8'b10000000)
					begin
						NEXT_reg0 <= reg0;
						NEXT_reg1 <= reg1;
						NEXT_reg2 <= reg2;
						NEXT_reg3 <= reg3;
						NEXT_reg4 <= reg4;
						NEXT_reg5 <= reg5;
						NEXT_reg6 <= wData;						
						NEXT_reg7 <= reg7;		
					end
				else
					begin
						NEXT_reg0 <= reg0;
						NEXT_reg1 <= reg1;
						NEXT_reg2 <= reg2;
						NEXT_reg3 <= reg3;
						NEXT_reg4 <= reg4;
						NEXT_reg5 <= reg5;
						NEXT_reg6 <= reg6;
						NEXT_reg7 <= reg7;
					end
			end
		else
			begin
						NEXT_reg0 <= reg0;
						NEXT_reg1 <= reg1;
						NEXT_reg2 <= reg2;
						NEXT_reg3 <= reg3;
						NEXT_reg4 <= reg4;
						NEXT_reg5 <= reg5;
						NEXT_reg6 <= reg6;
						NEXT_reg7 <= reg7;			
			end
	end

	//---------------------------------------------------------------------------------
	
	// Combinational Logic - (rData정의.)	
	always @ (rAddr or reg0 or reg1 or reg2 or reg3 or reg4 or reg5 or reg6 or reg7)
	begin
		if(rAddr == 3'b001)
			rData	<= reg0;
		else if(rAddr == 3'b010)
			rData <= reg1;
		else if(rAddr == 3'b011)
			rData <= reg2;
		else if(rAddr == 3'b100)
			rData <= reg3;
		else if(rAddr == 3'b101)
			rData	<= reg4;
		else if(rAddr == 3'b110)
			rData <= reg5;
		else if(rAddr == 3'b111)
			rData <= reg6;
		else if(rAddr == 3'b000)
			rData <= reg7;
		else
			rData <= 8'b0;
	end
	
endmodule
module	fifo_mx2(d0, d1, s, y);
	input		d0, d1, s;
	output	y;
	assign	y = (s == 0) ? d0 : d1;
endmodule
module	fifo_and1(a, b, y);
	input		a, b;
	output	y;
	assign	y = a & b;
endmodule
