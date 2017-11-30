module shift_mult (input logic clk, reset, 
				   input logic [31:0] Y, X,
				   output logic [63:0] product);
		
reg [4:0] count;
logic [2:0] x, x0;
logic [63:0] PP, hold;
logic enable;
parameter zero = 0, one = 1, two = 2, three = 3, four = 4;
parameter five = 5, six = 6, seven = 7, eight = 8;
parameter nine = 9, ten = 10, eleven = 11, twelve = 12;
parameter thirteen = 13, fourteen = 14, fifteen = 15, sixteen = 16;
assign x0 = {X[2:1], 1'b0};
// Booth encoder/selector
sel_encoder pp (
				.X(x),
				.Y(Y),
				.PP(PP)
				);

// 64 bit register used to store result				
reg64 add1(
			.reset(reset),
			.clk(clk),
			.enable(enable),
			.D(PP),
			.Q(product)
			);

always @(count)
	begin
		case(count)
			zero:
				begin
				x = x0;
				enable = 1'b0; 
				end
			one:
				x = X[3:1];
			two:
				x = X[5:3];
			three:
				x = X[7:5];
			four:
				x = X[9:7];
			five:
				x = X[11:9];
			six:
				x = X[13:11];
			seven:
				x = X[15:13];
			eight:
				x = X[17:15];
			nine:
				x = X[19:17];
			ten:
				x = X[21:19];
			eleven:
				x = X[23:21];
			twelve:
				x = X[25:23];
			thirteen:
				x = X[27:25];
			fourteen:
				x = X[29:27];
			fifteen:
				x = X[31:29];
			sixteen:
				begin
				x = {2'b00, X[31]};
				enable = 1'b1;
				end
				
		endcase
	end // end always
			
			
always @(posedge clk or posedge reset)
	begin
		if(reset)
			count = zero;
		else
			case(count)
				zero:
					count = one;
				one:
					count = two;
				two:
					count = three;
				three:
					count = four;
				four:
					count = five;
				five:
					count = six;
				six:
					count = seven;
				seven:
					count = eight;
				eight:
					count = nine;
				nine:
					count = ten;
				ten:
					count = eleven;
				eleven:
					count = twelve;
				twelve:
					count = thirteen;
				thirteen:
					count = fourteen;
				fourteen:
					count = fifteen;
				fifteen:
					count = sixteen;
				sixteen:
					count = sixteen;
				endcase
	end //end always
			
	

endmodule

//From figure 11.80 on p. 482
module sel_encoder (input logic [2:0] X, 
					input logic [31:0] Y,
					output logic [63:0] PP);
			
			// Booth Encoder
			logic single, double, neg, x_minus, x, x_plus;
			logic nand1, nand2;
			
			assign x_minus = X[0];
			assign x = X[1];
			assign x_plus = X[1];
			
			nand3 gate1 (
				.in1	( x_minus ), // input
				.in2	( ~x      ), // input
				.in3 	( ~x_plus ), // input
				.out    ( nand1   )  // output
				);
			
			nand3 gate2 (
				.in1	( ~x_minus ), // input
				.in2	( ~x       ), // input
				.in3 	( x_plus   ), // input
				.out    ( nand2    )  // output
				);
			
			assign single = x_minus ^ x;
			
			assign double = ~(nand1 & nand2);
			
			assign neg = x_plus;
			
			// Booth Selector
			logic extend; // Sign extension
			logic [31:0] Y_intermediate; // Y output of encoder
			
			assign extend = neg ^ Y[31];

			assign Y_intermediate = (((single & Y) | (double & (Y << 1))) ^ neg);
			assign PP[0] = neg;
			assign PP[1] = 1'b0;
			assign PP[33:2] = Y_intermediate;
			assign PP[63:34] = extend;
			
endmodule

//Three input NAND gate because Verilog sucks balls
module nand3 (input logic in1, in2, in3,
			  output logic out);
			  
			  logic intermediate;
			  assign intermediate = ~(in1 & in2);
			  assign out = ~(intermediate & in3);
endmodule

module reg64 (input logic reset, clk, enable, 
			 input logic [63:0] D, 
			 output logic [63:0] Q);

logic [63:0] A;

always @(posedge clk)
	if(enable)
	begin
		if(reset)
			begin
				Q <= 0;
				A <= 0;
			end
		else
			begin
				Q <= D + A;
				A <= D;
			end
	end

endmodule 