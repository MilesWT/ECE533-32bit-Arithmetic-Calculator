module shift_mult (input logic clk, reset, enable,
				   input logic [31:0] Y, X,
				   output logic [63:0] product
				   );
		

logic [2:0] x, x0, x1, x15;
//logic [4:0] count;
logic [63:0] PP;


parameter zero = 5'b00000, one = 5'b00001, two = 5'b00010, three = 5'b00011, four = 5'b00100;
parameter five = 5'b00101, six = 5'b00110, seven = 5'b00111, eight = 5'b01000;
parameter nine = 5'b01001, ten = 5'b01010, eleven = 5'b01011, twelve = 5'b01100;
parameter thirteen = 5'b01101, fourteen = 5'b01110, fifteen = 5'b01111, sixteen = 5'b10000;
parameter start = 5'b11111, finish = 5'b10001, ready = 5'b11110;
assign x0 = {X[1:0], 1'b0};
assign x15 = {2'b0, X[31]};

// Booth encoder/selector
sel_encoder pp (
				.X(x),
				.Y(Y),
				.PP(PP)
				);

// 64 bit register used to store result,
// Adds input to current value			
reg64 add1(
			.reset(reset),
			.clk(clk),
			.enable(enable),
			.D(hold),
			.Q(product)
			);
// State machine defines shift size of partial product
// Rotates the x value going into booth encoder, and shifts
// partial product to align for addition in addition register
always @(count)
	begin
		case(count)
		// Start in a known state to avoid XXXXX in test bench
			ready:
				begin
				x = 0;
				hold = 0;
				end
			start:
				begin
				x = x0;
				hold = PP;
				end
			zero:
				begin
				x = X[3:1];
				hold = PP; // Partial product is one clock behind x value
				end
			one:
				begin
				x = X[5:3];
				hold = PP << 2 ;
				end
			two:
				begin 
				x = X[7:5];
				hold = PP << 4 ;
				end
			three:
				begin
				x = X[9:7];
				hold = PP << 6 ;
				end
			four:
				begin
				x = X[11:9];
				hold = PP << 8 ;
				end
			five:
				begin
				x = X[13:11];
				hold = PP << 10 ;
				end
			six:
				begin
				x = X[15:13];
				hold = PP << 12 ;
				end
			seven:
				begin
				x = X[17:15];
				hold = PP << 14 ;
				end
			eight:
				begin
				x = X[19:17];
				hold = PP << 16 ;
				end
			nine:
				begin
				x = X[21:19];
				hold = PP << 18 ;
				end
			ten:
				begin
				x = X[23:21];
				hold = PP << 20 ;
				end
			eleven:
				begin
				x = X[25:23];
				hold = PP << 22 ;
				end
			twelve:
				begin
				x = X[27:25];
				hold = PP << 24  ;
				end
			thirteen:
				begin
				x = X[29:27];
				hold = PP << 26;
				end
			fourteen:
				begin
				x = X[31:29];
				hold = PP << 28 ;
				end
			fifteen:
				begin
				x = x15;
				hold = PP << 30 ;
				end
			sixteen:
				begin
				x = 3'b0;
				hold = PP << 32 ;
				end
			finish:
				begin
				x = 3'b0;
				hold = 0;
				end
		endcase
	end // end always
			
// State machine state selector
always @(posedge clk or posedge reset)
	begin
		if(reset)
			count = ready;
		else
			case(count)
				ready:
					count = start;
				start:
					count = zero;
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
					count = finish;
				finish:
					count = finish;
				endcase
	end //end always
			
endmodule

//From figure 11.80 on p. 482
module sel_encoder (input logic [2:0] X,
					input logic [31:0] Y,
					output logic [63:0] PP
					);
			
			logic [2:0] sel1;
			assign sel = sel1;
			encoder encode (
							.X(X),
							.sel(sel1)
							);
			
			selector select (
							.Y(Y),
							.sel(sel1),
							.PP(PP)
							);
endmodule

module encoder (input logic [2:0] X, 
				output logic [2:0] sel);
			
			// Booth Encoder
			logic single, double, neg, x_minus, x, x_plus;
			logic and1, and2;
			
			assign x_minus = X[0];
			assign x = X[1];
			assign x_plus = X[2];
			
			assign and1 = x_minus & x & (~x_plus);
			assign and2 = (~x_minus) & (~x) & x_plus;
			
			assign single = x_minus ^ x;
			
			assign double = and1 | and2;
			
			assign neg = x_plus;
			assign sel = {single, double, neg};
endmodule

module selector (input logic [31:0] Y,
				 input logic [2:0] sel,
				 output logic [63:0] PP);
				 
			// Booth Selector
			logic [31:0] single, double, neg, Yshift, and1, and2, or1, two;
			logic [31:0] extend_full;
			logic extend; // Sign extension
			
			assign single = {32{sel[2]}};
			assign double = {32{sel[1]}};
			assign neg = {32{sel[0]}};
			
			assign extend = neg[0] ^ Y[31];
			assign extend_full = {32{extend}};
			
			assign and1 = Y & single;
			assign Yshift = Y << 1;
			assign and2 = Yshift & double;
			
			assign or1 = and1 | and2;
			assign two = (or1 ^ neg) + neg[0];
			
			// Inefficient to do this, but trees are hard yo
			// Fill partial product with sign bits out to 64
			assign PP[63:0] = {extend_full, two};
			
			
endmodule

// Addition register for serial addition
module reg64 (input logic reset, clk, enable, 
			 input logic [63:0] D, 
			 output logic [63:0] Q);


always @(posedge clk)
	begin
		if(reset)
			begin
				Q <= 0;

			end
		else
			begin
				if(enable)
					begin
						Q <= Q + D;
					end
		end
	end

endmodule 

// Test bench
module shift_tb();
	logic clk, rst, enable;
	logic [31:0] Y, X;
	logic [63:0] product, hold;
	//logic [63:0] add1, add2, sum1, add3, sum2, add4, sum3;
	logic [4:0] count;

	
	shift_mult DUT(
		.clk(clk),
		.reset(rst),
		.enable(enable),
		.Y(Y),
		.X(X),
		.product(product),
		.hold(hold),
		.count(count)
		);
		
	initial begin 
		clk = 1'b0;
		forever #50 clk = ~clk;
	end
	
	initial begin
		rst = 1'b1;
		enable = 1'b0;
		
		//Problem from book
		//Y = 32'b0000_0000_0000_0000_0000_0000_0001_1001;
		//X = 32'b0000_0000_0000_0000_0000_0000_0010_0111;
		
		Y = 32'b0000_0000_0000_0000_0000_0000_0000_0010;
		X = 32'b1100_0000_0000_0000_0000_0000_0000_0000;
		
		//Problem from book with intermediate steps calculated
		/*
		add1 = 64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1110_0111;
		add2 = 64'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1100_1000; 
		sum1 =  add1 + add2;
		add3 = 64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100_1110_0000;
		sum2 = add3 + sum1;
		add4 = 64'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0110_0100_0000;
		sum3 = add4 + sum2;
		*/
		
		#50 enable = 1'b1;
		#50 rst = 1'b0;
		#3500 $finish;
	end
endmodule