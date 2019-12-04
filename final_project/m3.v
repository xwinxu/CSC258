module m3
    (
        CLOCK_50,
        KEY,
        SW,
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,					//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
    );
    input           CLOCK_50;
    input   [1:0]   KEY;
    input   [3:0]   SW;

    output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;			//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]

    wire resetn;
    wire go;

    assign go = ~KEY[1];
    assign resetn = KEY[0];

    wire [2:0] colour;
    wire [7:0] x;
    wire [6:0] y;
    wire writeEn;

//    vga_adapter VGA(
//        .resetn(resetn),
//        .clock(CLOCK_50),
//        .colour(colour),
//        .x(x),
//        .y(y),
//        .plot(writeEn),
//        .VGA_R(VGA_R),
//        .VGA_G(VGA_G),
//        .VGA_B(VGA_B),
//        .VGA_HS(VGA_HS),
//        .VGA_VS(VGA_VS),
//        .VGA_BLANK(VGA_BLANK_N),
//        .VGA_SYNC(VGA_SYNC_N),
//        .VGA_CLK(VGA_CLK));
//    defparam VGA.RESOLUTION = "160x120";
//    defparam VGA.MONOCHROME = "FALSE";
//    defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
//    defparam VGA.BACKGROUND_IMAGE = "black.mif";

    wire [7:0] data_result;
    wire [3:0] digs, decoder_in, encoding;
    wire [5:0] braille;

    wire ld_dig;

    wire done;

    wire loop;
    
    wire load;
    wire draw;

    wire [7:0] x_in;
    wire [6:0] y_in;
    
    wire ld_a, ld_b, ld_x;
    wire ld_t;
    wire ld_c;
    wire ld_op;
    wire ld_q;
    wire ld_r, ld_r_r, ld_op_reg;
    wire [1:0] ld_r_reg, ld_op_reg_op;
    wire ld_alu_out;
    wire [2:0] alu_select_a, alu_select_b;
    wire [2:0] alu_op;


    vga_datapath vd0(
        .clk(CLOCK_50),
        .resetn(resetn),
        .load(load),
        .draw(draw),
        .x_in(x_in),
        .y_in(y_in),
        .braille(braille),
        .done(done),
        .x_out(x),
        .y_out(y),
        .clr_out(colour)
    );

    digs dig0(
        .data_result(data_result),
        .dig_num(dig_num),

        .dig(encoding)
    );

    datapath d0(
        .clk(clk),
        .resetn(resetn),

        .data_in(SW[3:0]),

        .ld_a(ld_a),
        .ld_b(ld_b),
        .ld_x(ld_x),

        .ld_t(ld_t),

        .ld_c(ld_c),

        .ld_op(ld_op),

        .ld_q(ld_q),

        .ld_r(ld_r),

        .ld_r_r(ld_r_r),

        .ld_op_reg(ld_op_reg),

        .ld_r_reg(ld_r_reg),

        .ld_op_reg_op(ld_op_reg_op),

        .ld_alu_out(ld_alu_out),

        .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),

        .alu_op(alu_op),

        .loop(loop),

        .data_result(data_result)
    );

    
    vga_control vc(
        .clk(CLOCK_50),
        .resetn(resetn),
        .go(go),

        .done(done),

        .loop(loop),

        .load(load),
        .draw(draw),
        
        .x_in(x_in),
        .y_in(y_in),

        .ld_a(ld_a),
        .ld_b(ld_b),
        .ld_x(ld_x),

        .ld_t(ld_t),

        .ld_c(ld_c),

        .ld_op(ld_op),

        .ld_q(ld_q),

        .ld_r(ld_r),

        .ld_r_r(ld_r_r),

        .ld_op_reg(ld_op_reg),

        .ld_r_reg(ld_r_reg),

        .ld_op_reg_op(ld_op_reg_op),

        .ld_alu_out(ld_alu_out),

        .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),

        .alu_op(alu_op),

        .ld_dig(ld_dig)
    );

    
    mux_digs md(
        .data_result(data_result),
        .encoding(encoding),
        .ld_dig(ld_dig),
        .decoder_in(decoder_in)
    );


    braille_decoder b0(
        .encoding(decoder_in),
        .decoding(braille)
    );

endmodule


module vga_control(
    input clk,
    input resetn,
    input go,

    input done,

    input loop,

    output reg load,
    output reg draw,

    output reg [7:0] x_in,
    output reg [6:0] y_in,

    output reg ld_a, ld_b, ld_x,
    output reg ld_t,
    output reg ld_c,
    output reg ld_op,
    output reg ld_q,
    output reg ld_r, ld_r_r, ld_op_reg,
    output reg [1:0] ld_r_reg,
    output reg [1:0] ld_op_reg_op,
    output reg ld_alu_out,
    output reg [2:0] alu_select_a, alu_select_b,
    output reg [2:0] alu_op,

    output reg ld_dig
    );

    reg [5:0] current_state, next_state;

    localparam  LD_A            = 6'd0,
                LD_A_WAIT       = 6'd1,
                DRAW_A          = 6'd2,
                DRAW_A_WAIT     = 6'd3,
                LD_B            = 6'd4,
                LD_B_WAIT       = 6'd5,
                DRAW_B          = 6'd6,
                DRAW_B_WAIT     = 6'd7,
                LD_OP           = 6'd8,
                LD_OP_WAIT      = 6'd9,
                DRAW_OP         = 6'd10,
                DRAW_OP_WAIT    = 6'd11,
                DRAW_EQ         = 6'd12,
                DRAW_EQ_WAIT    = 6'd13,
                ADD             = 6'd14,
                SUB             = 6'd15,
                MUL             = 6'd16,
                PRE_DIV         = 6'd17,
                DIV_0           = 6'd18,
                DIV_1           = 6'd19,
                DIV_2           = 6'd20,
                DIV_3           = 6'd21,
                DIV_4           = 6'd22,
                DIV_5           = 6'd23,
                DIV_6           = 6'd24,
                LD_DIV          = 6'd25,
                LD              = 6'd26,
                LD_R1           = 6'd27,
                DRAW_R1         = 6'd28,
                DRAW_R1_WAIT    = 6'd29,
                LD_R2           = 6'd30,
                DRAW_R2         = 6'd31,
                DRAW_R2_WAIT    = 6'd32;

    always @ (*) begin
        case(current_state)
            LD_A:           next_state = go     ? LD_A_WAIT     : LD_A;
            LD_A_WAIT:      next_state = go     ? LD_A_WAIT     : DRAW_A;
            DRAW_A:         next_state = DRAW_A_WAIT;
            DRAW_A_WAIT:    next_state = done   ? LD_B          : DRAW_A_WAIT;
            LD_B:           next_state = go     ? LD_B_WAIT     : LD_B;
            LD_B_WAIT:      next_state = go     ? LD_B_WAIT     : DRAW_B;
            DRAW_B:         next_state = DRAW_B_WAIT;
            DRAW_B_WAIT:    next_state = done   ? LD_OP         : DRAW_B_WAIT;
            LD_OP:          next_state = go     ? LD_OP_WAIT    : LD_OP;
            LD_OP_WAIT:     next_state = go     ? LD_OP_WAIT    : DRAW_OP;
            DRAW_OP:        next_state = DRAW_OP_WAIT;
            DRAW_OP_WAIT:   next_state = done   ? DRAW_EQ       : DRAW_OP_WAIT;
            DRAW_EQ:        next_state = DRAW_EQ_WAIT;
            DRAW_EQ_WAIT:   next_state = done   ? ADD           : DRAW_EQ_WAIT;
            ADD:            next_state = SUB;
            SUB:            next_state = MUL;
            MUL:            next_state = PRE_DIV;
            PRE_DIV:        next_state = DIV_0;
            DIV_0:          next_state = DIV_1;
            DIV_1:          next_state = DIV_2;
            DIV_2:          next_state = DIV_3;
            DIV_3:          next_state = DIV_4;
            DIV_4:          next_state = DIV_5;
            DIV_5:          next_state = DIV_6;
            DIV_6:          next_state = loop   ? DIV_0         : LD_DIV;
            LD_DIV:         next_state = LD;
            LD:             next_state = LD_R1;
            LD_R1:          next_state = DRAW_R1;
            DRAW_R1:        next_state = DRAW_R1_WAIT;
            DRAW_R1_WAIT:   next_state = done   ? LD_R2         : DRAW_R1_WAIT;
            LD_R2:          next_state = DRAW_R2;
            DRAW_R2:        next_state = DRAW_R2_WAIT;
            DRAW_R2_WAIT:   next_state = done   ? LD_A          : DRAW_R2_WAIT;
            default:        next_state = LD_A;
        endcase
    end

    localparam  A_X     = 8'd23,
                A_Y     = 7'd23,
                OP_X    = 8'd23 + 8'd16,
                OP_Y    = 7'd23,
                B_X     = 8'd23 + 8'd2 * 8'd16,
                B_Y     = 7'd23,
                EQ_X    = 8'd23 + 8'd3 * 8'd16,
                EQ_Y    = 7'd23,
                R1_X    = 8'd23 + 8'd4 * 8'd16,
                R1_Y    = 7'd23,
                R2_X    = 8'd23 + 8'd5 * 8'd16,
                R2_Y    = 7'd23;

    always @ (*) begin
        load            = 1'b0;
        draw            = 1'b0;

        x_in            = 8'b0;
        y_in            = 7'b0;
        
        ld_a            = 1'b0;
        ld_b            = 1'b0;
        ld_x            = 1'b0;
        
        ld_t            = 1'b0;

        ld_c            = 1'b0;

        ld_op           = 1'b0;

        ld_q            = 1'b0;

        ld_r            = 1'b0;
        ld_r_r          = 1'b0;
        ld_r_reg        = 2'b0;
        ld_op_reg       = 1'b0;
        
        ld_op_reg_op    = 2'b0;
        
        ld_alu_out      = 1'b0;
        
        alu_select_a    = 3'b0;
        alu_select_b    = 3'b0;

        alu_op          = 3'b0;

        ld_dig          = 1'b0;

        case (current_state)
            LD_A: begin
                ld_a        = 1'b1;
            end
            DRAW_A: begin
                // TODO: one clock cycle earlier?
                ld_r        = 1'b1;
                ld_r_r      = 1'b1;
                ld_r_reg    = 2'b00;

                load        = 1'b1;
                x_in        = A_X;
                y_in        = A_Y;
            end
            DRAW_A_WAIT: begin
                draw        = 1'b1;
            end
            LD_B: begin
                ld_b        = 1'b1;
            end
            DRAW_B: begin
                // TODO: one clock cycle earlier?
                ld_r        = 1'b1;
                ld_r_r      = 1'b1;
                ld_r_reg    = 2'b01;
                
                load        = 1'b1;
                x_in        = B_X;
                y_in        = B_Y;
            end
            DRAW_B_WAIT: begin
                draw        = 1'b1;
            end
            LD_OP: begin
                ld_op       = 1'b1;
            end
            DRAW_OP: begin
                // TODO: one clock cycle earlier?
                ld_r        = 1'b1;
                ld_r_r      = 1'b1;
                ld_r_reg    = 2'b10;

                load        = 1'b1;
                x_in        = OP_X;
                y_in        = OP_Y;
            end
            DRAW_OP_WAIT: begin
                draw        = 1'b1;
            end
            DRAW_EQ: begin                
                // TODO: one clock cycle earlier?
                ld_r        = 1'b1;
                ld_r_r      = 1'b1;
                ld_r_reg    = 2'b11;
                
                load        = 1'b1;
                x_in        = EQ_X;
                y_in        = EQ_Y;
            end
            DRAW_EQ_WAIT: begin
                draw        = 1'b1;
            end
            ADD: begin
                alu_select_a    = 3'd0;
                alu_select_b    = 3'd1;

                alu_op          = 3'd0;

                ld_op_reg       = 1'd1;
                ld_op_reg_op    = 2'd0;
            end
            SUB: begin
                alu_select_a    = 3'd0;
                alu_select_b    = 3'd1;

                alu_op          = 3'd1;

                ld_op_reg       = 1'd1;
                ld_op_reg_op    = 2'd1;
            end
            MUL: begin
                alu_select_a    = 3'd0;
                alu_select_b    = 3'd1;

                alu_op          = 3'd2;

                ld_op_reg       = 1'd1;
                ld_op_reg_op    = 2'd2;
            end
            PRE_DIV: begin
                ld_c            = 1'd1;  // set the clock counter to 0
            end
            DIV_0: begin
                alu_select_a    = 3'd2;
                alu_select_b    = 3'd0;

                alu_op          = 3'd3;

                ld_x            = 1'd1;
            end
            DIV_1: begin
                alu_select_a    = 3'd0;
                
                alu_op          = 3'd4;

                ld_alu_out      = 1'd1;
                ld_a            = 1'd1;
            end
            DIV_2: begin
                alu_select_a    = 3'd2;
                alu_select_b    = 3'd1;
                
                alu_op          = 3'd1;

                ld_x            = 1'd1;
            end
            DIV_3: begin
                alu_select_a    = 3'd2;

                alu_op          = 3'd5;

                ld_q            = 1'd1;
            end
            DIV_4: begin
                alu_select_a    = 3'd3;
                alu_select_b    = 3'd1;
                
                alu_op          = 3'd2;

                ld_t            = 1'd1;
            end
            DIV_5: begin
                alu_select_a    = 3'd2;
                alu_select_b    = 3'd4;

                alu_op          = 3'd0;

                ld_alu_out      = 1'd1;
                ld_x            = 1'd1;
            end
            DIV_6: begin
                alu_select_a    = 3'd0;
                alu_select_b    = 3'd3;

                alu_op          = 3'd6;

                ld_alu_out      = 1'd1;
                ld_a            = 1'd1;
            end
            LD_DIV: begin
                ld_op_reg       = 1'd1;
                ld_op_reg_op    = 2'd3;
            end 
            LD: begin
                ld_r            = 1'b1;
            end
            DRAW_R1: begin
                // TODO: ld_r_reg correctly?
                ld_dig          = 1'b1;
                load            = 1'b1;
                x_in            = R1_X;
                y_in            = R1_Y;
            end
            DRAW_R1_WAIT: begin
                draw            = 1'b1;
            end
            DRAW_R2: begin
                // TODO: ld_r_reg correctly?
                ld_dig          = 1'b1;
                load            = 1'b1;
                x_in            = R2_X;
                y_in            = R2_Y;
            end
            DRAW_R2_WAIT: begin
                draw            = 1'b1;
            end
        endcase
    end

    always @ (posedge clk) begin
        if (!resetn)
            current_state <= LD_A;
        else
            current_state <= next_state;
    end
endmodule


module vga_datapath(
    input clk,
    input resetn,
    input load,
    input draw,
    input [7:0] x_in,
    input [6:0] y_in,
    input [5:0] braille,
    
    output reg done,
    output [7:0] x_out,
    output [6:0] y_out,
    output reg [2:0] clr_out
    );
   
    localparam  BOX_SIZE    = 7'd8,     
                OFF_CLR     = 3'd0,         
                ON_CLR      = 3'd1;  

    // the x and y for the top left corner of the braille encoding
    reg [7:0] x_r;
    reg [6:0] y_r;
    
    // the x and y for which the offsets are calculated relative to
    reg [7:0] x_reg;
    reg [6:0] y_reg;

    // the x and y offsets
    reg [7:0] x_add;
    reg [6:0] y_add;

    // count which square we're on (don't do division)
    reg [2:0] sq;

    // count which pixel we're on in the current box
    reg [5:0] c;

    // get colour based on bits of braille
    reg [5:0] shift;
    reg clr_bit;

    always @ (posedge clk) begin
        if (!resetn) begin
            x_r <= 0;
            y_r <= 0;

            x_reg <= 0;
            y_reg <= 0;
            
            x_add <= 0;
            y_add <= 0;

            sq <= 0;
            c <= 0;

            shift <= 0;
            clr_bit <= 0;

            done <= 0;
        end
        else begin
            if (load) begin
                // draw a new braille encoding
                x_r <= x_in;
                y_r <= y_in;
                
                sq <= 0;
                c <= 0;
                
                // TODO: need to be synchronous?
                shift <= braille >> sq;
                clr_bit <= shift[0:0];

                done <= 0;
            end
            else if (draw) begin
                // TODO: modelsim for offby1!
                c <= c + 1;
                x_add <= {5'b00_000, c[2:0]};
                y_add <= {4'b00_00, c[5:3]};

                if (c == 6'd62) begin
                    // on this pos edge, we'll send a sig to draw the last pixel for the current box
                    
                    sq <= sq + 1;
                    x_reg <= x_r + {7'd0, sq[0:0]} * BOX_SIZE;
                    y_reg <= y_r + {5'd0, sq[2:1]} * BOX_SIZE; 
                    
                    if (sq == 3'd5)
                        done <= 1'd1;
                end
                
                // mux to get colour
                case (clr_bit) 
                    1'd0:   clr_out <= OFF_CLR;
                    1'd1:   clr_out <= ON_CLR;
                endcase
            end
        end
    end

    assign x_out = x_reg + x_add;
    assign y_out = y_reg + y_add;

endmodule


module datapath(
    input clk,
    input resetn,
    input [3:0] data_in,
    input ld_a, ld_b, ld_x, 
    input ld_t,
    input ld_c,
    input ld_op,
    input ld_q,
    input ld_r, ld_r_r, ld_op_reg,
    input [1:0] ld_r_reg,
    input [1:0] ld_op_reg_op, 
    input ld_alu_out,
    input [2:0] alu_select_a, alu_select_b,
    input [2:0] alu_op,
    output reg loop,
    output reg [7:0] data_result
    );

    // input registers
    reg [3:0] a, b, x;

    // special tmp reg for div
    reg [3:0] t;

    // count clock cycles for div
    reg [4:0] c;

    // op register
    reg [1:0] op;
    
    // special reg for div
    reg q;

    // output of the alu
    reg [7:0] alu_out;

    // op results
    reg [7:0] add, sub, mul, div;

    // alu input muxes
    reg [3:0] alu_a, alu_b;

    // load registers
    always @ (posedge clk) begin
        if (!resetn) begin
            a <= 4'd0;
            b <= 4'd0;
            x <= 4'd0;
            
            t <= 4'd0;

            c <= 5'd0;

            op <= 2'd0;
            
            q <= 1'd0;
        end
        else begin
            if (ld_a)
                a <= ld_alu_out ? alu_out[3:0] : data_in;
            if (ld_b)
                b <= data_in;
            if (ld_x)
                x <= alu_out[3:0];
            if (ld_op)
                op <= data_in[1:0];
            if (ld_q)
                q <= alu_out[3:3];
            if (ld_t)
                t <= alu_out[3:0];
            
            if (ld_c)
                c <= 5'd0;
            else
                c <= c + 5'd1; 
        end
    end

    // output result register
    always @ (posedge clk) begin
        if (!resetn) begin
            data_result <= 8'd0;
            
            add <= 8'd0;
            sub <= 8'd0;
            mul <= 8'd0;
            div <= 8'd0;

            loop <= 1'd0;
        end
        else begin
            if (ld_r) begin
                if (ld_r_r) begin
                    case (ld_r_reg)
                        2'b00: data_result <= {4'd0, a};
                        2'b01: data_result <= {4'd0, b};
                        2'b10: data_result <= {6'd0, op} + 8'd10; // OP, converted to our encoding
                        2'b11: data_result <= 8'd14; // EQ, converted to our encoding
                        default: data_result <= 8'd0;
                    endcase
                end
                else begin
                    case (op)
                        2'b00: data_result <= add;
                        2'b01: data_result <= sub;
                        2'b10: data_result <= mul;
                        2'b11: data_result <= div;
                    endcase
                end
            end
            if (ld_op_reg) begin
                case (ld_op_reg_op)
                    2'b00: add <= alu_out;
                    2'b01: sub <= alu_out;
                    2'b10: mul <= alu_out;
                    2'b11: div <= {4'd0, a};
                endcase
            end

            loop <= c < 5'd26;
        end
    end

    // The ALU input multiplexers
    always @(*)
    begin
        case (alu_select_a)
            3'd0:
                alu_a = a;
            3'd1:
                alu_a = b;
            3'd2:
                alu_a = x;
            3'd3:
                alu_a = {3'b000, q};
            3'd4:
                alu_a = t;
            default:
                alu_a = a;
        endcase

        case (alu_select_b)
            3'd0:
                alu_b = a;
            3'd1:
                alu_b = b;
            3'd2:
                alu_b = x;
            3'd3:
                alu_b = {3'b000, q};
            3'd4:
                alu_b = t;
            default:
                alu_b = a;
        endcase
    end

    // tmp reg for alu out
    reg [7:0] tmp;

    // The ALU
    always @(*)
    begin : ALU
        case (alu_op)
            3'd0:   alu_out = {4'd0, alu_a} + {4'd0, alu_b};
            3'd1:   alu_out = {4'd0, alu_a} - {4'd0, alu_b};
            3'd2:   alu_out = {4'd0, alu_a} * {4'd0, alu_b};
            3'd3:   
            begin
                    tmp = {alu_a, alu_b} << 1;
                    alu_out = {4'd0, tmp[7:4]}; 
            end
            3'd4:   alu_out = {4'd0, alu_a << 1};
            3'd5:   alu_out = {4'd0, alu_a};
            3'd6:   alu_out = {4'd0, alu_a[3:1], ~alu_b[0]};
        endcase
    end

endmodule


module digs(data_result, dig_num, dig);
    input [7:0] data_result;    // the number 
    input dig_num;              // which digit (1s or 10s)

    output reg [3:0] dig;           // the digit

    wire [7:0] m1, m2;

    assign m1 = data_result % 8'd10;
    assign m2 = (data_result / 8'd10) % 8'd10;  // in case it's three digs
    // TODO: will this synthesize to a lookup table? if not, hardcode it
    always @(*) begin
        case (dig_num)
            1'b0:   dig = m1[3:0];
            1'b1:   dig = m2[3:0];  
        endcase
    end

endmodule


module mux_digs(data_result, encoding, ld_dig, decoder_in);
    input [7:0] data_result;
    input [3:0] encoding;
    input ld_dig;

    output reg [3:0] decoder_in;

    always @(*) begin
        case(ld_dig)
            1'b0:   decoder_in = data_result[3:0];
            1'b1:   decoder_in = encoding;
        endcase
    end

endmodule


module braille_decoder(encoding, decoding);
    input [3:0] encoding;
    output reg [5:0] decoding;

    always @(*)
        case (encoding)
            // TODO: reverse raster scan
            // 1 if coloured in, raster scan order
            4'd0: decoding = 6'b00_0111;
            4'd1: decoding = 6'b00_1000;
            4'd2: decoding = 6'b00_1010;
            4'd3: decoding = 6'b00_1100;
            4'd4: decoding = 6'b00_1101;
            4'd5: decoding = 6'b00_1001;
            4'd6: decoding = 6'b00_1110;
            4'd7: decoding = 6'b00_1111;
            4'd8: decoding = 6'b00_1011;
            4'd9: decoding = 6'b00_0101;
            4'd10: decoding = 6'b01_0011;
            4'd11: decoding = 6'b00_0011;
            4'd12: decoding = 6'b10_0001;
            4'd13: decoding = 6'b01_0010;
            4'd14: decoding = 6'b11_1111;
        endcase
endmodule
