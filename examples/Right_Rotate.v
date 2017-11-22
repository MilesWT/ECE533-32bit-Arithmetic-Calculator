module rotator (input logic [3:0] a, // The DUT
                input logic [1:0] Ror,
                output logic [3:0] f);
always_comb
  case (Ror)
	0: f = a;
	1: begin f[3] = a[0]; f[2] = a[3]; f[1] = a[2]; f[0] = a[1]; end
	2: begin f[3] = a[1]; f[2] = a[0]; f[1] = a[3]; f[0] = a[2]; end
	3: begin f[3] = a[2]; f[2] = a[1]; f[1] = a[0]; f[0] = a[3]; end
  endcase
endmodule

module test; // The test bench.

  logic [3:0] a, f;
  logic [1:0] Ror;

 rotator rot1 (a,Ror,f); // This line instantiates the DUT.

initial 
  begin
     a = 4'b0011; // Initiallize "a" to 0011.
     Ror =2'b00;
     #12 $finish; 
  end

// The next two lines clock the bits of input "Ror" so as to count up from 0 to 3.
  always  #2 Ror[0] = ~Ror[0]; // (Note: all procedural blocks run concurrently.)
  always  #4 Ror[1] = ~Ror[1];   

endmodule 

