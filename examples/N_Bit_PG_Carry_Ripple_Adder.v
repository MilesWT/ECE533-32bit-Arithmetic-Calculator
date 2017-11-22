module n_bit_pg_carry_ripple //Top level module for N-bit Carry Ripple Adder (See Fig. 11.14).

  #(parameter N = 64) // The parameter "N" may be edited to change bit count.

   (input logic [N:1] A, B, //Two N-bit input words.
    input logic Cin, //1-bit carry in.
    output logic [N:1] S, //N-bit sum.
    output logic Cout); //1-bit carry out.

  wire [N:1] P, G; //Wires for the N bitwise PG signals. 
  wire [(N-1):1] C; //Wires for the N-1 carry signals.

    N_Bit_Bitwise_PG BPG1 (P, G, A, B); //Instantiate bitwise PG logic, Eq. (11.5).
    N_Bit_Group_PG GPG1 (C, G[(N-1):1], P[(N-1):1], Cin); //Instantiate group PG logic, Eq. (11.10).
    N_Bit_Sum_Logic SL1 (Cout, S, G[N], {C,Cin}, P); //Instantiate sum logic, Eqs. (11.7) and (11.11).

endmodule

module N_Bit_Bitwise_PG //This module realizes the bitwise PG logic of Eq (11.5) and FIG 11.12.

  #(parameter N = 64) // The parameter "N" may be edited to change bit count.

   (output logic [N:1] P, G, //N-bit Propagate and Generate signals.
    input logic [N:1] A, B); //Two N-bit input words.

    assign G = A&B; //Bitwise AND of inputs A and B, Eq. (11.5).
    assign P = A^B; //Bitwise XOR of inputs A and B, Eq. (11.5).

endmodule

module N_Bit_Group_PG //This module realizes the group PG logic of Eq (11.10) and FIG 11.14.

  #(parameter N = 64) // The parameter "N" may be edited to change bit count.
   
   (output logic [(N-1):1] GG, //N-1 group generate signals that are output to sum logic.
    input logic [(N-1):1] G, P, //PG inputs from bitwise PG logic.
    input logic Cin); //1-bit carry in.

     always_comb
      begin:GPG1 //Named group. Can have local variables, i.e. "i".
       integer i;
       GG[1] = G[1] | P[1]&Cin;//Eq. (11.10).
        for (i=2; i<=(N-1); i=i+1) //Loop saves having to write N-2 more "GG" assignment statements.
         GG[i] = G[i] | P[i]&GG[(i-1)]; //Eq. (11.10).
      end

endmodule

module N_Bit_Sum_Logic //This module realizes the sum logic of Eq. (11.7) and FIG 11.14.

  #(parameter N = 64) // The parameter "N" may be edited to change bit count.

   (output logic Cout, //1-bit carry out.
    output logic [N:1] S, //N-bit sum.
    input logic GN, //Most significant group generate bit.
    input logic [(N-1):0] C, //The carry signals from the group PG logic are also the group gernerate signals
                             //(see pg. 437).
    input logic [N:1] P); //P inputs from bitwise PG logic.

    assign S = P^C; //Eq. (11.7).
    assign Cout = GN | P[N]&C[(N-1)]; //Eq. (11.11).

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
