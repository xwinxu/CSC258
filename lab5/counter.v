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

// T flip flop; if t is not set, q remains the same
// if t is set at next posedge of clock, q will flip.
// q is the output signal
module tflipf(input clk, input clr, input t, output reg q);
    always @(posedge clk, negedge clr) begin
        if (~clr)
            q <= 0;
        else
            if (~t)
                q <= ~q;
            else
                q <= q;
    end
endmodule

module eightbitcounter(input clk, input enable, input reset, output [7:0] q);
    wire [7:0] in_t;

    assign in_t[0] = enable;
    // assign out_t[0] = q[0];
    assign in_t[1] = q[0] & in_t[0];
    // assign out_t[0] = q[1];
    assign in_t[2] = q[1] & in_t[1];
    // assign out_t[0] = q[2];
    assign in_t[3] = q[2] & in_t[2];
    // assign out_t[0] = q[3];
    assign in_t[4] = q[3] & in_t[3];
    // assign out_t[0] = q[4];
    assign in_t[5] = q[4] & in_t[4];
    // assign out_t[0] = q[5];
    assign in_t[6] = q[5] & in_t[5];
    // assign out_t[0] = q[6];
    assign in_t[7] = q[6] & in_t[6];
    // assign out_t[0] = q[7];

    tflipf t0(
        .clk(clk),
        .clr(reset),
        .t(in_t[0]),
        // .t(enable),
        .q(q[0])
    );
    tflipf t1(
        .clk(clk),
        .clr(reset),
        .t(in_t[1]),
        // .t(q[0] & enable),
        .q(q[1])
    );
    tflipf t2(
        .clk(clk),
        .clr(reset),
        .t(in_t[2]),
        // .t(q[1] & q[0] & enable), etc. will be long...
        .q(q[2])
    );
    tflipf t3(
        .clk(clk),
        .clr(reset),
        .t(in_t[3]),
        .q(q[3])
    );
    tflipf t4(
        .clk(clk),
        .clr(reset),
        .t(in_t[4]),
        .q(q[4])
    );
    tflipf t5(
        .clk(clk),
        .clr(reset),
        .t(in_t[5]),
        .q(q[5])
    );
    tflipf t6(
        .clk(clk),
        .clr(reset),
        .t(in_t[6]),
        .q(q[6])
    );
    tflipf t7(
        .clk(clk),
        .clr(reset),
        .t(in_t[7]),
        .q(q[7])
    );
endmodule

module counter(input [3:0] KEY, input [9:0] SW, output [6:0] HEX0, output [6:0] HEX1);
    wire [7:0] counter; // this is the 8 bit output

    // 2 switches, one for enable and one for clearb, 1 key for clock
    eightbitcounter ebc(.clk(KEY[0]), .enable(SW[0]), .reset(SW[1]), .q(counter));
    sevenhex s0(.in(counter[3:0]), .hex(HEX0));
    sevenhex s1(.in(counter[7:4]), .hex(HEX1));
endmodule