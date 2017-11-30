// Top level module
module multiplier (input logic clk, // arbitrary clk  for synthesis
				   input logic [31:0] Y, X,
				   output logic [63:0] product);

	logic [33:0] X_e;
	logic [33:0] PP_array [15:0];
	
	assign X_e = {2'b00, X}; // X extended with 2 0's to generate PPs
	
	sel_encoder gen0 (
		.x_minus ( 1'b0   ), // input
		.x		 ( X_e[0] ), // input
		.x_plus  ( X_e[1] ), // input
		.Y       ( Y      ), // input [31:0]
		.PP		 ( PP_array[0] ) // output
		);

	generate
	genvar index;
		for (index = 1; index < 16; index = index + 1)
			begin: gen_code_label
				
				sel_encoder encoder_inst (
							.x_minus ( X_e[(2 * index - 1)]  ), // input
							.x		 ( X_e[(2 * index)]      ), // input
							.x_plus  ( X_e[(2 * index + 1)]  ), // input
							.Y       ( Y                     ), // input [31:0]
							.PP		 ( PP_array[index]		 )  // output [33:0]
							);
				
			end
	endgenerate

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