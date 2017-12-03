module N_Bit_Kogge_Stone_Adder //Top level 

  #(parameter N = 32) 

   (input logic [N:1] A, B, //Two N-bit input words.
    input logic Cin, //1-bit carry in.
    output logic [N:1] S, //N-bit sum.
    output logic Cout); //1-bit carry out.

  wire [N:1] P, G; //Wires for the N bitwise PG signals. 
  wire [(N-1):1] C; //Wires for the N-1 carry signals.
  

    N_Bit_Bitwise_PG BPG1 (P, G, A, B); 
    N_Bit_Group_PG GPG1 (C, G[(N-1):1], P[(N-1):1], Cin); 
    N_Bit_Sum_Logic SL1 (Cout, S, G[N], {C,Cin}, P); 

endmodule



module N_Bit_Bitwise_PG //This module realizes the bitwise PG logic 

  #(parameter N = 32) 

   (output logic [N:1] P, G, //N-bit Propagate and Generate signals.
    input logic [N:1] A, B); //Two N-bit input words.

    assign G = A&B; //Bitwise AND of inputs A and B, Eq. (11.5).
    assign P = A^B; //Bitwise XOR of inputs A and B, Eq. (11.5).

endmodule






module N_Bit_Group_PG //This module realizes the group PG logic of Eq (11.10) and FIG 11.14.

  #(parameter N = 32) // The parameter "N" may be edited to change bit count.
   
   (output logic [(N-1):1] GG, //N-1 group generate signals that are output to sum logic.
    input logic [N:1] G, P, //PG inputs from bitwise PG logic.
    input logic Cin); //1-bit carry in.
	
    wire [N:2] P1, G1;
    wire [N:4] P2, G2;
    wire [N:8] P3, G3;
    wire [N:16] P4, G4;
   
  
	assign GG[1] = G[1] | P[1]&Cin;

    genvar i;
    generate
	    	for (i=2; i<=(N-1); i=i+1) begin : flops1
	      		Black_cell Black_first ( P[i-1], G[i-1], P[i], G[i], G1[i], P1[i] );
	    	end


		assign GG[2] = G1[2] | (P1[2] & Cin);
		assign GG[3] = G1[3] | P1[3]&GG[1];
		for (i=4; i<=(N-1); i=i+1) begin : flops2
	      		Black_cell Black_second ( P1[i-2], G1[i-2], P1[i], G1[i], G2[i], P2[i] );
	    	end
		
		assign GG[4] = G2[4] | P2[4]&Cin;
		assign GG[5] = G2[5] | P2[5]&GG[1];
		assign GG[6] = G2[6] | P2[6]&GG[2];
		assign GG[7] = G2[7] | P2[7]&GG[3];
		for (i=8; i<=(N-1); i=i+1) begin : flops3
	      		Black_cell Black_third ( P2[i-4], G2[i-4], P2[i], G2[i], G3[i], P3[i] );
	    	end

	    	assign GG[8] = G3[8] | P3[8]&Cin;
		assign GG[9] = G3[9] | P3[9]&GG[1];
		assign GG[10] = G3[10] | P3[10]&GG[2];
		assign GG[11] = G3[11] | P3[11]&GG[3];
		assign GG[12] = G3[12] | P3[12]&GG[4];
		assign GG[13] = G3[13] | P3[13]&GG[5];
		assign GG[14] = G3[14] | P3[14]&GG[6];
		assign GG[15] = G3[15] | P3[15]&GG[7];
		for (i=16; i<=(N-1); i=i+1) begin : flops4
	      		Black_cell Black_fourth ( P3[i-8], G3[i-8], P3[i], G3[i], G4[i], P4[i] );
	    	end
		
		assign GG[16] = G4[16] | P4[16]&Cin;
		assign GG[17] = G4[17] | P4[17]&GG[1];
		assign GG[18] = G4[18] | P4[18]&GG[2];
		assign GG[19] = G4[19] | P4[19]&GG[3];
		assign GG[20] = G4[20] | P4[20]&GG[4];
		assign GG[21] = G4[21] | P4[21]&GG[5];
		assign GG[22] = G4[22] | P4[22]&GG[6];
		assign GG[23] = G4[23] | P4[23]&GG[7];
		assign GG[24] = G4[24] | P4[24]&GG[8];
		assign GG[25] = G4[25] | P4[25]&GG[9];
		assign GG[26] = G4[26] | P4[26]&GG[10];
		assign GG[27] = G4[27] | P4[27]&GG[11];
		assign GG[28] = G4[28] | P4[28]&GG[12];
		assign GG[29] = G4[29] | P4[29]&GG[13];
		assign GG[30] = G4[30] | P4[30]&GG[14];
		assign GG[31] = G4[31] | P4[31]&GG[15];
		

	      endgenerate

 	


endmodule






module Black_cell (input Pkj, input Gkj, input Pik, input Gik, output G, output P);

	assign G = (Gik | (Gkj & Pik));
	assign P = Pik & Pkj;

endmodule
 


module N_Bit_Sum_Logic //This module realizes the sum logic of Eq. (11.7) and FIG 11.14.

  #(parameter N = 32) // The parameter "N" may be edited to change bit count.

   (output logic Cout, //1-bit carry out.
    output logic [N:1] S, //N-bit sum.
    input logic GN, //Most significant group generate bit.
    input logic [(N-1):0] C, //The carry signals from the group PG logic are also the group gernerate signals
                             //(see pg. 437).
    input logic [N:1] P);
    
    
    assign S = P^C; //Eq. (11.7).
    //assign test = C[8];
    assign Cout = GN | P[N]&C[(N-1)]; //Eq. (11.11).

endmodule


module test

  #(parameter N = 32); // The parameter "N" may be edited to change bit count.

  logic [N:1] A, B, S;
  logic Cin, Cout;
 

  N_Bit_Kogge_Stone_Adder A1 (A,B,Cin,S,Cout);

  initial
    begin
     A = 0; B = 0; Cin = 0;
     #2 A   = 32'd4294967295;
     #2 B   = 32'd1;
     #2 Cin = 1'b1;
     #6 $finish;
    end


endmodule









