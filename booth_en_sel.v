//From figure 11.80 on p. 482


module encoder (input logic x_minus, x, x_plus
				output logic single, double, neg);
				
			assign single = x_minus xor x;
			
			assign double = (x_minus nand x nand ~x_plus) nand (~x_minus nand ~x nand x_plus);
			
			assign neg = x_plus;
				
endmodule: encoder

module selector(input logic single, double, neg, Y[31:0]
				output logic PP[32:0]);
			
			//TODO Change this to sign extended instead of 0 extended
			wire Y_e; // Y extended with a leading 0
			assign Y_e = {1b'0, Y};
			
			assign PP = ((single and Y_e) or
						(double and (Y_e << 1))) xor neg;

endmodule: selector