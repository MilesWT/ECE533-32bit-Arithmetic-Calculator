module divider 

    /*
    Code for divider adapted from
    http://verilogcodes.blogspot.com/2015/11/synthesisable-verilog-code-for-division.html
    Written by Vipin Lal: https://plus.google.com/101203706428430388905
    */

    //the size of input and output ports of the division module is generic.
    #(parameter N = 32)
	
	(input logic [N-1:0] A, B, 
	 output logic [N-1:0] quotient
	 output logic [N-1:0] remainder);

    //internal variablesc
    logic [N-1:0] a1, b1;
    logic [N:0] p1;
	logic [N-1:0] result = 0;
    integer i;

    always@ (A or B)
    begin
        //initialize the variables.
        a1 = A;
        b1 = B;
        p1 = 0;
        for(i = 0; i < N; i = i+1)
        begin //start the for loop
            p1 = {p1[N-2:0], a1[N-1]};
            a1[N-1:1] = a1[N-2:0];
            p1 = p1 - b1;
            if(p1[N-1] == 1)
            begin
                a1[0] = 0;
                p1 = p1 + b1;
            end
            else
                a1[0] = 1;
        end
        result = a1;
    end
	assign quotient = result;
	assign p1 = remainder;
    /////////
    // a1 = A;
    // b1 = B;
    // p1 = 0;
    // P = N
    // D = D << n            //-- P and D need twice the word width of N and Q
    // for (i = N-1; i >= 0, i = i-1) //-- for example 31..0 for 32 bits
    // begin
    //     if (P >= 0)
    //     begin
    //         q[i] = +1;
    //         P = 2 * P - D;
    //     end
    //     else
    //     begin
    //         q[i] = -1;
    //         P = 2 * P + D;
    //     end
    // end
    
    // //-- Note: N=Numerator, D=Denominator, n=#bits, P=Partial remainder, q(i)=bit #i of quotient.
    

endmodule




module testbench_division;


    parameter N = 32;
    // Inputs
    logic [N-1:0] A;
    logic [N-1:0] B;
    // Outputs
    logic [N-1:0] Res;

    
    divider DUT (
        .A   ( A   ), 
        .B   ( B   ), 
        .quotient ( Res )
    );

    initial begin
        // Initialize Inputs and wait for 100 ns
        A = 0;  B = 0;
        #100;  //Undefined inputs
        //Apply each set of inputs and wait for 100 ns.
        A = 100; B = 10;
        #100;
        A = 200; B = 40;
        #100;
        A = 90; B = 9;
        #100;
        A = 70; B = 10;
        #100;
        A = 16; B = 3;
        #100;
        A = 255; B = 5;
        #100;
    end

endmodule
