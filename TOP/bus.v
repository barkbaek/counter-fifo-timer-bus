module	bus(clk, reset_n, M0_req, M0_address, M0_wr, M0_dout, M0_grant, M1_req, M1_address, M1_wr, M1_dout, M1_grant, M_din, S0_sel, S1_sel, S_address, S_wr, S_din, S0_dout, S1_dout);
	input					clk;
	input					reset_n;
	input					M0_req;
	input		[7:0]		M0_address;
	input					M0_wr;
	input		[7:0]		M0_dout;
	
	input					M1_req;
	input		[7:0]		M1_address;
	input					M1_wr;
	input		[7:0]		M1_dout;
	
	input		[7:0]		S0_dout;
	input		[7:0]		S1_dout;
	
	output				M0_grant;
	output				M1_grant;
	
	output	[7:0]		M_din;
	output				S0_sel;
	output				S1_sel;
	output	[7:0]		S_address;
	output				S_wr;
	output	[7:0]		S_din;
	
	reg					bus_mx_S1, bus_mx_S2;					// output M_din의 Mux의 S.
	reg					NEXT_bus_mx_S1, NEXT_bus_mx_S2;
	
	wire					M0_grant_w;
	wire		[7:0]		S_address_w;
	wire					S0_sel_w, S1_sel_w;
	wire		[7:0]		M_din_1_w, M_din_2_w;					// output M_din의 Mux
	
	//instance
	Arbitrator		 U0_Arbitrator(clk, reset_n, M0_req, M1_req, M0_grant_w, M1_grant);
	
	mx2_bus				U1_S_wr_mx2(M1_wr, 		M0_wr,	 	M0_grant_w, 	S_wr);
	mx2_addr			 U2_S_addr_mx2(M1_address,	M0_address,	M0_grant_w,		S_address_w);
	mx2_addr			  U3_S_din_mx2(M1_dout,		M0_dout,		M0_grant_w,		S_din);
	
	Address_decoder U4_addr_decoder(S_address_w, S0_sel_w, S1_sel_w);
	
	mx2_addr			 U5_M_din_mx2(8'b0,			S0_dout,		bus_mx_S1,		M_din_1_w);
	mx2_addr			 U6_M_din_mx2(S1_dout,		8'b0,			bus_mx_S1,		M_din_2_w);
	mx2_addr			 U7_M_din_mx2(M_din_1_w,	M_din_2_w,	bus_mx_S2,		M_din);
	
	//Sequential Circuit - output M_din을 출력하기 위한 Mux - S 정의.
	always @ (posedge clk or negedge reset_n)
	begin
		if(reset_n == 1'b0)
			begin
				bus_mx_S1	<= 1'b0;
				bus_mx_S2 	<= 1'b0;
			end
		else
			begin
				bus_mx_S1	<= NEXT_bus_mx_S1;
				bus_mx_S2 	<= NEXT_bus_mx_S2;
			end
	end
	//Combinatinal Circuit - output M_din을 출력하기 위한 Mux - S 정의.	
	always @ (S0_sel_w or S1_sel_w)
	begin
		if((S0_sel_w == 1'b1) && (S1_sel_w == 1'b0))
			begin
				NEXT_bus_mx_S1	<=	1'b1;
				NEXT_bus_mx_S2	<=	1'b0;
			end
		else if((S0_sel_w == 1'b0) && (S1_sel_w == 1'b1))
			begin
				NEXT_bus_mx_S1 <= 1'b0;
				NEXT_bus_mx_S2 <= 1'b1;
			end
		else if((S0_sel_w == 1'b0) && (S1_sel_w == 1'b0))
			begin
				NEXT_bus_mx_S1 <= 1'b0;
				NEXT_bus_mx_S2 <= 1'b0;
			end
		else
			begin
				NEXT_bus_mx_S1 <= 1'b1;
				NEXT_bus_mx_S2 <= 1'b1;			
			end
	end
	
	assign	M0_grant  = M0_grant_w;															// output M0_grant 정의.
	assign	S_address = S_address_w;														// output S_address 정의.
	assign	S0_sel	 = S0_sel_w;
	assign	S1_sel	 = S1_sel_w;
	
endmodule
module	mx2_addr(d0, d1, s, y);
	input		[7:0]		d0, d1;
	input					s;
	output	[7:0]		y;
	assign	y = (s == 0) ? d0 : d1;
endmodule
module	mx2_bus(d0, d1, s, y);
	input		d0, d1, s;
	output	y;
	assign	y = (s == 0) ? d0 : d1;
endmodule
