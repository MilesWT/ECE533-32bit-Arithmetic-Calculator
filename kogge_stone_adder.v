module kogge_stone_adder_32_bit //Top level module for N-bit Carry Ripple Adder (See Fig. 11.14).

    #(parameter N = 32)

    (input logic [N:1] A, B, //Two N-bit input words.
    input logic Cin, //1-bit carry in.
    output logic [N:1] S, //N-bit sum.
    output logic Cout); //1-bit carry out.

    wire [N:1] P, G; //Wires for the N bitwise PG signals. 
    wire [(N-1):1] C; //Wires for the N-1 carry signals.

    // Bitwise_PG_32_Bit BPG1 (P, G, A, B);
    //Instantiate bitwise PG logic
    Bitwise_PG_32_Bit BPG1 (
        .P ( P ),
        .G ( G ),
        .A ( A ),
        .B ( B )
    );
    // Group_PG_32_Bit GPG1 (C, G[(N-1):1], P[(N-1):1], Cin);
    //Instantiate group PG logic
    Group_PG_32_Bit GPG1 (
        .GG  ( C          ),
        .G   ( G[(N-1):1] ),
        .P   ( P[(N-1):1] ),
        .Cin ( Cin        )
    );
    // 32_Bit_Sum_Logic SL1 (Cout, S, G[N], {C,Cin}, P);
    //Instantiate sum logic
    Sum_Logic_32_Bit SL1 (
        .Cout ( Cout    ),
        .S    ( S       ),
        .GN   ( G[N]    ),
        .C    ( {C,Cin} ),
        .P    ( P       )
    );

endmodule

module Bitwise_PG_32_Bit //This module realizes the bitwise PG logic of Eq (11.5) and FIG 11.12.

    #(parameter N = 32) // The parameter "N" may be edited to change bit count.
    //            [32 spaces]
    (output logic [N:1] P, G, //N-bit Propagate and Generate signals.
    input logic [N:1] A, B); //Two N-bit input words.

    assign G = A&B; //Bitwise AND of inputs A and B, Eq. (11.5).
    assign P = A^B; //Bitwise XOR of inputs A and B, Eq. (11.5).

endmodule

module Group_PG_32_Bit //This module realizes the group PG logic of Eq (11.10) and FIG 11.14.

    #(parameter N = 32) // The parameter "N" may be edited to change bit count.
   
    (output logic [(N-1):1] GG, //N-1 group generate signals that are output to sum logic.
    // [(N-1):1]
    input logic [N:1] G, P, //PG inputs from bitwise PG logic.
    input logic Cin); //1-bit carry in.

    wire [(N-1):2] G0Wire, P0Wire;
    wire [(N-1):4] G1Wire, P1Wire;
    wire [(N-1):8] G2Wire, P2Wire;
    wire [(N-1):16] G3Wire, P3Wire;

    // ROW 0 (1st)
    Gray_Cell_Val2 gray_cell_Cin0 (
        .Gi_k     ( G[1]  ),
        .Pi_k     ( P[1]  ),
        .Gkmin1_j ( Cin   ),
        .Gi_j     ( GG[1] )
    );
    generate
        genvar black0;
        for (black0 = 2; black0 <= N-1; black0=black0+1)
        begin: black0_label
            Black_Cell_Val2 black_cell_inst0 (
                .Gi_k     ( G[black0]      ),
                .Pi_k     ( P[black0]      ),
                .Gkmin1_j ( G[black0 - 1]  ),
                .Pkmin1_j ( P[black0 - 1]  ),
                .Gi_j     ( G0Wire[black0] ),
                .Pi_j     ( P0Wire[black0] )
            );
        end
    endgenerate

    // ROW 1 (2nd)
    Gray_Cell_Val2 gray_cell_Cin1 (
        .Gi_k     ( G0Wire[2]  ),
        .Pi_k     ( P0Wire[2]  ),
        .Gkmin1_j ( Cin   ),
        .Gi_j     ( GG[2] )
    );
    generate
        genvar gray1;
        for (gray1 = 2+1; gray1 < 4; gray1=gray1+1)
        begin: gray1_label
            Gray_Cell_Val2 gray_cell_inst1 (
                .Gi_k     ( G0Wire[gray1]     ),
                .Pi_k     ( P0Wire[gray1]     ),
                .Gkmin1_j ( GG[gray1 - 2] ),
                .Gi_j     ( GG[gray1]         )
            );
        end
    endgenerate
    generate
        genvar black1;
        for (black1 = 4; black1 <= N-1; black1=black1+1)
        begin: black1_label
            Black_Cell_Val2 black_cell_inst1 (
                .Gi_k     ( G0Wire[black1]     ),
                .Pi_k     ( P0Wire[black1]     ),
                .Gkmin1_j ( G0Wire[black1 - 2] ),
                .Pkmin1_j ( P0Wire[black1 - 2] ),
                .Gi_j     ( G1Wire[black1]     ),
                .Pi_j     ( P1Wire[black1]     )
            );
        end
    endgenerate

    // ROW 2 (3rd)
    Gray_Cell_Val2 gray_cell_Cin2 (
        .Gi_k     ( G1Wire[4]  ),
        .Pi_k     ( P1Wire[4]  ),
        .Gkmin1_j ( Cin   ),
        .Gi_j     ( GG[4] )
    );
    generate
        genvar gray2;
        for (gray2 = 4+1; gray2 < 8; gray2=gray2+1)
        begin: gray2_label
            Gray_Cell_Val2 gray_cell_inst2 (
                .Gi_k     ( G1Wire[gray2]     ),
                .Pi_k     ( P1Wire[gray2]     ),
                .Gkmin1_j ( GG[gray2 - 4] ),
                .Gi_j     ( GG[gray2]         )
            );
        end
    endgenerate
    generate
        genvar black2;
        for (black2 = 8; black2 <= N-1; black2=black2+1)
        begin: black2_label
            Black_Cell_Val2 black_cell_inst2 (
                .Gi_k     ( G1Wire[black2]     ),
                .Pi_k     ( P1Wire[black2]     ),
                .Gkmin1_j ( G1Wire[black2 - 4] ),
                .Pkmin1_j ( P1Wire[black2 - 4] ),
                .Gi_j     ( G2Wire[black2]     ),
                .Pi_j     ( P2Wire[black2]     )
            );
        end
    endgenerate

    // ROW 3 (4th)
    Gray_Cell_Val2 gray_cell_Cin3 (
        .Gi_k     ( G2Wire[8]  ),
        .Pi_k     ( P2Wire[8]  ),
        .Gkmin1_j ( Cin   ),
        .Gi_j     ( GG[8] )
    );
    generate
        genvar gray3;
        for (gray3 = 8+1; gray3 < 16; gray3=gray3+1)
        begin: gray3_label
            Gray_Cell_Val2 gray_cell_inst3 (
                .Gi_k     ( G2Wire[gray3]     ),
                .Pi_k     ( P2Wire[gray3]     ),
                .Gkmin1_j ( GG[gray3 - 8] ),
                .Gi_j     ( GG[gray3]         )
            );
        end
    endgenerate
    generate
        genvar black3;
        for (black3 = 16; black3 <= N-1; black3=black3+1)
        begin: black3_label
            Black_Cell_Val2 black_cell_inst3 (
                .Gi_k     ( G2Wire[black3]     ),
                .Pi_k     ( P2Wire[black3]     ),
                .Gkmin1_j ( G2Wire[black3 - 8] ),
                .Pkmin1_j ( P2Wire[black3 - 8] ),
                .Gi_j     ( G3Wire[black3]     ),
                .Pi_j     ( P3Wire[black3]     )
            );
        end
    endgenerate

    // ROW 4 (5th)
    Gray_Cell_Val2 gray_cell_Cin4 (
        .Gi_k     ( G3Wire[16]  ),
        .Pi_k     ( P3Wire[16]  ),
        .Gkmin1_j ( Cin   ),
        .Gi_j     ( GG[16] )
    );
    generate
        genvar gray4;
        for (gray4 = 16+1; gray4 <= N-1; gray4=gray4+1)
        begin: gray4_label
            Gray_Cell_Val2 gray_cell_inst4 (
                .Gi_k     ( G3Wire[gray4]      ),
                .Pi_k     ( P3Wire[gray4]      ),
                .Gkmin1_j ( GG[gray4 - 16] ),
                .Gi_j     ( GG[gray4]          )
            );
        end
    endgenerate
    // (No black cells in last row)

endmodule

module Sum_Logic_32_Bit //This module realizes the sum logic of Eq. (11.7) and FIG 11.14.

    #(parameter N = 32) // The parameter "N" may be edited to change bit count.

    (output logic Cout, //1-bit carry out.
    output logic [N:1] S, //N-bit sum.
    input logic GN, //Most significant group generate bit.
    input logic [(N-1):0] C, //The carry signals from the group PG logic are also the group generate signals
                             //(see pg. 437).
    input logic [N:1] P); //P inputs from bitwise PG logic.

    assign S = P^C; // Eq. (11.7): Si = Pi ^ Gi-1:0
    assign Cout = GN | P[N]&C[(N-1)]; // Eq. (11.11): Cout = GN:0 = GN | (PN & GN-1:0)

endmodule

module Gray_Cell_Val2

   (input logic Gi_k, Pi_k, Gkmin1_j,
    output logic Gi_j);
    assign Gi_j = Gi_k | Pi_k & Gkmin1_j;

endmodule

module Black_Cell_Val2

    (input logic Gi_k, Pi_k, Gkmin1_j, Pkmin1_j,
    output logic Gi_j, Pi_j);
    assign Gi_j = Gi_k | Pi_k & Gkmin1_j;
    assign Pi_j = Pkmin1_j & Pi_k;

endmodule

/*module testbench

    #(parameter N = 32); // The parameter "N" may be edited to change bit count.

    logic [N:1] A, B, S;
    logic Cin, Cout;

    kogge_stone_adder_32_bit A1 (A,B,Cin,S,Cout);

    initial
    begin
        A = 0; B = 0; Cin = 0;
        #2 A   = 32'd25;
        #2 B   = 32'd75;
        #2 Cin = 1'b1;
        #6 $finish;
    end

endmodule*/
