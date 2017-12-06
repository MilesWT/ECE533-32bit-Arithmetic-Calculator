`include "/home/mtricarico/Documents/ECE533/ASIC_Design/src/kogge_stone_adder.v"

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

    // 2's Complement of input B
    kogge_stone_adder_32_bit Adder_2s_Comp (
        .A    ( ~B        ),
        .B    ( 32'b1     ),
        .S    ( NotB      ),
        .Cin  ( 1'b0      ),
        .Cout ( DummyCout )
    );

    always @(Flag)
    if (Flag)
        // Addition: A + B
        assign NewB = B;
    else
        // Subtraction: A - B
        assign NewB = NotB;

    kogge_stone_adder_32_bit Adder1 (
        .A    ( A    ),
        .B    ( NewB ),
        .S    ( S    ),
        .Cin  ( Cin  ),
        .Cout ( Cout )
    );    

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
        #2 Cin = 1'b0;
        #6 $finish;
    end

endmodule
