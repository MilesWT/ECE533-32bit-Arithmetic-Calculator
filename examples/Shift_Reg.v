module shift_register(input logic clk, D, // This module defines the DUT.
		      output logic Q1, Q2); 

 always_ff @(posedge clk) Q1 <= D; // Use nonblocking assignments for sequential logic. 
 always_ff @(posedge clk) Q2 <= Q1;// (See pp. 717, 725 and section A.5.4)

endmodule


module test; // This is the test bench. It specifies input signals to drive the DUT.

logic clk, D;
logic Q1, Q2;

shift_register shft1(clk, D, Q1, Q2); // This line instantiates the DUT.

 initial
  begin 
   clk = 0;
   D = 1;
   #20 $finish;
  end

 always #2 clk = ~clk;

endmodule
