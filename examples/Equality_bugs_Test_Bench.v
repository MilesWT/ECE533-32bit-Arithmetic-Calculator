module equality (input logic [3:0] a, b, // This module defines the DUT.
                 output logic Equal); 
 
 always_comb
   begin
      if (a == b)
         Equal = 1;
      els
         Equal = 0;
    end
endmodule
//
//
//
module test; // This is the test bench. It specifies input signals to drive the DUT.

 logic [3:0] a, b;
 logic Equal;

equality Eq1 (a, b, Equal); // This line instantiates the DUT.

initial 
  begin
     a = 4'b0000; // Initiallize "a" to 0.
     b = 4'b0000; // Initiallize "b" to 0.
     #512 $finish; // Simulate for 32x16 = 512 time steps to exercise the entire truth table.
		  // (32 steps/cycle x 16 cycles)

  end

// The next four lines clock the bits of input "b" so as to count up from 0 to 15.
  always  #2 b[0] = ~b[0]; // (Note: all procedural blocks run concurrently.)
  always  #4 b[1] = ~b[1]; 
  always  #8 b[2] = ~b[2];
  always #16 b[3] = ~b[3]; // One complete cycle is 2x16 = 32 time steps.

  always #32 a = a+1; // "a" is incremented by one after each complete count of "b".  

endmodule 
