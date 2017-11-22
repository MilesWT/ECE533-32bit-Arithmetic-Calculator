module test_mux; //test bench for mux.
  logic a, b, select, out;
  mux mux_1(a, b, select, out); // instantiate the mux module.
  initial
   begin
    #2; select = 0; 
    #2; a = 0; 
    #1; a = 1;
    #1; b = 0;
    #2; select = 1'bx;
    #2; select = 1'bz;
    #2; select = 1;
    #3; b = 1;
    #2 $finish;
  end
endmodule: test_mux

module mux (input logic a, b, mux_select, //the actual mux.
           output logic mux_output);
  always_comb
   begin
    case(mux_select)
       0: mux_output = a;
       1: mux_output = b;
       default mux_output = 1'bx;
    endcase
   end
endmodule: mux
    
