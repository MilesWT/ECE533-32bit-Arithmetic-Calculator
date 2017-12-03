module sel_encoder (input logic [2:0] X,
					input logic [31:0] Y,
					output logic [32:0] PP,
					output logic [2:0] sel);
			
			logic [2:0] sel1;
			assign sel = sel1;
			encoder encode (
							.X(X),
							.sel(sel1)
							);
			
			selector select (
							.Y(Y),
							.sel(sel1),
							.PP(PP)
							);
endmodule

module encoder (input logic [2:0] X, 
				output logic [2:0] sel);
			
			// Booth Encoder
			logic single, double, neg, x_minus, x, x_plus;
			logic and1, and2;
			
			assign x_minus = X[0];
			assign x = X[1];
			assign x_plus = X[2];
			
			assign and1 = x_minus & x & (~x_plus);
			assign and2 = (~x_minus) & (~x) & x_plus;
			
			assign single = x_minus ^ x;
			
			assign double = and1 | and2;
			
			assign neg = x_plus;
			assign sel = {single, double, neg};
endmodule

module selector (input logic [31:0] Y,
				 input logic [2:0] sel,
				 output logic [32:0] PP);
				 
			// Booth Selector
			logic [31:0] single, double, neg, Yshift, and1, and2, or1;
			logic extend; // Sign extension
			
			assign single = {32{sel[2]}};
			assign double = {32{sel[1]}};
			assign neg = {32{sel[0]}};
			assign extend = neg[0] ^ Y[31];
			
			assign and1 = Y & single;
			assign Yshift = Y << 1;
			assign and2 = Yshift & double;
			
			assign or1 = and1 | and2;
			
			assign PP[31:0] = or1 ^ neg;
			/*assign PP[0] = neg;
			assign PP[1] = 1'b0;
			assign PP[33:2] = Y_intermediate;
			assign PP[63:34] = extend;*/
			assign PP[32] = extend;
			
endmodule


module booth_tb();

logic [31:0] Y;
logic [2:0] X, sel;
logic [32:0] PP;

sel_encoder DUT(
				.X(X),
				.Y(Y),
				.PP(PP),
				.sel(sel)
				);

initial begin
	Y = 32'h0000_0001;
	
	for (int i = 0; i < 8; i = i + 1) 
		begin
			X = i;
			#20;
		end
	
	$finish;
end

endmodule