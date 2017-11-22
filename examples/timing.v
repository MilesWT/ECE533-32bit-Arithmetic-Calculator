module timing_example;
   logic a, b, c, d, e;
   initial
     begin
       a = 1;
       b = 0;
       c = 1;
       # 10 d = 1'b0;
       # 5 c = d;
       # 5 e = b;
     end
   initial
     begin
       $display("         T a b c d e");
       $monitor($stime,, a,, b,, c,, d,, e);
     end
endmodule
