module Arithmetic;
  real a, b, c, d, e, f;
  	initial
  	  begin
  	    a = 10.0; // set initial values for a and b.
  	    b =  3.0;
  	    #15 // advance simulation 15 time steps.
  	    c = a + b; // add
  	    d = a - b; // subtract
  	    e = a * b; // multiply
  	    f = a / b; // divide
            #5 $finish;
  	  end
endmodule
  	    

module Bitwise;
  logic[3:0] a, b, c, d, e, f;
  	initial
  	  begin
  	    a = 10; // set initial values for a and b.
  	    b =  3;
  	    #15 // advance simulation 15 time steps.
  	    c = a & b; // bitwise AND.
  	    d = a | b; // bitwise OR.
  	    e = a ^ b; // bitwise XOR.
	    f = ~a; // bitwise NOT.
  	  end
endmodule

module Unary_Reduction;
  logic[3:0] a, b;
  logic c, d, e, f, g, h, i;
  	initial
  	  begin
  	    a = 10; // set initial values for a and b.
  	    b =  7;
  	    #15 // advance simulation 15 time steps.
  	    c = &a; // AND all bits in a (one-bit result).
  	    d = &b; // AND all bits in b (one-bit result).
  	    e = |a; // OR all bits in a (one-bit result).
  	    f = |b; // OR all bits in b (one-bit result).
  	    g = ^a; // XOR all bits in a (one-bit result).
  	    h = ^b; // XOR all bits in b (one-bit result).
	    i = ~&a; // NAND all bits in a (one-bit result).
  	  end
endmodule

module Logical;      //  Same as bit-wise only for single bit operands. Can work on expressions,
  logic[3:0] a, b, c; // integers or groups of bits.  Treat all values that are nonzero as "1".
  logic d;        // 
  	initial
  	  begin
  	    a = 0; // set initial values for a, b and c.
  	    b = 3;
       	    c = 3;
  	    #15 // advance simulation 15 time steps.
  	    if((a == b) && (c) || (c == b)) d = 1; // d = 1 if a = b , AND c is nonzero
						   // OR c = b.
  	     else d = !a; // Else d = 0 if a is anything but zero.
  	  end
endmodule
