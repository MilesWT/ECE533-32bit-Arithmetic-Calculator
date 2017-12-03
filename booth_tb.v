//From figure 11.80 on p. 482
module sel_encoder (input logic [2:0] X,
					input logic [31:0] Y,
					output logic [63:0] PP
					);
			
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
				 output logic [63:0] PP);
				 
			// Booth Selector
			logic [31:0] single, double, neg, Yshift, and1, and2, or1, two;
			logic [63:0] extend_full;
			logic extend; // Sign extension
			
			assign single = {32{sel[2]}};
			assign double = {32{sel[1]}};
			assign neg = {32{sel[0]}};
			
			assign extend = neg[0] ^ Y[31];
			assign extend_full = {32{extend}};
			
			assign and1 = Y & single;
			assign Yshift = Y << 1;
			assign and2 = Yshift & double;
			
			assign or1 = and1 | and2;
			assign two = (or1 ^ neg) + neg[0];
			
			// Inefficient to do this, but trees are hard yo
			assign PP[63:0] = {extend_full, two};
			
			
endmodule


module booth_tb();

logic [31:0] Y;
logic [2:0] X;
logic [63:0] PP;

sel_encoder DUT(
				.X(X),
				.Y(Y),
				.PP(PP)
				);

initial begin
	//Y = 32'h0000_0001;
	Y = 32'b0000_0000_0000_0000_0000_0000_0001_1001;
	//X = 32'b0000_0000_0000_0000_0000_0000_0010_0111;
	for (int i = 0; i < 8; i = i + 1) 
		begin
			X = i;
			#20;
		end
	
	$finish;
end

endmodule