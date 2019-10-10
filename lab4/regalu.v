// adder of 4 bits in verilog
module addFour(X, Y, C, overflow);
	input [3:0] X;
	input [3:0] Y;
	output [3:0] C;
	output overflow;
	assign {overflow, C} = X+Y;
endmodule

module fullAdder(A, B, cin, S, cout);
	input A, B, cin;                        
	output S, cout;                         
	assign cout = (A & B) | ((A ^ B) & cin);
	assign S = A ^ B ^ cin;                 
endmodule                                       

module fourBitAdder(A, B, cin, S, cout);
	input [3:0] A;
	input [3:0] B;
	input cin;
	
	output [3:0] S;
	output cout;

	wire c1;
	wire c2;
	wire c3;

	fullAdder fa1(
		.A(A[0]),
		.B(B[0]),
		.S(S[0]),
		.cin(cin),
		.cout(c1)
	);
	fullAdder fa2(
		.A(A[1]),
		.B(B[1]),
		.S(S[1]),
		.cin(c1),
		.cout(c2)
	);
	fullAdder fa3(
		.A(A[2]),
		.B(B[2]),
		.S(S[2]),
		.cin(c2),
		.cout(c3)
	);
	fullAdder fa4(
		.A(A[3]),
		.B(B[3]),
		.S(S[3]),
		.cin(c3),
		.cout(cout)
	);
endmodule

module alublock(ALUout, A, B, f);
	output reg [7:0] ALUout;
	input [3:0] A, B;
	input [2:0] f;

	wire [3:0] ab1;
	wire ab2;
endmodule

// seven segment decoder for use in ALU output
module sevenhex(hex, in);
    input [3:0] in;
    output [6:0] hex;

    assign hex[0] = (~in[0] & in[1] & ~in[2] & ~in[3]) | (in[0] & ~in[1] & in[2] & in[3]) | (in[0] & in[1] & ~in[2] & in[3]) | (~in[0] & ~in[1] & ~in[2] & in[3]);

    assign hex[1] = (in[0] & in[2] & in[3]) | (in[0] & in[1] & ~in[3]) | (~in[0] & in[1] & ~in[2] & in[3]) | (in[1] & in[2] & ~in[3]);

    assign hex[2] = (~in[0] & ~in[1] & in[2] & ~in[3]) | (in[0] & in[1] & ~in[3]) | (in[0] & in[1] & in[2]);

    assign hex[3] = (~in[1] & ~in[2] & in[3]) | (in[0] & ~in[1] & in[2] & ~in[3]) | (in[1] & in[2] & in[3]) | (~in[0] & in[1] & ~in[2] & ~in[3]);

    assign hex[4] = (~in[1] & ~in[2] & in[3]) | (~in[0] & in[1] & ~in[2]) | (~in[0] & in[3]);

    assign hex[5] = (~in[0] & ~in[1] & in[2]) | (~in[0] & ~in[1] & in[3]) | (in[0] & in[1] & ~in[2] & in[3]) | (~in[0] & in[2] & in[3]);

    assign hex[6] = (~in[0] & in[1] & in[2] & in[3]) | (in[0] & in[1] & ~in[2] & ~in[3]) | (~in[0] & ~in[1] & ~in[2]);

endmodule

// positive edge-triggered flip-flop with active-low, synchronous reset
module register(in, clock, reset_n, out);
	input [7:0] in;
	input clock;
	input reset_n;
	output reg [7:0] out;

	// triggered every time clock rises
	always @(posedge clock)
	begin
		// when reset_n is 0
		if (reset_n == 1'b0)
			// assignment with <= instead of =
			out <= 8'b00000000;
		else
			// store the value of in in out
			out <= in;
	end
endmodule

module innerAlu(clock, reset_n, func, data, Out);
	input clock;
	input reset_n;
	input [2:0] func;
	input [3:0] data;
	output [7:0] Out;

	// register
	wire [3:0] r;
	register r0(.in(Out),
				.clock(clock),
				.reset_n(reset_n),
				.out(r)
				);

	// A+1
	wire [3:0] w1;
	wire o1;
	fourBitAdder f1(.A(data), .B(4'b0001), .cin(1'b0), .S(w1), .cout(o1));

	// A+B
	wire [3:0] w2;
	wire o2;
	fourBitAdder f2(.A(data), .B(r[3:0]), .cin(1'b0), .S(w2), .cout(o2));
	// do the A+B addition
	wire [3:0] sum;
	wire outv;
	addFour sum4(.X(data), .Y(r[3:0]), .C(sum), .overflow(outv));

	always @(*)
	begin
		case (func[2:0])
			//A + 1
			3'b000: Out = {3'b000, addA2, addA1};
			//A + B (Using fourBitAdder)
			3'b001: Out = {3'b000, ab2, ab1};
			//A + B (Using verilog arithmetic)
			3'b010: Out = {3'b000, abvo, abv};
			//A XOR B in lower 4 bits, A OR B in higher 4
			3'b011: Out = {data | r[3:0], data ^ r[3:0]};
			//A and B reduction OR
			3'b100: Out = {7'b0000000, |(data|r[3:0])};
			//Left shift B by A bits
			3'b101: Out = (r[3:0] << data);
			//Right (logical) shift B by A bits
			3'b110: Out = (r[3:0] >> data);
			//A X B using verilog * operator
			3'b111: Out = data * r[3:0];
			//Display 0, can separate digits of 4
			default: Out = 8'b0000_0000;
		endcase
	end	
endmodule

module regalu(SW, LEDR, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [9:0] SW;
	input [2:0] KEY;
	output [7:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	wire [7:0] out;
	
	innerAlu alu1(.clock(KEY[0]),
				  .reset_n(SW[9]),
				  .func(SW[7:5]),
				  .data(SW[3:0]),
				  .Out(out)
				 );

	assign LEDR[7:0] = out;

	sevenhex h0(.in(SW[3:0]), .hex(HEX0));
	// display least-significant
	sevenhex h4(.in(out[3:0]), .hex(HEX4));
	// display most-significant
	sevenhex h5(.in(out[7:4]), .hex(HEX5));
	
	// hex1, hex2, hex3 should display nothing, turn them off
	assign HEX1[6:0] = 7'b111_1111;
	assign HEX2[6:0] = 7'b111_1111;
	assign HEX3[6:0] = 7'b111_1111;
	// sevenhex h1(.in(SW[7:4]), .hex(HEX2));
	// sevenhex h2(.in(4'b0000), .hex(HEX1));
	// sevenhex h3(.in(4'b0000), .hex(HEX1));

endmodule
