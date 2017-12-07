//include "/home/mtricarico/Documents/ECE533/ASIC_Design/src/kogge_stone_adder.v"
`include "/home/rmuri/ECE_533/ASIC_Design/src/Calculator/kogge_stone_adder.v"
module add_subtract

    #(parameter N = 32) // The parameter "N" may be edited to change bit count.

    (input logic [N:1] A, B, // Two N-bit input words.
    input logic Cin, // 1-bit carry in.
    input logic Flag, // Add/Subtract flag
    output logic [N:1] S, // N-bit sum.
    output logic Cout); // 1-bit carry out

    logic [N:1] NotB;
    logic [N:1] NewB;
    logic DummyCout;
	logic [N:1] inv_b;
    // 2's Complement of input B
	
	assign inv_b = ~B;
	
    kogge_stone_adder_32_bit Adder_2s_Comp (
        .A    ( inv_b     ),
        .B    ( 32'b1     ),
        .S    ( NotB      ),
        .Cin  ( 1'b0      ),
        .Cout ( DummyCout )
    );

    kogge_stone_adder_32_bit Adder1 (
        .A    ( A    ),
        .B    ( NewB ),
        .S    ( S    ),
        .Cin  ( Cin  ),
        .Cout ( Cout )
    );

	mux muxyo(
			  .B(B),
			  .NotB(inv_b),
			  .select(Flag),
			  .mux_output(NewB)
			  );

endmodule

module mux (input logic [31:0] B, NotB,
			input logic select,
            output logic [31:0] mux_output);
  always_comb
   begin
    case(select)
       0: mux_output = B;
       1: mux_output = NotB;
       default mux_output = B;
    endcase
   end
endmodule


module testbench

    #(parameter N = 32); // The parameter "N" may be edited to change bit count.

    logic [N:1] A, B, S;
    logic Flag;
    logic Cin, Cout;

    add_subtract add_sub1 (
        .A    ( A    ),
        .B    ( B    ),
        .S    ( S    ),
        .Flag ( Flag ),
        .Cin  ( Cin  ),
        .Cout ( Cout )
    );

    initial
    begin
        A = 0; B = 0; Cin = 0; Flag = 0;
        #2 A   = 32'd75;
        #2 B   = 32'd25;

		#2 A = 75; B = 25; Flag = 1;
        #6 $finish;
    end

endmodule

