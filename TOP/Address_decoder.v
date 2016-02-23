module	Address_decoder(sel_address, S0_sel, S1_sel);  // bus - Address_decoder.
	input			[7:0]	sel_address;
	output reg			S0_sel, S1_sel;

	always @ (sel_address)										  // bus - S0_sel°ú S1_sel ¼±ÅÃ.
	begin
		if((sel_address[4] == 1) && (sel_address[5] == 0) && (sel_address[6] == 0) && (sel_address[7] == 0))
			begin
				S0_sel <= 1'b1;
				S1_sel <= 1'b0;
			end
		else if((sel_address[4] == 0) && (sel_address[5] == 1) && (sel_address[6] == 0) && (sel_address[7] == 0))
			begin
				S0_sel <= 1'b0;
				S1_sel <= 1'b1;
			end
		else
			begin
				S0_sel <= 1'b0;
				S1_sel <= 1'b0;			
			end
	end
endmodule

