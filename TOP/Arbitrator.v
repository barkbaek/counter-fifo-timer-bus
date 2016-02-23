module	Arbitrator(clk, reset_n, M0_req, M1_req, M0_grant, M1_grant);
	input			clk, reset_n, M0_req, M1_req;
	output reg	M0_grant, M1_grant;
	
	//Encode states
	parameter	M0GRANT	= 1'b0;
	parameter	M1GRANT	= 1'b1;
	
	reg			Arbit_STATE;														
	reg			Arbit_NEXT_STATE;
	
	//-----------------------------------------------------------------------------
	
	// Sequential Circuit - (Arbit_STATE)
	always @ (posedge clk or negedge reset_n)
	begin
	if(reset_n == 1'b0)	Arbit_STATE <= M0GRANT;
	else 						Arbit_STATE <= Arbit_NEXT_STATE;
	end
	
	//-----------------------------------------------------------------------------
	
	// Combinational Logic - (Arbit_NEXT_STATE)
	always @ (reset_n or M0_req or M1_req or Arbit_STATE or M0GRANT or M1GRANT)
	begin
	case(Arbit_STATE)
	M0GRANT:
		begin
			if(reset_n == 1'b0)									 Arbit_NEXT_STATE <= M0GRANT;
			else if((M0_req == 1'b0) && (M1_req == 1'b0)) Arbit_NEXT_STATE <= M0GRANT;
			else if(M0_req == 1'b1)								 Arbit_NEXT_STATE <= M0GRANT;
			else if((M0_req == 1'b0) && (M1_req == 1'b1)) Arbit_NEXT_STATE <= M1GRANT;
			else														 Arbit_NEXT_STATE <= M0GRANT;
		end
	M1GRANT:
		begin
			if(reset_n == 1'b0) 									 Arbit_NEXT_STATE <= M0GRANT;
			else if(M1_req == 1'b1) 							 Arbit_NEXT_STATE <= M1GRANT;
			else if(M1_req == 1'b0) 							 Arbit_NEXT_STATE <= M0GRANT;
			else														 Arbit_NEXT_STATE <= M0GRANT;
		end
	default:															 Arbit_NEXT_STATE <= M0GRANT;
	endcase
	end
	
	//-----------------------------------------------------------------------------
	
	// Combinational Circuit - Output Logic
	always @ (Arbit_STATE)
	begin
	case(Arbit_STATE)
		M0GRANT : 
		begin
			M0_grant = 1'b1;
			M1_grant = 1'b0;
		end
		M1GRANT : 
		begin
			M0_grant = 1'b0;
			M1_grant = 1'b1;
		end
	endcase
	end
	
endmodule
