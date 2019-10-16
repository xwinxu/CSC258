module rateDivider(input clock, input [25:0] load, input reset_n, output enable);
    reg [25:0] rate;
    reg [25:0] q;
    // output register
    reg regenable;

    always @(posedge clock) begin
        if (reset_n == 0) begin
            q <= rate - 1; // count down from top
            regenable <= regenable;
        end
        else if (q == 1'b0) begin // finishe the cycle, reset it
            q <= rate - 1;
            regenable <= 0;
        end
        else if (q == 1'b1) begin // not finished cycle, reset it
            q <= q - 1; // decrement 
            regenable <= 1; // finishes on 50 M clock cycle
        end       
        else begin
            q <= q - 1;
            regenable <= regenable;
        end
    end

    // need th
    assign enable = regenable;
endmodule

// lookup table mux
module lookup(input [2:0] letter, output reg [15:0] sequence);
    always @(*) begin
        case (letter)
            // S
            3'b000: sequence = 16'b1010100000000000;
			// T
			3'b001: sequence = 16'b1110000000000000;
			// U
			3'b010: sequence = 16'b1110101000000000;
			// V
			3'b011: sequence = 16'b1110101010000000;
			// W
			3'b100: sequence = 16'b1110111010000000;
			// X
			3'b101: sequence = 16'b1110101011100000;
			// Y
			3'b110: sequence = 16'b1110111010111000;
			// Z
			3'b111: sequence = 16'b1010111011100000;
        endcase
    end
endmodule

// 16-bit bit shifter module
module bitShifter(input clock, input reset_n, input in, input [15:0] loadVal, input shift, input load_n, output q);
    reg [15:0] loadVal;
    
    // instantiate 16x
    wire [15:0] sout; // output of the shift

    // first one, has leading zeros since each output of prev is input of subsequent
    // shift is a dummy variable, not using it, it is just 1'b0
    subShifterBit s15(.clock(clock), .load(loadVal[15]), .in(in), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[15]));
    subShifterBit s14(.clock(clock), .load(loadVal[14]), .in(sout[15]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[14]));
    subShifterBit s13(.clock(clock), .load(loadVal[13]), .in(sout[14]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[13]));
    subShifterBit s12(.clock(clock), .load(loadVal[12]), .in(sout[13]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[12]));
    subShifterBit s11(.clock(clock), .load(loadVal[11]), .in(sout[12]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[11]));
    subShifterBit s10(.clock(clock), .load(loadVal[10]), .in(sout[11]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[10]));
    subShifterBit s9(.clock(clock), .load(loadVal[9]), .in(sout[10]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[9]));
    subShifterBit s8(.clock(clock), .load(loadVal[8]), .in(sout[9]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[8]));
    subShifterBit s7(.clock(clock), .load(loadVal[7]), .in(sout[8]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[7]));
    subShifterBit s6(.clock(clock), .load(loadVal[6]), .in(sout[7]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[6]));
    subShifterBit s5(.clock(clock), .load(loadVal[5]), .in(sout[6]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[5]));
    subShifterBit s4(.clock(clock), .load(loadVal[4]), .in(sout[5]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[4]));
    subShifterBit s3(.clock(clock), .load(loadVal[3]), .in(sout[4]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[3]));
    subShifterBit s2(.clock(clock), .load(loadVal[2]), .in(sout[3]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[2]));
    subShifterBit s1(.clock(clock), .load(loadVal[1]), .in(sout[2]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[1]));
    subShifterBit s0(.clock(clock), .load(loadVal[0]), .in(sout[1]), .reset(reset_n), .load_n(load_n), .shift(shift), .out(sout[0]));

    assign q = sout[0];
endmodule

module subShifterBit(input clock, input load, input in, input reset, input load_n, input shift, output out);
    wire m1;
    wire m2;
    wire mout; // dummy, will be 0

    mux2to1 mux1(.x(mout), .y(in), .s(shift), .m(m1)); // in is the input
    mux2to1 mux2(.x(load), .y(m1), .s(load_n), .m(m2)); // s is switch, load is the load val

    flipflop ff(.clk(clock), .reset_n(reset), .d(m2), .q(mout)); // d: value flip flop state

    assign out = mout;
endmodule

//2 to 1 multiplexer
    //x: selected when s is 0
    //y : selected when s is 1
    //s: select signal
    //m: output
module mux2to1(input x, input y, input s, output m);
    // y if s, else x, s is our load value
    assign m = s & y | ~s & x;
endmodule

//D flip flop (from lab4)
module flipflop(input clk, input reset_n, input d, output reg q);
	always @(posedge clk) begin
		if (reset_n == 1'b0)
			q <= 0;
		else 
			q <= d;
	end
endmodule

// top level module
module morse(input [9:0] SW, input [3:0] KEY, input CLOCK_50, output [9:0] LEDR);
    wire [15:0] morse;
    lookup lut(SW[2:0], morse); // SW[2:0] is the letter, KEY[1:0] is enable/reset 

    wire [15:0] rdOut; // LEDR[0]
    rateDivider rd(.clock(CLOCK_50), .load(25'b10111110101111000010000000), .reset_n(KEY[0]), .enable(rdOut));

    wire shift;
    assign shift = (rdOut == 0) ? 1 : 0;
    bitShifter bs(.clock(shift), .reset_n(KEY[0]), .in(1'b0), .loadVal(morse), .shift(1'b0), .load_n(KEY[1]), .q(LEDR[0]));
endmodule