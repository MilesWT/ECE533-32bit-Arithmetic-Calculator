module 32_bit_pg_kogge_stone_adder //Top level module for N-bit Carry Ripple Adder (See Fig. 11.14).

    #(parameter N = 32)

   (input logic [N:1] A, B, //Two N-bit input words.
    input logic Cin, //1-bit carry in.
    output logic [N:1] S, //N-bit sum.
    output logic Cout); //1-bit carry out.

    wire [N:1] P, G; //Wires for the N bitwise PG signals. 
    wire [(N-1):1] C; //Wires for the N-1 carry signals.

    // 32_Bit_Bitwise_PG BPG1 (P, G, A, B);
    //Instantiate bitwise PG logic, Eq. (11.5).
    32_Bit_Bitwise_PG BPG1 (
        .P ( P ),
        .G ( G ),
        .A ( A ),
        .B ( B )
    );
    // 32_Bit_Group_PG GPG1 (C, G[(N-1):1], P[(N-1):1], Cin);
    //Instantiate group PG logic, Eq. (11.10).
    32_Bit_Group_PG GPG1 (
        .C   ( C          ),
        .G   ( G[(N-1):1] ),
        .P   ( P[(N-1):1] ),
        .Cin ( Cin        )
    );
    // 32_Bit_Sum_Logic SL1 (Cout, S, G[N], {C,Cin}, P);
    //Instantiate sum logic, Eqs. (11.7) and (11.11).
    32_Bit_Sum_Logic SL1 (
        Cout ( Cout    ),
        S    ( S       ),
        GN   ( G[N]    ),
        C    ( {C,Cin} ),
        P    ( P       )
    );

endmodule

module 32_Bit_Bitwise_PG //This module realizes the bitwise PG logic of Eq (11.5) and FIG 11.12.

  #(parameter N = 32) // The parameter "N" may be edited to change bit count.

   (output logic [N:1] P, G, //N-bit Propagate and Generate signals.
    input logic [N:1] A, B); //Two N-bit input words.

    assign G = A&B; //Bitwise AND of inputs A and B, Eq. (11.5).
    assign P = A^B; //Bitwise XOR of inputs A and B, Eq. (11.5).

endmodule

module 32_Bit_Group_PG //This module realizes the group PG logic of Eq (11.10) and FIG 11.14.

  #(parameter N = 32) // The parameter "N" may be edited to change bit count.
   
   (output logic [(N-1):1] GG, //N-1 group generate signals that are output to sum logic.
    input logic [(N-1):1] G, P, //PG inputs from bitwise PG logic.
    input logic Cin); //1-bit carry in.

    always_comb
        begin:GPG1 //Named group. Can have local variables, i.e. "i".
       
        wire [N-1:2] G0Wire, P0Wire;
        wire [N-1:4] G1Wire, P1Wire;
        wire [N-1:8] G2Wire, P2Wire;
        wire [N-1:16] G3Wire, P3Wire;
        assign G0Wire[0] = Cin;
        assign G1Wire[0] = Cin;
        assign G2Wire[0] = Cin;
        assign G3Wire[0] = Cin;
        
        // ROW 0 (1st)
        generate
            genvar gray0;
            for (gray0 = 1; gray0 < 2; gray0=gray0+1)
            {
                begin: gray0_label
                    Gray_Cell_Val2 gray_cell_inst0 (
                        .Gi_k     ( G0Wire[gray0] ),
                        .Pi_k     ( P0Wire[gray0] ),
                        .Gkmin1_j ( G0Wire[0]     ), // ???????????????????????????
                        .Gi_j     ( GG[gray0]     )
                    );
                end
            }
        endgenerate
        generate
            genvar black0;
            for (black0 = 2; black0 < N; black0=black0+1)
            {
                begin: black0_label
                    Black_Cell_Val2 black_cell_inst0 (
                        .Gi_k     ( G0Wire[black0]     ),
                        .Pi_k     ( P0Wire[black0]     ),
                        .Gkmin1_j ( G0Wire[black0 - 1] ),
                        .Pkmin1_j ( P0Wire[black0 - 1] ),
                        .Gi_j     ( G1Wire[black0]     ),
                        .Pi_j     ( P1Wire[black0]     )
                    );
                end
            }
        endgenerate

        // ROW 1 (2nd)
        generate
            genvar gray1;
            for (gray1 = 2; gray1 < 4; gray1=gray1+1)
            {
                begin: gray1_label
                    Gray_Cell_Val2 gray_cell_inst1 (
                        .Gi_k     ( G1Wire[gray1] ),
                        .Pi_k     ( P1Wire[gray1] ),
                        .Gkmin1_j ( G1Wire[0]     ), // ???????????????????????????
                        .Gi_j     ( GG[gray1]         )
                    );
                end
            }
        endgenerate
        generate
            genvar black1;
            for (black1 = 4; black1 < N; black1=black1+1)
            {
                begin: black1_label
                    Black_Cell_Val2 black_cell_inst1 (
                        .Gi_k     ( G1Wire[black1]     ),
                        .Pi_k     ( P1Wire[black1]     ),
                        .Gkmin1_j ( G1Wire[black1 - 1] ),
                        .Pkmin1_j ( P1Wire[black1 - 1] ),
                        .Gi_j     ( G2Wire[black1]     ),
                        .Pi_j     ( P2Wire[black1]     )
                    );
                end
            }
        endgenerate

        // ROW 2 (3rd)
        generate
            genvar gray2;
            for (gray2 = 4; gray2 < 8; gray2=gray2+1)
            {
                begin: gray2_label
                    Gray_Cell_Val2 gray_cell_inst2 (
                        .Gi_k     ( G2Wire[gray2] ),
                        .Pi_k     ( P2Wire[gray2] ),
                        .Gkmin1_j ( G2Wire[0]     ), // ???????????????????????????
                        .Gi_j     ( GG[gray2]         )
                    );
                end
            }
        endgenerate
        generate
            genvar black2;
            for (black2 = 8; black2 < N; black2=black2+1)
            {
                begin: black2_label
                    Black_Cell_Val2 black_cell_inst2 (
                        .Gi_k     ( G2Wire[black2]     ),
                        .Pi_k     ( P2Wire[black2]     ),
                        .Gkmin1_j ( G2Wire[black2 - 1] ),
                        .Pkmin1_j ( P2Wire[black2 - 1] ),
                        .Gi_j     ( G3Wire[black2]     ),
                        .Pi_j     ( P3Wire[black2]     )
                    );
                end
            }
        endgenerate

        // ROW 3 (4th)
        generate
            genvar gray3;
            for (gray3 = 8; gray3 < 16; gray3=gray3+1)
            {
                begin: gray3_label
                    Gray_Cell_Val2 gray_cell_inst3 (
                        .Gi_k     ( G3Wire[gray3] ),
                        .Pi_k     ( P3Wire[gray3] ),
                        .Gkmin1_j ( G3Wire[0]     ), // ???????????????????????????
                        .Gi_j     ( GG[gray3]         )
                    );
                end
            }
        endgenerate
        generate
            genvar black3;
            for (black3 = 16; black3 < N; black3=black3+1)
            {
                begin: black3_label
                    Black_Cell_Val2 black_cell_inst3 (
                        .Gi_k     ( G3Wire[black3]     ),
                        .Pi_k     ( P3Wire[black3]     ),
                        .Gkmin1_j ( G3Wire[black3 - 1] ),
                        .Pkmin1_j ( P3Wire[black3 - 1] ),
                        .Gi_j     ( G4Wire[black3]     ),
                        .Pi_j     ( P4Wire[black3]     )
                    );
                end
            }
        endgenerate

        // ROW 4 (5th)
        generate
            genvar gray4;
            for (gray4 = 16; gray4 < N; gray4=gray4+1)
            {
                begin: gray4_label
                    Gray_Cell_Val2 gray_cell_inst4 (
                        .Gi_k     ( G4Wire[gray4] ),
                        .Pi_k     ( P4Wire[gray4] ),
                        .Gkmin1_j ( G4Wire[0]     ), // ???????????????????????????
                        .Gi_j     ( GG[gray4]         )
                    );
                end
            }
        endgenerate
        
        // integer i;
        // // outer for loop for rows
        // for (row=0; row<5; row=row+1)
        // {
        //     // inner for loops for columns
        //     // gray cells
        //     for (gcol=1; gcol < 2**row; gcol=gcol+1)
        //     {
        //         // create gray cells
        //         // output logic Gi_j, //N-bit Propagate and Generate signals.
        //         // input logic Gi_k, Pi_k, Gkmin1_j); //Two N-bit input words.
        //         if (gcol == 0)
        //         {
        //             assign G[1] = Gi_k;
        //             assign P[1] = Pi_k;
        //         }
        //         assign 

        //     }
        //     // black cells
        //     for (bcol=2**row; bcol < row**2 - 2**row; bcol=bcol+1)
        //     {

        //     }
        // }

        GG[1] = G[1] | P[1]&Cin;//Eq. (11.10).
        for (i=2; i<=(N-1); i=i+1) //Loop saves having to write N-2 more "GG" assignment statements.
            GG[i] = G[i] | P[i]&GG[(i-1)]; //Eq. (11.10).
      end

endmodule

module 32_Bit_Sum_Logic //This module realizes the sum logic of Eq. (11.7) and FIG 11.14.

  #(parameter N = 32) // The parameter "N" may be edited to change bit count.

   (output logic Cout, //1-bit carry out.
    output logic [N:1] S, //N-bit sum.
    input logic GN, //Most significant group generate bit.
    input logic [(N-1):0] C, //The carry signals from the group PG logic are also the group generate signals
                             //(see pg. 437).
    input logic [N:1] P); //P inputs from bitwise PG logic.

    assign S = P^C; //Eq. (11.7).
    assign Cout = GN | P[N]&C[(N-1)]; //Eq. (11.11).

endmodule

module Gray_Cell_Val2

   (input logic Gi_k, Pi_k, Gkmin1_j,
    output logic Gi_j);
    assign Gi_j = Gi_k | Pi_k & Gkmin1_j

endmodule

module Black_Cell_Val2

   (input logic Gi_k, Pi_k, Gkmin1_j, Pkmin1_j,
    output logic Gi_j, Pi_j);
    assign Gi_j = Gi_k | Pi_k & Gkmin1_j
    assign Pi_j = Pimin1_j & Pi_k

endmodule

module test

  #(parameter N = 64); // The parameter "N" may be edited to change bit count.

  logic [N:1] A, B, S;
  logic Cin, Cout;

  n_bit_pg_carry_ripple A1 (A,B,Cin,S,Cout);

  initial
    begin
     A = 0; B = 0; Cin = 0;
     #2 A   = 64'd25;
     #2 B   = 64'd75;
     #2 Cin = 1'b1;
     #6 $finish;
    end

endmodule
