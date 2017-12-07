`include "/home/rmuri/ECE_533/ASIC_Design/src/Calculator/add_subtract.v"
`include "/home/rmuri/ECE_533/ASIC_Design/src/Calculator/divider.v"
`include "/home/rmuri/ECE_533/ASIC_Design/src/Calculator/shift_multiplier.v"
module control (input logic [31:0] a, b, 
				input logic [1:0] select,
				input logic clk, enable, reset,
				output logic overflow,
				output logic [31:0] control_output, remainder);
// a and b get connnected to adder, multiplier, divider
// Select 0 connected to adder to choose between add/subtract
// Arithmetic units get connected to mux
// Mux gives output

logic [31:0] add, multiply, divide;



// Kogge-stone multiplier
add_subtract nonduplicatename(
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
					  .product(3) // 64 bit output
					  );

// Restoring division					  
divider divider(
				.A(a), // 32 bit input
				.B(b), // 32 bit divisor
				.quotient(divide), // 32 bit quotient
				.remainder(remainder)
				);
					  

mux1 output_select(
				  .add(add),
				  .multiply(multiply),
				  .divide(divide),
				  .mux_select(select),
				  .mux_output(control_output)
				  );

				  
endmodule

module mux1 (input logic [31:0] add, divide,
			input logic [31:0] multiply,
			input logic [1:0] mux_select,
            output logic [31:0] mux_output);
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

/*
module top_tb();
logic [31:0] a, b;
logic [1:0] select;
logic clk, enable, reset;
logic overflow;
logic [31:0] out;
	
control DUT(
			.a(a),
			.b(b),
			.control_output(out),
			.select(select),
			.clk(clk), 
			.enable(enable), 
			.reset(reset),
			.overflow(overflow)
			);
			
	
initial begin 
	clk = 1'b0;
	forever #50 clk = ~clk;
end
	
initial begin


reset = 1'b1;
enable = 1'b0;
select = 2'b00;
		
// 39 * 25 = 975
a = 32'b0000_0000_0000_0000_0000_0000_0001_1001;
b = 32'b0000_0000_0000_0000_0000_0000_0010_0111;
		
#50 enable = 1'b1; select = 2'b10;
#50 reset = 1'b0;
		
#1900 enable = 1'b0; reset = 1'b1;


//-2 * 2 = -4
a = 32'b1000_0000_0000_0000_0000_0000_0000_0010;
b = 32'b0000_0000_0000_0000_0000_0000_0000_0010;
		
#50 enable = 1'b1;
#50 reset = 1'b0;
		

#1900

		
select = 2'b00;

// Subtraction
a = 0; b = 0;
#50 a = 32'd75; b = 32'd25; // 75 - 25 = 50
#50 b = 32'd280; //  - 25 = -100

#50 select = 2'b01;
// Addition
 a = 32'd200; b = 32'd100; // 200 + 100 = 300

#50 select = 2'b11;
// Division
a = 200; b = 40;


#1000 $finish;
end
endmodule
*/