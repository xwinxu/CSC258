module part1(SW, KEY, HEX0, HEX2, HEX4, HEX5);
    input [9:0] SW;
    input [1:0] KEY;
    output [6:0] HEX0, HEX2, HEX4, HEX5;

    wire [3:0] data_out;

    ram32x4 mem(
        .address(SW[8:4]),
        .data(SW[3:0]),
        .clock(KEY[0]),
        .wren(SW[9]),
        .q(data_out)
    );

    hex_decoder h0(
        .hex_digit(data_out),
        .segments(HEX0)
    );
    
    hex_decoder h2(
        .hex_digit(SW[3:0]),
        .segments(HEX2)
    );

    hex_decoder h4(
        .hex_digit(SW[7:4]),
        .segments(HEX4)
    );
    
    hex_decoder h5(
        .hex_digit({3'b000, SW[8]}),
        .segments(HEX5)
    );
endmodule

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule