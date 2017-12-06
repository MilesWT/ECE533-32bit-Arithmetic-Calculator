module control (input logic [31:0] a, b, 
				input logic select[1:0],
				input logic clk, enable, reset,
				output logic overflow,
				output logic [63:0] control_output);
// a and b get connnected to adder, multiplier, divider
// Select 0 connected to adder to choose between add/subtract
// Arithmetic units get connected to mux
// Mux gives output


// Kogge-stone multiplier
add_subtract adder(
				   .A(a), // 32 bit Term A
				   .B(b), // 32 bit Term B
				   .Cin(1'b0), // Assume no carry in
				   .Flag(select[0]), // If flag is 0, subtract B from A
				   .S(add), // The 32 bit sum/difference 
				   .Cout(overflow) // Carry out is only high on overflow
				   );

// Serial shift multiplier
shift_mult multiplier(
					  .clk(clk), // Clock
					  .reset(reset), // Reset should be high to start
					  .enable(enable), // Enable needs to start low and go high before reset goes low
					  .Y(a), // 32 bit Factor Y
					  .X(b), // 32 bit Factor X
					  .product(multiply) // 64 bit output
					  );

// Restoring division					  
divider divider(
				.A(a), // 32 bit input
				.B(b), // 32 bit divisor
				.quotient(divide) // 32 bit quotient
				);
					  

mux output_select(
				  .add(add),
				  .multiply(multiply),
				  .divide(divide),
				  .mux_select(select),
				  .mux_output(control_output)
				  );

				  
endmodule

module mux (input logic add[31:0], multiply[31:0], divide[31:0], mux_select[1:0], //the actual mux.
           output logic mux_output);
  always_comb
   begin
    case(mux_select)
       00: mux_output = add;  // Bit 0 is used to select subtraction
       01: mux_output = add;  // If bit 0 is 1, then perform addition
	   10: mux_output = multiply;
	   11: mux_output = divide;
       default mux_output = add;
    endcase
   end
endmodule