//Figure 11.89 in the text, pg 486
module compress (input logic x, y, z, w, tin
				output logic s, c, tout );
	wire x_y, z_w
	
	wire x_y_nand, z_w_nand;
	wire xy_zw_xor;
	
	x_y_nand = x ~& y;
	z_w_nand = z ~& w;
	
	x_y = x_y_nand ~& (x | y); //XNOR x y
	z_w = z_w_nand ~& (z | w); //XNOR z w
	
	
	xy_zw_xor = x_y ^ z_w; //XOR of xnors, used in s and c
	
	// Sum out
	s = xy_zw_xor ^ tin;
		
	// Intermediate carry out
	tout = x_y_nand ~& z_w_nand
	
	// Carry out
	c = (tin & xy_zw_xor) | ((x_y ~& z_w) | (x_y_nand ~| z_w_nand));
				
endmodule: compress