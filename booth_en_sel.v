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
module sel_encoder (input logic x_minus, x, x_plus, 
					input logic [31:0] Y,
					output logic [33:0] PP);
			
			// Booth Encoder
			logic single, double, neg;
			logic nand1, nand2;
			
			nand3 gate1 (
				.in1	( x_minus ), // input
				.in2	( ~x      ), // input
				.in3 	( ~x_plus ), // input
				.out    ( nand1   )  // output
				);
			
			nand3 gate2 (
				.in1	( ~x_minus ), // input
				.in2	( ~x       ), // input
				.in3 	( x_plus   ), // input
				.out    ( nand2    )  // output
				);
			
			assign single = x_minus ^ x;
			
			assign double = ~(nand1 & nand2);
			
			assign neg = x_plus;
			
			// Booth Selector
			logic [33:0] Y_e; // Y sign extended
			assign Y_e = {neg ^ Y[31], Y};
			
			// Append s to the LSB
			assign PP = {((single & Y_e) |
						(double & (Y_e << 1))) ^ neg,
						neg};

endmodule

//Three input NAND gate because Verilog sucks balls
module nand3 (input logic in1, in2, in3,
			  output logic out);
			  
			  logic intermediate;
			  assign intermediate = ~(in1 & in2);
			  assign out = ~(intermediate & in3);
endmodule

module csa (input logic a, b, cin,
			output logic cout, s);
			
		assign {cout, s} = a + b + cin
endmodule

module cpa (input logic a, b,
			output logic s, cout);
		assign cout = a & b;
		assign s = a ^ b;