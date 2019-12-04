module m1(SW, LEDR);
    input [3:0] SW;
    output [5:0] LEDR;

    braille_decoder b1(
        .encoding(SW[3:0]),
        .decoding(LEDR[5:0])
    );
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
