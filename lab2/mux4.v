module mux(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;

    wire ConnectUV;
    wire ConnectWX;

    mux2to1 u0(
        .x(SW[0]), // U
        .y(SW[1]), // V
        .s(SW[9]), // s0
        .m(ConnectUV)
        );


    mux2to1 u1(
        .x(SW[2]), // U
        .y(SW[3]), // V
        .s(SW[9]), // s0
        .m(ConnectWX)
        );


    mux2to1 u2(
        .x(ConnectUV), // W
        .y(ConnectWX), // X
        .s(SW[8]), // s0
        .m(LEDR[0])
        );
endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output

    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;

endmodule
