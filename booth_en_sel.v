// Top level module
module multiplier (input logic clk, // arbitrary clk  for synthesis
				   input logic [31:0] Y, X,
				   output logic [63:0] product);

	logic [33:0] X_e;
	logic [33:0] PP0, PP1, PP2, PP3, PP4, PP5, PP6, PP7, PP8, PP9;
	logic [33:0] PP10, PP11, PP12, PP13, PP14, PP15;
	
	assign X_e = {2'b00, X}; // X extended with 2 0's to generate PPs
	
	sel_encoder gen0 (
		.x_minus ( 1'b0   ), // input
		.x		 ( X_e[0] ), // input
		.x_plus  ( X_e[1] ), // input
		.Y       ( Y      ), // input [31:0]
		.PP		 ( PP0 ) // output
		);
	sel_encoder gen1 (
		.x_minus ( X_e[1] ), // input
		.x		 ( X_e[2] ), // input
		.x_plus  ( X_e[3] ), // input
		.Y       ( Y      ), // input [31:0]
		.PP		 ( PP1 ) // output
		);
		
	sel_encoder gen2 (
		.x_minus ( X_e[3] ), // input
		.x		 ( X_e[4] ), // input
		.x_plus  ( X_e[5] ), // input
		.Y       ( Y      ), // input [31:0]
		.PP		 ( PP2 ) // output
		);

	sel_encoder gen3 (
		.x_minus ( X_e[5] ), // input
		.x		 ( X_e[6] ), // input
		.x_plus  ( X_e[7] ), // input
		.Y       ( Y      ), // input [31:0]
		.PP		 ( PP3 ) // output
		);

	sel_encoder gen4 (
		.x_minus ( X_e[7] ), // input
		.x		 ( X_e[8] ), // input
		.x_plus  ( X_e[9] ), // input
		.Y       ( Y      ), // input [31:0]
		.PP		 ( PP4 ) // output
		);
		
	sel_encoder gen5 (
		.x_minus ( X_e[9]  ), // input
		.x		 ( X_e[10] ), // input
		.x_plus  ( X_e[11] ), // input
		.Y       ( Y       ), // input [31:0]
		.PP		 ( PP5 ) // output
		);
		
	sel_encoder gen6 (
		.x_minus ( X_e[11] ), // input
		.x		 ( X_e[12] ), // input
		.x_plus  ( X_e[13] ), // input
		.Y       ( Y       ), // input [31:0]
		.PP		 ( PP6 ) // output
		);
		
	sel_encoder gen7 (
		.x_minus ( X_e[13] ), // input
		.x		 ( X_e[14] ), // input
		.x_plus  ( X_e[15] ), // input
		.Y       ( Y       ), // input [31:0]
		.PP		 ( PP7 ) // output
		);
		
	sel_encoder gen8 (
		.x_minus ( X_e[15] ), // input
		.x		 ( X_e[16] ), // input
		.x_plus  ( X_e[17] ), // input
		.Y       ( Y       ), // input [31:0]
		.PP		 ( PP8 ) // output
		);
		
	sel_encoder gen9 (
		.x_minus ( X_e[17] ), // input
		.x		 ( X_e[18] ), // input
		.x_plus  ( X_e[19] ), // input
		.Y       ( Y       ), // input [31:0]
		.PP		 ( PP9 ) // output
		);
		
	sel_encoder gen10 (
		.x_minus ( X_e[19] ), // input
		.x		 ( X_e[20] ), // input
		.x_plus  ( X_e[21] ), // input
		.Y       ( Y       ), // input [31:0]
		.PP		 ( PP10) // output
		);
		
	sel_encoder gen11 (
		.x_minus ( X_e[21] ), // input
		.x		 ( X_e[22] ), // input
		.x_plus  ( X_e[23] ), // input
		.Y       ( Y       ), // input [31:0]
		.PP		 ( PP11 ) // output
		);
		
	sel_encoder gen12 (
		.x_minus ( X_e[23] ), // input
		.x		 ( X_e[24] ), // input
		.x_plus  ( X_e[25] ), // input
		.Y       ( Y       ), // input [31:0]
		.PP		 ( PP12 ) // output
		);
		
	sel_encoder gen13 (
		.x_minus ( X_e[25] ), // input
		.x		 ( X_e[26] ), // input
		.x_plus  ( X_e[27] ), // input
		.Y       ( Y       ), // input [31:0]
		.PP		 ( PP13 ) // output
		);
		
	sel_encoder gen14 (
		.x_minus ( X_e[27] ), // input
		.x		 ( X_e[28] ), // input
		.x_plus  ( X_e[29] ), // input
		.Y       ( Y       ), // input [31:0]
		.PP		 ( PP14 ) // output
		);
		
	sel_encoder gen15 (
		.x_minus ( X_e[29] ), // input
		.x		 ( X_e[30] ), // input
		.x_plus  ( X_e[31] ), // input
		.Y       ( Y       ), // input [31:0]
		.PP		 ( PP15 ) // output
		);
	
	// Column 0
	cpa col0_1 (PP0[1], PP0[0], product[0], 
	// Column 1
	assign product[1] = PP0[2];
	// Column 2
	cpa()
	
	assign product[2] = ;
	assign product[3] = ;
	assign product[4] = ;
	assign product[5] = ;
	assign product[6] = ;
	assign product[7] = ;
	assign product[8] = ;
	assign product[9] = ;
	
	assign product[0] = ;
	assign product[1] = ;
	assign product[2] = ;
	assign product[3] = ;
	assign product[4] = ;
	assign product[5] = ;
	assign product[6] = ;
	assign product[7] = ;
	assign product[8] = ;
	assign product[9] = ;
	
	assign product[0] = ;
	assign product[1] = ;
	assign product[2] = ;
	assign product[3] = ;
	assign product[4] = ;
	assign product[5] = ;
	assign product[6] = ;
	assign product[7] = ;
	assign product[8] = ;
	assign product[9] = ;
	
	assign product[0] = ;
	assign product[1] = ;
	assign product[2] = ;
	assign product[3] = ;
	assign product[4] = ;
	assign product[5] = ;
	assign product[6] = ;
	assign product[7] = ;
	assign product[8] = ;
	assign product[9] = ;
	
	assign product[0] = ;
	assign product[1] = ;
	assign product[2] = ;
	assign product[3] = ;
	assign product[4] = ;
	assign product[5] = ;
	assign product[6] = ;
	assign product[7] = ;
	assign product[8] = ;
	assign product[9] = ;
	
	assign product[0] = ;
	assign product[1] = ;
	assign product[2] = ;
	assign product[3] = ;



endmodule

//From figure 11.80 on p. 482
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

module csa (input logic a, b, cin,
			output logic cout, s);
			
		assign {cout, s} = a + b + cin
endmodule

module cpa (input logic a, b,
			output logic s, cout);
		assign cout = a & b;
		assign s = a ^ b;