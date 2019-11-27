module m2(SW, KEY, CLOCK_50, LEDR);
    input [3:0] SW;
    input [1:0] KEY;
    input CLOCK_50;
    output [5:0] LEDR;

    wire resetn;
    wire go;

    wire [3:0] data_result;
    assign go = ~KEY[1];
    assign resetn = KEY[0];

    calc c0(
        .clk(CLOCK_50),
        .resetn(resetn),
        .go(go),
        .data_in(SW[3:0]),
        .data_result(data_result)
    );

    braille_decoder b0(
        .encoding(data_result[3:0]),
        .decoding(LEDR[5:0])
    );

endmodule


module calc(
    input clk,
    input resetn,
    input go,
    input [3:0] data_in,
    output [3:0] data_result
    );
  
    wire loop;

    wire ld_a, ld_b, ld_x;
    wire ld_t;
    wire ld_c;
    wire ld_op;
    wire ld_q;
    wire ld_r, ld_op_reg;
    wire [1:0] ld_op_reg_op;
    wire ld_alu_out;
    wire [2:0] alu_select_a, alu_select_b;
    wire [2:0] alu_op;

    control c0(
        .clk(clk),
        .resetn(resetn),

        .go(go),

        .loop(loop),

        .ld_a(ld_a),
        .ld_b(ld_b),
        .ld_x(ld_x),

        .ld_t(ld_t),

        .ld_c(ld_c),

        .ld_op(ld_op),

        .ld_q(ld_q),

        .ld_r(ld_r),

        .ld_op_reg(ld_op_reg),

        .ld_op_reg_op(ld_op_reg_op),

        .ld_alu_out(ld_alu_out),

        .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),

        .alu_op(alu_op)
    );

    datapath d0(
        .clk(clk),
        .resetn(resetn),

        .data_in(data_in),

        .ld_a(ld_a),
        .ld_b(ld_b),
        .ld_x(ld_x),

        .ld_t(ld_t),

        .ld_c(ld_c),

        .ld_op(ld_op),

        .ld_q(ld_q),

        .ld_r(ld_r),

        .ld_op_reg(ld_op_reg),

        .ld_op_reg_op(ld_op_reg_op),

        .ld_alu_out(ld_alu_out),

        .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),

        .alu_op(alu_op),

        .loop(loop),

        .data_result(data_result)
    );
endmodule


module control(
    input clk,
    input resetn,
    input go,

    input loop,

    output reg ld_a, ld_b, ld_x,
    output reg ld_t,
    output reg ld_c,
    output reg ld_op,
    output reg ld_q,
    output reg ld_r, ld_op_reg,
    output reg [1:0] ld_op_reg_op,
    output reg ld_alu_out,
    output reg [2:0] alu_select_a, alu_select_b,
    output reg [2:0] alu_op
    );

    reg [4:0] current_state, next_state;

    localparam  LD_A        = 5'd0,
                LD_A_WAIT   = 5'd1,
                LD_B        = 5'd2,
                LD_B_WAIT   = 5'd3,
                LD_OP       = 5'd4,
                LD_OP_WAIT  = 5'd5,
                ADD         = 5'd6,
                SUB         = 5'd7,
                MUL         = 5'd8,
                PRE_DIV     = 5'd9,
                DIV_0       = 5'd10,
                DIV_1       = 5'd11,
                DIV_2       = 5'd12,
                DIV_3       = 5'd13,
                DIV_4       = 5'd14,
                DIV_5       = 5'd15,
                DIV_6       = 5'd16,
                LD_DIV      = 5'd17,
                LD          = 5'd18;
                

    always @(*) begin
        case (current_state)
            LD_A:       next_state = go ? LD_A_WAIT : LD_A;
            LD_A_WAIT:  next_state = go ? LD_A_WAIT: LD_B;
            LD_B:       next_state = go ? LD_B_WAIT : LD_B;
            LD_B_WAIT:  next_state = go ? LD_B_WAIT : LD_OP;
            LD_OP:      next_state = go ? LD_OP_WAIT: LD_OP;
            LD_OP_WAIT: next_state = go ? LD_OP_WAIT : ADD;
            ADD:        next_state = SUB;
            SUB:        next_state = MUL;
            MUL:        next_state = PRE_DIV;
            PRE_DIV:    next_state = DIV_0;
            DIV_0:      next_state = DIV_1;
            DIV_1:      next_state = DIV_2;
            DIV_2:      next_state = DIV_3;
            DIV_3:      next_state = DIV_4;
            DIV_4:      next_state = DIV_5;
            DIV_5:      next_state = DIV_6;
            DIV_6:      next_state = loop ? DIV_0 : LD_DIV; 
            LD_DIV:     next_state = LD;
            LD:         next_state = LD_A;
            default:    next_state = LD_A;
        endcase
    end

    always @(*) begin
        ld_a            = 1'b0;
        ld_b            = 1'b0;
        ld_x            = 1'b0;
        
        ld_t            = 1'b0;

        ld_c            = 1'b0;

        ld_op           = 1'b0;

        ld_q            = 1'b0;

        ld_r            = 1'b0;
        ld_op_reg       = 1'b0;
        
        ld_op_reg_op    = 2'b0;
        
        ld_alu_out      = 1'b0;
        
        alu_select_a    = 3'b0;
        alu_select_b    = 3'b0;

        alu_op          = 3'b0;

        case (current_state)
            LD_A: begin
                ld_a            = 1'b1;    
            end
            LD_B: begin
                ld_b            = 1'b1;
            end
            LD_OP: begin
                ld_op           = 1'b1;
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
            LD: begin
                ld_r            = 1'b1;
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


module datapath(
    input clk,
    input resetn,
    input [3:0] data_in,
    input ld_a, ld_b, ld_x, 
    input ld_t,
    input ld_c,
    input ld_op,
    input ld_q,
    input ld_r, ld_op_reg,
    input [1:0] ld_op_reg_op, 
    input ld_alu_out,
    input [2:0] alu_select_a, alu_select_b,
    input [2:0] alu_op,
    output reg loop,
    output reg [3:0] data_result
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
    reg [3:0] alu_out;

    // op results
    reg [3:0] add, sub, mul, div;

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
                a <= ld_alu_out ? alu_out : data_in;
            if (ld_b)
                b <= data_in;
            if (ld_x)
                x <= alu_out;
            if (ld_op)
                op <= data_in[1:0];
            if (ld_q)
                q <= alu_out[3:3];
            if (ld_t)
                t <= alu_out;
            
            if (ld_c)
                c <= 5'd0;
            else
                c <= c + 5'd1; 
        end
    end

    // output result register
    always @ (posedge clk) begin
        if (!resetn) begin
            data_result <= 4'd0;
            
            add <= 4'd0;
            sub <= 4'd0;
            mul <= 4'd0;
            div <= 4'd0;

            loop <= 1'd0;
        end
        else begin
            if (ld_r) begin
                case (op)
                    2'b00: data_result <= add;
                    2'b01: data_result <= sub;
                    2'b10: data_result <= mul;
                    2'b11: data_result <= div;
                endcase
            end
            if (ld_op_reg) begin
                case (ld_op_reg_op)
                    2'b00: add <= alu_out;
                    2'b01: sub <= alu_out;
                    2'b10: mul <= alu_out;
                    2'b11: div <= a;
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
            3'd0:   alu_out = alu_a + alu_b;
            3'd1:   alu_out = alu_a - alu_b;
            3'd2:   alu_out = alu_a * alu_b;
            3'd3:   
            begin
                    tmp = {alu_a, alu_b} << 1;
                    alu_out = tmp[7:4]; 
            end
            3'd4:   alu_out = alu_a << 1;
            3'd5:   alu_out = alu_a;
            3'd6:   alu_out = {alu_a[3:1], ~alu_b[0]};
        endcase
    end

endmodule


module braille_decoder(encoding, decoding);
    input [3:0] encoding;
    output reg [5:0] decoding;

    always @(*)
        case (encoding)
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
