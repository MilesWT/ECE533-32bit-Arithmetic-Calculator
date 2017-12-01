module shift_mult (input logic clk, reset, 
				   input logic [31:0] Y, X,
				   output logic [63:0] product, hold,
				   input logic enable,
				   output logic [2:0] x,
				   output logic [4:0] count);
		
//reg [3:0] count;
logic [2:0] x, x0;
logic [63:0] PP ;//hold;
//logic enable;
parameter zero = 5'b00000, one = 5'b00001, two = 5'b00010, three = 5'b00011, four = 5'b00100;
parameter five = 5'b00101, six = 5'b00110, seven = 5'b00111, eight = 5'b01000;
parameter nine = 5'b01001, ten = 5'b01010, eleven = 5'b01011, twelve = 5'b01100;
parameter thirteen = 5'b01101, fourteen = 5'b01110, fifteen = 5'b01111, sixteen = 5'b10000;
parameter start = 5'b11111, finish = 5'b10001;
assign x0 = {X[1:0], 1'b0};
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
			.D(hold),
			.Q(product)
			);

always @(count)
	begin
		case(count)
			start:
				begin
				x = 3'b0;
				hold = 64'b0;
				end
			zero:
				begin
				x = X[3:1];
				hold = PP;
				//enable = 1'b1; 
				end
			one:
				begin
				x = X[3:1];
				hold = {PP[61:0], 2'b0};
				end
			two:
				begin 
				x = X[5:3];
				hold = {PP[59:0], 4'b0};
				end
			three:
				begin
				x = X[7:5];
				hold = {PP[57:0], 6'b0};
				end
			four:
				begin
				x = X[9:7];
				hold = {PP[55:0], 8'b0};
				end
			five:
				begin
				x = X[11:9];
				hold = {PP[53:0], 10'b0};
				end
			six:
				begin
				x = X[13:11];
				hold = {PP[51:0], 12'b0};
				end
			seven:
				begin
				x = X[15:13];
				hold = {PP[49:0], 14'b0};
				end
			eight:
				begin
				x = X[17:15];
				hold = {PP[47:0], 16'b0};
				end
			nine:
				begin
				x = X[19:17];
				hold = {PP[45:0], 18'b0};
				end
			ten:
				begin
				x = X[21:19];
				hold = {PP[43:0], 20'b0};
				end
			eleven:
				begin
				x = X[23:21];
				hold = {PP[41:0], 22'b0};
				end
			twelve:
				begin
				x = X[25:23];
				hold = {PP[39:0], 24'b0};
				end
			thirteen:
				begin
				x = X[27:25];
				hold = {PP[37:0], 26'b0};
				end
			fourteen:
				begin
				x = X[29:27];
				hold = {PP[35:0], 28'b0};
				end
			fifteen:
				begin
				x = X[31:29];
				hold = {PP[33:0], 30'b0};
				end
			sixteen:
				begin
				x = {2'b00, X[31]};
				hold = {PP[31:0], 32'b0};
				end
			finish:
				begin
				x = 3'b0;
				hold = 64'b0;
			end
		endcase
	end // end always
			
			
always @(posedge clk or posedge reset)
	begin
		if(reset)
			count = start;
		else
			case(count)
				start:
					count = zero;
				zero:
					count = 4'b0001;
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
					count = fifteen;
				sixteen:
					count = finish;
				finish:
					count = finish;
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
			assign x_plus = X[2];
			
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
			/*assign PP[0] = neg;
			assign PP[1] = 1'b0;
			assign PP[33:2] = Y_intermediate;
			assign PP[63:34] = extend;*/
			assign PP[31:0] =  Y_intermediate;
			assign PP[63:32] = 0'b0;
			
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
				Q <= (A + D);
				A <= D;
			end
	end

endmodule 

// Test bench
module shift_tb();
	logic clk, rst, enable;
	logic [31:0] Y, X;
	logic [63:0] product, hold;
	logic [4:0] count;
	logic [2:0] x;
	
	shift_mult DUT(
		.clk(clk),
		.reset(rst),
		.Y(Y),
		.X(X),
		.product(product),
		.enable(enable),
		.count(count),
		.hold(hold),
		.x(x)
		);
		
	initial begin 
		clk = 1'b0;
		forever #100 clk = ~clk;
	end
	
	initial begin
		enable = 1'b0;
		rst = 1'b1;
		Y = 32'h0000_0010;
		X = 32'h0000_0010;
		#100 enable = 1'b1; rst = 1'b0;
		#3000 $finish;
	end
endmodule