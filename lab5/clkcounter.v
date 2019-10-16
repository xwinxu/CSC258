// seven segment decoder for use in ALU output
module sevenhex(hex, in);
    input [3:0] in;
    output [6:0] hex;

    wire [3:0] rev;
    assign rev[0] = in[3];
    assign rev[1] = in[2];
    assign rev[2] = in[1];
    assign rev[3] = in[0];

    assign hex[0] = (~rev[0] & rev[1] & ~rev[2] & ~rev[3]) | (rev[0] & ~rev[1] & rev[2] & rev[3]) | (rev[0] & rev[1] & ~rev[2] & rev[3]) | (~rev[0] & ~rev[1] & ~rev[2] & rev[3]);

    assign hex[1] = (rev[0] & rev[2] & rev[3]) | (rev[0] & rev[1] & ~rev[3]) | (~rev[0] & rev[1] & ~rev[2] & rev[3]) | (rev[1] & rev[2] & ~rev[3]);

    assign hex[2] = (~rev[0] & ~rev[1] & rev[2] & ~rev[3]) | (rev[0] & rev[1] & ~rev[3]) | (rev[0] & rev[1] & rev[2]);

    assign hex[3] = (~rev[1] & ~rev[2] & rev[3]) | (rev[0] & ~rev[1] & rev[2] & ~rev[3]) | (rev[1] & rev[2] & rev[3]) | (~rev[0] & rev[1] & ~rev[2] & ~rev[3]);

    assign hex[4] = (~rev[1] & ~rev[2] & rev[3]) | (~rev[0] & rev[1] & ~rev[2]) | (~rev[0] & rev[3]);

    assign hex[5] = (~rev[0] & ~rev[1] & rev[2]) | (~rev[0] & ~rev[1] & rev[3]) | (rev[0] & rev[1] & ~rev[2] & rev[3]) | (~rev[0] & rev[2] & rev[3]);

    assign hex[6] = (~rev[0] & rev[1] & rev[2] & rev[3]) | (rev[0] & rev[1] & ~rev[2] & ~rev[3]) | (~rev[0] & ~rev[1] & ~rev[2]);

endmodule

module rateDivider(input clock, input reset_n, input [1:0] speeds, output enable);
    reg [25:0] rate;
    reg [25:0] q;

    always @(*) begin
        case(speeds)
            2'b00: rate = 1; // count every cycle
            // 2'b01: rate = 50_000_000; // count every 50 million hertz cycles
            // 2'b10: rate = 100_000_000; // count 2x as long
            // 2'b11: rate = 200_000_000; // take 4x as long
            2'b01: rate = 5;
            2'b10: rate = 10;
            2'b11: rate = 20; 
        endcase
    end

    always @(posedge clk) begin
        if (reset_n == 0) begin
            q <= rate - 1; // count down from top
            enable <= enable;
        end
        else if (q == 1'b0) begin // finishe the cycle, reset it
            q <= rate - 1;
            enable <= 0;
        end
        else if (q == 1'b1) begin // not finished cycle, reset it
            q <= q - 1; // decrement 
            enable <= 1; // finishes on 50 M clock cycle
        end       
        else begin
            q <= q - 1;
            enable <= enable;
        end
    end
endmodule

module counter(input clk, input enb, input reset_n, input parload_n, input [3:0] d, output reg [3:0] q);
    // no need to include parallel load
    always @(posedge clk) begin
        if (~reset_n)
            q <= 0;
        else if (parload_n)
            q <= d;
        else if (enable) begin
            if (&q)
            // if (q == 4'b1111)
                q <= 0;
            else
                q <= q + 1'b1;
        end
    end
endmodule

module clkcounter(input [9:0] SW, input CLOCK_50, output [6:0] HEX0);
    wire [3:0] count; // 4 bit output
    wire enable;
    // speeds is rate, 2 bits
    rateDivider rd(.clock(CLOCK_50), .reset_n(SW[2]), .speeds(SW[1:0]), .enable(enable));
    // d is the thing we'd parload in if parload == 1
    counter c(.clk(CLOCK_50), .enb(enable), .reset_n(SW[3]), .parload_n(1b'0), .d(1b'0), .q(count));
    sevenhex decode(.in(count), .hex(HEX0));
endmodule