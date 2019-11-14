// Part 2 skeleton
module datapath(
	input [6:0] data_in,
	input clk,
	input resetn,
	input loadx,
	input [2:0] color,
	input [3:0] ctrl, // the 4-bit X | Y split input
	output reg [7:0] X,
	output reg [6:0] Y,
	output [2:0] color_out);

	// at posedge
	always @(posedge clk) begin
		// active low
		if (!resetn) begin
			X <= 8'd0;
			Y <= 7'd0;
		end
		else begin
			if (loadx)
				// concatenate
				X <= { 1'b0, data_in } + { 6'b0000_00, ctrl[3:2] };
			else
				Y <= data_in + { 5'b0000_0, ctrl[1:0] }; 
		end
	end

	assign color_out = color;
endmodule

module control(
	input go,
	input resetn,
	input clk,
	output reg [3:0] ctrl,
	output reg plot);

	reg [4:0] current_state;
	reg [4:0] next_state;

	localparam S_WAIT = 5'd0, // 5 bits
				S_W_WAIT = 5'd1,
				S_CYCLE_0 = 5'd2,
				S_CYCLE_1 = 5'd3,
				S_CYCLE_2 = 5'd4,
				S_CYCLE_3 = 5'd5,
				S_CYCLE_4 = 5'd6,
				S_CYCLE_5 = 5'd7,
				S_CYCLE_6 = 5'd8,
				S_CYCLE_7 = 5'd9,
				S_CYCLE_8 = 5'd10,
				S_CYCLE_9 = 5'd11,
				S_CYCLE_10 = 5'd12,
				S_CYCLE_11 = 5'd13,
				S_CYCLE_12 = 5'd14,
				S_CYCLE_13 = 5'd15,
				S_CYCLE_14 = 5'd16,
				S_CYCLE_15 = 5'd17;

	// state table
	always @(*) begin
		case (current_state)
			S_WAIT: next_state = go ? S_W_WAIT : S_WAIT;
			S_W_WAIT: next_state = go ? S_W_WAIT : S_CYCLE_0;
			S_CYCLE_0: next_state = S_CYCLE_1;
			S_CYCLE_1: next_state = S_CYCLE_2;
			S_CYCLE_2: next_state = S_CYCLE_3;
			S_CYCLE_3: next_state = S_CYCLE_4;
			S_CYCLE_4: next_state = S_CYCLE_5;
			S_CYCLE_5: next_state = S_CYCLE_6;
			S_CYCLE_6: next_state = S_CYCLE_7;
			S_CYCLE_7: next_state = S_CYCLE_8;
			S_CYCLE_8: next_state = S_CYCLE_9;
			S_CYCLE_9: next_state = S_CYCLE_10;
			S_CYCLE_10: next_state = S_CYCLE_11;
			S_CYCLE_11: next_state = S_CYCLE_12;
			S_CYCLE_12: next_state = S_CYCLE_13;
			S_CYCLE_13: next_state = S_CYCLE_14;
			S_CYCLE_14: next_state = S_CYCLE_15;
			S_CYCLE_15: next_state = S_WAIT;
			default: next_state = S_WAIT;
		endcase
	end

	// output logic
	always @(*) begin
		ctrl = 0;
		plot = 0;
		case (current_state)
			S_CYCLE_0: begin
				ctrl = 4'b0000;
				plot = 1'b1;
			end
			S_CYCLE_1: begin
				ctrl = 4'b0001;
				plot = 1'b1;
			end
			S_CYCLE_2: begin
				ctrl = 4'b0010;
				plot = 1'b1;
			end
			S_CYCLE_3: begin
				ctrl = 4'b0011;
				plot = 1'b1;
			end
			S_CYCLE_4: begin
				ctrl = 4'b0100;
				plot = 1'b1;
			end
			S_CYCLE_5: begin
				ctrl = 4'b0101;
				plot = 1'b1;
			end
			S_CYCLE_6: begin
				ctrl = 4'b0110;
				plot = 1'b1;
			end
			S_CYCLE_7: begin
				ctrl = 4'b0111;
				plot = 1'b1;
			end
			S_CYCLE_8: begin
				ctrl = 4'b1000;
				plot = 1'b1;
			end
			S_CYCLE_9: begin
				ctrl = 4'b1001;
				plot = 1'b1;
			end
			S_CYCLE_10: begin
				ctrl = 4'b1010;
				plot = 1'b1;
			end
			S_CYCLE_11: begin
				ctrl = 4'b1011;
				plot = 1'b1;
			end
			S_CYCLE_12: begin
				ctrl = 4'b1100;
				plot = 1'b1;
			end
			S_CYCLE_13: begin
				ctrl = 4'b1101;
				plot = 1'b1;
			end
			S_CYCLE_14: begin
				ctrl = 4'b1110;
				plot = 1'b1;
			end
			S_CYCLE_15: begin
				ctrl = 4'b1111;
				plot = 1'b1;
			end
		endcase
	end

	always @(posedge clk) begin
		if (!resetn)
			current_state <= S_WAIT;
		else
			current_state <= next_state;
	end
endmodule

module part2
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
	wire [3:0] control_signal;

    // Instansiate datapath
	datapath d0(
		.clk(CLOCK_50),
		.resetn(resetn),
		.loadx(~KEY[3]),
		.data_in(SW[6:0]),
		.color(SW[9:7]),
		.ctrl(control_signal),
		.X(x),
		.Y(y),
		.color_out(colour)
	);

    // Instansiate FSM control
    control c0(
		.clk(CLOCK_50),
		.resetn(resetn),
		.go(~KEY[1]),
		.ctrl(control_signal),
		.plot(writeEn)
	);
    
endmodule
