//single bit shifter
module subShifterBit(load_val, load_n, clk, in, shift, reset_n, out);
	input load_val;
    input load_n;
    input clk;
    input in;
    input shift; 
    input reset_n;
	output out;
	
	wire mux1tomux2;
	wire mux2toff;
	wire ffout;
	
	mux2to1 mux1(.x(in), 
					 .y(ffout), 
					 .s(shift), 
					 .m(mux1tomux2));
					 
	mux2to1 mux1(.x(mux1tomux2), 
					 .y(load_val), 
					 .s(load_n), 
					 .m(mux2toff));
					 
	flipflop ff(.clock(clk), 
					.reset_n(reset_n), 
					.d(mux2toff), 
					.q(ffout));
	
	assign out = ffout;
endmodule

//2 to 1 multiplexer
module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
endmodule

//D flip flop
module flipflop(clock, reset_n, d, q);
	input clock;
    input reset_n; 
    input d;
	output q;
	
	always @(posedge clock)
	begin
		if (reset_n == 1'b0)
			q <= 0;
		else 
			q <= d;
	end
endmodule