module blocking; // Use blocking assignments for Combinational logic.
  logic[3:0] a, b; // Statements are evaluated in the order that they appear
	initial 
	  begin
	    a = 5; // set initial values for a and b.
	    b = 6;
	    #10 // advance simulation time 10 steps.
	    a = b+2; // "blocking" assignment. Evaluate and assign. Block next expression until done. a <- 6+2=8
	    b = a+2; // "blocking" assignment. Evaluate and assign. Block next expression until done. b <- 8+2=10
	    #5 $finish; 
	  end
endmodule

module nonblocking;  // Use nonblocking assignments for Sequential logic.
  logic[3:0] a, b;     // Statements are evaluated concurrently.
	initial 
	  begin
	    a = 5; // set initial values for a and b.
	    b = 6;
	    #10 // advance simulation time 10 steps.
	    a <= b+2; // "nonblocking" assignment. Evaluate all expressions then assign all. a <- 6+2=8
	    b <= a+2; // 								     b <- 5+2=7
	  end         
endmodule
