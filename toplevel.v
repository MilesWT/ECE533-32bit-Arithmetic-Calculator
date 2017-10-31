module control (input logic a[31:0], b[31:0], select[1:0]
				output logic control_output)
// a and b get connnected to adder, multiplier, divider
// Select 0 connected to adder to choose between add/subtract
// Arithmetic units get connected to mux
// Mux gives output
				
endmodule: control

module mux (input logic add[31:0], multiply[31:0], divide[31:0], mux_select[1:0], //the actual mux.
           output logic mux_output);
  always_comb
   begin
    case(mux_select)
       00: mux_output = add;
       01: mux_output = add;
	   10: mux_output = multiply;
	   11: mux_output = divide;
       default mux_output = add;
    endcase
   end
endmodule: mux